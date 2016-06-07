//
//  ViewController.h
//  Neighborhood Mapper ObjC
//
//  Created by John Nimis on 5/20/16.
//  Copyright © 2016 John Nimis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProtocolHeader.h"
#import "ButtonCell.h"
#import "SurveyViewController.h"

@interface ViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PingSurveyControllerDelegate, MainScreenButtonDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSDictionary* pingInfo;
@property (strong, nonatomic) NSArray* locKeys;
@property (strong, nonatomic) NSMutableArray* keysButtonsToMake;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) SurveyViewController* surveyView;
@property (strong, nonatomic) NSString* surveyStatus;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)pingButtonTapped:(id)sender;

@end

