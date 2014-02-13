//
//  VehiclesDetailTableViewController.h
//  PortalDirect
//
//  Created by Brian Kalski on 2/25/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VehiclesDetailTableViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UILabel *txtYear;
@property (strong, nonatomic) IBOutlet UILabel *txtMake;
@property (strong, nonatomic) IBOutlet UILabel *txtModel;
@property (strong, nonatomic) IBOutlet UILabel *txtBodilyInjury;
@property (strong, nonatomic) IBOutlet UILabel *txtPPILimit;
@property (strong, nonatomic) IBOutlet UILabel *txtPPIDeductible;
@property (strong, nonatomic) IBOutlet UILabel *txtComprehensive;
@property (strong, nonatomic) IBOutlet UILabel *txtCollision;
@property (strong, nonatomic) IBOutlet UILabel *txtUninsuredMotorist;
@property (strong, nonatomic) IBOutlet UILabel *txtPIPCoverage;
@property (strong, nonatomic) IBOutlet UILabel *txtPIPDeductible;
@property (strong, nonatomic) IBOutlet UILabel *txtRoadsideAssistance;
@property (strong, nonatomic) IBOutlet UILabel *txtMCCAFee;
@property (strong, nonatomic) IBOutlet UILabel *txtStatutory;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end
