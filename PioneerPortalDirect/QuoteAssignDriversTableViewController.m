//
//  QuoteReviewTableViewController.m
//  PortalDirect
//
//  Created by Brian Kalski on 9/24/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import "QuoteAssignDriversTableViewController.h"
#import "QuoteDriverSelectTableViewController.h"
#import "QuoteListTableViewController.h"
#import "Globals.h"
#import "QuoteVehicle.h"
#import "QuoteDriver.h"
#import "Quotes.h"
#import "QuoteReviewTableViewCell.h"

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == nil ? @"" : obj; })

@interface QuoteAssignDriversTableViewController ()

@end

@implementation QuoteAssignDriversTableViewController
@synthesize ReviewTableView,currentQuote;

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
    
    [self SetTabBarImages];
    
    [self.navigationController setToolbarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES];
    
    [self LoadQuoteVehicleList];
    
    [ReviewTableView reloadData];
    
    
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self SetTabBarImages];
    
    [self.navigationController setToolbarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES];
    
    [self LoadQuoteVehicleList];
    
    [ReviewTableView reloadData];    
}

- (void)viewDidAppear:(BOOL)animated{
    [self.navigationController setToolbarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES];
    
    [self SetTabBarImages];
    
    [self LoadQuoteVehicleList];
    
    [ReviewTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)LoadQuoteVehicleList{
    Globals *tmp = [Globals sharedSingleton];
    tmp.currentVehicleID = @"";
    self.managedObjectContext = tmp.managedObjectContext;
    
    arrayQuoteVehicle = [[NSMutableArray alloc] init];
    arrayQuoteVehicleID = [[NSMutableArray alloc] init];
    
    arrayQuoteDriver = [[NSMutableArray alloc] init];
    arrayQuoteDriverID = [[NSMutableArray alloc] init];
    
    arrayQuoteVehicleDriver = [[NSMutableArray alloc] init];
        
    NSFetchRequest *_fetchReqE = [[NSFetchRequest alloc] init];
    _fetchReqE.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"quoteID =='", tmp.currentQuoteGuid, @"'", nil]];
    NSEntityDescription *entityE = [NSEntityDescription entityForName:@"QuoteVehicle" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqE setEntity:entityE];
    //sorting
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"year" ascending: NO];
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor, nil];
    [_fetchReqE setSortDescriptors:sortDescriptors];
    
    
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:_fetchReqE error:nil];
    
    for (NSManagedObject *info in fetchedObjects)
    {
        QuoteVehicle *Vehicle = (QuoteVehicle *)info;
        NSString *VehicleString = [NSString stringWithFormat:@"%@%@%@%@%@", Vehicle.year, @" ", Vehicle.make, @" ", Vehicle.model];
        [arrayQuoteVehicle addObject:VehicleString];
        [arrayQuoteVehicleID addObject:Vehicle.vehicleID];
        [arrayQuoteVehicleDriver addObject:NULL_TO_NIL(Vehicle.assignedDriverName)];
    }
    
    //fill driver arrays
    NSFetchRequest *_fetchReqD = [[NSFetchRequest alloc] init];
    _fetchReqD.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"quoteID =='", tmp.currentQuoteGuid, @"'", nil]];
    NSEntityDescription *entityD = [NSEntityDescription entityForName:@"QuoteDriver" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqD setEntity:entityD];
    //sorting
    NSSortDescriptor* sortDescriptorD = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending: NO];
    NSArray* sortDescriptorsD = [[NSArray alloc] initWithObjects: sortDescriptorD, nil];
    [_fetchReqD setSortDescriptors:sortDescriptorsD];
    
    
    NSArray *fetchedObjectsD = [self.managedObjectContext executeFetchRequest:_fetchReqD error:nil];
    
    for (NSManagedObject *info in fetchedObjectsD)
    {
        QuoteDriver *driver = (QuoteDriver *)info;
        NSString *driverString = [NSString stringWithFormat:@"%@%@%@", driver.firstName, @" ", driver.lastName];
        [arrayQuoteDriver addObject:driverString];
        [arrayQuoteDriverID addObject:driver.driverID];
        
    }

    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [arrayQuoteVehicle count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Globals *tmp = [Globals sharedSingleton];
    static NSString *CellIdentifier = @"VehicleListCell";
    
    QuoteReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[QuoteReviewTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    cell.txtVehicle.text = [arrayQuoteVehicle objectAtIndex:indexPath.row];
    if([[arrayQuoteVehicleDriver objectAtIndex:indexPath.row] isEqualToString:@""]){
        cell.txtDriver.text = @"Select Driver";
    }
    else{
        cell.txtDriver.text = [arrayQuoteVehicleDriver objectAtIndex:indexPath.row];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.txtVehicle.font = tmp.TableViewListFont;
    cell.txtDriver.font = tmp.TableViewListFont;
    
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"Quote - Assign Drivers";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    //return @"Assign drivers to vehicles";
    return @"";
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Globals *tmp = [Globals sharedSingleton];
    tmp.quoteSelectedVehicle = [arrayQuoteVehicleID objectAtIndex:indexPath.row];
    QuoteDriverSelectTableViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"QuoteDriverSelectTableViewController"];
    [self.navigationController pushViewController:svc animated:YES];
}

- (IBAction)SaveQuote:(id)sender{
    saveStatus = @"saveOnly";
    [self SubmitQuote:self];
}

- (IBAction)SubmitQuote:(id)sender{
    
    if([saveStatus isEqualToString:@"saveOnly"]){
        [self CommitChanges:@"In Progress"];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Submit Quote Confirmation"
                                                       message: @"Are you sure you want to submit this quote? It will no longer be editable."
                                                      delegate: self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"OK",nil];
        alert.tag = 10;
        [alert show];
    }
    saveStatus = @"";
    
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        if(alertView.tag == 10){
            [self CommitChanges:@"In Progress"];
        }
    }
}

-(void)CommitChanges:(NSString*) status{
    Globals *tmp = [Globals sharedSingleton];
    self.managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *_fetchReqE = [[NSFetchRequest alloc] init];
    _fetchReqE.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"quoteID == '", tmp.currentQuoteGuid, @"'", nil]];
    NSEntityDescription *entityE = [NSEntityDescription entityForName:@"Quotes" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqE setEntity:entityE];
    
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:_fetchReqE error:nil];
    
    for (NSManagedObject *info in fetchedObjects)
    {
        currentQuote = (Quotes *)info;
    }
    currentQuote.quoteStatus = status;
    
    QuoteListTableViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"QuoteListTableViewController"];
    [self.navigationController pushViewController:svc animated:YES];
    
    //QuoteListTableViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"QuoteListTableViewController"];
    //[self.navigationController pushViewController:svc animated:YES];
}

- (void)SetTabBarImages{
    Globals *tmp = [Globals sharedSingleton];
    NSMutableArray *tempArray = [tmp SetTabBarImages:tmp.currentQuoteGuid];
    
    NSInteger qa = [tempArray[0] integerValue];
    NSInteger qd = [tempArray[1] integerValue];
    NSInteger qv = [tempArray[2] integerValue];
    NSInteger qc = [tempArray[3] integerValue];
    
    NSArray *viewControllers = [[NSArray alloc] init];
    viewControllers = self.tabBarController.viewControllers;
    //review tab
    ((UIViewController*)viewControllers[4]).tabBarItem.image = [UIImage imageNamed:@"car-side.png"];
    
    
    if((int)qa == 1){
        ((UIViewController*)viewControllers[0]).tabBarItem.image = [UIImage imageNamed:@"tick.png"];
    }
    else{
        ((UIViewController*)viewControllers[0]).tabBarItem.image = [UIImage imageNamed:@"question.png"];
    }
    
    if((int)qd == 1){
        ((UIViewController*)viewControllers[1]).tabBarItem.image = [UIImage imageNamed:@"tick.png"];
    }
    else{
        ((UIViewController*)viewControllers[1]).tabBarItem.image = [UIImage imageNamed:@"question.png"];
    }
    
    if((int)qv == 1){
        ((UIViewController*)viewControllers[2]).tabBarItem.image = [UIImage imageNamed:@"tick.png"];
    }
    else{
        ((UIViewController*)viewControllers[2]).tabBarItem.image = [UIImage imageNamed:@"question.png"];
    }
    
    if((int)qc == 1){
        ((UIViewController*)viewControllers[3]).tabBarItem.image = [UIImage imageNamed:@"tick.png"];
    }
    else{
        ((UIViewController*)viewControllers[3]).tabBarItem.image = [UIImage imageNamed:@"question.png"];
    }
    
}

@end
