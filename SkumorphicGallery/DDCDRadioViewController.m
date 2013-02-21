//
//  DDCDRadioViewController.m
//  SkumorphicGallery
//
//  Created by Ben Bruckhart on 2/17/13.
//  Copyright (c) 2013 Ben Bruckhart. All rights reserved.
//

#import "DDCDRadioViewController.h"
#import "MixerHostAudio.h"

@interface DDCDRadioViewController ()

@end

#define MIN_X_TUNER 230
#define MAX_X_TUNER 495

#define STATION_1 MIN_X_TUNER 
#define STATION_2 MIN_X_TUNER + 40
#define STATION_3 MIN_X_TUNER + 120
#define STATION_4 MIN_X_TUNER + 200
#define STATION_5 MAX_X_TUNER - 20

@implementation DDCDRadioViewController

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
    self.tunerLineLastX = CGRectGetMinX(self.tunerLine.frame);
    self.soundFileURLRef    = [[NSBundle mainBundle] URLForResource: @"DialClick"
                                                      withExtension: @"caf"];
    AudioServicesCreateSystemSoundID (
                                      
                                      (__bridge CFURLRef) self.soundFileURLRef,
                                      &_soundFileObject
                                      );
    
}

-(void) viewDidAppear:(BOOL)animated
{
    self.audioObject = [[MixerHostAudio alloc] init];
    
    [self registerForAudioObjectNotifications];
    [self.audioObject setMixerOutputGain: (AudioUnitParameterValue)0];
    
    self.antennaDeployedPercent = 0.0;
    self.antennaView.delegate = self;
    [self rebalanceTuner];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLeftKnobVolume:nil];
    [self setRightKnobTuning:nil];
    [self setTunerLine:nil];
    [self setLeftKnobGestureRecognizer:nil];
    [self setRightKnobGestureRecognizer:nil];
    [self setAntennaView:nil];
    [super viewDidUnload];
}

-(void) viewWillAppear:(BOOL)animated
{

}

-(void) antennaHeightChanged:(float) percent
{
    self.antennaDeployedPercent = percent;
    [self rebalanceTuner];
    
}

-(CGFloat)mixPercentForStation:(int) station
{
    CGFloat targetStationX = 0;
    if (station == 1)
    {
        targetStationX = STATION_1;
    }
    else if (station == 2)
    {
        targetStationX = STATION_2;
    }
    else if (station == 3)
    {
        targetStationX = STATION_3;
    }
    else if (station == 4)
    {
        targetStationX = STATION_4;
    }
    else if (station == 5)
    {
        targetStationX = STATION_5;
    }
    
    CGFloat currentLocation = CGRectGetMinX(self.tunerLine.frame);
    
    if (ABS(targetStationX - currentLocation) < 20)
    {
        return 1.0 - (ABS(targetStationX - currentLocation) / 20.0);
    }
    return 0;
}

-(void) rebalanceTuner
{
    
    
    
    CGFloat station1Level = [self mixPercentForStation:1];
    CGFloat station2Level = [self mixPercentForStation:2];
    CGFloat station3Level = [self mixPercentForStation:3];
    CGFloat station4Level = [self mixPercentForStation:4];
    CGFloat station5Level = [self mixPercentForStation:5];
    
    CGFloat maxStationValue = MAX(station1Level, MAX(station2Level, MAX(station3Level, MAX(station4Level, station5Level))));
    CGFloat stationOffModifier = 1.0 - maxStationValue;
    
    [self.audioObject setMixerInput: (UInt32) 1 gain: (AudioUnitParameterValue) station1Level];
    [self.audioObject setMixerInput: (UInt32) 2 gain: (AudioUnitParameterValue) station2Level];
    [self.audioObject setMixerInput: (UInt32) 3 gain: (AudioUnitParameterValue) station3Level];
    [self.audioObject setMixerInput: (UInt32) 4 gain: (AudioUnitParameterValue) station4Level];
    [self.audioObject setMixerInput: (UInt32) 5 gain: (AudioUnitParameterValue) station5Level];
    
    
    CGFloat totalStatic = (1.0 - self.antennaDeployedPercent) + stationOffModifier;
    
    
    [self.audioObject setMixerInput: (UInt32) 0 gain: (AudioUnitParameterValue) totalStatic];
}

- (IBAction)antennaPan:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.view];
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        self.antennaYLast = self.antennaView.frame.origin.y;
        self.antennaYBottom = CGRectGetMaxY(self.antennaView.frame);
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGFloat newOriginy = translation.y + self.antennaYLast;
        newOriginy = MAX(newOriginy, 64);
        newOriginy = MIN(newOriginy, 334);
        self.antennaView.frame = CGRectMake(self.antennaView.frame.origin.x, newOriginy, self.antennaView.frame.size.width, 364-newOriginy);
    }
}

- (IBAction)volumeRotating:(UIRotationGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        self.volumeRotationInitial = sender.rotation;
    } else
    if (sender.state == UIGestureRecognizerStateChanged)
    {
        
        
        CGFloat difference = sender.rotation - self.volumeRotationInitial;
        CGFloat currentRotation = self.volumeRotationLast + difference;
        
        if (currentRotation > 0)
        {
            if (!self.audioObject.isPlaying) {
                AudioServicesPlaySystemSound (self.soundFileObject);

                [self.audioObject startAUGraph];
            }
            [self.audioObject setMixerOutputGain: (AudioUnitParameterValue) currentRotation/M_PI];
        }
        else
        {
            if (self.audioObject.isPlaying) {
                [self.audioObject stopAUGraph];
                AudioServicesPlaySystemSound (self.soundFileObject);

            }
        }

        self.leftKnobVolume.transform = CGAffineTransformMakeRotation(currentRotation);
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        self.volumeRotationLast =  atan2(self.leftKnobVolume.transform.b, self.leftKnobVolume.transform.a);
    }
}

- (IBAction)tuningRotating:(UIRotationGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        self.tuningRotationInitial = sender.rotation;
    }
    else
    if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGFloat difference = sender.rotation - self.tuningRotationInitial;
        CGFloat currentRotation = self.tuningRotationLast + difference;
        
        self.rightKnobTuning.transform = CGAffineTransformMakeRotation(currentRotation);
        
        CGFloat newX =  self.tunerLineLastX + 100*difference;
        newX = MIN(MAX_X_TUNER, newX);
        newX = MAX(MIN_X_TUNER, newX);
        self.tunerLine.frame = CGRectMake(newX, self.tunerLine.frame.origin.y, self.tunerLine.frame.size.width, self.tunerLine.frame.size.height);
        [self rebalanceTuner];
        
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        self.tuningRotationLast =  atan2(self.rightKnobTuning.transform.b, self.rightKnobTuning.transform.a);
        self.tunerLineLastX = CGRectGetMinX(self.tunerLine.frame);
    }
}

- (IBAction)presetOne:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.tunerLine.frame = CGRectMake(STATION_1, self.tunerLine.frame.origin.y, self.tunerLine.frame.size.width, self.tunerLine.frame.size.height);
        self.tunerLineLastX = CGRectGetMinX(self.tunerLine.frame);
    }];
    [self rebalanceTuner];
}

- (IBAction)presetTwo:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.tunerLine.frame = CGRectMake(STATION_2, self.tunerLine.frame.origin.y, self.tunerLine.frame.size.width, self.tunerLine.frame.size.height);
        self.tunerLineLastX = CGRectGetMinX(self.tunerLine.frame);
    }];
    [self rebalanceTuner];

}

- (IBAction)presetThree:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.tunerLine.frame = CGRectMake(STATION_3, self.tunerLine.frame.origin.y, self.tunerLine.frame.size.width, self.tunerLine.frame.size.height);
        self.tunerLineLastX = CGRectGetMinX(self.tunerLine.frame);
    }];
    [self rebalanceTuner];

}

- (IBAction)presetFour:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.tunerLine.frame = CGRectMake(STATION_4, self.tunerLine.frame.origin.y, self.tunerLine.frame.size.width, self.tunerLine.frame.size.height);
        self.tunerLineLastX = CGRectGetMinX(self.tunerLine.frame);
    }];
    [self rebalanceTuner];

}

- (IBAction)presetFive:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.tunerLine.frame = CGRectMake(STATION_5, self.tunerLine.frame.origin.y, self.tunerLine.frame.size.width, self.tunerLine.frame.size.height);
        self.tunerLineLastX = CGRectGetMinX(self.tunerLine.frame);
    }];
    [self rebalanceTuner];

}

#pragma mark -
#pragma mark Notification registration
// If this app's audio session is interrupted when playing audio, it needs to update its user interface
//    to reflect the fact that audio has stopped. The MixerHostAudio object conveys its change in state to
//    this object by way of a notification. To learn about notifications, see Notification Programming Topics.
- (void) registerForAudioObjectNotifications {
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver: self
                           selector: @selector (handlePlaybackStateChanged:)
                               name: MixerHostAudioObjectPlaybackStateDidChangeNotification
                             object: self.audioObject];
}


// Handle a play/stop button tap
- (IBAction) playOrStop: (id) sender {
    
    if (self.audioObject.isPlaying) {
        [self.audioObject stopAUGraph];
    }
    else {
        [self.audioObject startAUGraph];
    } 
}


- (void) handlePlaybackStateChanged: (id) notification {
    
    [self playOrStop: nil];
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
