//
//  ViewCertificateViewController.h
//  PortalDirect
//
//  Created by Brian Kalski on 3/4/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewCertificateViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UILabel *txtInsured;
@property (strong, nonatomic) IBOutlet UILabel *txtPolicyNumber;
@property (strong, nonatomic) IBOutlet UILabel *txtYear;
@property (strong, nonatomic) IBOutlet UILabel *txtMake;
@property (strong, nonatomic) IBOutlet UILabel *txtModel;
@property (strong, nonatomic) IBOutlet UILabel *txtVIN;
@property (strong, nonatomic) IBOutlet UILabel *txtEffectiveDates;
@property (strong, nonatomic) IBOutlet UILabel *txtInsuredAddress1;
@property (strong, nonatomic) IBOutlet UILabel *txtInsuredAddress2;
@property (strong, nonatomic) IBOutlet UILabel *txtInsuredCity;
@property (strong, nonatomic) IBOutlet UILabel *txtInsuredState;
@property (strong, nonatomic) IBOutlet UILabel *txtInsuredZip;
@property (strong, nonatomic) IBOutlet UITableViewCell *TableViewCellAddress2;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end
