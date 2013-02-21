//
//  DDCDHorseViewController.h
//  SkumorphicGallery
//
//  Created by Ben Bruckhart on 2/17/13.
//  Copyright (c) 2013 Ben Bruckhart. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface DDCDHorseViewController : UIViewController

- (IBAction)reignsPanned:(UIPanGestureRecognizer *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *reigns;
@property (weak, nonatomic) IBOutlet UIImageView *forwardHead;
@property (weak, nonatomic) IBOutlet UIImageView *forwardHeadBlocker;
@property (weak, nonatomic) IBOutlet UIImageView *rightHead;
@property (weak, nonatomic) IBOutlet UIImageView *leftHead;
@property (weak, nonatomic) IBOutlet UIImageView *background;

@property (nonatomic) CGPoint initialPan;
@property (nonatomic) CGFloat currentHorseSpeed;

@end
