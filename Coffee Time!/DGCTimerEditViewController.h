//
//  DGCTimerEditViewController.h
//  Coffee Time!
//
//  Created by RIcky Chang on 3/17/14.
//  Copyright (c) 2014 RIcky Chang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGCTimerModel.h"


@class DGCTimerEditViewController;

typedef enum {
    DGCTimerEditViewControllerTimerTypeCoffee = 0,
    DGCTimerEditViewControllerTimerTypeTea
}DGCTimerEditViewControllerTimerType;

@protocol DGCTimerEditViewControllerDelegate <NSObject>

-(void)timerEditViewControllerDidCancel:(DGCTimerEditViewController *)viewController;
-(void)timerEditViewControllerDidSaveTimerModel:(DGCTimerEditViewController *)viewController;

@end

@interface DGCTimerEditViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) DGCTimerModel *timerModel;
@property (nonatomic, weak) IBOutlet UITextField *nameField;
@property (nonatomic, weak) IBOutlet UILabel *minutesLabel;
@property (nonatomic, weak) IBOutlet UILabel *secondsLabel;
@property (nonatomic, weak) IBOutlet UIPickerView *durationPicker;

@property (nonatomic, assign) BOOL creatingNewTimer;
@property (nonatomic, weak) id <DGCTimerEditViewControllerDelegate> delegate;


-(IBAction)cancelButtonWasPressed:(id)sender;
-(IBAction)doneButtonWasPressed:(id)sender;
-(IBAction)textFieldReturn:(id)sender;

@end
