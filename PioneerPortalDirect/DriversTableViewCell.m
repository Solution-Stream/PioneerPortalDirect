//
//  DriversTableViewCell.m
//  PortalDirect
//
//  Created by Brian Kalski on 2/7/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import "DriversTableViewCell.h"

@implementation DriversTableViewCell
@synthesize txtDriversName,imgDriverIcon;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
