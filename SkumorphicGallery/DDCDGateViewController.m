//
//  DDCDGateViewController.m
//  SkumorphicGallery
//
//  Created by Ben Bruckhart on 2/17/13.
//  Copyright (c) 2013 Ben Bruckhart. All rights reserved.
//

#import "DDCDGateViewController.h"

NSString* const kAppUnlockedNotification = @"DDCD_APP_UNLOCKED";

@interface DDCDGateViewController ()

@end

@implementation DDCDGateViewController

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
    
    NSURL *keySound   = [[NSBundle mainBundle] URLForResource: @"Unlock2"
                                                withExtension: @"caf"];
    
    // Store the URL as a CFURLRef instance
    self.soundFileURLRef = keySound;
    
    // Create a system sound object representing the sound file.
    AudioServicesCreateSystemSoundID (
                                      
                                      (__bridge CFURLRef) self.soundFileURLRef,
                                      &_soundFileObject
                                      );
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)keyPan:(UIPanGestureRecognizer *)sender {
    CGPoint position = [sender translationInView:self.view];
    if(sender.state == UIGestureRecognizerStateBegan) {
        self.initialKeyCenter = self.keyImageView.center;
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGFloat newCenterRightX = self.initialKeyCenter.x + position.x;
        CGFloat newCenterRightY = self.initialKeyCenter.y + position.y;
        
        self.currentLocation = CGPointMake(newCenterRightX, newCenterRightY);
        self.keyImageView.center = self.currentLocation;
        self.keyTopImageView.center = self.keyImageView.center;
        
        [self checkLock];
    } 
}
- (void)viewDidUnload {
    [self setKeyImageView:nil];
    [self setKeyTopImageView:nil];
    [super viewDidUnload];
}
- (IBAction)rotateKey:(UIRotationGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        self.initialRotation = sender.rotation;
    }
    else
        if (sender.state == UIGestureRecognizerStateChanged)
        {
            CGFloat difference = sender.rotation - self.self.initialRotation;
            self.currentRotation = self.lastRotation + difference;
            
            self.keyImageView.transform = CGAffineTransformMakeRotation(self.currentRotation);
            self.keyTopImageView.transform = self.keyImageView.transform;
            [self checkLock];
        }
        else if (sender.state == UIGestureRecognizerStateEnded)
        {
            self.lastRotation =  atan2(self.keyImageView.transform.b, self.keyImageView.transform.a);
        }
    
}

-(void) checkLock
{
    if (self.currentRotation < 1.3 && self.currentRotation > 1.1 && CGRectContainsPoint(CGRectMake(550, 420, 50, 50) ,  self.currentLocation ))
    {
        AudioServicesPlaySystemSound (self.soundFileObject);
        [[NSNotificationCenter defaultCenter] postNotificationName:kAppUnlockedNotification object:nil];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (![gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] && ![otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        return YES;
    }
    
    return NO;
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
