//
//  AppDelegate.m
//  CircleMenu
//
//  Created by Richard Calahan on 5/17/12.
//  Copyright (c) 2012 All Day Everyday. All rights reserved.
//

#import "AppDelegate.h"
#import "Menu.h"
#import "MenuItem.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  // Override point for customization after application launch.
  UIViewController *rootViewController = [[UIViewController alloc] init];
  self.window.rootViewController = rootViewController;
  
  Menu *menu = [[Menu alloc] initWithFrame:rootViewController.view.bounds];
  MenuItem *item1 = [[MenuItem alloc] initWithImage:[UIImage imageNamed:@"bg-menuitem"]];
  MenuItem *item2 = [[MenuItem alloc] initWithImage:[UIImage imageNamed:@"bg-menuitem"]];
  MenuItem *item3 = [[MenuItem alloc] initWithImage:[UIImage imageNamed:@"bg-menuitem"]];
  MenuItem *item4 = [[MenuItem alloc] initWithImage:[UIImage imageNamed:@"bg-menuitem"]];
  MenuItem *item5 = [[MenuItem alloc] initWithImage:[UIImage imageNamed:@"bg-menuitem"]];
  MenuItem *item6 = [[MenuItem alloc] initWithImage:[UIImage imageNamed:@"bg-menuitem"]];
  
  NSArray *items = [NSArray arrayWithObjects:item1,item2,item3,item4,item5,item6, nil];
  menu.items = items;
  
  // Add Pinch Gesture
  UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:menu action:@selector(pinchDidOccur:)];
  [menu addGestureRecognizer:pinch];
  [rootViewController.view addSubview:menu];
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
