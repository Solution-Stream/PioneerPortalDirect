//
//  VehiclesDetailTableViewController.m
//  PortalDirect
//
//  Created by Brian Kalski on 2/25/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import "VehiclesDetailTableViewController.h"
#import "Globals.h"
#import "VehicleList.h"

@interface VehiclesDetailTableViewController ()

@end

@implementation VehiclesDetailTableViewController
@synthesize txtBodilyInjury,txtCollision,txtComprehensive,txtMake,txtMCCAFee,txtModel,txtPIPCoverage,txtPIPDeductible;
@synthesize txtPPIDeductible,txtPPILimit,txtRoadsideAssistance,txtStatutory,txtUninsuredMotorist,txtYear,managedObjectContext;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set background image
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clouds.png"]];
    [tempImageView setFrame:self.tableView.frame];
    self.tableView.backgroundView = tempImageView;

    Globals *tmp = [Globals sharedSingleton];
    self.managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *_fetchReqE = [[NSFetchRequest alloc] init];
    NSString *selectedVIN = tmp.VIN;
    _fetchReqE.predicate = [NSPredicate predicateWithFormat:@"vin == %@", selectedVIN];
    NSEntityDescription *entityE = [NSEntityDescription entityForName:@"VehicleList" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqE setEntity:entityE];
    NSArray *arrayTempE = [self.managedObjectContext executeFetchRequest:_fetchReqE error:nil];
    for(int i = 0; i < [arrayTempE count] ; i++){
        VehicleList *_vehicleList = (VehicleList*)[arrayTempE objectAtIndex:i];
        txtYear.text = _vehicleList.year;
        txtMake.text = _vehicleList.make;
        txtModel.text = _vehicleList.model;
        txtBodilyInjury.text = _vehicleList.bodilyInjury;
        txtComprehensive.text = _vehicleList.comprehensive;
        txtUninsuredMotorist.text = _vehicleList.uninsuredMotorist;
        }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
