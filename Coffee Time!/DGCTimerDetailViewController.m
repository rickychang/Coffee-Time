//
//  DGCTimerDetailViewController.m
//  Coffee Time!
//
//  Created by RIcky Chang on 3/12/14.
//  Copyright (c) 2014 RIcky Chang. All rights reserved.
//

#import "DGCTimerDetailViewController.h"
#import "DGCTimerEditViewController.h"
#import "DGCConversionUtils.h"

@interface DGCTimerDetailViewController ()

@property (nonatomic, weak) IBOutlet UILabel *countdownLabel;
@property (nonatomic, weak) IBOutlet UIButton *startStopButton;
@property (nonatomic, weak) IBOutlet UILabel *waterAmountLabel;
@property (nonatomic, weak) IBOutlet UILabel *waterUnitsLabel;
@property (nonatomic, weak) IBOutlet UILabel *coffeeAmountLabel;
@property (nonatomic, weak) IBOutlet UILabel *coffeeUnitsLabel;
@property (nonatomic, weak) IBOutlet UISlider *waterAmountSlider;


@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) NSInteger timeRemaining;

@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

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
    
    self.navigationController.navigationBar.barTintColor = [UIColor brownColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];


	
    self.title = self.timerModel.name;
    NSLog(@"viewDidLoad for detail view called");
    NSInteger countdownRemaining = self.timerModel.duration;
    NSLog(@"Timer duration: %d", self.timerModel.duration);
    NSLog(@"Timer water: %d", self.timerModel.water);
    NSLog(@"Timer ratio: %f", self.timerModel.coffeeToWaterRatio);
    NSLog(@"Timer water display unit: %d", self.timerModel.waterDisplayUnits);
    if (self.timer)
    {
        countdownRemaining = self.timeRemaining;
    }

    self.countdownLabel.text = [NSString stringWithFormat:@"%d:%02d",
                               countdownRemaining / 60,
                               countdownRemaining % 60];
    
    [self updateWaterCoffeeUI];

    
    [self.timerModel addObserver:self
                      forKeyPath:@"duration"
                         options:NSKeyValueObservingOptionNew
                         context:nil];
    [self.timerModel addObserver:self
                      forKeyPath:@"name"
                         options:NSKeyValueObservingOptionNew
                         context:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateWaterCoffeeUI];
}

-(void)updateWaterCoffeeUI
{
    NSLog(@"update water coffee UI");
    DGCUnits waterUnits = self.timerModel.waterDisplayUnits;
    DGCUnits coffeeUnits = self.timerModel.coffeeDisplayUnits;
    NSInteger waterAmount = (NSInteger) self.timerModel.water;
    NSLog(@"water amount: %d", waterAmount);
    NSInteger waterGrams = 0;
    switch (waterUnits)
    {
        case DGCFluidOuncesUnit:
            self.waterAmountSlider.minimumValue = 0;
            self.waterAmountSlider.maximumValue = 32;
            self.waterAmountSlider.value = waterAmount;
            self.waterUnitsLabel.text = @"fl oz";
            self.waterAmountLabel.text = [NSString stringWithFormat:@"%d", waterAmount];
            waterGrams = [DGCConversionUtils convertFluidOuncesToGrams:waterAmount];
            break;
        case DGCGramsUnit:
            self.waterAmountSlider.minimumValue = 0;
            self.waterAmountSlider.maximumValue = 1000;
            self.waterAmountSlider.value = waterAmount;
            self.waterUnitsLabel.text = @"g";
            waterGrams = waterAmount;
            self.waterAmountLabel.text = [NSString stringWithFormat:@"%d", waterAmount];
            break;
        default:
            break;
    }
    NSInteger coffeeGrams = (NSInteger)roundf(waterGrams * self.timerModel.coffeeToWaterRatio);
    NSLog(@"coffeeGrams: %d", coffeeGrams);
    switch (coffeeUnits)
    {
        case DGCGramsUnit:
            self.coffeeUnitsLabel.text = @"g";
            self.coffeeAmountLabel.text = [NSString stringWithFormat:@"%d", coffeeGrams];
            break;
        case DGCTableSpoonsUnit:
            self.coffeeUnitsLabel.text = @"tbsp";
            self.coffeeAmountLabel.text = [NSString stringWithFormat:@"%1.1f", [DGCConversionUtils convertGramsToTablespoons:coffeeGrams]];
            break;
        default:
            break;
            
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)toggleEditButton:(BOOL)show
{
    if (show)
    {
        self.navigationItem.rightBarButtonItem.enabled = true;
    }
    else
    {
        self.navigationItem.rightBarButtonItem.enabled = false;
    }
}

-(IBAction)buttonPressed:(id)sender
{
    if (self.timer)
    {
        // Timer is running and button is pressed. Stop timer.
        
        [self.navigationItem setHidesBackButton:NO animated:YES];
        [self toggleEditButton:YES];
        self.timeRemaining = self.timerModel.duration;
        self.countdownLabel.text = [NSString stringWithFormat:@"%d:%02d",
                                    self.timeRemaining / 60,
                                    self.timeRemaining % 60];
        [self.startStopButton setTitle:@"Start" forState:UIControlStateNormal];
        [self.startStopButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
        NSLog(@"Ending backgroundTaskId: %d", self.backgroundTaskIdentifier);
        [self.timer invalidate];
    }
    else
    {
        [self.navigationItem setHidesBackButton:YES animated:YES];
        [self toggleEditButton:NO];
        
        [self.startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
        [self.startStopButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.timeRemaining = self.timerModel.duration;
        self.countdownLabel.text = [NSString stringWithFormat:@"%d:%02d",
                                    self.timeRemaining / 60,
                                    self.timeRemaining % 60];
        self.backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            NSInteger timeRemaining = [[UIApplication sharedApplication] backgroundTimeRemaining];
            NSLog(@"Killing background task: background time remaining: %d", timeRemaining);
        }];
        NSLog(@"Created backgroundTaskId: %d", self.backgroundTaskIdentifier);
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(timerFired:)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}

-(IBAction)sliderValueChanged:(id)sender
{
    self.timerModel.water = self.waterAmountSlider.value;
    [self updateWaterCoffeeUI];
}

-(void)timerFired:(NSTimer *)timer
{
    self.timeRemaining -= 1;
    if (self.timeRemaining % 20 == 0)
    {
        NSInteger timeRemaining = [[UIApplication sharedApplication] backgroundTimeRemaining];
        NSLog(@"background time remaining: %d", timeRemaining);
    }
    if (self.timeRemaining > 0)
    {
        self.countdownLabel.text = [NSString stringWithFormat:@"%d:%02d",
                                    self.timeRemaining / 60,
                                    self.timeRemaining % 60];
    }
    else
    {
        self.countdownLabel.text = [NSString stringWithFormat:@"%d:%02d",
                                    self.timerModel.duration / 60,
                                    self.timerModel.duration % 60];
        NSLog(@"Timer complete.");
        [self notifyUser:@"Coffee Timer Completed!"];
        [self.startStopButton setTitle:@"Start" forState:UIControlStateNormal];
        [self.startStopButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
        NSLog(@"timerFired -> Ending backgroundTaskId: %d", self.backgroundTaskIdentifier);
        [self.timer invalidate];
        [self.navigationItem setHidesBackButton:NO animated:YES];
        self.editButtonItem.enabled = true;
        self.editButtonItem.title = @"Edit";
    }
}

-(void)notifyUser:(NSString *)alert
{
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
    {
        [[[UIAlertView alloc] initWithTitle:@"Coffee Time!"
                                    message:alert
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil] show];
    }
    else
    {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.alertBody = alert;
        notification.alertAction = @"OK";
        notification.fireDate = nil;
        notification.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication]
         scheduleLocalNotification:notification];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editDetail"])
    {
        UINavigationController *navController = segue.destinationViewController;
        DGCTimerEditViewController *viewController = (DGCTimerEditViewController *)navController.topViewController;
        viewController.timerModel = self.timerModel;
    }
}

-(void)dealloc
{
    [self.timerModel removeObserver:self forKeyPath:@"duration"];
    [self.timerModel removeObserver:self forKeyPath:@"name"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"duration"])
    {
        self.countdownLabel.text = [NSString stringWithFormat:@"%d:%02d",
                                    self.timerModel.duration / 60,
                                    self.timerModel.duration % 60];
    }
    else if ([keyPath isEqualToString:@"name"])
    {
        self.title = self.timerModel.name;
    }
}

@end
