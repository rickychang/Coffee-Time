//
//  DGCTimerListViewController.m
//  Coffee Time!
//
//  Created by Ricky Chang on 3/17/14.
//  Copyright (c) 2014 RIcky Chang. All rights reserved.
//

#import "DGCTimerListViewController.h"
#import "DGCTimerDetailViewController.h"
#import "DGCTimerEditViewController.h"
#import "DGCConversionUtils.h"

enum {
    DGCTimerListCoffeeSection = 0,
    DGCTimerListNumberOfSections
};

@interface DGCTimerListViewController ()

@property (nonatomic, weak) DGCTimerDetailViewController *detailChildController;

@end

@implementation DGCTimerListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    
    self.title = @"Coffee Time!";

    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    NSError *fetchError;
    if (![self.fetchedResultsController performFetch:&fetchError])
    {
        NSLog(@"Error fetching: %@", fetchError);
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    
    return sectionInfo.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    DGCTimerModel *timerModel = [self timerModelForIndexPath:indexPath];
    cell.textLabel.text = timerModel.name;
    cell.textLabel.font = [UIFont systemFontOfSize:24];

    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == DGCTimerListCoffeeSection)
    {
        return @"Brewing Recipes";
    }
    // This shouldn't happen
    return @"";
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]])
    {
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        DGCTimerModel *model = [self timerModelForIndexPath:indexPath];
        
        if ([segue.identifier isEqualToString:@"pushDetail"])
        {
            DGCTimerDetailViewController *viewController = segue.destinationViewController;
            self.detailChildController = viewController;
            viewController.timerModel = model;
        }
        else if ([segue.identifier isEqualToString:@"editDetail"])
        {
            UINavigationController *navController = segue.destinationViewController;
            DGCTimerEditViewController *viewController = (DGCTimerEditViewController *)navController.topViewController;
            viewController.delegate = self;
            viewController.timerModel = model;
        }
    }
    else
    {
        if ([segue.identifier isEqualToString:@"newTimer"])
        {
            NSManagedObjectContext *managedObjectContext = [(DGCAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
            DGCTimerModel *model = [NSEntityDescription insertNewObjectForEntityForName:@"DGCTimerModel"
                                                                 inManagedObjectContext:managedObjectContext];
            
            // initialize new model with some default values
            model.coffeeToWaterRatio = 0.0565f;
            model.duration = 210;
            model.waterDisplayUnits = DGCFluidOuncesUnit;
            model.water = 6;
            model.coffeeDisplayUnits = DGCGramsUnit;
            
            UINavigationController *navController = segue.destinationViewController;
            DGCTimerEditViewController *viewController = (DGCTimerEditViewController *)navController.topViewController;
            viewController.creatingNewTimer = YES;
            viewController.delegate = self;
            viewController.timerModel = model;
            
        }
    }
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"pushDetail"])
    {
        if (self.tableView.isEditing)
        {
            return NO;
        }
    }
    
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.presentedViewController != nil)
    {
        [self.tableView reloadData];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isEditing)
    {
        [self performSegueWithIdentifier:@"editDetail" sender:
         [self.tableView cellForRowAtIndexPath:indexPath]];
    }
}

-(void)timerEditViewControllerDidSaveTimerModel:(DGCTimerEditViewController *)viewController;
{
    [viewController.timerModel.managedObjectContext save:nil];
}

-(void)timerEditViewControllerDidCancel:(DGCTimerEditViewController *)viewController
{
    if (viewController.creatingNewTimer)
    {
        [viewController.timerModel.managedObjectContext deleteObject:viewController.timerModel];
    }
    
}

-(DGCTimerModel*)timerModelForIndexPath:(NSIndexPath *)indexPath
{
    DGCTimerModel *timerModel = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    return timerModel;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        DGCTimerModel *timerModel = [self timerModelForIndexPath:indexPath];
        [timerModel.managedObjectContext deleteObject:timerModel];
    }
}

// Enabling contextual menus for cells
-(BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if ([NSStringFromSelector(action) isEqualToString:@"copy:"])
    {
        return YES;
    }
    return NO;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    self.userReorderingCells = YES;
    
    NSMutableArray *sectionObjects = [[[self.fetchedResultsController sections][sourceIndexPath.section] objects] mutableCopy];
    
    NSManagedObject *movedObject = [[self fetchedResultsController] objectAtIndexPath:sourceIndexPath];
    
    [sectionObjects removeObject:movedObject];
    
    [sectionObjects insertObject:movedObject atIndex:destinationIndexPath.row];
    
    for (NSInteger i = 0; i < sectionObjects.count; i++)
    {
        DGCTimerModel *model = sectionObjects[i];
        model.displayOrder = (int) i;
    }
    
    [movedObject.managedObjectContext save:nil];
    self.userReorderingCells = NO;
}

-(NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (sourceIndexPath.section == proposedDestinationIndexPath.section)
    {
        return proposedDestinationIndexPath;
    }
    
    if (sourceIndexPath.section == DGCTimerListCoffeeSection)
    {
        NSInteger numberOfCells = [self.fetchedResultsController.sections[DGCTimerListCoffeeSection] numberOfObjects];
        return [NSIndexPath indexPathForRow:numberOfCells - 1 inSection:DGCTimerListCoffeeSection];
    }
    
    return sourceIndexPath;
}

-(void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    DGCTimerModel *timerModel = [self timerModelForIndexPath:indexPath];
    UIPasteboard *sharedPasteboard = [UIPasteboard generalPasteboard];
    [sharedPasteboard setString:timerModel.name];
}

-(NSFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController)
    {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"DGCTimerModel"];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"displayOrder" ascending:YES]];
        NSManagedObjectContext *managedObjectConext =
        [(DGCAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectConext sectionNameKeyPath:nil cacheName:nil];
        _fetchedResultsController.delegate = self;
    }
    
    return _fetchedResultsController;
}

-(void)controller:(NSFetchedResultsController *)controller
  didChangeObject:(id)anObject
      atIndexPath:(NSIndexPath *)indexPath
    forChangeType:(NSFetchedResultsChangeType)type
     newIndexPath:(NSIndexPath *)newIndexPath
{
    if (self.userReorderingCells) return;
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
    }
}

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if (self.userReorderingCells) return;
    [self.tableView beginUpdates];
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (self.userReorderingCells) return;
    [self.tableView endUpdates];
}

// state preservation / restoration
- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.detailChildController forKey:@"DGCTimerListViewDetailChild"];
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    self.detailChildController = [coder decodeObjectForKey:@"DGCTimerListViewDetailChild"];
    [super decodeRestorableStateWithCoder:coder];
}


@end
