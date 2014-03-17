//
//  DGCTimerDetailViewController.m
//  Coffee Time!
//
//  Created by RIcky Chang on 3/12/14.
//  Copyright (c) 2014 RIcky Chang. All rights reserved.
//

#import "DGCTimerDetailViewController.h"

@interface DGCTimerDetailViewController ()

@property (nonatomic, strong) IBOutlet UILabel *durationLabel;

@end

@implementation DGCTimerDetailViewController

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
    NSLog(@"Detail view did load %@", self.timerModel.name);
	
    self.title = self.timerModel.name;
    
    self.durationLabel.text = [NSString stringWithFormat:@"%d min %d sec",
                               self.timerModel.duration / 60,
                               self.timerModel.duration % 60];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
