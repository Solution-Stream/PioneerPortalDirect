//
//  ViewCertificateTableViewCell.m
//  PortalDirect
//
//  Created by Brian Kalski on 3/4/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import "ViewCertificateTableViewCell.h"

@implementation ViewCertificateTableViewCell
@synthesize txtVehicleMake,txtVehicleModel,txtVehicleYear,imgViewVehicles;
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
