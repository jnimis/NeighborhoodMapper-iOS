//
//  LocationManager.m
//  Neighborhood Mapper ObjC
//
//  Created by John Nimis on 5/20/16.
//  Copyright © 2016 John Nimis. All rights reserved.
//

#define pingDelayInMinutes 2
#define URL @"https://citytravel.ssc.wisc.edu/collectInfoiPhone.php"

#import "LocationManager.h"
#import <UIKit/UIKit.h>
@import CoreLocation;
#import "Constants.h"
#import "LinkedList.h"

@implementation LocationManager

+ (instancetype)sharedInstance
{
  static id sharedInstance = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
    LocationManager *instance = sharedInstance;
    instance.locationManager = [CLLocationManager new];
    instance.locationManager.delegate = instance;
    instance.locationManager.desiredAccuracy = kCLLocationAccuracyBest; // you can use kCLLocationAccuracyHundredMeters to get better battery life
    instance.locationManager.pausesLocationUpdatesAutomatically = NO; // this is important
  });
  
  return sharedInstance;
}

- (void)startUpdatingLocation
{
  CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
  
  if (status == kCLAuthorizationStatusDenied)
  {
    NSLog(@"Location services are disabled in settings.");
  }
  else
  {
    // for iOS 8
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
      [self.locationManager requestAlwaysAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
  }
}

- (BOOL)storeLocationForKey:(NSString*)key {
  if (self.currentLocation == nil) {
    return false;
  } else {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSData* locationData = [NSKeyedArchiver archivedDataWithRootObject:self.currentLocation];
    [userDefaults setObject:locationData forKey:key];
    
  }
  return true;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
  CLLocation *mostRecentLocation = locations.lastObject;
  self.currentLocation = mostRecentLocation;
  
  if ([self.locationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)]) {
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
  }
  
  NSDate *now = [NSDate date];
  NSTimeInterval interval = self.lastTimestamp ? [now timeIntervalSinceDate:self.lastTimestamp] : 0;
  NSDateFormatter* df = [[NSDateFormatter alloc] init];
  df.dateFormat = @"MM-dd";
  self.dateStamp = [df stringFromDate:now];
  df.dateFormat = @"HH";
  self.hourStamp = [df stringFromDate:now];
  
  if (!self.lastTimestamp || interval >= pingDelayInMinutes * 60)
  {
    self.lastTimestamp = now;
    
    NSString* latitude = [NSString stringWithFormat:@"%lf", mostRecentLocation.coordinate.latitude];
    NSString* longitude = [NSString stringWithFormat:@"%lf", mostRecentLocation.coordinate.longitude];
    double timeStamp = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString* timeString = [NSString stringWithFormat:@"%.0lf", timeStamp];
    NSString *uuid = [[UIDevice currentDevice] identifierForVendor].UUIDString;

    NSLog(@"Current location: %@ %@", @(mostRecentLocation.coordinate.latitude), @(mostRecentLocation.coordinate.longitude));

    NSLog(@"Sending current location to web service.");
    NSDictionary* dataToSend = [NSDictionary dictionaryWithObjectsAndKeys:
                                latitude, @"lat",
                                longitude, @"long",
                                timeString, @"time",
                                uuid, @"user_id",
                                nil];
    self.userData = dataToSend;
//    NSLog([NSString stringWithFormat:@"%@", dataToSend]);
    
    [self sendData:dataToSend toURL:URL];
    
    [self testForPing:NO];
    
    [self addRecentLocation];
  }
}

- (void)addRecentLocation {
  
  NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
  NSMutableArray* archiveArray = [userDefaults objectForKey:@"recentLocations"];
  NSMutableArray* recentLocations =[NSMutableArray new];
  if (archiveArray != nil) {
    for (NSData* encodedLocation in archiveArray) {
      CLLocation *location = [NSKeyedUnarchiver unarchiveObjectWithData:encodedLocation];
      [recentLocations addObject:location];
    }
  }
  
  [recentLocations insertObject:self.currentLocation atIndex:0];
  if ([recentLocations count] > MAX_SAVED_LOCS) {
    [recentLocations removeObjectAtIndex:MAX_SAVED_LOCS];
  }
  
  for (CLLocation *location in recentLocations) {
    NSData *encodedLocation = [NSKeyedArchiver archivedDataWithRootObject:location];
    [archiveArray addObject:encodedLocation];
  }

  [userDefaults setObject:archiveArray forKey:@"recentLocations"];
  
}

- (void)sendData:(NSDictionary*)dataToSend toURL:(NSString*)url {
  
  NSError* error;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataToSend options:0 error:&error];

  NSURL* dataServerURL = [NSURL URLWithString:url];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:dataServerURL];
  [request setHTTPMethod:@"POST"];
  [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
  NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]];
  [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
  [request setHTTPBody: jsonData];
  
  NSURLSession* session = [NSURLSession sharedSession];
  NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data,
                                                                                            NSURLResponse *response,
                                                                                            NSError *error){
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSLog(@"Data dictionary: %@", responseDictionary);
    //      NSLog(@"NSURLResponse: %@", response);
  }];
  [dataTask resume];

}

- (void)testForPing:(BOOL)test {
  bool shouldPing = YES;
  
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  
  NSArray* keys = @[
    @"My home",
    @"My grocery store",
    @"My gym or \rfitness studio",
    @"Favorite coffee shop",
    @"Favorite store",
    @"Best local \rwine/beer/alcohol",
    @"Favorite restaurant",
    @"Most relaxing spot \rin my neighborhood"
    ];
  
  NSMutableArray* savedLocations = [NSMutableArray array];
  for (NSString* key in keys) {
    NSData* encodedSavedLocation = [userDefaults objectForKey:key];
    if (encodedSavedLocation != nil) {
      [savedLocations addObject:[NSKeyedUnarchiver unarchiveObjectWithData:encodedSavedLocation]];
    }
  }
//  NSArray* savedLocations = [userDefaults objectForKey:@"savedLocations"];
  if ([savedLocations count] > 0) {
    for (CLLocation* location in savedLocations) {
      if ([location distanceFromLocation:self.currentLocation] < 50) {
        shouldPing = NO;
      }
    }
  }
  
  NSMutableArray* recentLocations = [NSMutableArray array];
  NSMutableArray* archiveArray = [userDefaults objectForKey:@"recentLocations"];
  
  if (archiveArray != nil) {
    for (NSData* encodedLocation in archiveArray) {
      CLLocation *location = [NSKeyedUnarchiver unarchiveObjectWithData:encodedLocation];
      [recentLocations addObject:location];
    }
  }
  
  int stationaryPings = (int) STATIONARY_TIME_MINUTES / (PING_TIME_SECONDS / 60);
  int movingPings = (int) MOVING_TIME_MINUTES / (PING_TIME_SECONDS / 60);
  
  if (shouldPing && [recentLocations count] == MAX_SAVED_LOCS) {
    for (int i = 0; i < stationaryPings; i++) {
      if ([self.currentLocation distanceFromLocation:recentLocations[i]] > 17) {
        shouldPing = false;
      }
    }
    
    for (int i = stationaryPings; i < (stationaryPings + movingPings); i++) {
      if ([self.currentLocation distanceFromLocation:recentLocations[i]] < 17) {
        shouldPing = false;
      }
    }
  } else {
    shouldPing = false;
  }
  
  NSString* lastPingToday = [userDefaults objectForKey:self.dateStamp];
  int lastPingHour = (int) [lastPingToday integerValue];
  int currentHour = (int) [self.hourStamp integerValue];
  if ((currentHour - lastPingHour > 1) && currentHour > 7 && currentHour < 9) {
    if (lastPingToday != nil) {
      if (lastPingHour < 12 && currentHour < 12) {
        shouldPing = false;
      } else if (lastPingHour < 17 && currentHour < 17) {
        shouldPing = false;
      } else if (lastPingHour < 21) {
        shouldPing = false;
      }
    }
  } else {
    shouldPing = false;
  }

  if (test) {
    shouldPing = true;
  }
  
  if (shouldPing) {
    
    NSDate* date = [NSDate date];
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM-dd";
    NSString* dateString = [df stringFromDate:date];
    df.dateFormat = @"HH";
    NSString* hourString = [df stringFromDate:date];
    [userDefaults setObject:hourString forKey:dateString];
    
    if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive) {
      // app is inactive: send notification to system
      UILocalNotification* localNotification = [[UILocalNotification alloc] init];
      localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
      localNotification.alertBody = @"Answer a question about your current location?";
      localNotification.alertAction = @"OK";
      localNotification.category = @"pingSurvey";
      localNotification.timeZone = [NSTimeZone defaultTimeZone];
      localNotification.userInfo = self.userData;
      [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    } else {
      [[NSNotificationCenter defaultCenter] postNotificationName:@"pingSurvey" object:nil userInfo:self.userData];
    }
    
  }
}

- (void)createPingNotification {
  
  UIUserNotificationType notificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound);
  
  UIMutableUserNotificationAction *action1;
  action1 = [[UIMutableUserNotificationAction alloc] init];
  [action1 setActivationMode:UIUserNotificationActivationModeForeground];
  [action1 setTitle:@"Now"];
  [action1 setIdentifier:@"pingGo"];
  [action1 setDestructive:NO];
  [action1 setAuthenticationRequired:NO];
  
  UIMutableUserNotificationAction *action2;
  action2 = [[UIMutableUserNotificationAction alloc] init];
  [action2 setActivationMode:UIUserNotificationActivationModeBackground];
  [action2 setTitle:@"Later"];
  [action2 setIdentifier:@"pingNo"];
  [action2 setDestructive:NO];
  [action2 setAuthenticationRequired:NO];
  
  UIMutableUserNotificationCategory *actionCategory;
  actionCategory = [[UIMutableUserNotificationCategory alloc] init];
  [actionCategory setIdentifier:@"pingSurvey"];
  [actionCategory setActions:@[action1, action2]
                  forContext:UIUserNotificationActionContextDefault];
  
  NSSet *categories = [NSSet setWithObject:actionCategory];
  
  UIUserNotificationSettings *settings;
  settings = [UIUserNotificationSettings settingsForTypes:notificationTypes
                                               categories:categories];

  [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
  
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
  
  if ([identifier isEqualToString:@"PingGo"]) {
    
    NSLog(@"You chose action 1.");
  }
  else if ([identifier isEqualToString:@"PingNo"]) {
    
    NSLog(@"You chose action 2.");
  }
  if (completionHandler) {
    
    completionHandler();
  }
}

@end
