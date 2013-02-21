//
//  DDCDViewController.m
//  SkumorphicGallery
//
//  Created by Ben Bruckhart on 2/8/13.
//  Copyright (c) 2013 Ben Bruckhart. All rights reserved.
//

#import "DDCDViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface DDCDViewController ()

@end

@implementation DDCDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createChildViewContollers];
    self.scrollView.delegate = self;
    
    self.leftCurtainMin = self.leftCurtain.center.x;
    self.rightCurtainMin = self.rightCurtain.center.x;
    self.ropeCenterMin = self.cord.center.y;
    
    [self hideSignLocation];
    
//    //This doesn't work for whatever reason. 
//    self.scrollView.panGestureRecognizer.maximumNumberOfTouches = 1;
//    self.scrollView.panGestureRecognizer.minimumNumberOfTouches = 1;
//    
//    // set up a two-finger pan recognizer as a dummy to steal two-finger scrolls from the scroll view
//    // we initialize without a target or action because we don't want the two-finger pan to be handled
//    UIPanGestureRecognizer *twoFingerPan = [[UIPanGestureRecognizer alloc] init];
//    twoFingerPan.minimumNumberOfTouches = 2;
//    twoFingerPan.maximumNumberOfTouches = 2;
//    [self.scrollView addGestureRecognizer:twoFingerPan];
    
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self checkSignLocation];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createChildViewContollers
{
    self.childViewControllers = [NSMutableArray arrayWithCapacity:4];
   
    [self createAndAddViewControllerWithIdentifier:@"radio"];
    [self createAndAddViewControllerWithIdentifier:@"horse"];
    [self createAndAddViewControllerWithIdentifier:@"switch"];
    
    self.scrollContentView.frame = CGRectMake(0,0,1024*self.childViewControllers.count,768);
    self.scrollView.contentSize = CGSizeMake(1024*self.childViewControllers.count,768);
    
}

-(void) createAndAddViewControllerWithIdentifier:(NSString *)identifier
{
    UIStoryboard *theStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
    UIViewController *vc = [theStoryBoard instantiateViewControllerWithIdentifier:identifier];
    
    [self.scrollContentView addSubview:vc.view];
    [self addChildViewController:vc];
    
    [self.childViewControllers addObject:vc];
}


- (IBAction)curtainCordPanner:(UIPanGestureRecognizer *)sender {
    CGPoint position = [sender translationInView:self.view];
    if(sender.state == UIGestureRecognizerStateBegan) {
        self.curtainLeftCenter = self.leftCurtain.center.x;
        self.curtainRightCenter = self.rightCurtain.center.x;
        self.ropeCenter = self.cord.center.y;
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGFloat newCenterRightX = self.curtainRightCenter + position.y * 1.8;
        CGFloat newCenterLeftX = self.curtainLeftCenter - position.y *1.8;
        
        newCenterLeftX = MIN(self.leftCurtainMin, newCenterLeftX);
        newCenterLeftX = MAX(-200, newCenterLeftX);
        
        newCenterRightX = MAX(self.rightCurtainMin, newCenterRightX);
        newCenterRightX = MIN(1200, newCenterRightX);
        

        self.leftCurtain.center = CGPointMake(newCenterLeftX, self.leftCurtain.center.y);
         self.rightCurtain.center = CGPointMake(newCenterRightX, self.rightCurtain.center.y);
        
        
        CGFloat newRopCenter = self.ropeCenter +position.y;
        newRopCenter = MAX(newRopCenter, self.ropeCenterMin);
       newRopCenter = MIN(newRopCenter, 300);
        
        
        self.cord.center = CGPointMake(self.cord.center.x, newRopCenter);
        [self checkSignLocation];
    }
}

-(void) hideSignLocation
{
    self.signImageView.frame = CGRectMake(CGRectGetMinX(self.signImageView.frame), -CGRectGetHeight(self.signImageView.frame), CGRectGetMinX(self.signImageView.frame), CGRectGetHeight(self.signImageView.frame));
}

-(void) checkSignLocation
{
   CGFloat pixelsVisible = CGRectGetMinX(self.rightCurtain.frame) - CGRectGetMaxX(self.leftCurtain.frame);
   if (pixelsVisible > 300)
   {
       CGFloat percentVisible = (pixelsVisible - 300.0) / 400.0;
       percentVisible = MIN(1.0, percentVisible);
       
       //Also Hide when scrolling close to the middles
       
       int scrollingMod = (int) self.scrollView.contentOffset.x % 1024;
       NSLog(@"scrollingMod %d", scrollingMod);
       
       if (self.scrollView.contentOffset.x > 200 && self.scrollView.contentOffset.x < self.scrollView.contentSize.width - 200)
       {
           if (scrollingMod < 530)
           {
               CGFloat scrollingPercentVisible = ((float) scrollingMod - 224.0) / 224.0;
               scrollingPercentVisible = 1.0 - scrollingPercentVisible;
               percentVisible = MIN(scrollingPercentVisible, percentVisible);
               NSLog(@"percentVisible B %f", percentVisible);
           }
           else 
           {
               CGFloat scrollingPercentVisible = ((float) scrollingMod - 200.0) / 200.0;
               scrollingPercentVisible =  scrollingPercentVisible - 1.6;
               percentVisible = MIN(scrollingPercentVisible, percentVisible);
               NSLog(@"percentVisible S %f", scrollingPercentVisible);
           }
        }
       
       
       
        self.signImageView.frame = CGRectMake(CGRectGetMinX(self.signImageView.frame), percentVisible*CGRectGetHeight(self.signImageView.frame) -CGRectGetHeight(self.signImageView.frame), CGRectGetMinX(self.signImageView.frame), CGRectGetHeight(self.signImageView.frame));
   }
   else{
       [self hideSignLocation];
   }
    
   int offset =  (530 + self.scrollView.contentOffset.x) / 1024;
    switch (offset) {
        case 1:
            self.signImageView.image = [UIImage imageNamed:@"horseSign"];
            break;
        case 2:
            self.signImageView.image = [UIImage imageNamed:@"knifeSwitchSign"];
            break;
        default:
            self.signImageView.image = [UIImage imageNamed:@"signRadio"];
            break;
    }
    
}


- (IBAction)rightCurtainPanner:(UIPanGestureRecognizer *)sender {
    CGPoint position = [sender translationInView:self.view];
    if(sender.state == UIGestureRecognizerStateBegan) {
        self.curtainRightCenter = self.rightCurtain.center.x;
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGFloat newCenterRightX = self.curtainRightCenter + position.x;
        
        newCenterRightX = MAX(self.rightCurtainMin, newCenterRightX);
        newCenterRightX = MIN(1200, newCenterRightX);
        
        self.rightCurtain.center = CGPointMake(newCenterRightX, self.rightCurtain.center.y);
        [self checkSignLocation];
        
    }
}

- (IBAction)leftCurtainPanner:(UIPanGestureRecognizer *)sender {
    CGPoint position = [sender translationInView:self.view];
    if(sender.state == UIGestureRecognizerStateBegan) {
        self.curtainLeftCenter = self.leftCurtain.center.x;
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGFloat newCenterLeftX = self.curtainLeftCenter + position.x ;
        
        newCenterLeftX = MIN(self.leftCurtainMin, newCenterLeftX);
        newCenterLeftX = MAX(-200, newCenterLeftX);
        
        
        
        self.leftCurtain.center = CGPointMake(newCenterLeftX, self.leftCurtain.center.y);
        [self checkSignLocation];
    
    }
}

-(BOOL) shouldAutorotate
{
    return YES;
    
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}


-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return  YES;
}

- (void)viewDidUnload {
    self.childViewControllers = nil;
    for (UIViewController *vc in self.childViewControllers)
    {
        [vc removeFromParentViewController];
    }
    [self setScrollView:nil];
    [self setLeftCurtain:nil];
    [self setRightCurtain:nil];
    [self setScrollContentView:nil];
    [self setSignImageView:nil];
    [super viewDidUnload];
}
@end
