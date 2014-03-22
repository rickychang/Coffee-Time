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
    
    // Keyboard dismissal and scrolling setup code
    [self registerForKeyboardNotifications];
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.scrollView addGestureRecognizer:tapGesture];
    
    self.minuteArray = [self genArrayOverRange:0 end:9];
    self.secondsArray = [self genArrayOverRange:0 end:59];
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor brownColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.title = self.timerModel.name;

	
    NSInteger numberOfMinutes = self.timerModel.duration / 60;
    NSInteger numberOfSeconds = self.timerModel.duration % 60;
    if (numberOfMinutes == 1)
    {
        self.minutesLabel.text = @"Minute";
    }
    else
    {
        self.minutesLabel.text = @"Minutes";
    }
    
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
    self.scrollView.contentSize = self.contentView.bounds.size;
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

-(DGCUnits)coffeeUnitsFromSegmentIndex:(NSInteger)index
{
    if (index == 0)
    {
        return DGCGramsUnit;
    }
    else
    {
        return DGCTableSpoonsUnit;
    }
}

-(DGCUnits)waterUnitsFromSegmentIndex:(NSInteger)index
{
    if (index == 0)
    {
        return DGCFluidOuncesUnit;
    }
    else
    {
        return DGCGramsUnit;
    }
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

-(void)saveModel
{
    self.timerModel.name = self.nameField.text;
    self.timerModel.duration = (int)[self.durationPicker selectedRowInComponent:0]* 60 + (int)[self.durationPicker selectedRowInComponent:1];
    if (self.ratioField.text != nil)
    {
        self.timerModel.coffeeToWaterRatio = [self.ratioField.text floatValue];
    }
    DGCUnits prevWaterUnits = self.timerModel.waterDisplayUnits;
    DGCUnits curWaterUnits = [self waterUnitsFromSegmentIndex:self.waterUnitsControl.selectedSegmentIndex];
    NSInteger prevWaterAmount = self.timerModel.water;
    if (prevWaterUnits != curWaterUnits)
    {
        if (curWaterUnits == DGCGramsUnit)
        {
            NSInteger curWaterAmount = [DGCConversionUtils convertFluidOuncesToGrams:prevWaterAmount];
            self.timerModel.water = curWaterAmount;
        }
        else
        {
            NSInteger curWaterAmount = [DGCConversionUtils convertGramsToFluidOunces:prevWaterAmount];
            self.timerModel.water = curWaterAmount;
        }
    }
    self.timerModel.waterDisplayUnits = curWaterUnits;
    
    DGCUnits curCoffeeUnits = [self coffeeUnitsFromSegmentIndex:self.coffeeUnitsControl.selectedSegmentIndex];
    self.timerModel.coffeeDisplayUnits = curCoffeeUnits;
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
    }
}

-(IBAction)textFieldReturn:(id)sender
{
    self.title = self.nameField.text;
    [sender resignFirstResponder];
}

- (IBAction)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
}

- (IBAction)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeField = nil;
}

-(void)dismissKeyboard {
    [self.activeField resignFirstResponder];
}


@end
