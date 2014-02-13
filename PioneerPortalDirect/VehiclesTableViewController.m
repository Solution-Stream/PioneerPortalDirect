//
//  VehiclesTableViewController.m
//  PortalDirect
//
//  Created by Brian Kalski on 2/25/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import "VehiclesTableViewController.h"
#import "AppDelegate.h"
#import "Globals.h"
#import "VehicleList.h"
#import "VehiclesTableViewCell.h"
#import "VehiclesDetailTableViewController.h"
#import "DeleteVehicleFromPolicy.h"
#import "VehiclesOnPolicy.h"

@interface VehiclesTableViewController ()

@end

@implementation VehiclesTableViewController
@synthesize VehiclesTableView,timer,timerReloadVehicleList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [self LoadVehicleGrid];
    
}

- (void) LoadVehicleGrid{
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
        [arrVehicleYear addObject:vehicleYear];
        [arrVehicleMake addObject:vehicleMake];
        [arrVehicleModel addObject:vehicleModel];
        [arrVehicleVIN addObject:vehicleVIN];
    }
    
    [self->VehiclesTableView reloadData];
    [VehiclesTableView setEditing:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [arrVehicleYear count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VehiclesTableCell";
    
    VehiclesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[VehiclesTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    NSMutableString *model = [arrVehicleModel objectAtIndex:indexPath.row];
    NSMutableString *make = [arrVehicleMake objectAtIndex:indexPath.row];
    NSMutableString *year = [arrVehicleYear objectAtIndex:indexPath.row];
    if([model isEqualToString:@"Add Vehicle..."] && [year isEqualToString:@"9999"])
    {        
        make = [NSMutableString stringWithString: @""];
        year = [NSMutableString stringWithString: @""];
        model = [NSMutableString stringWithString: @""];
        cell.txtAddVehicle.text = @"Add Vehicle...";
        UIImage *PlusImage = [UIImage imageNamed:@"SmallBluePlus.png"];
        cell.imgViewVehicles.image = PlusImage;
    }
    else{
        cell.txtAddVehicle.text = [NSMutableString stringWithString: @""];
        UIImage *PlusImage = [UIImage imageNamed:@"blueCar.png"];
        cell.imgViewVehicles.image = PlusImage;
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.txtVehicleYear.text = year;
    cell.txtVehicleMake.text = make;
    cell.txtVehicleModel.text = model;
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return NO;
    }
    else{
        return YES;
    }
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIStoryboard *storyboard = self.storyboard;
    VehiclesDetailTableViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"VehiclesDetailTableViewController"];
    UIViewController *addVehicleController = [storyboard instantiateViewControllerWithIdentifier:@"AddVehicleTableViewController"];
    //store policy number array to be used in detail view
        
    if(indexPath.row == 0){
        [self.navigationController pushViewController:addVehicleController animated:YES];
    }
    else{
        Globals *tmp = [Globals sharedSingleton];
        tmp.VIN = [arrVehicleVIN objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:detailViewController animated:YES];
    }

}

- (IBAction)EditVehicleList:(id)sender {
    if([VehiclesTableView isEditing]){
        [VehiclesTableView setEditing:NO animated:YES];
    }else{
        [VehiclesTableView setEditing:YES animated:YES];
    }

}

- (void)tableView:(UITableView *)table commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(timer){
        [timer invalidate];
        timer = nil;
    }
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Globals *tmp = [Globals sharedSingleton];
        [tmp ShowWaitScreen:@"Removing Vehicle from Policy"];
        
        NSString *deleteVIN = [arrVehicleVIN objectAtIndex:indexPath.row];
        DeleteVehicleFromPolicy *deletePolicy = [[DeleteVehicleFromPolicy alloc] init];
        [deletePolicy RemoveVehicleFromPolicy:tmp.mainPolicyNumber VIN:deleteVIN];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFiring) userInfo:nil repeats:YES];
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 5){
        Globals *tmp = [Globals sharedSingleton];
        if([tmp.VehiclesDoneLoading isEqualToString:@"done"]){
            tmp.VehiclesDoneLoading = @"";
            [self LoadVehicleGrid];
        }
        else{
            [tmp ShowWaitScreen:@"Reloading Vehicle List"];
            timerReloadVehicleList = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerReloadVehicleListFiring) userInfo:nil repeats:YES];
        }
    }
}

-(void) timerReloadVehicleListFiring{
    Globals *tmp = [Globals sharedSingleton];
    if([tmp.VehiclesDoneLoading isEqualToString:@"done"]){
        tmp.VehiclesDoneLoading = @"";
        
        [timerReloadVehicleList invalidate];
        timerReloadVehicleList = nil;
        
        [self LoadVehicleGrid];
        [tmp HideWaitScreen];
    }
}

-(void)timerFiring{
    Globals *tmp = [Globals sharedSingleton];
        
    if([tmp.vehicleRemoved isEqualToString:@"success"]){
        [timer invalidate];
        timer = nil;
        [tmp HideWaitScreen];
        
        // reload vehicle list in CoreData
        tmp.VehiclesDoneLoading = @"";
        VehiclesOnPolicy *vehicleList = [[VehiclesOnPolicy alloc] init];
        [vehicleList LoadVehiclesOnPolicyList:tmp.mainPolicyNumber];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Vehicle Removed"
                                                       message: @"Vehicle Removed Successfully"
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        alert.tag = 5;
        [alert show];
        
        
    }
    if(![tmp.vehicleRemoved isEqualToString:@"success"] && [tmp.vehicleRemoved length] > 0){
        [timer invalidate];
        timer = nil;
        [tmp HideWaitScreen];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Problem Removing Vehicle"
                                                       message: @"Problem removing vehicle. Please try again later."
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        alert.tag = 2;
        [alert show];
    }
}

@end
