//
//  ViewController.m
//  Neighborhood Mapper ObjC
//
//  Created by John Nimis on 5/20/16.
//  Copyright © 2016 John Nimis. All rights reserved.
//

#import "ViewController.h"
#import "LocationManager.h"
#import "PingSurveyViewController.h"
#import "ButtonCell.h"
#import "DebugConsoleViewController.h"
#import "Constants.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewWillAppear:(BOOL)animated {
  
  self.locKeys = @[
                          @"My home",
                          @"My grocery store",
                          @"My gym or fitness studio",
                          @"Favorite coffee shop",
                          @"Favorite store",
                          @"Best local wine/beer/alcohol",
                          @"Favorite restaurant",
                          @"Most relaxing spot in my neighborhood"
                          ];
  
  self.keysButtonsToMake = [NSMutableArray array];
  
  NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
  for (NSString* key in self.locKeys) {
    if ([userDefaults objectForKey:key] == nil) {
      // add button for this location
      [self.keysButtonsToMake addObject:key];
    }
  }
  
  // now there's an array with text for each button that should be made
//  [self.collectionView registerClass:[ButtonCell class] forCellWithReuseIdentifier:@"Cell"];

}

- (void)viewDidLoad {
  [super viewDidLoad];
    
//  if ([[UIApplication sharedApplication] respondsToSelector:@selector(currentUserNotificationSettings)]){ // Check it's iOS 8 and above
//    UIUserNotificationSettings *grantedSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
//    
//    if (grantedSettings.types == UIUserNotificationTypeNone) {
//      NSLog(@"No permission granted");
//      UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Please enable Notifications"
//                                                      message:@"In order to be compensated for the study, please go to Settings and turn on Notifications for this app."
//                                                     delegate:nil
//                                            cancelButtonTitle:@"OK"
//                                            otherButtonTitles:nil];
//      [alert show];
//
//    }
//    else if (grantedSettings.types & UIUserNotificationTypeSound & UIUserNotificationTypeAlert ){
//      NSLog(@"Sound and alert permissions ");
//    }
//    else if (grantedSettings.types  & UIUserNotificationTypeAlert){
//      NSLog(@"Alert Permission Granted");
//    }
//  }
//
//  if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
//    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Please enable Location Services"
//                                       message:@"In order to be compensated for the study, please go to Settings and turn on Location Service for this app."
//                                      delegate:nil
//                             cancelButtonTitle:@"OK"
//                             otherButtonTitles:nil];
//    [alert show];
//  }
//
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePingSurvey:) name:@"presentPing" object:nil];
  
  [self.collectionView registerNib:[UINib nibWithNibName:@"ButtonCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
  
  UICollectionViewFlowLayout* flow = (UICollectionViewFlowLayout*) self.collectionView.collectionViewLayout;
  flow.estimatedItemSize = CGSizeMake(1, 1);
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  if (self.surveyStatus == nil) {
    self.surveyStatus = [[NSUserDefaults standardUserDefaults] objectForKey:surveyKey];
  }
  
  if (self.surveyStatus == nil) {
    [self initialSurvey];
    self.surveyStatus = @"yes";
  }

}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)initialSurvey {
  self.surveyView = [[SurveyViewController alloc] initWithNibName:@"SurveyViewController" bundle:nil];
  self.surveyView.delegate = self;
  
  // initialize survey arrays
  self.surveyView.genderResponses = @[@"Male", @"Female", @"Transgender", @"Gender queer / gender nonconforming"];
  self.surveyView.educationResponses = @[@"Grammar School",
                                         @"High school or GED",
                                         @"Vocational/technical school (2 year)",
                                         @"Some college",
                                         @"Bachelor's degree",
                                         @"Professional (MD, JD), Master's or Doctoral degree"];
  self.surveyView.yearsResponses = @[@"Less than 1 year",
                                     @"1-2 years",
                                     @"3-5 years",
                                     @"6-10 years", 
                                     @"More than 10 years"];
  self.surveyView.ownRentResponses = @[@"Own",
                                       @"Rent"];
  self.surveyView.maritalResponses = @[@"Single, never married",
                                       @"Married",
                                       @"Divorced or widowed", 
                                       @"Other"];
  self.surveyView.childrenResponses = @[@"None",
                                        @"One",
                                        @"Two", 
                                        @"Three", 
                                        @"Four or more"];
  self.surveyView.incomeResponses = @[@"Under $25,000",
                                      @"$26,000-$40,000",
                                      @"$41,000-$55,000",
                                      @"$56,000-$75,000",
                                      @"$76,000-$99,999", 
                                      @"$100,000-$150,000", 
                                      @"$150,000+"];
  self.surveyView.racialResponses = @[@"White",
                                      @"Black",
                                      @"Asian",
                                      @"Pacific Islander",
                                      @"Indigenous or Aboriginal",
                                      @"Hispanic or Latino",
                                      @"Multi-racial",
                                      @"Other"];
  
  [self presentViewController:self.surveyView animated:YES completion:^{
    
  }];
}


- (IBAction)pingButtonTapped:(id)sender {
  
//  [[NSNotificationCenter defaultCenter] postNotificationName:@"pingSurvey" object:nil userInfo:nil];
//  NSDictionary* testDict = @{ @"lat" : @33, @"long" : @-80 };
//  [[LocationManager sharedInstance] testForPing:YES];
//  [self initialSurvey];
  DebugConsoleViewController* vc = [[DebugConsoleViewController alloc] initWithNibName:@"DebugConsoleViewController" bundle:nil];
  vc.delegate = self;
  
  [self presentViewController:vc animated:YES completion:^{
    
  }];
}

- (void)handlePingSurvey:(NSNotification*)notification {
  if (self.presentedViewController != nil) {
    [self dismissViewControllerAnimated:YES completion:nil];
  }
  
  PingSurveyViewController* pingSurveyVC = [[PingSurveyViewController alloc] initWithNibName:@"PingSurveyViewController" bundle:nil];
  pingSurveyVC.userData = notification.userInfo;
  pingSurveyVC.delegate = self;
  NSDateFormatter* df = [NSDateFormatter new];
  df.dateFormat = @"MMM d, h:mm a";
  pingSurveyVC.dateStamp = [df stringFromDate:[NSDate date]];;
//  pingSurveyVC.picker.dataSource = pingSurveyVC;
//  pingSurveyVC.picker.delegate = pingSurveyVC;
  
//  NSLog(@"Ping info in handlePingSurvey is %@", notification.userInfo);
  
  [self presentViewController:pingSurveyVC animated:YES completion:^{
    
  }];
  
}

- (void)dismissPingSurvey {
  [self dismissViewControllerAnimated:YES completion:^{
    
  }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return [self.keysButtonsToMake count];
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  ButtonCell* cell = (ButtonCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
  NSString* title = [self.keysButtonsToMake objectAtIndex:indexPath.row];
  [cell.button setTitle:title forState:UIControlStateNormal];
  cell.key = title;
  cell.delegate = self;

  return cell;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView
//                  layout:(UICollectionViewLayout *)collectionViewLayout
//  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//  CGRect screenRect = [[UIScreen mainScreen] bounds];
//  CGFloat screenWidth = screenRect.size.width;
//  CGFloat screenHeight = screenRect.size.height;
//  float cellWidth = screenWidth / 3.0; //Replace the divisor with the column count requirement. Make sure to have it in float.
//  if (screenHeight > screenWidth) {
//    cellWidth = screenWidth; //Replace the divisor with the column count requirement. Make sure to have it in float.
//  }
//  
//  CGSize size = CGSizeMake(cellWidth, cellWidth);
//  
//  return size;
//}

- (void)mainScreenButtonTapped:(NSString*)key {
  
//  ButtonCell* tappedButton = (ButtonCell*) sender;
//  NSString* key = tappedButton.key;
  
  // get location
  BOOL success = [[LocationManager sharedInstance] storeLocationForKey:key];
  
//  BOOL success = false;
  
  if (!success) {
    // alert view to show failure?
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Location not available"
                                                                   message:@"Please try again later"
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *stayAction)
                                   {
                                     // present other options
                                     
                                   }];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];

  } else {
    NSLog(@"succeeded at storing location");
    // remove button from view
    NSString* toRemove;
    for (NSString* testKey in self.keysButtonsToMake) {
      if ([testKey isEqualToString:key]) {
        toRemove = testKey;
      }
    }
    
    if (toRemove != nil) {
      [self.keysButtonsToMake removeObject:toRemove];
    }
    
    [self.tableView reloadData];
    
    if ([key isEqualToString:@"My home"]) {
//        [self initialSurvey];
    }
    
  }
}

#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.keysButtonsToMake count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
  }
  
  NSString* title = [self.keysButtonsToMake objectAtIndex:indexPath.row];
  
  [cell.textLabel setText:title];
  cell.textLabel.numberOfLines = 0;
  cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // get key, call mainScreenButtonTapped
  UITableViewCell* tappedCell = [tableView cellForRowAtIndexPath:indexPath];
  NSString* key = tappedCell.textLabel.text;
  [self mainScreenButtonTapped:key];
  
}

@end
