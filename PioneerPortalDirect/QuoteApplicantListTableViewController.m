//
//  QuoteApplicantListTableViewController.m
//  PortalDirect
//
//  Created by Brian Kalski on 12/18/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//
#import "Globals.h"
#import "Quotes.h"
#import "QuoteApplicant.h"
#import "QuoteUITabBarController.h"
#import "QuoteApplicantTableViewCell.h"
#import "QuoteApplicantUITableViewController.h"
#import "QuoteDriverListUITableViewController.h"
#import "QuoteListTableViewCell.h"
#import "QuoteApplicantListTableViewController.h"

@interface QuoteApplicantListTableViewController ()

@end

@implementation QuoteApplicantListTableViewController
@synthesize ApplicantListTableView,editButton;

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
    
    [self StartupFunctions];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self StartupFunctions];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self StartupFunctions];
}

-(void)StartupFunctions{
    [self CheckQuoteToProceed];
    
    self.tabBarItem.title = @"Applicant List";
    
    [self.navigationController setToolbarHidden:NO];
    [self.navigationController setNavigationBarHidden:YES];
    
    editButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Delete Applicant"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(ToggleEditing)];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithTitle:@"Add Applicant"
                                  style:UIBarButtonItemStyleBordered
                                  target:self
                                  action:@selector(AddApplicant)];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                              target:nil
                                                                              action:nil];
    
    
    
    //[[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:70/255.0f green:155/255.0f blue:19/255.0f alpha:1.0]];
    
    NSArray *arrBtns = [[NSArray alloc]initWithObjects:editButton, flexible, addButton, nil];
    self.toolbarItems = arrBtns;
    
    
    [self LoadQuoteApplicantList];
    [ApplicantListTableView reloadData];
    
    [self SetTabBarImages];

}

-(void)AddApplicant{
    Globals *tmp = [Globals sharedSingleton];
    tmp.currentApplicantID = @"";
    tmp.createNewApplicant = @"YES";
    QuoteApplicantUITableViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"QuoteApplicantUITableViewController"];
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
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:_fetchReqE error:&error];
    NSUInteger qa = 0;
    
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
        tmp.createNewApplicant = @"YES";
        tmp.quoteViewIndex = [NSNumber numberWithInt:0];
        QuoteApplicantUITableViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"QuoteApplicantUITableViewController"];
        [self.navigationController pushViewController:svc animated:YES];
    }
    
}

-(void)LoadQuoteApplicantList{
    Globals *tmp = [Globals sharedSingleton];
    arrayQuoteApplicant = [[NSMutableArray alloc] init];
    arrayQuoteApplicantID = [[NSMutableArray alloc] init];
    tmp.currentApplicantID = @"";
    self.managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *_fetchReqE = [[NSFetchRequest alloc] init];
    _fetchReqE.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"quoteID =='", tmp.currentQuoteGuid, @"'", nil]];
    NSEntityDescription *entityE = [NSEntityDescription entityForName:@"Quotes" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqE setEntity:entityE];
    //sorting
    //NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending: NO];
    //NSArray* sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor, nil];
    //[_fetchReqE setSortDescriptors:sortDescriptors];
    
    //[arrayQuoteApplicant addObject:@"Add Applicant"];
    //[arrayQuoteApplicantID addObject:@"-1"];
    
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:_fetchReqE error:nil];
    
    for (NSManagedObject *info in fetchedObjects)
    {
        Quotes *quote = (Quotes *)info;
        
        for(QuoteApplicant *Applicant in quote.quoteApplicant)
        {
            NSString *ApplicantString = [NSString stringWithFormat:@"%@%@%@", Applicant.firstName, @" ", Applicant.lastName];
            [arrayQuoteApplicant addObject:ApplicantString];
            [arrayQuoteApplicantID addObject:Applicant.applicantID];
        }
        
        //        if([arrayQuoteApplicant count] == 0){
        //            tmp.createNewApplicant = @"YES";
        //            QuoteAddApplicantUITableViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"QuoteAddApplicantUITableViewController"];
        //            [self.navigationController pushViewController:svc animated:YES];
        //        }
    }
    
    //[arrayQuoteApplicant sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
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
    return [arrayQuoteApplicant count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"QuoteListTableViewCell";
    
    
    
    QuoteListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[QuoteListTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    cell.txtLeftCell.text = [arrayQuoteApplicant objectAtIndex:indexPath.row];
    cell.txtRightCell.text = @"";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
//    if(indexPath.row == 0){
//        UIImage *PlusImage = [UIImage imageNamed:@"SmallBluePlus.png"];
//        cell.imgIcon.image = PlusImage;
//    }
//    else{
        UIImage *PlusImage = [UIImage imageNamed:@"user_real_person.png"];
        cell.imgIcon.image = PlusImage;
//    }
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    Globals *tmp = [Globals sharedSingleton];
    self.managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *_fetchReqE = [[NSFetchRequest alloc] init];
    
    _fetchReqE.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"quoteID =='", tmp.currentQuoteGuid, @"'", nil]];
    NSEntityDescription *entityE = [NSEntityDescription entityForName:@"Quotes" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqE setEntity:entityE];
    
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:_fetchReqE error:nil];
    
    int qa = 0;
    
    for (NSManagedObject *info in fetchedObjects)
    {
        Quotes *app = (Quotes *)info;
        
        qa = app.quoteApplicant.count;
    }
    
    if(qa < 2){
        editButton.enabled = NO;
        return NO;
    }
    else{
        editButton.enabled = YES;
        return YES;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"Applicant List";
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //[ApplicantListTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSString *applicantID = [arrayQuoteApplicantID objectAtIndex:indexPath.row];
        
        Globals *tmp = [Globals sharedSingleton];
        self.managedObjectContext = tmp.managedObjectContext;
        
        //delete all objects
        NSFetchRequest *_fetchReq = [[NSFetchRequest alloc] init];
        _fetchReq.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"applicantID =='", applicantID, @"'", nil]];
        NSError *error;
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"QuoteApplicant" inManagedObjectContext:self.managedObjectContext];
        [_fetchReq setEntity:entity];
        
        NSArray *arrayTemp = [self.managedObjectContext executeFetchRequest:_fetchReq error:&error];
        for (NSManagedObject * rec in arrayTemp) {
            [self.managedObjectContext deleteObject:rec];
        }
        NSError *saveError = nil;
        [self.managedObjectContext save:&saveError];
        
        [self setEditing:NO];
        
        [arrayQuoteApplicant removeObjectAtIndex:indexPath.row];
        [arrayQuoteApplicantID removeObjectAtIndex:indexPath.row];
        [ApplicantListTableView reloadData];
        
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
    tmp.currentApplicantID = [arrayQuoteApplicantID objectAtIndex:indexPath.row];
    
    if([tmp.currentApplicantID isEqualToString:@"-1"]){
        tmp.createNewApplicant = @"YES";
    }
    else{
        tmp.createNewApplicant = @"NO";
    }
    
    tmp.quoteApplicantViewIndex = [NSNumber numberWithInt:1];
    QuoteApplicantUITableViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"QuoteApplicantUITableViewController"];
    //QuoteAddApplicantUITableViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"QuoteAddApplicantUITableViewController"];
    [self.navigationController pushViewController:svc animated:YES];
    //[self presentViewController:svc animated:YES completion: nil];
}

-(IBAction)NextStep:(id)sender{
    QuoteDriverListUITableViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"QuoteDriverListUITableViewController"];
    [self.navigationController pushViewController:svc animated:YES];
}

-(IBAction)AddAnotherApplicant:(id)sender{
    Globals *tmp = [Globals sharedSingleton];
    tmp.currentApplicantID = @"";
    tmp.createNewApplicant = @"YES";
    QuoteApplicantUITableViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"QuoteAddApplicantUITableViewController"];
    [self.navigationController pushViewController:svc animated:YES];
}

-(void)SetTabBarImages{
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
        [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:TRUE];
        [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:TRUE];
        [[[[self.tabBarController tabBar]items]objectAtIndex:3]setEnabled:TRUE];
    }
    else{
        ((UIViewController*)viewControllers[0]).tabBarItem.image = [UIImage imageNamed:@"question.png"];
        [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:FALSE];
        [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:FALSE];
        [[[[self.tabBarController tabBar]items]objectAtIndex:3]setEnabled:FALSE];
    }
    
    if((int)qd == 1){
        ((UIViewController*)viewControllers[1]).tabBarItem.image = [UIImage imageNamed:@"tick.png"];
        [[[[self.tabBarController tabBar]items]objectAtIndex:4]setEnabled:TRUE];
    }
    else{
        ((UIViewController*)viewControllers[1]).tabBarItem.image = [UIImage imageNamed:@"question.png"];
        [[[[self.tabBarController tabBar]items]objectAtIndex:4]setEnabled:FALSE];
    }
    
    if((int)qv == 1){
        ((UIViewController*)viewControllers[2]).tabBarItem.image = [UIImage imageNamed:@"tick.png"];
        [[[[self.tabBarController tabBar]items]objectAtIndex:4]setEnabled:TRUE];
    }
    else{
        ((UIViewController*)viewControllers[2]).tabBarItem.image = [UIImage imageNamed:@"question.png"];
        [[[[self.tabBarController tabBar]items]objectAtIndex:4]setEnabled:FALSE];
    }
    
    if((int)qc == 1){
        ((UIViewController*)viewControllers[3]).tabBarItem.image = [UIImage imageNamed:@"tick.png"];
    }
    else{
        ((UIViewController*)viewControllers[3]).tabBarItem.image = [UIImage imageNamed:@"question.png"];
    }
    
}




@end
