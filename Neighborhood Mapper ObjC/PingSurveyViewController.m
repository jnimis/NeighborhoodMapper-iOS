//
//  PingSurveyViewController.m
//  Neighborhood Mapper ObjC
//
//  Created by John Nimis on 5/22/16.
//  Copyright © 2016 John Nimis. All rights reserved.
//

#import "PingSurveyViewController.h"
#import "LocationManager.h"
#import "Constants.h"

@interface PingSurveyViewController ()

@end

@implementation PingSurveyViewController
{
  
}

- (void)viewWillAppear:(BOOL)animated {
  
  self.activityValues = @[
                          @"Work",
                          @"Fitness",
                          @"Socializing",
                          @"Relaxing",
                          @"Commuting/ In-transit",
                          @"Errands & chores",
                          @"Family time"
                          ];

}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.timeLabel setText:[NSString stringWithFormat:@"Message date: %@", self.dateStamp]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return [self.activityValues count];
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  return [self.activityValues objectAtIndex:row];
}

- (IBAction)submitButtonTapped:(id)sender {
  
  int safety = (int) self.slider.value;
  NSString* activity = self.activityValues[[self.picker selectedRowInComponent:0]];
  
  NSMutableDictionary* tempDict = [[NSMutableDictionary alloc] initWithDictionary:self.userData];
  [tempDict setValue:[NSNumber numberWithInt:safety] forKey:@"safety"];
  [tempDict setValue:activity forKey:@"activity"];
  
  // send to server
  [[LocationManager sharedInstance] sendData:tempDict toURL:PING_SURVEY_URL];
  NSLog(@"sending ping survey to server");
  
  // dismiss ping survey
  [self.delegate dismissPingSurvey];
}

- (IBAction)sliderChanged:(UISlider*)sender {
  int discreteValue = roundl([sender value]); // Rounds float to an integer
  [sender setValue:(float)discreteValue];
  self.safetyValue = discreteValue;
}

@end
