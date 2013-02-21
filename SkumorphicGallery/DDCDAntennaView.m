//
//  DDCDAntennaView.m
//  SkumorphicGallery
//
//  Created by Ben Bruckhart on 2/17/13.
//  Copyright (c) 2013 Ben Bruckhart. All rights reserved.
//

#import "DDCDAntennaView.h"

@implementation DDCDAntennaView

-(void) awakeFromNib
{
    CGFloat antenna1Height =  self.antenna1.bounds.size.height;
    CGFloat antenna2Height =  self.antenna2.bounds.size.height;
    CGFloat antenna3Height =  self.antenna3.bounds.size.height;
    CGFloat maxHeight = antenna1Height + antenna2Height + antenna3Height;
    CGFloat offsetY = 0;
    if (maxHeight < self.frame.size.height)
        offsetY = self.frame.size.height - maxHeight;
    
    self.minTopY = offsetY;
    self.maxTopY = self.frame.size.height - 30;
    self.min2Y = self.frame.size.height - antenna3Height - antenna2Height;
    self.max2Y = self.frame.size.height - 20;
    self.min2Y = self.frame.size.height - antenna3Height;
    self.max2Y = self.frame.size.height - 10;
    
    self.topPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(topPanned:)];
    
    //TODO: Make these move independently. 
    self.pan2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(topPanned:)];
    self.pan3 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(topPanned:)];
    [self.antenna1 addGestureRecognizer: self.topPan];
    [self.antenna2 addGestureRecognizer: self.pan2];
    [self.antenna3 addGestureRecognizer: self.pan3];
    
}

- (IBAction)topPanned:(UIPanGestureRecognizer *)sender
{
    CGPoint position = [sender translationInView:self];
    if(sender.state == UIGestureRecognizerStateBegan) {
        self.initialTopY = self.antenna1.frame.origin.y;
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGFloat newTopY = self.initialTopY + position.y;
        
        newTopY = MAX(self.minTopY, newTopY);
        newTopY = MIN(self.maxTopY, newTopY);
        
        self.antenna1.frame = CGRectMake(self.antenna1.frame.origin.x, newTopY, self.antenna1.frame.size.width, self.antenna1.frame.size.height);
        self.antennaTop.frame = CGRectMake(self.antennaTop.frame.origin.x, newTopY, self.antennaTop.frame.size.width, self.antennaTop.frame.size.height);
        
        CGFloat newTwoTopY = self.antenna2.frame.origin.y;
        newTwoTopY = MIN(newTwoTopY, CGRectGetMaxY(self.antenna1.frame));
        newTwoTopY = MAX(newTwoTopY, CGRectGetMaxY(self.antennaTop.frame));
        
        self.antenna2.frame = CGRectMake(self.antenna2.frame.origin.x, newTwoTopY, self.antenna2.frame.size.width, self.antenna2.frame.size.height);
        
        CGFloat newThreeTopY = self.antenna3.frame.origin.y;
        newThreeTopY = MIN(newThreeTopY, CGRectGetMaxY(self.antenna2.frame));
        newThreeTopY = MAX(newThreeTopY, CGRectGetMinY(self.antenna2.frame) + 7);
        
        self.antenna3.frame = CGRectMake(self.antenna3.frame.origin.x, newThreeTopY, self.antenna3.frame.size.width, self.antenna3.frame.size.height);
        
        
        [self.delegate antennaHeightChanged:(self.maxTopY - newTopY)/(self.maxTopY-self.minTopY) ];
    }
}

- (IBAction)twoPanned:(UIPanGestureRecognizer *)sender
{
    CGPoint position = [sender translationInView:self];
    if(sender.state == UIGestureRecognizerStateBegan) {
        self.initialTopY = self.antenna1.frame.origin.y;
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGFloat newTopY = self.initialTopY + position.y;
        
        newTopY = MAX(self.minTopY, newTopY);
        newTopY = MIN(self.maxTopY, newTopY);
        
        self.antenna1.frame = CGRectMake(self.antenna1.frame.origin.x, newTopY, self.antenna1.frame.size.width, self.antenna1.frame.size.height);
        self.antennaTop.frame = CGRectMake(self.antennaTop.frame.origin.x, newTopY, self.antennaTop.frame.size.width, self.antennaTop.frame.size.height);
        
        CGFloat newTwoTopY = self.antenna2.frame.origin.y;
        newTwoTopY = MIN(newTwoTopY, CGRectGetMaxY(self.antenna1.frame));
        newTwoTopY = MAX(newTwoTopY, CGRectGetMaxY(self.antennaTop.frame));
        
        self.antenna2.frame = CGRectMake(self.antenna2.frame.origin.x, newTwoTopY, self.antenna2.frame.size.width, self.antenna2.frame.size.height);
        
        CGFloat newThreeTopY = self.antenna3.frame.origin.y;
        newThreeTopY = MIN(newThreeTopY, self.max3Y);
        newThreeTopY = MAX(newThreeTopY, CGRectGetMinY(self.antenna2.frame));
        
        self.antenna3.frame = CGRectMake(self.antenna3.frame.origin.x, newThreeTopY, self.antenna3.frame.size.width, self.antenna3.frame.size.height);
    }
}

- (IBAction)threePanned:(UIPanGestureRecognizer *)sender
{
    CGPoint position = [sender translationInView:self];
    if(sender.state == UIGestureRecognizerStateBegan) {
        self.initialTopY = self.antenna1.frame.origin.y;
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGFloat newTopY = self.initialTopY + position.y;
        
        newTopY = MAX(self.minTopY, newTopY);
        newTopY = MIN(self.maxTopY, newTopY);
        
        self.antenna1.frame = CGRectMake(self.antenna1.frame.origin.x, newTopY, self.antenna1.frame.size.width, self.antenna1.frame.size.height);
        self.antennaTop.frame = CGRectMake(self.antennaTop.frame.origin.x, newTopY, self.antennaTop.frame.size.width, self.antennaTop.frame.size.height);
        
        CGFloat newTwoTopY = self.antenna2.frame.origin.y;
        newTwoTopY = MIN(newTwoTopY, CGRectGetMaxY(self.antenna1.frame));
        newTwoTopY = MAX(newTwoTopY, CGRectGetMaxY(self.antennaTop.frame) );
        
        self.antenna2.frame = CGRectMake(self.antenna2.frame.origin.x, newTwoTopY, self.antenna2.frame.size.width, self.antenna2.frame.size.height);
        
        CGFloat newThreeTopY = self.antenna3.frame.origin.y;
        newThreeTopY = MIN(newThreeTopY, self.max3Y);
        newThreeTopY = MAX(newThreeTopY, CGRectGetMinY(self.antenna2.frame));
        
        self.antenna3.frame = CGRectMake(self.antenna3.frame.origin.x, newThreeTopY, self.antenna3.frame.size.width, self.antenna3.frame.size.height);
    }
}

@end
