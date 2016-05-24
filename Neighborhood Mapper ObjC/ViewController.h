//
//  ViewController.h
//  Neighborhood Mapper ObjC
//
//  Created by John Nimis on 5/20/16.
//  Copyright © 2016 John Nimis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PingSurveyViewController.h"
#import "ButtonCell.h"

@interface ViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, PingSurveyControllerDelegate, MainScreenButtonDelegate>

@property (strong, nonatomic) NSDictionary* pingInfo;
@property (strong, nonatomic) NSArray* locKeys;
@property (strong, nonatomic) NSMutableArray* keysButtonsToMake;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)pingButtonTapped:(id)sender;

@end

