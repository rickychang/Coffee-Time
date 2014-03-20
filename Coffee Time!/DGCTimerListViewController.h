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
#import "DGCAppDelegate.h"

@interface DGCTimerListViewController : UITableViewController <DGCTimerEditViewControllerDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, assign) BOOL userReorderingCells;

@end
