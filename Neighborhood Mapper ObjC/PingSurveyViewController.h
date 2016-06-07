//
//  PingSurveyViewController.h
//  Neighborhood Mapper ObjC
//
//  Created by John Nimis on 5/22/16.
//  Copyright © 2016 John Nimis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProtocolHeader.h"

@interface PingSurveyViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property NSArray* activityValues;

@property (strong, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property int safetyValue;
@property (strong, nonatomic) NSString* dateStamp;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) NSDictionary* userData;

@property id<PingSurveyControllerDelegate> delegate;

- (IBAction)submitButtonTapped:(id)sender;
- (IBAction)sliderChanged:(id)sender;

@end
