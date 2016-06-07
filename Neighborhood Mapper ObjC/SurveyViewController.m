//
//  SurveyViewController.m
//  Neighborhood Mapper ObjC
//
//  Created by John Nimis on 5/20/16.
//  Copyright © 2016 John Nimis. All rights reserved.
//

#import "SurveyViewController.h"
#import "LocationManager.h"
#import "Constants.h"

@interface SurveyViewController ()

@end

@implementation SurveyViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
  UILabel* tView = (UILabel*)view;
  if (!tView)
  {
    tView = [[UILabel alloc] init];
    [tView setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    tView.numberOfLines=3;
  }
  NSString* title;

  switch (pickerView.tag) {
    case SurveyPickerGender:
      title = [self.genderResponses objectAtIndex:row];
      break;
    case SurveyPickerEducation:
      title = [self.educationResponses objectAtIndex:row];
      break;
    case SurveyPickerIncome:
      title = [self.incomeResponses objectAtIndex:row];
      break;
    case SurveyPickerMarital:
      title = [self.maritalResponses objectAtIndex:row];
      break;
    case SurveyPickerChildren:
      title = [self.childrenResponses objectAtIndex:row];
      break;
    case SurveyPickerYears:
      title = [self.yearsResponses objectAtIndex:row];
      break;
    case SurveyPickerOwnRent:
      title = [self.ownRentResponses objectAtIndex:row];
      break;
  }

  // Fill the label text here
  tView.text = title;
  return tView;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  NSInteger rowsCount = 0;
  enum SurveyPicker pickerIndex = pickerView.tag;
  switch (pickerIndex) {
    case SurveyPickerGender:
      rowsCount = [self.genderResponses count];
      break;
    case SurveyPickerEducation:
      rowsCount = [self.educationResponses count];
      break;
    case SurveyPickerIncome:
      rowsCount = [self.incomeResponses count];
      break;
    case SurveyPickerMarital:
      rowsCount = [self.maritalResponses count];
      break;
    case SurveyPickerChildren:
      rowsCount = [self.childrenResponses count];
      break;
    case SurveyPickerYears:
      rowsCount = [self.yearsResponses count];
      break;
    case SurveyPickerOwnRent:
      rowsCount = [self.ownRentResponses count];
      break;
  }
  
  return rowsCount;
  
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  
  NSString* title;

  switch (pickerView.tag) {
    case SurveyPickerGender:
      title = [self.genderResponses objectAtIndex:row];
      break;
    case SurveyPickerEducation:
      title = [self.educationResponses objectAtIndex:row];
      break;
    case SurveyPickerIncome:
      title = [self.incomeResponses objectAtIndex:row];
      break;
    case SurveyPickerMarital:
      title = [self.maritalResponses objectAtIndex:row];
      break;
    case SurveyPickerChildren:
      title = [self.childrenResponses objectAtIndex:row];
      break;
    case SurveyPickerYears:
      title = [self.yearsResponses objectAtIndex:row];
      break;
    case SurveyPickerOwnRent:
      title = [self.ownRentResponses objectAtIndex:row];
      break;
  }
  return title;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.racialResponses count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
  }

  cell.textLabel.text = [self.racialResponses objectAtIndex:indexPath.row];
  return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return true;
}

- (IBAction)backgroundTapped:(id)sender {
  [self.view endEditing:true];
}

- (IBAction)submitTapped:(id)sender {
  [self.view endEditing:true];
  
  NSString* email = self.emailField.text;
  if ([email isEqualToString:@""] || email == nil) {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Please enter an Email" message:@"It will be used exclusively to verify your participation in the study" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:ok];
    [alert setModalPresentationStyle:UIModalPresentationPopover];
    [self presentViewController:alert animated:YES completion:nil];
  } else {
  
  NSString* age = self.ageField.text;
  NSString* gender = self.genderResponses[[self.genderPicker selectedRowInComponent:0]];
  NSString* education = self.educationResponses[[self.educationPicker selectedRowInComponent:0]];
  NSString* income = self.incomeResponses[[self.incomePicker selectedRowInComponent:0]];
  NSString* marital = self.maritalResponses[[self.maritalPicker selectedRowInComponent:0]];
  NSString* children = self.childrenResponses[[self.childrenPicker selectedRowInComponent:0]];
  NSString* years = self.yearsResponses[[self.yearsPicker selectedRowInComponent:0]];
  NSString* ownRent = self.ownRentResponses[[self.ownRentPicker selectedRowInComponent:0]];
  NSMutableString* ethnicity = [NSMutableString stringWithString:@"ethnic id: "];
  NSArray* selectedEthnicities = [self.raceTable indexPathsForSelectedRows];
  for (NSIndexPath* indexPath in selectedEthnicities) {
    [ethnicity appendString:[NSString stringWithFormat:@" %@", self.racialResponses[indexPath.row]]];
  }
  NSString* ethnicString = [NSString stringWithString:ethnicity];
  
  NSString *uuid = [[UIDevice currentDevice] identifierForVendor].UUIDString;
  
  int aloneInt = (int) [self.safetySlider value];
  int trustInt = (int) [self.trustSlider value];
  NSString* alone = [NSString stringWithFormat:@"%d", aloneInt];
  NSString* trust = [NSString stringWithFormat:@"%d", trustInt];
  
  NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:
                              age, @"age",
                              gender, @"gender",
                              education, @"education",
                              income, @"income",
                              marital, @"marital",
                              children, @"children",
                              years, @"years_lived",
                              ownRent, @"own_rent",
                              ethnicString, @"ethnic",
                              alone, @"alone",
                              trust, @"trust",
                              uuid, @"user_id",
                              email, @"email",
                              nil];
  
  dispatch_after(20, dispatch_get_main_queue(), ^{
    [[LocationManager sharedInstance] sendData:data toURL:surveyURL];
  });
    
  [self.delegate dismissPingSurvey];
  }
}

- (IBAction)sliderChanged:(UISlider*)sender {
  int discreteValue = roundl([sender value]); // Rounds float to an integer
  [sender setValue:(float)discreteValue];
}

@end
