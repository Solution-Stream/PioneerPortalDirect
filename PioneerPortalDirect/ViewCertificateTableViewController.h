//
//  ViewCertificateTableViewController.h
//  PortalDirect
//
//  Created by Brian Kalski on 3/4/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewCertificateTableViewController : UITableViewController{
    NSMutableArray *arrVehicleYear;
    NSMutableArray *arrVehicleMake;
    NSMutableArray *arrVehicleModel;
    NSMutableArray *arrVehicleVIN;
}
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UITableView *ViewCertificateTableView;
@end
