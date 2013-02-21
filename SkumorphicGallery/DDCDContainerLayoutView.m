//
//  DDCDContainerLayoutView.m
//  SkumorphicGallery
//
//  Created by Ben Bruckhart on 2/17/13.
//  Copyright (c) 2013 Ben Bruckhart. All rights reserved.
//

#import "DDCDContainerLayoutView.h"

@implementation DDCDContainerLayoutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    int viewWidth = self.bounds.size.width / self.subviews.count;
    
    [self.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        view.frame = CGRectMake(idx*viewWidth, 0, viewWidth,self.bounds.size.height);
    }];
}

@end
