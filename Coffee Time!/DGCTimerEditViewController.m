//
//  DGCTimerEditViewController.m
//  Coffee Time!
//
//  Created by RIcky Chang on 3/17/14.
//  Copyright (c) 2014 RIcky Chang. All rights reserved.
//

#import "DGCTimerEditViewController.h"

@interface DGCTimerEditViewController ()

@property (nonatomic, weak) IBOutlet UISegmentedControl *timerTypeSegmentedControl;
@property (nonatomic, strong) NSArray *minuteArray;
@property (nonatomic, strong) NSArray *secondsArray;

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

-(NSArray *)genArrayOverRange:(NSInteger)start end:(NSInteger)end{
    NSMutableArray *array = [NSMutableArray array];
    for(int i=start; i<=end; i++) {
        [array addObject:@(i)]; // @() is the modern objective-c syntax, to box the value into an NSNumber.
    }
    return array;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.minuteArray = [self genArrayOverRange:0 end:9];
    self.secondsArray = [self genArrayOverRange:0 end:59];
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor brownColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.title = self.timerModel.name;

	
    NSInteger numberOfMinutes = self.timerModel.duration / 60;
    NSInteger numberOfSeconds = self.timerModel.duration % 60;
    
    [self.durationPicker selectRow:numberOfMinutes inComponent:0 animated:NO];
    [self.durationPicker selectRow:numberOfSeconds inComponent:1 animated:NO];
    
    self.nameField.text = self.timerModel.name;
    if (self.timerModel.type == DGCTimerModelTypeCoffee)
    {
        self.timerTypeSegmentedControl.selectedSegmentIndex = 0;
    }
    else
    {
        self.timerTypeSegmentedControl.selectedSegmentIndex = 1;
    }
    
}

- (void)updateLabelsWithMinutes:(NSInteger)numberOfMinutes
                        seconds:(NSInteger)numberOfSeconds
{
    if (numberOfMinutes == 1)
    {
        self.minutesLabel.text = @"Minute";
    }
    else
    {
        self.minutesLabel.text = @"Minutes";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancelButtonWasPressed:(id)sender
{
    [self.delegate timerEditViewControllerDidCancel:self];
    [self.presentingViewController
     dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)doneButtonWasPressed:(id)sender
{
    [self saveModel];
    [self.delegate timerEditViewControllerDidSaveTimerModel:self];
    [self.presentingViewController
     dismissViewControllerAnimated:YES completion:nil];
}

-(void)saveModel
{
    DGCTimerModelType type;
    
    if (self.timerTypeSegmentedControl.selectedSegmentIndex == 0)
    {
        type = DGCTimerModelTypeCoffee;
    }
    else
    {
        type = DGCTimerModelTypeTea;
    }
    self.timerModel.name = self.nameField.text;
    self.timerModel.duration = [self.durationPicker selectedRowInComponent:0]* 60 + [self.durationPicker selectedRowInComponent:1];
    self.timerModel.type = type;
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0)
    {
        return self.minuteArray.count;
    }
    else
    {
        return self.secondsArray.count;

    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    if (component == 0)
    {
        return [NSString stringWithFormat:@"%@", self.minuteArray[row]];
        
    }
    else
    {
        return [NSString stringWithFormat:@"%@", self.secondsArray[row]];
    }
}


#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    if (component == 0)
    {
        if (row == 1)
        {
            self.minutesLabel.text = @"Minute";
        }
        else
        {
            self.minutesLabel.text = @"Minutes";
        }
        NSLog(@"selected minute: %@", self.minuteArray[row]);
        
    }
    else
    {
        NSLog(@"selected second: %@", self.secondsArray[row]);
    }
}

-(IBAction)textFieldReturn:(id)sender
{
    self.title = self.nameField.text;
    [sender resignFirstResponder];
}


@end
