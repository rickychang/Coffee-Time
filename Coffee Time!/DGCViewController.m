//
//  DGCViewController.m
//  Coffee Time!
//
//  Created by RIcky Chang on 3/12/14.
//  Copyright (c) 2014 RIcky Chang. All rights reserved.
//

#import "DGCViewController.h"

@interface DGCViewController ()

@property (nonatomic, strong) IBOutlet UILabel *label;

@property (nonatomic, strong) IBOutlet UISlider *slider;

@property (nonatomic, strong) IBOutlet UIProgressView *progressView;

@end

@implementation DGCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"View is loaded.");
    
    self.view.backgroundColor = [UIColor grayColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)buttonWasPressed:(id)sender
{
    NSLog(@"Button was pressed.");
    
    // Get current date and time
    NSDate *date = [NSDate date];
    
    // Update label.
    self.label.text = [NSString stringWithFormat:@"Button pressed at %@", date];
}

-(IBAction)sliderValueChanged:(id)sender
{
    NSLog(@"Slider value changed to %f", self.slider.value);
    
    // Update our progressView's progress to match
    // the slider value.
    self.progressView.progress = self.slider.value;
}

@end
