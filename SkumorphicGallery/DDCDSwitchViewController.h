//
//  DDCDSwitchViewController.h
//  SkumorphicGallery
//
//  Created by Ben Bruckhart on 2/17/13.
//  Copyright (c) 2013 Ben Bruckhart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface DDCDSwitchViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *knifeHandle;

@property (nonatomic) CGFloat initialPan;
@property (nonatomic) CGFloat currentAngle;
@property (nonatomic) BOOL lightWasOff;
- (IBAction)switchPanned:(UIPanGestureRecognizer *)sender;

@property (strong)	  NSURL *		soundFileURLRef;
@property (readonly) SystemSoundID	soundFileObject;
@property (strong)	  NSURL *		offSoundFileURLRef;
@property (readonly) SystemSoundID	offSoundFileObject;

@property (strong) UIImage *onImage;
@property (strong) UIImage *offImage;

@end
