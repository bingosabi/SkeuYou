//
//  DDCDGateViewController.h
//  SkumorphicGallery
//
//  Created by Ben Bruckhart on 2/17/13.
//  Copyright (c) 2013 Ben Bruckhart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

FOUNDATION_EXPORT   NSString* const kAppUnlockedNotification;

@interface DDCDGateViewController : UIViewController<UIGestureRecognizerDelegate>
- (IBAction)keyPan:(UIPanGestureRecognizer *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *keyImageView;
@property (weak, nonatomic) IBOutlet UIImageView *keyTopImageView;

- (IBAction)rotateKey:(UIRotationGestureRecognizer *)sender;
@property (nonatomic) CGPoint initialKeyCenter;
@property (nonatomic) CGFloat initialRotation;
@property (nonatomic) CGFloat lastRotation;


@property (nonatomic) CGFloat currentRotation;
@property (nonatomic) CGPoint currentLocation;
@property (strong)	  NSURL *		soundFileURLRef;
@property (readonly) SystemSoundID	soundFileObject;

@end
