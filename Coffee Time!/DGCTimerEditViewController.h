//
//  DGCTimerEditViewController.h
//  Coffee Time!
//
//  Created by RIcky Chang on 3/17/14.
//  Copyright (c) 2014 RIcky Chang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGCTimerModel.h"

@interface DGCTimerEditViewController : UIViewController

@property (nonatomic, strong) DGCTimerModel *timerModel;
@property (nonatomic, strong) IBOutlet UITextField *nameField;
@property (nonatomic, strong) IBOutlet UILabel *minutesLabel;
@property (nonatomic, strong) IBOutlet UILabel *secondsLabel;
@property (nonatomic, strong) IBOutlet UISlider *minutesSlider;
@property (nonatomic, strong) IBOutlet UISlider *secondsSlider;


-(IBAction)cancelButtonWasPressed:(id)sender;
-(IBAction)doneButtonWasPressed:(id)sender;
-(IBAction)sliderValueChanged:(id)sender;

@end
