//
//  ButtonCell.m
//  Neighborhood Mapper ObjC
//
//  Created by John Nimis on 5/24/16.
//  Copyright © 2016 John Nimis. All rights reserved.
//

#import "ButtonCell.h"

@implementation ButtonCell

- (void)awakeFromNib {
  [super awakeFromNib];
    // Initialization code
  
}

- (IBAction)buttonTapped:(id)sender {
  [self.delegate mainScreenButtonTapped:self.key];
}

@end
