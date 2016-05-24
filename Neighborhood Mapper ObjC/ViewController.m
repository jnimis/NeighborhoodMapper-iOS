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

@interface ViewController ()

@end

@implementation ViewController


- (void)viewWillAppear:(BOOL)animated {
  
  self.locKeys = @[
                          @"My home",
                          @"My grocery store",
                          @"My gym or \rfitness studio",
                          @"Favorite coffee shop",
                          @"Favorite store",
                          @"Best local \rwine/beer/alcohol",
                          @"Favorite restaurant",
                          @"Most relaxing spot \rin my neighborhood"
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
  
  [[LocationManager sharedInstance] startUpdatingLocation];
  
  [[LocationManager sharedInstance] createPingNotification];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePingSurvey:) name:@"pingSurvey" object:nil];
  
  [self.collectionView registerNib:[UINib nibWithNibName:@"ButtonCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
  
  UICollectionViewFlowLayout* flow = (UICollectionViewFlowLayout*) self.collectionView.collectionViewLayout;
  flow.estimatedItemSize = CGSizeMake(1, 1);
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)pingButtonTapped:(id)sender {
//  NSDictionary* testDict = @{ @"lat" : @33, @"long" : @-80 };
  [[LocationManager sharedInstance] testForPing:YES];
}

- (void)handlePingSurvey:(NSNotification*)notification {
  PingSurveyViewController* pingSurveyVC = [[PingSurveyViewController alloc] initWithNibName:@"PingSurveyViewController" bundle:nil];
  pingSurveyVC.userData = notification.userInfo;
  pingSurveyVC.delegate = self;
//  pingSurveyVC.picker.dataSource = pingSurveyVC;
//  pingSurveyVC.picker.delegate = pingSurveyVC;
  
  NSLog(@"Ping info in handlePingSurvey is %@", notification.userInfo);
  
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
//  [cell.button addGestureRecognizer:[[UITapGestureRecognizer alloc]
//                                     initWithTarget:self action:@selector(mainScreenButtonTapped:)]];
  return cell;
}

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
    
    [self.collectionView reloadData];
  }
}

@end
