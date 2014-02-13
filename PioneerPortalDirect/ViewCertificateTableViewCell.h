//
//  ViewCertificateTableViewCell.h
//  PortalDirect
//
//  Created by Brian Kalski on 3/4/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewCertificateTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *txtVehicleYear;
@property (strong, nonatomic) IBOutlet UILabel *txtVehicleMake;
@property (strong, nonatomic) IBOutlet UILabel *txtVehicleModel;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewVehicles;
@end
