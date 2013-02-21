//
//  DDMMViewController.m
//  Minimal
//
//  Created by Ben Bruckhart on 2/19/13.
//  Copyright (c) 2013 Ben Bruckhart. All rights reserved.
//

#import "DDMMViewController.h"

@interface DDMMViewController ()

@end

NSString* const kAppUnlockedNotification = @"DDCD_APP_UNLOCKED";

@implementation DDMMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Swiped:(id)sender {
     [[NSNotificationCenter defaultCenter] postNotificationName:kAppUnlockedNotification object:nil];
}

- (IBAction)tapped:(id)sender {
    [UIView animateWithDuration:0.2 animations:^{
        self.modal.alpha = 1.0;
    } ];
    [self performSelector:@selector(fadeOut) withObject:nil afterDelay:1.0];
}

-(void) fadeOut
{
    [UIView animateWithDuration:1.0 animations:^{
        self.modal.alpha = 0.0;
    }];
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

@end
