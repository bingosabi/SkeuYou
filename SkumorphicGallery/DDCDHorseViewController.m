//
//  DDCDHorseViewController.m
//  SkumorphicGallery
//
//  Created by Ben Bruckhart on 2/17/13.
//  Copyright (c) 2013 Ben Bruckhart. All rights reserved.
//

#import "DDCDHorseViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface DDCDHorseViewController ()

@end

@implementation DDCDHorseViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (CATransform3D)rectToQuad:(CGRect)rect
                    quadTLX:(CGFloat)x1a
                    quadTLY:(CGFloat)y1a
                    quadTRX:(CGFloat)x2a
                    quadTRY:(CGFloat)y2a
                    quadBLX:(CGFloat)x3a
                    quadBLY:(CGFloat)y3a
                    quadBRX:(CGFloat)x4a
                    quadBRY:(CGFloat)y4a
{
    CGFloat X = rect.origin.x;
    CGFloat Y = rect.origin.y;
    CGFloat W = rect.size.width;
    CGFloat H = rect.size.height;
    
    CGFloat y21 = y2a - y1a;
    CGFloat y32 = y3a - y2a;
    CGFloat y43 = y4a - y3a;
    CGFloat y14 = y1a - y4a;
    CGFloat y31 = y3a - y1a;
    CGFloat y42 = y4a - y2a;
    
    CGFloat a = -H*(x2a*x3a*y14 + x2a*x4a*y31 - x1a*x4a*y32 + x1a*x3a*y42);
    CGFloat b = W*(x2a*x3a*y14 + x3a*x4a*y21 + x1a*x4a*y32 + x1a*x2a*y43);
    CGFloat c = H*X*(x2a*x3a*y14 + x2a*x4a*y31 - x1a*x4a*y32 + x1a*x3a*y42) - H*W*x1a*(x4a*y32 - x3a*y42 + x2a*y43) - W*Y*(x2a*x3a*y14 + x3a*x4a*y21 + x1a*x4a*y32 + x1a*x2a*y43);
    
    CGFloat d = H*(-x4a*y21*y3a + x2a*y1a*y43 - x1a*y2a*y43 - x3a*y1a*y4a + x3a*y2a*y4a);
    CGFloat e = W*(x4a*y2a*y31 - x3a*y1a*y42 - x2a*y31*y4a + x1a*y3a*y42);
    CGFloat f = -(W*(x4a*(Y*y2a*y31 + H*y1a*y32) - x3a*(H + Y)*y1a*y42 + H*x2a*y1a*y43 + x2a*Y*(y1a - y3a)*y4a + x1a*Y*y3a*(-y2a + y4a)) - H*X*(x4a*y21*y3a - x2a*y1a*y43 + x3a*(y1a - y2a)*y4a + x1a*y2a*(-y3a + y4a)));
    
    CGFloat g = H*(x3a*y21 - x4a*y21 + (-x1a + x2a)*y43);
    CGFloat h = W*(-x2a*y31 + x4a*y31 + (x1a - x3a)*y42);
    CGFloat i = W*Y*(x2a*y31 - x4a*y31 - x1a*y42 + x3a*y42) + H*(X*(-(x3a*y21) + x4a*y21 + x1a*y43 - x2a*y43) + W*(-(x3a*y2a) + x4a*y2a + x2a*y3a - x4a*y3a - x2a*y4a + x3a*y4a));
    
    if(fabs(i) < 0.00001)
    {
        i = 0.00001;
    }
    
    CATransform3D t = CATransform3DIdentity;
    
    t.m11 = a / i;
    t.m12 = d / i;
    t.m13 = 0;
    t.m14 = g / i;
    t.m21 = b / i;
    t.m22 = e / i;
    t.m23 = 0;
    t.m24 = h / i;
    t.m31 = 0;
    t.m32 = 0;
    t.m33 = 1;
    t.m34 = 0;
    t.m41 = c / i;
    t.m42 = f / i;
    t.m43 = 0;
    t.m44 = i / i;
    
    return t;
}

- (IBAction)reignsPanned:(UIPanGestureRecognizer *)sender {
    
    CGPoint position = [sender translationInView:self.view];
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        self.initialPan = position;
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGFloat xDiff = self.initialPan.x - position.x;
        CGFloat yDiff = self.initialPan.y - position.y;
        
        
        if (position.x < -50)
        {
            self.leftHead.alpha = 1.0;
            self.forwardHead.alpha = 0.0;
            self.forwardHeadBlocker.alpha = 0.0;
            self.reigns.alpha = 0.0;
            self.rightHead.alpha = 0.0;
        }
        else if (position.x > 50)
        {
            self.leftHead.alpha = 0.0;
            self.forwardHead.alpha = 0.0;
            self.forwardHeadBlocker.alpha = 0.0;
            self.reigns.alpha = 0.0;
            self.rightHead.alpha = 1.0;
        }
        else
        {
            self.leftHead.alpha = 0.0;
            self.forwardHead.alpha = 1.0;
            self.forwardHeadBlocker.alpha = 1.0;
            self.reigns.alpha = 1.0;
            self.rightHead.alpha = 0.0;
            
            
        }
        
        
        if (yDiff < 0)
        {
            yDiff = 0;
        }
        
        CGFloat distance = yDiff;
        if (distance > 50)
        {
            distance = 50;
        } else if (distance < -50)
        {
            distance = -50;
        }
        
        self.currentHorseSpeed = distance;
        self.background.center = CGPointMake( CGRectGetMidX(self.background.bounds), CGRectGetMidY(self.background.bounds) + distance -30);
        

        yDiff = MIN(140, yDiff);
        
        CATransform3D trans =

                [self rectToQuad:self.reigns.bounds
                                             quadTLX:CGRectGetMinX(self.reigns.bounds)
                                           quadTLY:CGRectGetMinY(self.reigns.bounds)
                                           quadTRX:CGRectGetMaxX(self.reigns.bounds)
                                           quadTRY:CGRectGetMinY(self.reigns.bounds)
                                           quadBLX:CGRectGetMinX(self.reigns.bounds) + xDiff
                                           quadBLY:CGRectGetMaxY(self.reigns.bounds) - yDiff
                                           quadBRX:CGRectGetMaxX(self.reigns.bounds) + xDiff
                                           quadBRY:CGRectGetMaxY(self.reigns.bounds) - yDiff
                 ];

        self.reigns.layer.transform = trans;
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        //[self.background.layer removeAllAnimations];
        self.reigns.layer.transform = CATransform3DIdentity;
        self.leftHead.alpha = 0.0;
        self.forwardHead.alpha = 1.0;
        self.forwardHeadBlocker.alpha = 1.0;
        self.reigns.alpha = 1.0;
        self.rightHead.alpha = 0.0;
        [UIView animateWithDuration:0.2 animations:^{
            self.background.center = CGPointMake( CGRectGetMidX(self.background.bounds), CGRectGetMidY(self.background.bounds) -30);
        } /*completion:^(BOOL finished) {
            [self degradeAnimationDown];
        }*/];
        
    }
}

-(void) degradeAnimationDown
{
    if (self.currentHorseSpeed > 1)
    {
        self.currentHorseSpeed *=0.9;
        
        //CGFloat distanct = MIN(self.currentHorseSpeed, 40);
    [UIView animateWithDuration:self.currentHorseSpeed animations:^{
        self.background.center = CGPointMake( CGRectGetMidX(self.background.bounds), CGRectGetMidY(self.background.bounds)-self.currentHorseSpeed);
    } completion:^(BOOL finished) {
        [self degradeAnimationUp];
    }];
    }
}

-(void) degradeAnimationUp
{
    if (self.currentHorseSpeed > 1)
    {
        self.currentHorseSpeed *=0.9;
        //CGFloat distanct = MIN(self.currentHorseSpeed, 40);
        [UIView animateWithDuration:self.currentHorseSpeed animations:^{
            self.background.center = CGPointMake( CGRectGetMidX(self.background.bounds), CGRectGetMidY(self.background.bounds)+self.currentHorseSpeed);
        } completion:^(BOOL finished) {
            [self degradeAnimationDown];
        }];
    }
}


- (void)viewDidUnload {
    [self setForwardHead:nil];
    [self setRightHead:nil];
    [self setLeftHead:nil];
    [self setReigns:nil];
    [self setBackground:nil];
    [self setForwardHeadBlocker:nil];
    [super viewDidUnload];
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
