//
//  DDCDContainerViewController.h
//  SkumorphicGallery
//
//  Created by Ben Bruckhart on 2/19/13.
//  Copyright (c) 2013 Ben Bruckhart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDCDContainerViewController : UIViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *modal;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *instructionImageView;

- (IBAction)swipedLeft:(UISwipeGestureRecognizer *)sender;

@end
