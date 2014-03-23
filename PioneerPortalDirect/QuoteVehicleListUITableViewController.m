//
//  QuoteVehicleListUITableViewController.m
//  PortalDirect
//
//  Created by Brian Kalski on 9/19/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import "QuoteVehicleListUITableViewController.h"
#import "QuoteApplicant.h"
#import "QuoteCoverages.h"
#import "Globals.h"
#import "QuoteVehicle.h"
#import "Quotes.h"
#import "QuoteUITabBarController.h"
#import "QuoteListTableViewCell.h"
#import "QuoteDriverListTableCell.h"
#import "QuoteCoveragesUITableViewController.h"
#import "QuoteVehicleTableViewController.h"

@interface QuoteVehicleListUITableViewController ()

@end

@implementation QuoteVehicleListUITableViewController
@synthesize VehicleListTableView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self StartupFunctions];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self StartupFunctions];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self StartupFunctions];
    
}

-(void)StartupFunctions{
    //set background image
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clouds.png"]];
    [tempImageView setFrame:self.tableView.frame];
    self.tableView.backgroundView = tempImageView;

    
    self.tabBarItem.title = @"Vehicle List";
    
    [self.navigationController setToolbarHidden:NO];
    [self.navigationController setNavigationBarHidden:YES];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Delete Vehicle"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(ToggleEditing)];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithTitle:@"Add Vehicle"
                                  style:UIBarButtonItemStyleBordered
                                  target:self
                                  action:@selector(AddVehicle)];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                              target:nil
                                                                              action:nil];
    
    
    
    //[[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:70/255.0f green:155/255.0f blue:19/255.0f alpha:1.0]];
    
    NSArray *arrBtns = [[NSArray alloc]initWithObjects:editButton, flexible, addButton, nil];
    self.toolbarItems = arrBtns;
    
    [self LoadQuoteVehicleList];
    [VehicleListTableView reloadData];
    
    [self SetTabBarImages];
}

-(void)AddVehicle{
    Globals *tmp = [Globals sharedSingleton];
    tmp.currentVehicleID = @"";
    tmp.createNewVehicle = @"YES";
    QuoteVehicleTableViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"QuoteVehicleTableViewController"];
    [self.navigationController pushViewController:svc animated:YES];
}

-(void) ToggleEditing{
    if(self.editing){
        [self setEditing:NO];
    }
    else{
        [self setEditing:YES];
    }
}


-(void)LoadQuoteVehicleList{
    Globals *tmp = [Globals sharedSingleton];
    tmp.currentVehicleID = @"";
    self.managedObjectContext = tmp.managedObjectContext;
    
    arrayQuoteVehicle = [[NSMutableArray alloc] init];
    arrayQuoteVehicleID = [[NSMutableArray alloc] init];
    
    //[arrayQuoteVehicle addObject:@"Add Vehicle"];
    //[arrayQuoteVehicleID addObject:@"-1"];
    
    NSFetchRequest *_fetchReqE = [[NSFetchRequest alloc] init];
    _fetchReqE.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"quoteID =='", tmp.currentQuoteGuid, @"'", nil]];
    NSEntityDescription *entityE = [NSEntityDescription entityForName:@"QuoteVehicle" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqE setEntity:entityE];
    //sorting
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"year" ascending: YES];
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor, nil];
    [_fetchReqE setSortDescriptors:sortDescriptors];
    
   
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:_fetchReqE error:nil];
    
    for (NSManagedObject *info in fetchedObjects)
    {
        QuoteVehicle *Vehicle = (QuoteVehicle *)info;
        
        //for(QuoteVehicle *Vehicle in quote.quoteVehicle)
        //{
            NSString *VehicleString = [NSString stringWithFormat:@"%@%@%@%@%@", Vehicle.year, @" ", Vehicle.make, @" ", Vehicle.model];
            [arrayQuoteVehicle addObject:VehicleString];
            [arrayQuoteVehicleID addObject:Vehicle.vehicleID];
        //}
        
        
    }
    
    if([arrayQuoteVehicle count] == 0){
        tmp.quoteViewIndex = [NSNumber numberWithInt:2];
        tmp.createNewVehicle = @"YES";
        QuoteVehicleTableViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"QuoteVehicleTableViewController"];
        [self.navigationController pushViewController:svc animated:YES];
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
    return [arrayQuoteVehicle count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Globals *tmp = [Globals sharedSingleton];
    static NSString *CellIdentifier = @"QuoteListTableViewCell";    
    
    QuoteListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[QuoteListTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    cell.txtLeftCell.text = [arrayQuoteVehicle objectAtIndex:indexPath.row];
    cell.txtRightCell.text = @"";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIImage *PlusImage = [UIImage imageNamed:@"blueCar.png"];
    cell.imgIcon.image = PlusImage;

    cell.txtLeftCell.font = tmp.TableViewListFont;
    cell.txtRightCell.font = tmp.TableViewListFont;
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"Vehicle List";
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //[ApplicantListTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSString *vehicleID = [arrayQuoteVehicleID objectAtIndex:indexPath.row];
        
        Globals *tmp = [Globals sharedSingleton];
        self.managedObjectContext = tmp.managedObjectContext;
        
        //delete all objects
        NSFetchRequest *_fetchReq = [[NSFetchRequest alloc] init];
        _fetchReq.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"vehicleID =='", vehicleID, @"'", nil]];
        NSError *error;
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"QuoteVehicle" inManagedObjectContext:self.managedObjectContext];
        [_fetchReq setEntity:entity];
        
        NSArray *arrayTemp = [self.managedObjectContext executeFetchRequest:_fetchReq error:&error];
        for (NSManagedObject * rec in arrayTemp) {
            [self.managedObjectContext deleteObject:rec];
        }
        NSError *saveError = nil;
        [self.managedObjectContext save:&saveError];
        
        [self setEditing:NO];
        
        [arrayQuoteVehicle removeObjectAtIndex:indexPath.row];
        [arrayQuoteVehicleID removeObjectAtIndex:indexPath.row];
        [VehicleListTableView reloadData];
        
        [self SetTabBarImages];
        
        if(![tmp QuoteReadyForReview:tmp.currentQuoteGuid]){
            [(QuoteUITabBarController *)self.tabBarController DisableReviewButton];
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    Globals *tmp = [Globals sharedSingleton];
    tmp.currentVehicleID = [arrayQuoteVehicleID objectAtIndex:indexPath.row];
    
    if([tmp.currentVehicleID isEqualToString:@"-1"]){
        tmp.createNewVehicle = @"YES";
    }
    else{
        tmp.createNewVehicle = @"NO";
    }
    
    QuoteVehicleTableViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"QuoteVehicleTableViewController"];
    [self.navigationController pushViewController:svc animated:YES];
}

-(IBAction)NextStep:(id)sender{
    QuoteCoveragesUITableViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"QuoteCoveragesUITableViewController"];
    [self.navigationController pushViewController:svc animated:YES];
}

-(IBAction)AddAnotherVehicle:(id)sender{
    Globals *tmp = [Globals sharedSingleton];
    tmp.currentVehicleID = @"";
    tmp.createNewVehicle = @"YES";
    QuoteVehicleTableViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"QuoteVehicleTableViewController"];
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)SetTabBarImages{
    Globals *tmp = [Globals sharedSingleton];
    [tmp SetTabBarImagesForTabBarController:self.tabBarController];}


@end
