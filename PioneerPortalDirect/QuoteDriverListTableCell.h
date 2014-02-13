//
//  QuoteDriverListTableCell.h
//  PortalDirect
//
//  Created by Brian Kalski on 9/13/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuoteDriverListTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *txtLeftCell;
@property (strong, nonatomic) IBOutlet UILabel *txtRightCell;
@property (nonatomic, strong) IBOutlet UIImageView *imgDriverIcon;
@end
