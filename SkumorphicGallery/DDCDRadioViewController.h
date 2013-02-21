//
//  DDCDRadioViewController.h
//  SkumorphicGallery
//
//  Created by Ben Bruckhart on 2/17/13.
//  Copyright (c) 2013 Ben Bruckhart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCDAntennaView.h"
#import <AudioToolbox/AudioToolbox.h>

NSString *MixerHostAudioObjectPlaybackStateDidChangeNotification = @"MixerHostAudioObjectPlaybackStateDidChangeNotification";

@class MixerHostAudio;

@interface DDCDRadioViewController : UIViewController<DDCDAntennaViewDelegate>

@property (strong, nonatomic) IBOutlet UIRotationGestureRecognizer *leftKnobGestureRecognizer;
@property (strong, nonatomic) IBOutlet UIRotationGestureRecognizer *rightKnobGestureRecognizer;

@property (strong, nonatomic) IBOutlet MixerHostAudio *audioObject;


@property (weak, nonatomic) IBOutlet UIImageView *leftKnobVolume;
@property (weak, nonatomic) IBOutlet UIImageView *rightKnobTuning;
@property (weak, nonatomic) IBOutlet UIImageView *tunerLine;
@property (weak, nonatomic) IBOutlet DDCDAntennaView *antennaView;

@property (nonatomic) CGFloat volumeRotationLast;
@property (nonatomic) CGFloat tuningRotationLast;
@property (nonatomic) CGFloat antennaYLast;
@property (nonatomic) CGFloat antennaYBottom;
@property (nonatomic) CGFloat antennaDeployedPercent;

@property (nonatomic) CGFloat initialVolume;
@property (nonatomic) CGFloat tunerLineLastX;

@property (nonatomic) CGFloat tuningRotationInitial;
@property (nonatomic) CGFloat volumeRotationInitial;

@property (nonatomic) NSArray *presetArrays;


- (IBAction)antennaPan:(UIPanGestureRecognizer *)sender;

- (IBAction)volumeRotating:(UIRotationGestureRecognizer *)sender;
- (IBAction)tuningRotating:(UIRotationGestureRecognizer *)sender;

- (IBAction)presetOne:(id)sender;
- (IBAction)presetTwo:(id)sender;
- (IBAction)presetThree:(id)sender;
- (IBAction)presetFour:(id)sender;
- (IBAction)presetFive:(id)sender;

@property (strong)	  NSURL *		soundFileURLRef;
@property (readonly) SystemSoundID	soundFileObject;


@end
