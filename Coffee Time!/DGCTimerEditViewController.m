//
//  DGCTimerEditViewController.m
//  Coffee Time!
//
//  Created by RIcky Chang on 3/17/14.
//  Copyright (c) 2014 RIcky Chang. All rights reserved.
//

#import "DGCTimerEditViewController.h"
#import "DGCConversionUtils.h"

@interface DGCTimerEditViewController ()

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
        [array addObject:@(i)];
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
    self.ratioField.keyboardType = UIKeyboardTypeDecimalPad;
    self.ratioField.text = [NSString stringWithFormat:@"%1.4f", self.timerModel.coffeeToWaterRatio];
    switch (self.timerModel.waterDisplayUnits)
    {
        case DGCFluidOuncesUnit:
            self.waterUnitsControl.selectedSegmentIndex = 0;
            break;
        case DGCGramsUnit:
            self.waterUnitsControl.selectedSegmentIndex = 1;
            break;
    }
    
    switch (self.timerModel.coffeeDisplayUnits)
    {
        case DGCGramsUnit:
            self.coffeeUnitsControl.selectedSegmentIndex = 0;
            break;
        case DGCTableSpoonsUnit:
            self.coffeeUnitsControl.selectedSegmentIndex = 1;
            break;
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.scrollView layoutIfNeeded];
    NSLog(@"contentView size: %f x %f", self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    self.scrollView.contentSize = self.contentView.bounds.size;
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
    self.timerModel.name = self.nameField.text;
    self.timerModel.duration = (int)[self.durationPicker selectedRowInComponent:0]* 60 + (int)[self.durationPicker selectedRowInComponent:1];
    if (self.ratioField.text != nil)
    {
        self.timerModel.coffeeToWaterRatio = [self.ratioField.text floatValue];
    }
    switch (self.waterUnitsControl.selectedSegmentIndex)
    {
        case 0:
            self.timerModel.waterDisplayUnits = DGCFluidOuncesUnit;
            break;
        case 1:
            self.timerModel.waterDisplayUnits = DGCGramsUnit;
            break;
    }
    
    switch (self.coffeeUnitsControl.selectedSegmentIndex)
    {
        case 0:
            self.timerModel.coffeeDisplayUnits = DGCGramsUnit;
            break;
        case 1:
            self.timerModel.coffeeDisplayUnits = DGCTableSpoonsUnit;
            break;
    }
    
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
