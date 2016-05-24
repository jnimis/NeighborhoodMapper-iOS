//
//  PingSurveyViewController.h
//  Neighborhood Mapper ObjC
//
//  Created by John Nimis on 5/22/16.
//  Copyright © 2016 John Nimis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PingSurveyControllerDelegate <NSObject>

- (void)dismissPingSurvey;

@end

@interface PingSurveyViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property NSArray* activityValues;

@property (strong, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property int safetyValue;

@property (strong, nonatomic) NSDictionary* userData;

@property id<PingSurveyControllerDelegate> delegate;

- (IBAction)submitButtonTapped:(id)sender;
- (IBAction)sliderChanged:(id)sender;

@end
