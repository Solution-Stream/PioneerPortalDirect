//
//  QuoteVehicleListUITableViewController.h
//  PortalDirect
//
//  Created by Brian Kalski on 9/19/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuoteVehicleListUITableViewController : UITableViewController{
    NSMutableArray *arrayQuoteVehicle;
    NSMutableArray *arrayQuoteVehicleID;
}
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(IBAction)NextStep:(id)sender;
-(IBAction)AddAnotherVehicle:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *VehicleListTableView;

@end
