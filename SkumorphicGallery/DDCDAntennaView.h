//
//  DDCDAntennaView.h
//  SkumorphicGallery
//
//  Created by Ben Bruckhart on 2/17/13.
//  Copyright (c) 2013 Ben Bruckhart. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDCDAntennaViewDelegate <NSObject>

-(void) antennaHeightChanged:(float) percent;

@end

@interface DDCDAntennaView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *antennaTop;
@property (weak, nonatomic) IBOutlet UIImageView *antenna1;
@property (weak, nonatomic) IBOutlet UIImageView *antenna2;
@property (weak, nonatomic) IBOutlet UIImageView *antenna3;
@property (weak, nonatomic) NSObject<DDCDAntennaViewDelegate> *delegate;

- (IBAction)topPanned:(UIPanGestureRecognizer *)sender;


@property (nonatomic) CGFloat initialTopY;
@property (nonatomic) CGFloat initial2Y;
@property (nonatomic) CGFloat initial3Y;

@property (nonatomic) CGFloat minTopY;
@property (nonatomic) CGFloat maxTopY;
@property (nonatomic) CGFloat min2Y;
@property (nonatomic) CGFloat max2Y;
@property (nonatomic) CGFloat min3Y;
@property (nonatomic) CGFloat max3Y;

@property (nonatomic, strong) UIPanGestureRecognizer *topPan;
@property (nonatomic, strong) UIPanGestureRecognizer *pan2;
@property (nonatomic, strong) UIPanGestureRecognizer *pan3;

@end
