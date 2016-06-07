//
//  SurveyViewController.h
//  Neighborhood Mapper ObjC
//
//  Created by John Nimis on 5/20/16.
//  Copyright © 2016 John Nimis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProtocolHeader.h"

@interface SurveyViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

enum  SurveyPicker {
  SurveyPickerGender,
  SurveyPickerEducation,
  SurveyPickerIncome,
  SurveyPickerMarital,
  SurveyPickerChildren,
  SurveyPickerYears,
  SurveyPickerOwnRent
};

- (IBAction)backgroundTapped:(id)sender;

@property id<PingSurveyControllerDelegate> delegate;

@property (strong, nonatomic) NSArray* genderResponses;
@property (strong, nonatomic) NSArray* educationResponses;
@property (strong, nonatomic) NSArray* incomeResponses;
@property (strong, nonatomic) NSArray* maritalResponses;
@property (strong, nonatomic) NSArray* childrenResponses;
@property (strong, nonatomic) NSArray* yearsResponses;
@property (strong, nonatomic) NSArray* ownRentResponses;
@property (strong, nonatomic) NSArray* racialResponses;

@property (strong, nonatomic) IBOutlet UITextField *ageField;
@property (strong, nonatomic) IBOutlet UIPickerView *genderPicker;
@property (strong, nonatomic) IBOutlet UITableView *raceTable;
@property (strong, nonatomic) IBOutlet UIPickerView *educationPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *incomePicker;
@property (strong, nonatomic) IBOutlet UIPickerView *maritalPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *childrenPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *yearsPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *ownRentPicker;
@property (strong, nonatomic) IBOutlet UISlider *trustSlider;
@property (strong, nonatomic) IBOutlet UISlider *safetySlider;
@property (strong, nonatomic) IBOutlet UITextField *emailField;

- (IBAction)submitTapped:(id)sender;
- (IBAction)sliderChanged:(id)sender;

@end
