//
//  ViewCertificateTableViewController.m
//  PortalDirect
//
//  Created by Brian Kalski on 3/4/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import "ViewCertificateTableViewController.h"
#import "ViewCertificateTableViewCell.h"
#import "ViewCertificateViewController.h"
#import "VehicleList.h"
#import "Globals.h"

@interface ViewCertificateTableViewController ()

@end

@implementation ViewCertificateTableViewController
@synthesize ViewCertificateTableView,managedObjectContext;

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

    arrVehicleYear = [[NSMutableArray alloc] init];
    arrVehicleMake = [[NSMutableArray alloc] init];
    arrVehicleModel = [[NSMutableArray alloc] init];
    arrVehicleVIN = [[NSMutableArray alloc] init];
    
    Globals *tmp = [Globals sharedSingleton];
    self.managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *_fetchReqE = [[NSFetchRequest alloc] init];
    _fetchReqE.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@",@"year <>", nil]];
    NSEntityDescription *entityE = [NSEntityDescription entityForName:@"VehicleList" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqE setEntity:entityE];
    //sorting
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"year" ascending:NO];
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor, nil];
    [_fetchReqE setSortDescriptors:sortDescriptors];
    
    NSArray *arrayTempE = [self.managedObjectContext executeFetchRequest:_fetchReqE error:nil];
    for(int i = 0; i < [arrayTempE count] ; i++){
        VehicleList *_vehicleList = (VehicleList*)[arrayTempE objectAtIndex:i];
        NSString *vehicleYear = _vehicleList.year;
        NSString *vehicleMake = _vehicleList.make;
        NSString *vehicleModel = _vehicleList.model;
        NSString *vehicleVIN = _vehicleList.vin;
        if(![vehicleYear isEqualToString:@"9999"]){
            [arrVehicleYear addObject:vehicleYear];
            [arrVehicleMake addObject:vehicleMake];
            [arrVehicleModel addObject:vehicleModel];
            [arrVehicleVIN addObject:vehicleVIN];
        }
    }
    
    [self->ViewCertificateTableView reloadData];}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrVehicleYear count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Globals *tmp = [Globals sharedSingleton];
    static NSString *CellIdentifier = @"VehiclesTableCell";
    
    ViewCertificateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ViewCertificateTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    NSMutableString *model = [arrVehicleModel objectAtIndex:indexPath.row];
    NSMutableString *make = [arrVehicleMake objectAtIndex:indexPath.row];
    NSMutableString *year = [arrVehicleYear objectAtIndex:indexPath.row];
        
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.txtVehicleYear.text = year;
    cell.txtVehicleMake.text = make;
    cell.txtVehicleModel.text = model;
    
    cell.txtVehicleYear.font = tmp.TableViewListFont;
    cell.txtVehicleMake.font = tmp.TableViewListFont;
    cell.txtVehicleModel.font = tmp.TableViewListFont;
    
    return cell;
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = self.storyboard;
    ViewCertificateViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"ViewCertificateViewController"];
            
    Globals *tmp = [Globals sharedSingleton];
    tmp.VIN = [arrVehicleVIN objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}

@end
