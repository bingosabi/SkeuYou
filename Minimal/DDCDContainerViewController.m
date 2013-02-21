//
//  DDCDContainerViewController.m
//  SkumorphicGallery
//
//  Created by Ben Bruckhart on 2/19/13.
//  Copyright (c) 2013 Ben Bruckhart. All rights reserved.
//

#import "DDCDContainerViewController.h"

@interface DDCDContainerViewController ()

@end

@implementation DDCDContainerViewController

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
    [self.scrollView setContentSize:CGSizeMake(1024, 2304)];
    [self.scrollView setContentOffset:CGPointMake(0, 1536) animated:NO];

}
- (IBAction)pinched:(UIPinchGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateChanged)
    {
        self.scrollView.transform = CGAffineTransformMakeScale(sender.scale, sender.scale);
        self.instructionImageView.transform = CGAffineTransformMakeScale(sender.scale, sender.scale);
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.transform = CGAffineTransformMakeScale(0, 0);
        }];
        [self performSelector:@selector(closeApp) withObject:nil afterDelay:0.3]; 
    }
}

-(void) closeApp
{
     abort();
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) shouldAutorotate
{
    return YES;
    
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y < -10)
    {
        [UIView animateWithDuration:0.2 animations:^{
            self.instructionImageView.alpha = 1.0;
        }];
    }
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return  YES;
}



- (IBAction)swipedLeft:(UISwipeGestureRecognizer *)sender {
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


@end
