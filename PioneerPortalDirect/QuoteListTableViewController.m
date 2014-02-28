//
//  QuoteListTableViewController.m
//  PortalDirect
//
//  Created by Brian Kalski on 8/26/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import "QuoteListTableViewController.h"
#import "QuoteApplicantUITableViewController.h"
#import "TabBarContainerViewController.h"
#import "QuoteUITabBarController.h"
#import "QuoteVehicle.h"
#import "QuoteApplicant.h"
#import "AppDelegate.h"
#import "Globals.h"
#import "Quotes.h"
#import "QuoteListTableViewCell.h"
#import "SendEmail.h"

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == nil ? @"" : obj; })


@interface QuoteListTableViewController ()

@end

@implementation QuoteListTableViewController
@synthesize managedObjectContext = __managedObjectContext;



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self StartupFunctions];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self StartupFunctions];
    
}

-(void) ToggleEditing{
    if(self.editing){
        [self setEditing:NO];
    }
    else{
        [self setEditing:YES];
    }
}

-(void)StartupFunctions{
    [self.navigationController setToolbarHidden:NO];
    
    //set background image
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clouds.png"]];
    [tempImageView setFrame:self.tableView.frame];
    self.tableView.backgroundView = tempImageView;
    
    
    UIBarButtonItem *buttonEdit = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target: self
                                                                  action:@selector(ToggleEditing) ];
    
    UIBarButtonItem *buttonNewQuote = [[UIBarButtonItem alloc] initWithTitle:@"New Quote"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target: self
                                                                      action:@selector(NewQuote:) ];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                              target:nil
                                                                              action:nil];
    self.toolbarItems = nil;
    
    self.toolbarItems = [ NSArray arrayWithObjects: buttonEdit, flexible, buttonNewQuote, nil ];
    
    arrayQuoteID = [[NSMutableArray alloc] init];
    arrayQuoteName = [[NSMutableArray alloc] init];
    arrayQuoteSubmitted = [[NSMutableArray alloc] init];
    arrayQuoteStatus = [[NSMutableArray alloc] init];
    
   
    self.title = @"Auto Quote List";
    
    [self LoadQuoteList];
    
    [self.tableView reloadData];

}

-(void)LoadQuoteList{
    Globals *tmp = [Globals sharedSingleton];
    self.managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *_fetchReqE = [[NSFetchRequest alloc] init];
    _fetchReqE.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@",@"quoteID <>", nil]];
    NSEntityDescription *entityE = [NSEntityDescription entityForName:@"Quotes" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqE setEntity:entityE];
    //sorting
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"quoteName" ascending: NO];
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor, nil];
    [_fetchReqE setSortDescriptors:sortDescriptors];
    
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:_fetchReqE error:nil];
    
    for (NSManagedObject *info in fetchedObjects)
    {
        Quotes *quote1 = (Quotes *)info;
        NSString *quoteString = quote1.quoteName;
        [arrayQuoteName addObject:quoteString];
        [arrayQuoteStatus addObject:NULL_TO_NIL(quote1.quoteStatus)];
        [arrayQuoteID addObject:quote1.quoteID];
        //Quotes *quote = [info valueForKey:@"quotes"];
        
    }
    
}

-(IBAction)NewQuote:(id)sender{
    Globals *tmp = [Globals sharedSingleton];
    tmp.currentQuoteGuid = @"";
    tmp.quoteViewIndex = 0;
    QuoteUITabBarController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"QuoteTabController"];
    [self.navigationController pushViewController:svc animated:YES];
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
    return [arrayQuoteName count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Globals *tmp = [Globals sharedSingleton];
    static NSString *CellIdentifier = @"QuoteListTableCell";
    
    
    
    QuoteListTableViewCell *cell = [tableView
                                  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[QuoteListTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    cell.txtLeftCell.text = [arrayQuoteName objectAtIndex:indexPath.row];
    cell.txtRightCell.text = [arrayQuoteStatus objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
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
	return @"Vehicle/Quote Status";
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *quoteID = [arrayQuoteID objectAtIndex:indexPath.row];
        
        Globals *tmp = [Globals sharedSingleton];
        self.managedObjectContext = tmp.managedObjectContext;
        
        //delete all objects
        NSFetchRequest *_fetchReq = [[NSFetchRequest alloc] init];
        _fetchReq.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"quoteID =='", quoteID, @"'", nil]];
        NSError *error;
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Quotes" inManagedObjectContext:self.managedObjectContext];
        [_fetchReq setEntity:entity];
        
        NSArray *arrayTemp = [self.managedObjectContext executeFetchRequest:_fetchReq error:&error];
        for (NSManagedObject * rec in arrayTemp) {
            [self.managedObjectContext deleteObject:rec];
        }
        NSError *saveError = nil;
        [self.managedObjectContext save:&saveError];
        
        [self setEditing:NO];
        
        [arrayQuoteID removeObjectAtIndex:indexPath.row];
        [arrayQuoteName removeObjectAtIndex:indexPath.row];
        [arrayQuoteStatus removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    Globals *tmp = [Globals sharedSingleton];
    tmp.currentQuoteGuid = [arrayQuoteID objectAtIndex:indexPath.row];
    
    NSString *status = [arrayQuoteStatus objectAtIndex:indexPath.row];
    
    if(![status isEqualToString:@"Submitted"]){
        tmp.quoteViewIndex = 0;
        QuoteUITabBarController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"QuoteTabController"];
        [self.navigationController pushViewController:svc animated:YES];
    }
    
}

@end
