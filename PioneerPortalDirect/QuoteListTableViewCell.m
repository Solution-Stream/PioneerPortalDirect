//
//  QuoteListTableViewCell.m
//  PortalDirect
//
//  Created by Brian Kalski on 8/26/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import "QuoteListTableViewCell.h"

@implementation QuoteListTableViewCell
@synthesize imgIcon;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code/Users/briankalski/Documents/PortalDirect - Main IOS 6.0/PortalDirect/PortalDirect/QuoteDriverListTableCell.h
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
