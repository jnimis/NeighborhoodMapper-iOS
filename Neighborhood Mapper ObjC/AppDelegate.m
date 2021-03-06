//
//  AppDelegate.m
//  Neighborhood Mapper ObjC
//
//  Created by John Nimis on 5/20/16.
//  Copyright © 2016 John Nimis. All rights reserved.
//

#import "AppDelegate.h"
#import "LocationManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
  }
  
  [[LocationManager sharedInstance] startUpdatingLocation];
  
  [[LocationManager sharedInstance] createPingNotification];

  // Override point for customization after application launch.
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
  UIApplicationState state = [application applicationState];
  if (state == UIApplicationStateInactive) {
    // Application was in the background when notification was delivered.
    NSLog(@"user info in handleActionWithIdenfifier is %@", notification.userInfo);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"presentPing" object:nil userInfo:notification.userInfo];

  } else {
    // App was running in the foreground. Perhaps
    // show a UIAlertView to ask them what they want to do?
    NSLog(@"user info in handleActionWithIdenfifier is %@", notification.userInfo);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"presentPing" object:nil userInfo:notification.userInfo];

  }
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {
  if ([identifier isEqualToString:@"pingNo"]) {
    // reschedule notification
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:300];
    localNotification.alertBody = @"Answer a question about your current location?";
    localNotification.alertAction = @"OK";
    localNotification.category = @"pingSurvey";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.userInfo = notification.userInfo;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
  } else {
//    NSLog(@"user info in handleActionWithIdenfifier is %@", notification.userInfo);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"presentPing" object:nil userInfo:notification.userInfo];
  }
  if (completionHandler) {
    completionHandler();
  }
}

@end
