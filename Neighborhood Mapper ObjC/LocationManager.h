//
//  LocationManager.h
//  Neighborhood Mapper ObjC
//
//  Created by John Nimis on 5/20/16.
//  Copyright © 2016 John Nimis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

@class CLLocationManager;

@interface LocationManager : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSDate *lastTimestamp;
@property (strong, nonatomic) NSDictionary* userData;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) NSString* dateStamp;
@property (strong, nonatomic) NSString* hourStamp;

+ (instancetype)sharedInstance;
- (void)startUpdatingLocation;
- (void)testForPing:(BOOL)test;
- (void)createPingNotification;
- (void)sendData:(NSDictionary*)dataToSend toURL:(NSString*)url;
- (BOOL)storeLocationForKey:(NSString*)key;

@end
