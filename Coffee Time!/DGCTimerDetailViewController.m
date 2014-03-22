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
@property (nonatomic, strong) UILocalNotification *timerNotification;

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
        countdownRemaining = lround([self timerSecondsRemaining]);
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
        self.countdownLabel.text = [NSString stringWithFormat:@"%d:%02d",
                                    self.timerModel.duration / 60,
                                    self.timerModel.duration % 60];
        [self.startStopButton setTitle:@"Start" forState:UIControlStateNormal];
        [self.startStopButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [[UIApplication sharedApplication] cancelLocalNotification:self.timerNotification];
        [self.timer invalidate];
    }
    else
    {
        [self.navigationItem setHidesBackButton:YES animated:YES];
        [self toggleEditButton:NO];
        
        [self.startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
        [self.startStopButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.countdownLabel.text = [NSString stringWithFormat:@"%d:%02d",
                                    self.timerModel.duration / 60,
                                    self.timerModel.duration % 60];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(timerFired:)
                                                    userInfo:nil
                                                     repeats:YES];
        NSLog(@"Creating local notification");
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.alertBody = @"Coffee Timer Completed!";
        notification.alertAction = @"OK";
        notification.fireDate = [[NSDate date] dateByAddingTimeInterval:self.timerModel.duration];
        notification.soundName = UILocalNotificationDefaultSoundName;
        self.timerNotification = notification;
        [[UIApplication sharedApplication]
         scheduleLocalNotification:notification];
        NSLog(@"fireDate %@", notification.fireDate);

    }
}

-(NSTimeInterval)timerSecondsRemaining
{
    NSLog(@"%@", self.timerNotification);
    if (self.timerNotification)
    {
        NSLog(@"found valid timer notification");
        NSDate *now = [NSDate date];
        return [self.timerNotification.fireDate timeIntervalSinceDate:now];
    }
    else
    {
        return 0.0;
    }
}

-(IBAction)sliderValueChanged:(id)sender
{
    // if current water units are grams step in increments of 10.
    if (self.timerModel.waterDisplayUnits == DGCGramsUnit)
    {
        [self.waterAmountSlider setValue:((int)((self.waterAmountSlider.value + 5) / 10) * 10) animated:NO];
    }
    self.timerModel.water = self.waterAmountSlider.value;
    [self updateWaterCoffeeUI];
}

-(void)timerFired:(NSTimer *)timer
{
    NSInteger secsRemaining = lround([self timerSecondsRemaining]);
    if (secsRemaining % 10 == 0)
    {
        NSTimeInterval timeRemaining = [self timerSecondsRemaining];
        NSLog(@"timerSecondsRemaining: %f", timeRemaining);
    }
    if (secsRemaining > 0)
    {
        self.countdownLabel.text = [NSString stringWithFormat:@"%d:%02d",
                                    secsRemaining / 60,
                                    secsRemaining % 60];
    }
    else
    {
        self.countdownLabel.text = [NSString stringWithFormat:@"%d:%02d",
                                    self.timerModel.duration / 60,
                                    self.timerModel.duration % 60];
        NSLog(@"Timer complete.");
        [self.startStopButton setTitle:@"Start" forState:UIControlStateNormal];
        [self.startStopButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
        NSLog(@"timerFired -> Ending backgroundTaskId: %d", self.backgroundTaskIdentifier);
        [self.timer invalidate];
        [self.navigationItem setHidesBackButton:NO animated:YES];
        [self toggleEditButton:YES];
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
        // TODO: refactor this code into a method...
        self.countdownLabel.text = [NSString stringWithFormat:@"%d:%02d",
                                    self.timerModel.duration / 60,
                                    self.timerModel.duration % 60];
    }
    else if ([keyPath isEqualToString:@"name"])
    {
        self.title = self.timerModel.name;
    }
}

// state preservation / restoration
- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"encodeRestorableStateWithCoder");
    [coder encodeObject:[self.timerModel entity] forKey:@"DGCTimerDetailViewTimerModelEntity"];
    if (self.timerNotification)
    {
        [coder encodeObject:self.timerNotification forKey:@"DGCTimerDetailViewTimeNotification"];
    }
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"decodeRestorableStateWithCoder");
    
    // Restore state based on timer model.
    NSManagedObjectContext *managedObjectContext = [(DGCAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entity = [coder decodeObjectForKey:@"DGCTimerDetailViewTimerModelEntity"];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSError *error;
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    if (array != nil) {
        self.timerModel = array[0];
        self.title = self.timerModel.name;
        self.countdownLabel.text = [NSString stringWithFormat:@"%d:%02d",
                                    self.timerModel.duration / 60,
                                    self.timerModel.duration % 60];
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
    // Restore state based on notification
    UILocalNotification *timerNotification = (UILocalNotification*)[coder decodeObjectForKey:@"DGCTimerDetailViewTimeNotification"];
    if (timerNotification)
    {
        if ([[NSDate date] earlierDate:timerNotification.fireDate])
        {
            // We have a valid notification that hasn't happened yet
            self.timerNotification = timerNotification;
            [self.navigationItem setHidesBackButton:YES animated:YES];
            [self toggleEditButton:NO];
            
            [self.startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
            [self.startStopButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            self.countdownLabel.text = [NSString stringWithFormat:@"%d:%02d",
                                        self.timerModel.duration / 60,
                                        self.timerModel.duration % 60];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                          target:self
                                                        selector:@selector(timerFired:)
                                                        userInfo:nil
                                                         repeats:YES];
        }
        else
        {
            // notifcation already fired.
            [self.navigationItem setHidesBackButton:NO animated:YES];
            [self toggleEditButton:YES];
            self.countdownLabel.text = [NSString stringWithFormat:@"%d:%02d",
                                        self.timerModel.duration / 60,
                                        self.timerModel.duration % 60];
            [self.startStopButton setTitle:@"Start" forState:UIControlStateNormal];
            [self.startStopButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        }
    }
    [super decodeRestorableStateWithCoder:coder];
}


@end
