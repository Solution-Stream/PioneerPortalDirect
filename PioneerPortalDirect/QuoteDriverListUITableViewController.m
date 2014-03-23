//
//  QuoteDriverListUITableViewController.m
//  PortalDirect
//
//  Created by Brian Kalski on 9/12/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import "QuoteDriverListUITableViewController.h"
#import "QuoteDriver.h"
#import "QuoteApplicant.h"
#import "QuoteCoverages.h"
#import "Globals.h"
#import "QuoteListTableViewCell.h"
#import "QuoteAddDriverUITableViewController.h"
#import "QuoteDriverListTableCell.h"
#import "QuoteCoveragesUITableViewController.h"
#import "QuoteUITabBarController.h"
#import "QuoteDriverUITabController.h"
#import "QuoteUITabBarController.h"

@interface QuoteDriverListUITableViewController ()

@end

@implementation QuoteDriverListUITableViewController
@synthesize DriverListTableView;

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
    
    [self StartupFunction];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self StartupFunction];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self StartupFunction];
}

-(void)StartupFunction{
    //set background image
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clouds.png"]];
    [tempImageView setFrame:self.tableView.frame];
    self.tableView.backgroundView = tempImageView;

    
    self.tabBarItem.title = @"Driver List";
    
    [self CheckQuoteToProceed];
    
    [self LoadQuoteDriverList];
    [DriverListTableView reloadData];
    
    [self SetTabBarImages];
    
    [self.navigationController setToolbarHidden:NO];
    [self.navigationController setNavigationBarHidden:YES];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Delete Driver"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(ToggleEditing)];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithTitle:@"Add Driver"
                                  style:UIBarButtonItemStyleBordered
                                  target:self
                                  action:@selector(AddDriver)];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                              target:nil
                                                                              action:nil];
    
    
    
    //[[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:70/255.0f green:155/255.0f blue:19/255.0f alpha:1.0]];
    
    NSArray *arrBtns = [[NSArray alloc]initWithObjects:editButton, flexible, addButton, nil];
    self.toolbarItems = arrBtns;
}

-(void)AddDriver{
    Globals *tmp = [Globals sharedSingleton];
    tmp.currentDriverID = @"";
    tmp.createNewDriver = @"YES";
    QuoteAddDriverUITableViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"QuoteAddDriverUITableViewController"];
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


-(void)CheckQuoteToProceed{
    Globals *tmp = [Globals sharedSingleton];
    self.managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *_fetchReqE = [[NSFetchRequest alloc] init];
    
    _fetchReqE.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"quoteID =='", tmp.currentQuoteGuid, @"'", nil]];
    NSEntityDescription *entityE = [NSEntityDescription entityForName:@"Quotes" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqE setEntity:entityE];
    
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:_fetchReqE error:nil];
    NSInteger qa = 0;
    
    for (NSManagedObject *info in fetchedObjects)
    {
        Quotes *app = (Quotes *)info;
        qa = app.quoteApplicant.count;
    }
    
    if(qa == 0){
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Applicant Info Missing"
//                                                       message: @"Please enter applicant info before proceeding"
//                                                      delegate: self
//                                             cancelButtonTitle:@"OK"
//                                             otherButtonTitles:nil];
//        [alert show];
        
        //[[self.navigationController popViewControllerAnimated:YES] viewWillAppear:YES];
        
        tmp.quoteViewIndex = [NSNumber numberWithInt:0];
        QuoteUITabBarController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"QuoteTabController"];
        [self.navigationController pushViewController:svc animated:YES];
    }

}

-(void)LoadQuoteDriverList{
    Globals *tmp = [Globals sharedSingleton];
    arrayQuoteDriver = [[NSMutableArray alloc] init];
    arrayQuoteDriverID = [[NSMutableArray alloc] init];
    arrayQDInfoNeeded = [[NSMutableArray alloc] init];
    tmp.currentDriverID = @"";
    self.managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *_fetchReqE = [[NSFetchRequest alloc] init];
    _fetchReqE.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"quoteID =='", tmp.currentQuoteGuid, @"'", nil]];
    NSEntityDescription *entityE = [NSEntityDescription entityForName:@"Quotes" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqE setEntity:entityE];
    //sorting
    //NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending: NO];
    //NSArray* sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor, nil];
    //[_fetchReqE setSortDescriptors:sortDescriptors];

    //[arrayQuoteDriver addObject:@"Add Driver"];
    //[arrayQuoteDriverID addObject:@"-1"];

    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:_fetchReqE error:nil];
    
    for (NSManagedObject *info in fetchedObjects)
    {
        Quotes *quote = (Quotes *)info;
        
        NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
        NSArray *sortDescriptors = @[nameDescriptor];
        NSArray *sortedArray = [quote.quoteDriver sortedArrayUsingDescriptors:sortDescriptors];

        for(QuoteDriver *driver in sortedArray)
        {
            
            NSString *driverString = [NSString stringWithFormat:@"%@%@%@", driver.firstName, @" ", driver.lastName];
            [arrayQuoteDriver addObject:driverString];
            [arrayQuoteDriverID addObject:driver.driverID];
            [arrayQDInfoNeeded addObject:driver.infoNeeded];
        }
    }
    
    
    
    if([arrayQuoteDriver count] == 0){
        tmp.quoteViewIndex = [NSNumber numberWithInt:1];
        tmp.createNewDriver = @"YES";
        QuoteAddDriverUITableViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"QuoteAddDriverUITableViewController"];
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
    return [arrayQuoteDriver count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Globals *tmp = [Globals sharedSingleton];
    static NSString *CellIdentifier = @"QuoteDriverListTableCell";
    
    
    
    QuoteDriverListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[QuoteDriverListTableCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    
    cell.txtLeftCell.text = [arrayQuoteDriver objectAtIndex:indexPath.row];
    cell.txtRightCell.text = [arrayQDInfoNeeded objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    UIImage *PlusImage = [UIImage imageNamed:@"user_real_person.png"];
    cell.imgDriverIcon.image = PlusImage;

    cell.txtLeftCell.font = tmp.TableViewListFont;
    //cell.txtRightCell.font = tmp.TableViewListFont;
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"Driver List";
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    Globals *tmp = [Globals sharedSingleton];
    tmp.currentDriverID = [arrayQuoteDriverID objectAtIndex:indexPath.row];
    
    if([tmp.currentDriverID isEqualToString:@"-1"]){
        tmp.createNewDriver = @"YES";
    }
    else{
        tmp.createNewDriver = @"NO";
    }
    
    tmp.quoteDriverViewIndex = [NSNumber numberWithInt:1];
    QuoteAddDriverUITableViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"QuoteAddDriverUITableViewController"];
    //QuoteAddDriverUITableViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"QuoteAddDriverUITableViewController"];
    [self.navigationController pushViewController:svc animated:YES];
    //[self presentViewController:svc animated:YES completion: nil];
}

-(IBAction)NextStep:(id)sender{
    QuoteCoveragesUITableViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"QuoteCoveragesUITableViewController"];
    [self.navigationController pushViewController:svc animated:YES];
}

-(IBAction)AddAnotherDriver:(id)sender{
    Globals *tmp = [Globals sharedSingleton];
    tmp.currentDriverID = @"";
    tmp.createNewDriver = @"YES";
    QuoteAddDriverUITableViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"QuoteAddDriverUITableViewController"];
    [self.navigationController pushViewController:svc animated:YES];
}

-(void)SetTabBarImages{
    Globals *tmp = [Globals sharedSingleton];
    [tmp SetTabBarImagesForTabBarController:self.tabBarController];}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //[ApplicantListTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSString *driverID = [arrayQuoteDriverID objectAtIndex:indexPath.row];
        
        Globals *tmp = [Globals sharedSingleton];
        self.managedObjectContext = tmp.managedObjectContext;
        
        //delete all objects
        NSFetchRequest *_fetchReq = [[NSFetchRequest alloc] init];
        _fetchReq.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"driverID =='", driverID, @"'", nil]];
        NSError *error;
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"QuoteDriver" inManagedObjectContext:self.managedObjectContext];
        [_fetchReq setEntity:entity];
        
        NSArray *arrayTemp = [self.managedObjectContext executeFetchRequest:_fetchReq error:&error];
        for (NSManagedObject * rec in arrayTemp) {
            [self.managedObjectContext deleteObject:rec];
        }
        NSError *saveError = nil;
        [self.managedObjectContext save:&saveError];
        
        [self setEditing:NO];
        
        [arrayQuoteDriver removeObjectAtIndex:indexPath.row];
        [arrayQuoteDriverID removeObjectAtIndex:indexPath.row];
        [DriverListTableView reloadData];
        
        [self SetTabBarImages];
        
        if(![tmp QuoteReadyForReview:tmp.currentQuoteGuid]){
            [(QuoteUITabBarController *)self.tabBarController DisableReviewButton];
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


@end
