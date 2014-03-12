//
//  DGCAppDelegate.m
//  Coffee Time!
//
//  Created by RIcky Chang on 3/12/14.
//  Copyright (c) 2014 RIcky Chang. All rights reserved.
//

#import "DGCAppDelegate.h"

@implementation DGCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"Application has launched.");
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"Application has resigned active.");
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

@end

