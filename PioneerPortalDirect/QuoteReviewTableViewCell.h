//
//  QuoteReviewTableViewCell.h
//  PortalDirect
//
//  Created by Brian Kalski on 9/24/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuoteReviewTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *txtVehicle;
@property (strong, nonatomic) IBOutlet UILabel *txtDriver;
@property (strong, nonatomic) IBOutlet UILabel *txtPremium;
@end
