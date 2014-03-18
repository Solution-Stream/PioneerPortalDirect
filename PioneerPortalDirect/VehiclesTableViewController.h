//
//  VehiclesTableViewController.h
//  PortalDirect
//
//  Created by Brian Kalski on 2/25/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VehiclesTableViewController : UITableViewController{
    NSMutableArray *arrVehicleYear;
    NSMutableArray *arrVehicleMake;
    NSMutableArray *arrVehicleModel;
    NSMutableArray *arrVehicleVIN;
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UITableView *VehiclesTableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnEditVehicles;
@property (retain, nonatomic) NSTimer *timer;
@property (retain, nonatomic) NSTimer *timerReloadVehicleList;
@property UIBarButtonItem *cancelButton;

- (IBAction)EditVehicleList:(id)sender;

@end
