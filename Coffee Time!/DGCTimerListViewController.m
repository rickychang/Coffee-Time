//
//  DGCTimerListViewController.m
//  Coffee Time!
//
//  Created by RIcky Chang on 3/17/14.
//  Copyright (c) 2014 RIcky Chang. All rights reserved.
//

#import "DGCTimerListViewController.h"
#import "DGCTimerDetailViewController.h"
#import "DGCTimerEditViewController.h"

enum {
    DGCTimerListCoffeeSection = 0,
    DGCTimerListTeaSection,
    DGCTimerListNumberOfSections
};

@interface DGCTimerListViewController ()

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

    
    self.coffeeTimers = @[[[DGCTimerModel alloc] initWithName:@"Columbian" duration:240 type:DGCTimerModelTypeCoffee],
                          [[DGCTimerModel alloc] initWithName:@"Mexican" duration:200 type:DGCTimerModelTypeCoffee]];
    
    self.teaTimers = @[[[DGCTimerModel alloc] initWithName:@"Green Tea" duration:400 type:DGCTimerModelTypeTea],
                       [[DGCTimerModel alloc] initWithName:@"Oolong" duration:400 type:DGCTimerModelTypeTea],
                       [[DGCTimerModel alloc] initWithName:@"Rooibos" duration:400 type:DGCTimerModelTypeTea]];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
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
    return DGCTimerListNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == DGCTimerListCoffeeSection)
    {
        return self.coffeeTimers.count;
    }
    else if (section == DGCTimerListTeaSection)
    {
        return self.teaTimers.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    DGCTimerModel *timerModel = [self timerModelForIndexPath:indexPath];
    cell.textLabel.text = timerModel.name;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == DGCTimerListCoffeeSection)
    {
        return @"Coffees";
    }
    else if (section == DGCTimerListTeaSection)
    {
        return @"Teas";
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
            UINavigationController *navController = segue.destinationViewController;
            DGCTimerEditViewController *viewController = (DGCTimerEditViewController *)navController.topViewController;
            viewController.creatingNewTimer = YES;
            viewController.delegate = self;
            viewController.timerModel = [[DGCTimerModel alloc] initWithName:@"" duration:240 type:DGCTimerModelTypeCoffee];
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
    DGCTimerModelType type = viewController.timerModel.type;
    
    if (type == DGCTimerModelTypeCoffee)
    {
        if (![self.coffeeTimers containsObject:viewController.timerModel])
        {
            self.coffeeTimers = [self.coffeeTimers arrayByAddingObject:viewController.timerModel];
        }
        
        if ([self.teaTimers containsObject: viewController.timerModel])
        {
            NSMutableArray *mutableArray = [self.teaTimers mutableCopy];
            [mutableArray removeObject:viewController.timerModel];
            self.teaTimers = [NSArray arrayWithArray:mutableArray];
        }
    }
    else if (type == DGCTimerModelTypeTea)
    {
        if (![self.teaTimers containsObject:viewController.timerModel])
        {
            self.teaTimers = [self.teaTimers arrayByAddingObject:viewController.timerModel];
        }
        
        if ([self.coffeeTimers containsObject:viewController.timerModel])
        {
            NSMutableArray *mutableArray = [self.coffeeTimers mutableCopy];
            [mutableArray removeObject:viewController.timerModel];
            self.coffeeTimers = [NSArray arrayWithArray:mutableArray];
        }
    }
}

-(void)timerEditViewControllerDidCancel:(DGCTimerEditViewController *)viewController
{
    
}

-(DGCTimerModel*)timerModelForIndexPath:(NSIndexPath *)indexPath
{
    DGCTimerModel *timerModel;
    if (indexPath.section == DGCTimerListCoffeeSection)
    {
        timerModel = self.coffeeTimers[indexPath.row];
    }
    else if (indexPath.section == DGCTimerListTeaSection)
    {
        timerModel = self.teaTimers[indexPath.row];
    }
    return timerModel;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if (indexPath.section == DGCTimerListCoffeeSection)
        {
            NSMutableArray *mutableArray = [self.coffeeTimers mutableCopy];
            [mutableArray removeObjectAtIndex:indexPath.row];
            self.coffeeTimers = [NSArray arrayWithArray:mutableArray];
        }
        
        else if (indexPath.section == DGCTimerListTeaSection)
        {
            NSMutableArray *mutableArray = [self.teaTimers mutableCopy];
            [mutableArray removeObjectAtIndex:indexPath.row];
            self.teaTimers = [NSArray arrayWithArray:mutableArray];
        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
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
    NSMutableArray *mutableArray;
    if (sourceIndexPath.section == DGCTimerListCoffeeSection)
    {
        mutableArray = [self.coffeeTimers mutableCopy];
    }
    else if (sourceIndexPath.section == DGCTimerListTeaSection)
    {
        mutableArray = [self.teaTimers mutableCopy];
    }
    
    DGCTimerModel *model = mutableArray[sourceIndexPath.row];
    [mutableArray removeObjectAtIndex:sourceIndexPath.row];
    [mutableArray insertObject:model atIndex:destinationIndexPath.row];
    
    if (sourceIndexPath.section == DGCTimerListCoffeeSection)
    {
        self.coffeeTimers = [NSArray arrayWithArray:mutableArray];
    }
    else if (sourceIndexPath.section == DGCTimerListTeaSection)
    {
        self.teaTimers = [NSArray arrayWithArray:mutableArray];
    }
}

-(NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (sourceIndexPath.section == proposedDestinationIndexPath.section)
    {
        return proposedDestinationIndexPath;
    }
    
    if (sourceIndexPath.section == DGCTimerListCoffeeSection)
    {
        return [NSIndexPath indexPathForRow:self.coffeeTimers.count - 1 inSection:0];
    }
    else if (sourceIndexPath.section == DGCTimerListTeaSection)
    {
        return [NSIndexPath indexPathForRow:0 inSection:1];
    }
    
    return sourceIndexPath;
}

-(void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    DGCTimerModel *timerModel = [self timerModelForIndexPath:indexPath];
    UIPasteboard *sharedPasteboard = [UIPasteboard generalPasteboard];
    [sharedPasteboard setString:timerModel.name];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

@end
