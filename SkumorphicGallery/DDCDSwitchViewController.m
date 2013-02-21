//
//  DDCDSwitchViewController.m
//  SkumorphicGallery
//
//  Created by Ben Bruckhart on 2/17/13.
//  Copyright (c) 2013 Ben Bruckhart. All rights reserved.
//

#import "DDCDSwitchViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface DDCDSwitchViewController ()

@end

@implementation DDCDSwitchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.knifeHandle.layer.anchorPoint = CGPointMake(0.5, 1.0);
    self.knifeHandle.layer.position = CGPointMake(self.knifeHandle.layer.position.x, self.knifeHandle.layer.position.y + CGRectGetHeight(self.knifeHandle.bounds) / 2.0);
    
   self.soundFileURLRef    = [[NSBundle mainBundle] URLForResource: @"SwitchOn"
                                                withExtension: @"caf"];
    AudioServicesCreateSystemSoundID (
                                      
                                      (__bridge CFURLRef) self.soundFileURLRef,
                                      &_soundFileObject
                                      );
    
    self.offSoundFileURLRef   = [[NSBundle mainBundle] URLForResource: @"SwitchOff"
                                                withExtension: @"caf"];
    AudioServicesCreateSystemSoundID (
                                      
                                      (__bridge CFURLRef) self.offSoundFileURLRef,
                                      &_offSoundFileObject
                                      );
    
    self.onImage = [UIImage imageNamed:@"KnifeSwitchBackgroundLightOn"];
    self.offImage = [UIImage imageNamed:@"knifeSwitchBackgroundLightOff"];
}

-(void) awakeFromNib{
    self.knifeHandle.layer.anchorPoint = CGPointMake(0.5, 1.0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBackgroundImageView:nil];
    [self setKnifeHandle:nil];
    [super viewDidUnload];
}
- (IBAction)switchPanned:(UIPanGestureRecognizer *)sender {
    CGPoint position = [sender translationInView:self.view];
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        self.initialPan = position.y;
        
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGFloat yDiff = self.initialPan - position.y;
        
        self.currentAngle = yDiff / -100.0;
        if (self.lightWasOff)
        {
            self.currentAngle +=M_PI;
        }
        
        
        self.currentAngle = MAX(0, self.currentAngle);
        self.currentAngle = MIN(M_PI, self.currentAngle);
                
        CATransform3D trans = CATransform3DMakeRotation(self.currentAngle, 1, 0, 0);
        
        if (self.currentAngle > M_PI / 2.0)
        {
            if (self.offImage != self.backgroundImageView.image)
            {
                self.backgroundImageView.image = self.offImage;
                AudioServicesPlaySystemSound (self.offSoundFileObject);
            }        }
        else
        {
            if (self.onImage != self.backgroundImageView.image)
            {
                self.backgroundImageView.image = self.onImage;
                AudioServicesPlaySystemSound (self.soundFileObject);
            }
        }
        
        self.knifeHandle.layer.transform = trans;
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:0.2
                         animations:^{
                             if (self.currentAngle > M_PI / 2.0)
                             {
                                 self.currentAngle = M_PI;
                                 CATransform3D trans = CATransform3DMakeRotation(self.currentAngle, 1, 0, 0);
                                 self.knifeHandle.layer.transform = trans;
                                 self.backgroundImageView.image = [UIImage imageNamed:@"knifeSwitchBackgroundLightOff"];
                                 self.lightWasOff = YES;
                             }
                             else
                             {
                                 self.currentAngle = 0;
                                 self.knifeHandle.layer.transform = CATransform3DIdentity;
                                 self.backgroundImageView.image = [UIImage imageNamed:@"KnifeSwitchBackgroundLightOn"];
                                 self.lightWasOff = NO;
                             }
                         }];
        
    }
}

-(BOOL) shouldAutorotate
{
    return YES;
    
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight;
}



@end
