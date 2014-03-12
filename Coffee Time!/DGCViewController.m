//
//  DGCViewController.m
//  Coffee Time!
//
//  Created by RIcky Chang on 3/12/14.
//  Copyright (c) 2014 RIcky Chang. All rights reserved.
//

#import "DGCViewController.h"
#import "DGCTimerDetailViewController.h"

@interface DGCViewController ()

@property (nonatomic, strong) IBOutlet UILabel *label;


@end

@implementation DGCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"View is loaded.");
    
    [self setupModel];
    
    self.title = @"Root";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Preparing for segue with identifier:%@", segue.identifier);
    if ([segue.identifier isEqualToString:@"pushDetail"])
    {
        DGCTimerDetailViewController *viewController =
        segue.destinationViewController;
        viewController.timerModel = self.timerModel;
    }
}

-(IBAction)buttonWasPressed:(id)sender
{
    NSLog(@"Button was pressed.");
    
    // Get current date and time
    NSDate *date = [NSDate date];
    
    // Update label.
    self.label.text = [NSString stringWithFormat:@"Button pressed at %@", date];
}


-(void)setTimerModel:(DGCTimerModel *)timerModel
{
    _timerModel = timerModel;
    
    [self updateUserInterface];
}

-(void)setupModel
{
    self.timerModel = [[DGCTimerModel alloc]
                       initWithCoffeeName:@"Columbian Coffee" duration:240];
}

-(void)updateUserInterface
{
    self.label.text = self.timerModel.coffeeName;
}


@end
