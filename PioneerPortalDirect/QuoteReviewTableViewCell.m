//
//  QuoteReviewTableViewCell.m
//  PortalDirect
//
//  Created by Brian Kalski on 9/24/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import "QuoteReviewTableViewCell.h"

@implementation QuoteReviewTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)DriverAssignDone:(id)sender{
    //[txtWorkWeek resignFirstResponder];
}

@end
