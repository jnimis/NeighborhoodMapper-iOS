//
//  ButtonCell.h
//  Neighborhood Mapper ObjC
//
//  Created by John Nimis on 5/24/16.
//  Copyright © 2016 John Nimis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainScreenButtonDelegate <NSObject>

- (void)mainScreenButtonTapped:(id)sender;

@end

@interface ButtonCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) NSString* key;

@property id<MainScreenButtonDelegate> delegate;

- (IBAction)buttonTapped:(id)sender;

@end
