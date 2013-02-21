//
//  DDMMViewController.h
//  Minimal
//
//  Created by Ben Bruckhart on 2/19/13.
//  Copyright (c) 2013 Ben Bruckhart. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT   NSString* const kAppUnlockedNotification;

@interface DDMMViewController : UIViewController
- (IBAction)Swiped:(id)sender;
- (IBAction)tapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *modal;

@end
