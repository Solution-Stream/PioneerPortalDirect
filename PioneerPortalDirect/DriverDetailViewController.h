//
//  DriverDetailViewController.h
//  PortalDirect
//
//  Created by Brian Kalski on 2/7/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h" 
#import "DriverInfo.h"
#import "Globals.h"

@interface DriverDetailViewController : UITableViewController{
    NSMutableArray *arrayPolicyNumbersDetailView;
    int *clientNumber;
}
@property (weak, nonatomic) IBOutlet UILabel *txtDriverName;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnRemoveDriver;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) IBOutlet UILabel *lblDateOfBirth;
@property (strong, nonatomic) IBOutlet UILabel *txtOccupation;
@property (strong, nonatomic) IBOutlet UILabel *txtEmploymentStatus;
@property (strong, nonatomic) IBOutlet UILabel *txtAnnualIncome;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segFaultAccidents;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segNoFaultAccidents;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segSpeedingTickets;

@end
