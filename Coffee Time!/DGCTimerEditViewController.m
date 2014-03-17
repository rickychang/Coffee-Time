//
//  DGCTimerEditViewController.m
//  Coffee Time!
//
//  Created by RIcky Chang on 3/17/14.
//  Copyright (c) 2014 RIcky Chang. All rights reserved.
//

#import "DGCTimerEditViewController.h"

@interface DGCTimerEditViewController ()

@end

@implementation DGCTimerEditViewController

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
	
    NSInteger numberOfMinutes = self.timerModel.duration / 60;
    NSInteger numberOfSeconds = self.timerModel.duration % 60;
    
    self.nameField.text = self.timerModel.coffeeName;
    self.minutesLabel.text = [NSString
                              stringWithFormat:@"%d Minutes", numberOfMinutes];
    self.secondsLabel.text = [NSString stringWithFormat:@"%d Seconds", numberOfSeconds];
    self.minutesSlider.value = numberOfMinutes;
    self.secondsSlider.value = numberOfSeconds;
    
}

- (void)updateLabelsWithMinutes:(NSInteger)numberOfMinutes
                        seconds:(NSInteger)numberOfSeconds
{
    if (numberOfMinutes == 1)
    {
        self.minutesLabel.text = @"1 Minute";
    }
    else
    {
        self.minutesLabel.text = [NSString stringWithFormat:@"%d Minutes", numberOfMinutes];
    }
    
    if (numberOfSeconds == 1)
    {
        self.secondsLabel.text = @"1 Second";
    }
    else
    {
        self.secondsLabel.text = [NSString stringWithFormat:@"%d Seconds", numberOfSeconds];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancelButtonWasPressed:(id)sender
{
    NSLog(@"cancelButtonWasPressed.");
    [self.presentingViewController
     dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)doneButtonWasPressed:(id)sender
{
    [self.presentingViewController
     dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)sliderValueChanged:(id)sender
{
    NSInteger numberOfMinutes = (NSInteger)self.minutesSlider.value;
    NSInteger numberOfSeconds = (NSInteger)self.secondsSlider.value;
    [self updateLabelsWithMinutes:numberOfMinutes seconds:numberOfSeconds];
}


@end
