//
//  DDCDViewController.h
//  SkumorphicGallery
//
//  Created by Ben Bruckhart on 2/8/13.
//  Copyright (c) 2013 Ben Bruckhart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDCDViewController : UIViewController<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *cord;

@property (nonatomic) CGFloat curtainLeftCenter;
@property (nonatomic) CGFloat curtainRightCenter;

@property (nonatomic) CGFloat ropeCenter;
@property (nonatomic) CGFloat ropeCenterMin;
@property (nonatomic) CGFloat leftCurtainMin;
@property (nonatomic) CGFloat rightCurtainMin;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet UIImageView *leftCurtain;
@property (weak, nonatomic) IBOutlet UIImageView *rightCurtain;
@property (weak, nonatomic) IBOutlet UIImageView *signImageView;

@property (strong, nonatomic) NSMutableArray *childViewControllers;

- (IBAction)curtainCordPanner:(UIPanGestureRecognizer *)sender;
- (IBAction)rightCurtainPanner:(UIPanGestureRecognizer *)sender;
- (IBAction)leftCurtainPanner:(UIPanGestureRecognizer *)sender;

@end
