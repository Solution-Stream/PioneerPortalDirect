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
@synthesize VehiclesTableView,timer,timerReloadVehicleList,cancelButton;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self StartupFunctions];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [self StartupFunctions];
    
}

- (void) StartupFunctions{
    //set up toolbar
    [self.navigationController setToolbarHidden:NO];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Delete Vehicle"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(ToggleEditing)];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithTitle:@"Add Vehicle"
                                  style:UIBarButtonItemStyleBordered
                                  target:self
                                  action:@selector(NavigateToAddVehicleScreen)];
    
    
    cancelButton = [[UIBarButtonItem alloc]
                    initWithTitle:@"Cancel"
                    style:UIBarButtonItemStyleBordered
                    target:self
                    action:@selector(ToggleEditing)];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                              target:nil
                                                                              action:nil];
    
    NSArray *arrBtns = [[NSArray alloc]initWithObjects:editButton, flexible, flexible, addButton, nil];
    self.toolbarItems = arrBtns;

    
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
        [arrVehicleYear addObject:vehicleYear];
        [arrVehicleMake addObject:vehicleMake];
        [arrVehicleModel addObject:vehicleModel];
        [arrVehicleVIN addObject:vehicleVIN];
    }
    
    [self->VehiclesTableView reloadData];
    [VehiclesTableView setEditing:NO animated:YES];
}

-(void) NavigateToAddVehicleScreen{
    UIStoryboard *storyboard = self.storyboard;
    UIViewController *addVehicleController = [storyboard instantiateViewControllerWithIdentifier:@"AddVehicleTableViewController"];
    [self.navigationController pushViewController:addVehicleController animated:YES];
}

-(void)ToggleEditing{
    if(self.editing){
        [self setEditing:NO];
        
        NSMutableArray *toolbarButtons = [self.toolbarItems mutableCopy];
        
        // This is how you remove the button from the toolbar and animate it
        [toolbarButtons removeObject:cancelButton];
        [self setToolbarItems:toolbarButtons animated:YES];
        
    }
    else{
        [self setEditing:YES];
        
        NSMutableArray *toolbarButtons = [self.toolbarItems mutableCopy];
        if (![toolbarButtons containsObject:cancelButton]) {
            [toolbarButtons insertObject:cancelButton atIndex:2];
            [self setToolbarItems:toolbarButtons animated:YES];
        }
    }
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
    Globals *tmp = [Globals sharedSingleton];
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
    
    cell.txtVehicleYear.font = tmp.TableViewListFont;
    cell.txtVehicleMake.font = tmp.TableViewListFont;
    cell.txtVehicleModel.font = tmp.TableViewListFont;
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIStoryboard *storyboard = self.storyboard;
    VehiclesDetailTableViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"VehiclesDetailTableViewController"];
    //UIViewController *addVehicleController = [storyboard instantiateViewControllerWithIdentifier:@"AddVehicleTableViewController"];
    //store policy number array to be used in detail view
        
//    if(indexPath.row == 0){
//        [self.navigationController pushViewController:addVehicleController animated:YES];
//    }
//    else{
        Globals *tmp = [Globals sharedSingleton];
        tmp.VIN = [arrVehicleVIN objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:detailViewController animated:YES];
//    }

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
            [self StartupFunctions];
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
        
        [self StartupFunctions];
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
