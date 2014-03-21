//
//  DGCAppDelegate.m
//  Coffee Time!
//
//  Created by RIcky Chang on 3/12/14.
//  Copyright (c) 2014 RIcky Chang. All rights reserved.
//

#import "DGCAppDelegate.h"
#import "DGCTimerModel.h"
#import "DGCConversionUtils.h"

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
            model.displayOrder = (int)i;
            switch (i) {
                case 0:
                    model.name = NSLocalizedString(@"French Press", @"Default French Press coffee name");
                    model.duration = 240;
                    model.waterDisplayUnits = DGCFluidOuncesUnit;
                    model.water = 16;
                    model.coffeeDisplayUnits = DGCGramsUnit;
                    model.coffeeToWaterRatio = 0.0718547979377f;
                    break;
                    
                case 1:
                    model.name = NSLocalizedString(@"Pour Over", @"Default Pour Over coffee name");
                    model.duration = 180;
                    model.waterDisplayUnits = DGCFluidOuncesUnit;
                    model.water = 10;
                    model.coffeeDisplayUnits = DGCGramsUnit;
                    model.coffeeToWaterRatio = 0.06829268292683f;
                    break;
                case 2:
                    model.name = NSLocalizedString(@"Aeropress", @"Default Aeropress name");
                    model.duration = 60;
                    model.waterDisplayUnits = DGCGramsUnit;
                    model.water = 100;
                    model.coffeeDisplayUnits = DGCGramsUnit;
                    model.coffeeToWaterRatio = 0.29896907216495f;
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

