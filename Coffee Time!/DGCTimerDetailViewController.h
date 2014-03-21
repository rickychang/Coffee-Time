//
//  DGCTimerDetailViewController.h
//  Coffee Time!
//
//  Created by RIcky Chang on 3/12/14.
//  Copyright (c) 2014 RIcky Chang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGCTimerModel.h"

@interface DGCTimerDetailViewController : UIViewController

@property (nonatomic, weak) DGCTimerModel *timerModel;
-(IBAction)sliderValueChanged:(id)sender;

@end
