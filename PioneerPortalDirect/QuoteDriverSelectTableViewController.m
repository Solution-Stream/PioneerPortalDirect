//
//  QuoteDriverSelectTableViewController.m
//  PortalDirect
//
//  Created by Brian Kalski on 9/24/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import "QuoteDriverSelectTableViewController.h"
#import "Globals.h"
#import "QuoteDriver.h"
#import "QuoteVehicle.h"

@interface QuoteDriverSelectTableViewController ()

@end

@implementation QuoteDriverSelectTableViewController

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

    [self LoadDriverData];
}

-(void)LoadDriverData{
    //fill driver arrays
    arrayQuoteDriver = [[NSMutableArray alloc] init];
    arrayQuoteDriverID = [[NSMutableArray alloc] init];
    
    Globals *tmp = [Globals sharedSingleton];
    self.managedObjectContext = tmp.managedObjectContext;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [arrayQuoteDriver count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DriverSelectTableCell";
    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    
    cell.textLabel.text = [arrayQuoteDriver objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
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
	return @"Please select driver";
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
    self.managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *_fetchReqD = [[NSFetchRequest alloc] init];
    _fetchReqD.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"vehicleID =='", tmp.quoteSelectedVehicle, @"'", nil]];
    NSEntityDescription *entityD = [NSEntityDescription entityForName:@"QuoteVehicle" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqD setEntity:entityD];
    NSArray *fetchedObjectsD = [self.managedObjectContext executeFetchRequest:_fetchReqD error:nil];
    
    for (NSManagedObject *info in fetchedObjectsD)
    {
        QuoteVehicle *vehicle = (QuoteVehicle *)info;
        vehicle.assignedDriverID = [arrayQuoteDriverID objectAtIndex:indexPath.row];
        //vehicle.assignedDriverName = [arrayQuoteDriver objectAtIndex:indexPath.row];
    }
    [self.managedObjectContext save:nil];
    
    [[self.navigationController popViewControllerAnimated:YES] viewWillAppear:YES];
}


@end
