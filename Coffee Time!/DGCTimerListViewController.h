//
//  DGCTimerListViewController.h
//  Coffee Time!
//
//  Created by RIcky Chang on 3/17/14.
//  Copyright (c) 2014 RIcky Chang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGCTimerModel.h"
#import "DGCTimerEditViewController.h"

@interface DGCTimerListViewController : UITableViewController <DGCTimerEditViewControllerDelegate>

@property (nonatomic, strong) NSArray *coffeeTimers;
@property (nonatomic, strong) NSArray *teaTimers;

@end
