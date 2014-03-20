//
//  DGCAppDelegate.m
//  Coffee Time!
//
//  Created by RIcky Chang on 3/12/14.
//  Copyright (c) 2014 RIcky Chang. All rights reserved.
//

#import "DGCAppDelegate.h"
#import "DGCTimerModel.h"

@implementation DGCAppDelegate

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"Application has launched.");
    
    BOOL hasLoadedDefaultModels = [[NSUserDefaults standardUserDefaults]
                                   boolForKey:@"loadedDefaults"];
    
    if (!hasLoadedDefaultModels)
    {
        for (NSInteger i = 0; i < 3; i++)
        {
            DGCTimerModel *model = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"DGCTimerModel"
                                    inManagedObjectContext:self.managedObjectContext];
            model.displayOrder = i;
            switch (i) {
                case 0:
                    model.name = NSLocalizedString(@"French Press", @"Default French Press coffee name");
                    model.duration = 240;
                    model.type = DGCTimerModelTypeCoffee;
                    break;
                    
                case 1:
                    model.name = NSLocalizedString(@"Pour Over", @"Default Pour Over coffee name");
                    model.duration = 180;
                    model.type = DGCTimerModelTypeCoffee;
                    break;
                case 2:
                    model.name = NSLocalizedString(@"Green Tea", @"Default Green Tea tea name");
                    model.duration = 300;
                    model.type = DGCTimerModelTypeTea;
                    break;
            }
        }
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loadedDefaults"];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"Application has resigned active.");
    
    NSError *error;
    if (![self.managedObjectContext save:&error])
    {
        NSLog(@"Could not save managed object context: %@", error);
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"Application has entered background");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"Application has entered background");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"Application has become active.");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext == nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
        
    }
    return _managedObjectContext;
}



-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator == nil)
    {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        
        NSURL *applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        
        NSLog(@"app doc dir: %@", applicationDocumentsDirectory);
        NSURL *storeURL = [applicationDocumentsDirectory
                           URLByAppendingPathComponent:@"CoffeeTime.sqlite"];
        
        NSLog(@"store url: %@", storeURL);
        NSError *error = nil;
        if (![_persistentStoreCoordinator
              addPersistentStoreWithType:NSSQLiteStoreType
              configuration:nil
              URL:storeURL
              options:nil
              error:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    return _persistentStoreCoordinator;
}

-(NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel == nil) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoffeeTime" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    
    return _managedObjectModel;
}

@end

