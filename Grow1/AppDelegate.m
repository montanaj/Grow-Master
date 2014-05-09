//
//  AppDelegate.m
//  Grow1
//
//  Created by Calvin Hildreth on 4/18/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//
#import <Parse/Parse.h>
#import <SpriteKit/SpriteKit.h>
#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"XfAqwHa29fhymS2YVHMi7gFJVwkMM9vUgKqPZTMV"
                  clientKey:@"Lb8SL7fl7Ti5g691gkzzhjdtLSDNdA8Hsp9ehrLN"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    return YES;
}

//-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session]];
//}

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    UINavigationController *navController = (id)self.window.rootViewController;
    for (UIViewController *viewController in navController.viewControllers)
    {
        if ([viewController isKindOfClass:[ViewController class]])
        {
            SKView *spriteView = (id)viewController.view;
            spriteView.paused = YES;
        }
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
//    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
    UINavigationController *navController = (id)self.window.rootViewController;
    for (UIViewController *viewController in navController.viewControllers)
    {
        if ([viewController isKindOfClass:[ViewController class]])
        {
            SKView *spriteView = (id)viewController.view;
            spriteView.paused = NO;
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}

-(BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    return YES;
}
@end
