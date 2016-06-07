//
//  DebugConsoleViewController.h
//  Neighborhood Mapper ObjC
//
//  Created by John Nimis on 5/28/16.
//  Copyright © 2016 John Nimis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProtocolHeader.h"

@interface DebugConsoleViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* recentLocations;
@property (strong, nonatomic) IBOutlet UILabel *hourStampLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateStampLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastPingLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) NSString* dateStamp;

@property id<PingSurveyControllerDelegate> delegate;
- (IBAction)dismissTapped:(id)sender;
- (IBAction)recentLocsTapped:(id)sender;
- (IBAction)ping:(id)sender;
- (IBAction)clearPings:(id)sender;

@end
