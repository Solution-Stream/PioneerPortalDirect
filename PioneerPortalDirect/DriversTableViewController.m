//
//  DriversTableViewController.m
//  PortalDirect
//
//  Created by Brian Kalski on 2/5/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import "DriversTableViewController.h"
#import "DriverDetailViewController.h"
#import "DriversTableViewCell.h"
#import "KeychainItemWrapper.h"
#import "Globals.h"

@interface DriversTableViewController ()

@end



@implementation DriversTableViewController

@synthesize numDrivers,btnEditDrivers,cancelButton;
@synthesize managedObjectContext = __managedObjectContext;


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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    [self StartupFunctions];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)StartupFunctions{
    //set up toolbar
    [self.navigationController setToolbarHidden:NO];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Delete Driver"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(ToggleEditing)];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithTitle:@"Add Driver"
                                  style:UIBarButtonItemStyleBordered
                                  target:self
                                  action:@selector(NavigateToAddDriverScreen)];
    
    
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
    
    NSError *error = nil;
    // retrieve the store URL
    NSURL * storeURL = [[self.managedObjectContext persistentStoreCoordinator] URLForPersistentStore:[[[self.managedObjectContext persistentStoreCoordinator] persistentStores] lastObject]];
    // lock the current context
    
    [[NSFileManager defaultManager]removeItemAtURL:storeURL error:&error];
    
    arrayDrivers = [[NSMutableArray alloc] init];
    arrayClientNumbers = [[NSMutableArray alloc] init];
    arrayPolicyNumbers = [[NSMutableArray alloc] init];
    
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"PortalDirect" accessGroup:nil];
    NSString *password = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
    NSString *username = [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];
    
    
    self.title = @"Drivers Attached";
    
    //[keychainItem resetKeychainItem];
    //take user to the login page if their keychain does not exist
    if([username isEqualToString:@""] || [password isEqualToString:@""])
    {
        UIStoryboard *storyboard = self.storyboard;
        UIViewController *finished = [storyboard instantiateViewControllerWithIdentifier:@"LoginTableViewController"];
        [self presentViewController:finished animated:NO completion:NULL];
    }else{
        Globals *tmp = [Globals sharedSingleton];
        self.managedObjectContext = tmp.managedObjectContext;
        NSFetchRequest *_fetchReqE = [[NSFetchRequest alloc] init];
        _fetchReqE.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@",@"fullName <>", nil]];
        NSEntityDescription *entityE = [NSEntityDescription entityForName:@"DriverInfo" inManagedObjectContext:self.managedObjectContext];
        [_fetchReqE setEntity:entityE];
        //sorting
        NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sortOrder" ascending: NO];
        NSArray* sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor, nil];
        [_fetchReqE setSortDescriptors:sortDescriptors];
        
        NSArray *arrayTempE = [self.managedObjectContext executeFetchRequest:_fetchReqE error:nil];
        for(int i = 0; i < [arrayTempE count] ; i++){
            DriverInfo *_driverList = (DriverInfo*)[arrayTempE objectAtIndex:i];
            NSString *_driverName = _driverList.fullName;
            NSString *_clientNumber = _driverList.clientNumber;
            NSString *_policyNumber = _driverList.policyNumber;
            [arrayDrivers addObject:_driverName];
            [arrayClientNumbers addObject:_clientNumber];
            [arrayPolicyNumbers addObject:_policyNumber];
        }
    }

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
    return [arrayDrivers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Globals *tmp = [Globals sharedSingleton];
    static NSString *CellIdentifier = @"DriversTableCell";
    
    DriversTableViewCell *cell = [tableView
                              dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DriversTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    //cell.textLabel.text = [arrayDrivers objectAtIndex:indexPath.row];
    cell.txtDriversName.text = [arrayDrivers objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
//    if(indexPath.row == 0){
//        UIImage *PlusImage = [UIImage imageNamed:@"SmallBluePlus.png"];
//        cell.imgDriverIcon.image = PlusImage;
//    }
//    else{
        UIImage *PlusImage = [UIImage imageNamed:@"user_real_person.png"];
        cell.imgDriverIcon.image = PlusImage;
//    }
    
    cell.txtDriversName.font = tmp.TableViewListFont;
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    UIStoryboard *storyboard = self.storyboard;
    DriverDetailViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"DriversDetailViewController"];
    //UIViewController *addDriverController = [storyboard instantiateViewControllerWithIdentifier:@"AddDriverTableViewController"];
    //store policy number array to be used in detail view
    Globals *tmp = [Globals sharedSingleton];
    tmp.arrayGlobalPolicyNumbers = self->arrayPolicyNumbers;
           
//    if(indexPath.row == 0){
//        [self.navigationController pushViewController:addDriverController animated:YES];
//    }
//    else{
        tmp.clientNumber = [arrayClientNumbers objectAtIndex:indexPath.row];
        detailViewController.managedObjectContext = self.managedObjectContext;
        [self.navigationController pushViewController:detailViewController animated:YES];
//   }

        
}

-(void)NavigateToAddDriverScreen{
    UIStoryboard *storyboard = self.storyboard;
    UIViewController *addDriverController = [storyboard instantiateViewControllerWithIdentifier:@"AddDriverTableViewController"];
    [self.navigationController pushViewController:addDriverController animated:YES];
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


- (IBAction)RemoveDriverEditMode:(id)sender {       
    if(editModeTblDriver == FALSE){
        self.btnEditDrivers.title = @"Done Editing";
        editModeTblDriver = TRUE;
        [tblDriverList setEditing:YES animated:YES];
    }
    else{
        self.btnEditDrivers.title = @"Edit";
        editModeTblDriver = FALSE;
        [tblDriverList setEditing:NO animated:YES];        
    }
}
@end
