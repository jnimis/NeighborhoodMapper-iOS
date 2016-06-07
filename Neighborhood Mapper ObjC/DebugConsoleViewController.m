//
//  DebugConsoleViewController.m
//  Neighborhood Mapper ObjC
//
//  Created by John Nimis on 5/28/16.
//  Copyright © 2016 John Nimis. All rights reserved.
//

#import "DebugConsoleViewController.h"
#import "LocationManager.h"
@import CoreLocation;

@interface DebugConsoleViewController ()

@end

@implementation DebugConsoleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
  
  NSDate *now = [NSDate date];
  NSDateFormatter* df = [[NSDateFormatter alloc] init];
  df.dateFormat = @"MM-dd";
  self.dateStamp = [df stringFromDate:now];
  df.dateFormat = @"HH";
  NSString* hourStamp = [df stringFromDate:now];
  [self.dateStampLabel setText:self.dateStamp];
  
  NSString* lastPingToday = [userDefaults objectForKey:self.dateStamp];
  int currentHour = (int) [hourStamp integerValue];
  [self.hourStampLabel setText:[NSString stringWithFormat:@"hourStamp: %d", currentHour ]];
  if (lastPingToday != nil) {
    [self.lastPingLabel setText:lastPingToday];
    int lastPingHour = (int) [lastPingToday integerValue];
  } else {
    [self.lastPingLabel setText:@"no ping yet today"];
  }
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  
//  [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.recentLocations count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
  }
  
  CLLocation* thisLoc = [self.recentLocations objectAtIndex:indexPath.row];
  
  [cell.textLabel setText:[NSString stringWithFormat:@"lat: %f long %f", thisLoc.coordinate.latitude, thisLoc.coordinate.longitude]];
  return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)dismissTapped:(id)sender {
  [self.delegate dismissPingSurvey];
}

- (IBAction)recentLocsTapped:(id)sender {
  NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
  NSMutableArray* recentLocations = [NSMutableArray array];
    NSMutableArray* archiveArray = [userDefaults objectForKey:@"recentLocations"];
  
    if (archiveArray != nil) {
      for (NSData* encodedLocation in archiveArray) {
        CLLocation *location = [NSKeyedUnarchiver unarchiveObjectWithData:encodedLocation];
        [recentLocations addObject:location];
      }
    }
  
  [self.countLabel setText:[NSString stringWithFormat:@"count: %lu", (unsigned long)[recentLocations count]]];
  
}

- (IBAction)ping:(id)sender {
  [[LocationManager sharedInstance] testForPing:true];
}

- (IBAction)clearPings:(id)sender {
  NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults removeObjectForKey:self.dateStamp];
}

@end
