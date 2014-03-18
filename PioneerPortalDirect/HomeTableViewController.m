//
//  HomeTableViewController.m
//  PortalDirect
//
//  Created by Brian Kalski on 1/30/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import "HomeTableViewController.h"
#import "DriversTableViewController.h"
#import "ViewCertificateTableViewController.h"
#import "UserInfo.h"
#import "SetUserInfo.h"
#import "DriversOnPolicy.h"
#import "PolicyInfoList.h"
#import "EditUserInfo.h"
#import "QuoteApplicantUITableViewController.h"
#import "QuoteListTableViewController.h"
#import "QuoteVehicleTableViewController.h"


@interface HomeTableViewController ()

@end

@implementation HomeTableViewController

@synthesize btnLogoutUser,txtFullName,timer,UserInfoTableView,EditButton,BottomToolbar,SaveToolbarButton,CancelToolbarButton,datePicker,txtBirthdate,txtFirstName,txtLastName,txtPhoneHome,txtEmail,txtPhoneWork,timerEditUserInfo,TableViewCellGetQuote;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize buttonGetQuote, buttonItemCancel, buttonItemEdit, buttonItemSave, flexible;
@synthesize TableViewCellName;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    [self StartupFunctions];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self StartupFunctions];
    
}

-(void) StartupFunctions{
    Globals *tmp = [Globals sharedSingleton];
    
    //set background image
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clouds.png"]];
    [tempImageView setFrame:self.tableView.frame];
    self.tableView.backgroundView = tempImageView;
    
    [self.navigationController setToolbarHidden:YES];
    
    BottomToolbar.hidden = YES;
    
    
    
    buttonItemSave = [[ UIBarButtonItem alloc ] initWithTitle: @"Save"
                                                        style: UIBarButtonItemStyleDone
                                                       target: self
                                                       action: @selector(SaveUserInfo:) ];
    
    buttonItemCancel = [[ UIBarButtonItem alloc ] initWithTitle: @"Cancel"
                                                          style: UIBarButtonItemStyleDone
                                                         target: self
                                                         action: @selector(CancelEditUserInfo:) ];
    
    buttonItemEdit = [[ UIBarButtonItem alloc ] initWithTitle: @"Edit"
                                                        style: UIBarButtonItemStyleDone
                                                       target: self
                                                       action: @selector(EditUserInfo:) ];
    
    flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                             target:nil
                                                             action:nil];
    
    buttonGetQuote = [[UIBarButtonItem alloc] initWithTitle:@"Get Auto Insurance Quote"
                                                      style:UIBarButtonItemStyleBordered
                                                     target: self
                                                     action:@selector(GotoQuoteScreen:) ];
    [self SetToolBarButtons:NO];
    
    self.txtEmail.text = @"";
    self.txtFirstName.text = @"";
    self.txtLastName.text = @"";
    self.txtBirthdate.text = @"";
    self.txtPhoneHome.text = @"";
    self.txtPhoneWork.text = @"";
    
    
    LoggedIn = NO;
    
    self.txtFirstName.delegate = (id)self;
    self.txtLastName.delegate = (id)self;
    self.txtEmail.delegate = (id)self;
    self.txtBirthdate.delegate = (id)self;
    self.txtPhoneHome.delegate = (id)self;
    self.txtPhoneWork.delegate = (id)self;
    
    
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"PortalDirect" accessGroup:nil];
    NSString *username = [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];
    NSString *password = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
    
    if([username isEqualToString:@""] || [password isEqualToString:@""])
    {
        //        UIStoryboard *storyboard = self.storyboard;
        //        UIViewController *LoginView = [storyboard instantiateViewControllerWithIdentifier:@"LoginTableViewController"];
        //[self presentViewController:finished animated:NO completion:NULL];
        if(timer){
            [timer invalidate];
            timer = nil;
        }
        LoggedIn = YES;
        //[self presentViewController:LoginView animated:YES completion:nil];
        //[self.navigationController pushViewController:LoginView animated:YES];
    }
    else
    {
        LoggedIn = YES;
        tmp.mainPolicyNumber = username;
        //if the user didn't just log in
        if(![tmp.userJustLoggedIn isEqualToString:@"true"]){
            tmp.userJustLoggedIn = @"";
            [tmp LoadPolicyDataForUser:username];
            
            if(([tmp.DriversInfoDoneLoading isEqualToString:@"done"] && [tmp.SetUserInfoDoneLoading isEqualToString:@"done"]
                && [tmp.PolicyInfoDoneLoading isEqualToString:@"done"] && [tmp.VehiclesDoneLoading isEqualToString:@"done"])){
                
                tmp.DriversInfoDoneLoading = @"";
                tmp.PolicyInfoDoneLoading = @"";
                tmp.VehiclesDoneLoading = @"";
                
                [self DataFinishedLoading];
            }
            else{
                [tmp ShowLoadingScreen];
                timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFiring) userInfo:nil repeats:YES];
            }
        }
        else{
            [self DataFinishedLoading];
        }
    }
    
    //Date of Birth field
    UIToolbar *DoneButtonView = [[UIToolbar alloc] init];
    DoneButtonView.barStyle = UIBarStyleBlack;
    DoneButtonView.translucent = YES;
    DoneButtonView.tintColor = nil;
    [DoneButtonView sizeToFit];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(DateOfBirthDonePressed:)];
    [DoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
    
    UIDatePicker *theDatePicker = [[UIDatePicker alloc] init];
    NSDate *now = [NSDate date];
    NSDate *modifiedDate = [now dateByAddingTimeInterval:-20*364*24*60*60];
    theDatePicker.datePickerMode = UIDatePickerModeDate;
    datePicker = theDatePicker;
    [datePicker setDate:modifiedDate];
    [datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    txtBirthdate.inputView = datePicker;
    txtBirthdate.inputAccessoryView = DoneButtonView;
    
    //Number Pad
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           //[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    self.txtPhoneHome.inputAccessoryView = numberToolbar;
    self.txtPhoneWork.inputAccessoryView = numberToolbar;

}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    UIDeviceOrientation orientation =  [[UIDevice currentDevice] orientation];
    if((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation == UIInterfaceOrientationLandscapeRight)){
        landscape = YES;
    }
    else{
        landscape = NO;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    /// Here you can set also height according to your section and row
    if(indexPath.section==0){
        return 67;
    }
    if(indexPath.section==1)
    {
        return 25;
    }
    if(indexPath.section==2)
    {
        return 38;
    }
    else{
        return 30;
    }
}


-(void)SetToolBarButtons:(bool)editing{
    
    UIDeviceOrientation orientation =  [[UIDevice currentDevice] orientation];
    
    if((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation == UIInterfaceOrientationLandscapeRight)){
        self.navigationItem.rightBarButtonItems = [ NSArray arrayWithObjects: buttonItemEdit, nil ];
    }
    else{          
        
        self.navigationItem.rightBarButtonItems = [ NSArray arrayWithObjects: buttonItemEdit, nil ];
        
        BottomToolbar.items = nil;
        
        buttonItemSave.tintColor = [UIColor colorWithRed: 72.0/255.0 green: 118.0/255.0 blue:255.0/255.0 alpha: 1.0];
        
        if(editing == YES){
            BottomToolbar.hidden = NO;
            BottomToolbar.items = [ NSArray arrayWithObjects: buttonItemSave, buttonItemCancel, flexible, nil ];
        }else{
            //BottomToolbar.items = [ NSArray arrayWithObjects: flexible, buttonGetQuote, flexible, nil ];
        }
    }
}


-(void)cancelNumberPad{
    [txtPhoneHome resignFirstResponder];
    //txtPhoneHome.text = @"";
    [txtPhoneWork resignFirstResponder];
    //txtPhoneWork.text = @"";
}

-(void)doneWithNumberPad{
    //NSString *numberFromTheKeyboard = txtSSN.text;
    [txtPhoneHome resignFirstResponder];
    [txtPhoneWork resignFirstResponder];
}


- (IBAction)datePickerChanged:(id)sender{
    pickerDate = datePicker.date;
}

- (IBAction)DateOfBirthDonePressed:(id)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M/d/yyyy"];
    NSString *dateString = [formatter stringFromDate:pickerDate];
    txtBirthdate.text = dateString;
    [txtBirthdate resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(void)timerFiring{
    Globals *tmp = [Globals sharedSingleton];
    if(([tmp.DriversInfoDoneLoading isEqualToString:@"done"] && [tmp.SetUserInfoDoneLoading isEqualToString:@"done"]
        && [tmp.PolicyInfoDoneLoading isEqualToString:@"done"] && [tmp.VehiclesDoneLoading isEqualToString:@"done"])){
        
        [timer invalidate];
        timer = nil;
        [self DataFinishedLoading];
    }
    
    if([tmp.connectionFailed isEqualToString:@"true"]){
        tmp.connectionFailed = @"";
        [timer invalidate];
        timer = nil;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: tmp.connectionErrorTitle
                                                       message: tmp.connectionErrorMessage
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        alert.tag = 8;
        [alert show];
    }
}



-(void)DataFinishedLoading{
    Globals *tmp = [Globals sharedSingleton];
    
        
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"PortalDirect" accessGroup:nil];
    NSString *username = [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];
    tmp.mainPolicyNumber = username;
              
    self.managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *_fetchReqE = [[NSFetchRequest alloc] init];
    _fetchReqE.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@",@"firstName <>", nil]];
    NSEntityDescription *entityE = [NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqE setEntity:entityE];
    NSArray *arrayTempE = [self.managedObjectContext executeFetchRequest:_fetchReqE error:nil];
    for(int i = 0; i < [arrayTempE count] ; i++){
        UserInfo *_userinfo = (UserInfo*)[arrayTempE objectAtIndex:i];
        self.txtFirstName.text = _userinfo.firstName;
        self.txtLastName.text = _userinfo.lastName;
        self.txtBirthdate.text = _userinfo.birthDate;
        self.txtEmail.text = _userinfo.email;
        self.txtPhoneHome.text = _userinfo.phoneHome;
        self.txtPhoneWork.text = _userinfo.phoneWork;
        self.txtFullName.text = [NSString stringWithFormat:@"%@%@%@",_userinfo.firstName, @" ", _userinfo.lastName];
        clientNumber = _userinfo.clientNumber;
        self.txtFirstName.hidden = YES;
        self.txtLastName.hidden = YES;
    }        
    
    numDrivers = 0;
    [tmp HideLoadingScreen];

    
    if([tmp.DriversInfoDoneLoading isEqualToString:@"connectionFailed"]){
        if(timer){
            [timer invalidate];
            timer = nil;
        }
        [tmp HideLoadingScreen];
        Globals *tmp = [Globals sharedSingleton];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: tmp.connectionErrorTitle
                                                       message: tmp.connectionErrorMessage
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        alert.tag = 4;
        [alert show];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = self.storyboard;
    //Manager Drivers
    if(indexPath.section == 2){
        if(indexPath.row == 0){
            DriversTableViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"DriversTableViewController"];
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
        //Manage Vehicles
        if(indexPath.row == 1){
            UIViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"VehiclesTableViewController"];
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
        //View Certificates
        if(indexPath.row == 2){
            ViewCertificateTableViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"ViewCertificateTableViewController"];
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
    }
}


- (IBAction)SaveUserInfo:(id)sender {
    if([txtBirthdate.text isEqualToString:@""] || [txtFirstName.text isEqualToString:@""] || [txtLastName.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Missing Fields"
                                                       message: @"First Name, Last Name, and Birth Date are required fields"
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        alert.tag = 10;
        [alert show];
    }else{
        [self EditingOff];
        Globals *tmp = [Globals sharedSingleton];
        [tmp ShowLoadingScreen];
        EditUserInfo *editUSERInfo = [[EditUserInfo alloc] init];
        [editUSERInfo EditUserInfo:clientNumber FirstName: txtFirstName.text LastName: txtLastName.text Email:txtEmail.text PhoneHome:txtPhoneHome.text PhoneWork:txtPhoneWork.text BirthDate:txtBirthdate.text];
        timerEditUserInfo = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerEditUserInfoFiring) userInfo:nil repeats:YES];
    }
}


-(void)timerEditUserInfoFiring{
    Globals *tmp = [Globals sharedSingleton];
    if([tmp.userInfoUpdated isEqualToString:@"done"]){
        tmp.userInfoUpdated = @"";
        [timerEditUserInfo invalidate];
        timerEditUserInfo = nil;
        [tmp HideLoadingScreen];
        txtFullName.text = [NSString stringWithFormat:@"%@%@%@", txtFirstName.text, @" ", txtLastName.text];
        [self EditingOff];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Changes Saved"
                                                       message: @"Changes have been saved successfully."
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        alert.tag = 11;
        [alert show];
        [UserInfoTableView setEditing:NO animated:YES];
    }
    
    if([tmp.userInfoUpdated isEqualToString:@"failed"] || [tmp.connectionFailed isEqualToString:@"true"]){
        if([tmp.connectionFailed isEqualToString:@"true"]){tmp.connectionFailed = @"";}
        
        [timerEditUserInfo invalidate];
        timerEditUserInfo = nil;
        [tmp HideLoadingScreen];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Problem Saving Changes"
                                                       message: @"There was a problem saving changes. Please try again later."
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        alert.tag = 9;
        [alert show];
        [UserInfoTableView setEditing:NO animated:YES];
    }
    
}

- (IBAction)CancelEditUserInfo:(id)sender {
    [self EditingOff];
    [UserInfoTableView setEditing:NO animated:YES];
    //[self.UserInfoTableView setContentOffset:CGPointZero animated:NO];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.UserInfoTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    BottomToolbar.hidden = YES;
}

- (IBAction)EditUserInfo:(id)sender {
    [UserInfoTableView setEditing:YES animated:YES];                
    [self EditingOn];
    [self.UserInfoTableView reloadData];
}

- (void) EditingOff {
    EditButton.enabled = YES;
    
    [self SetToolBarButtons:NO];
    
    self.navigationItem.rightBarButtonItems = [ NSArray arrayWithObjects: buttonItemEdit, nil ];
        
    self.txtFirstName.enabled = NO;
    self.txtLastName.enabled = NO;
    self.txtEmail.enabled = NO;
    self.txtPhoneHome.enabled = NO;
    self.txtPhoneWork.enabled = NO;
    self.txtBirthdate.enabled = NO;
    [self.txtFirstName setBorderStyle:UITextBorderStyleNone];
    [self.txtLastName setBorderStyle:UITextBorderStyleNone];
    [self.txtEmail setBorderStyle:UITextBorderStyleNone];
    [self.txtPhoneHome setBorderStyle:UITextBorderStyleNone];
    [self.txtPhoneWork setBorderStyle:UITextBorderStyleNone];
    [self.txtBirthdate setBorderStyle:UITextBorderStyleNone];
    self.txtFirstName.hidden = YES;
    self.txtLastName.hidden = YES;
    self.txtFullName.hidden = NO;
}

- (void) EditingOn {
    EditButton.enabled = NO;
    
    [self SetToolBarButtons:YES];
    
    if(landscape == YES){
        self.navigationItem.rightBarButtonItems = [ NSArray arrayWithObjects: buttonItemSave, buttonItemCancel, flexible, nil ];
    }else{
        self.navigationItem.rightBarButtonItems = [ NSArray arrayWithObjects: buttonItemEdit, nil ];
    }
    
    self.txtFirstName.enabled = YES;
    self.txtLastName.enabled = YES;
    self.txtEmail.enabled = YES;
    self.txtPhoneHome.enabled = YES;
    self.txtPhoneWork.enabled = YES;
    self.txtBirthdate.enabled = YES;
    [self.txtFirstName setBorderStyle:UITextBorderStyleRoundedRect];
    [self.txtLastName setBorderStyle:UITextBorderStyleRoundedRect];
    [self.txtEmail setBorderStyle:UITextBorderStyleRoundedRect];
    [self.txtPhoneHome setBorderStyle:UITextBorderStyleRoundedRect];
    [self.txtPhoneWork setBorderStyle:UITextBorderStyleRoundedRect];
    [self.txtBirthdate setBorderStyle:UITextBorderStyleRoundedRect];
    self.txtFirstName.hidden = NO;
    self.txtLastName.hidden = NO;
    self.txtFullName.hidden = YES;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (IBAction)LogoutUser:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Logout Confirmation"
                                                   message: @"Are you sure you want to logout?"
                                                  delegate: self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"OK",nil];
    alert.tag = 3;
    [alert show];
    
}

-(void)LogUserOut{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"PortalDirect" accessGroup:@"logins"];
    [keychainItem resetKeychainItem];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        if(alertView.tag == 3){
            [self LogUserOut];
        }
    }
    if(buttonIndex == 0){
        if(alertView.tag == 4 || alertView.tag == 8){
            exit(0);
        }
    }
    
    if(alertView.tag == 11){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.UserInfoTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
}

//-(void) connectionDidFinishLoading:(NSURLConnection *) connection {
//    //NSLog(@"DONE. Received Bytes: %d", [webData length]);
//    
//    xmlParser = [[NSXMLParser alloc] initWithData: webData];
//    [xmlParser setDelegate: self];
//    [xmlParser setShouldResolveExternalEntities:YES];
//    [xmlParser parse];
//}
//
////---when the start of an element is found---
//-(void) parser:(NSXMLParser *) parser
//didStartElement:(NSString *) elementName
//  namespaceURI:(NSString *) namespaceURI
// qualifiedName:(NSString *) qName
//    attributes:(NSDictionary *) attributeDict {
//    
//    if( [elementName isEqualToString:@"a:FirstName"])
//    {
//        if (!soapResults)
//        {
//            soapResults = [[NSMutableString alloc] init];
//        }
//        elementFound = YES;        
//    }
//    if( [elementName isEqualToString:@"a:LastName"])
//    {
//        if (!soapResults)
//        {
//            soapResults = [[NSMutableString alloc] init];
//        }
//        elementFound = YES;
//    }
//    if( [elementName isEqualToString:@"a:email"])
//    {
//        if (!soapResults)
//        {
//            soapResults = [[NSMutableString alloc] init];
//        }
//        elementFound = YES;
//    }
//    if( [elementName isEqualToString:@"a:PhoneHome"])
//    {
//        if (!soapResults)
//        {
//            soapResults = [[NSMutableString alloc] init];
//        }
//        elementFound = YES;
//    }
//    if( [elementName isEqualToString:@"a:PhoneWork"])
//    {
//        if (!soapResults)
//        {
//            soapResults = [[NSMutableString alloc] init];
//        }
//        elementFound = YES;
//    }
//    if( [elementName isEqualToString:@"a:BirthDate"])
//    {
//        if (!soapResults)
//        {
//            soapResults = [[NSMutableString alloc] init];
//        }
//        elementFound = YES;
//    }
//    if( [elementName isEqualToString:@"a:numDrivers"])
//    {
//        if (!soapResults)
//        {
//            soapResults = [[NSMutableString alloc] init];
//        }
//        elementFound = YES;
//    }
//    if( [elementName isEqualToString:@"a:GetUserInfoResponse"])
//    {
//        if (!soapResults)
//        {
//            soapResults = [[NSMutableString alloc] init];
//        }
//        elementFound = YES;
//    }
//    
//}
//
//-(void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string
//{
//    if (elementFound)
//    {
//        [soapResults appendString: string];
//    }
//}
//
////---when the end of element is found---
//-(void)parser:(NSXMLParser *)parser
//didEndElement:(NSString *)elementName
// namespaceURI:(NSString *)namespaceURI
//qualifiedName:(NSString *)qName
//{
//     
//    if ([elementName isEqualToString:@"a:FirstName"])
//    {
//        self.txtFirstName.text = soapResults;
//        [soapResults setString:@""];
//        elementFound = FALSE;
//    }
//    if ([elementName isEqualToString:@"a:LastName"])
//    {
//        self.txtLastName.text = soapResults;
//        [soapResults setString:@""];
//        elementFound = FALSE;
//    }
//    if ([elementName isEqualToString:@"a:email"])
//    {
//        self.txtEmail.text = soapResults;
//        [soapResults setString:@""];
//        elementFound = FALSE;
//    }
//    if ([elementName isEqualToString:@"a:PhoneHome"])
//    {
//        self.txtPhoneHome.text = soapResults;
//        [soapResults setString:@""];
//        elementFound = FALSE;
//    }
//    if ([elementName isEqualToString:@"a:PhoneWork"])
//    {
//        self.txtPhoneWork.text = soapResults;
//        [soapResults setString:@""];
//        elementFound = FALSE;
//    }
//    if ([elementName isEqualToString:@"a:BirthDate"])
//    {
//        
//        self.txtBirthdate.text = soapResults;
//        [soapResults setString:@""];
//        elementFound = FALSE;
//    }
//    if ([elementName isEqualToString:@"a:numDrivers"])
//    {        
//        numDrivers = [soapResults intValue];
//        [soapResults setString:@""];
//        elementFound = FALSE;
//    }
//    if ([elementName isEqualToString:@"GetUserInfoResponse"])
//    {        
//        [[Globals sharedSingleton] HideLoadingScreen];
//    }
//    
//    //self.tcManageDrivers.textLabel.text = [NSString stringWithFormat:@"%@%@%@", @"Manage Drivers (", [NSString stringWithFormat:@"%i", numDrivers], @")"];
//}
//
//-(void) connection:(NSURLConnection *) connection
//    didReceiveData:(NSData *) data {
//    [webData appendData:data];
//}
//
//-(void) connection:(NSURLConnection *) connection
//  didFailWithError:(NSError *) error {
//    
//    [[Globals sharedSingleton] HideLoadingScreen];
//    
//    Globals *tmp = [Globals sharedSingleton];
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: tmp.connectionErrorTitle
//                                                   message: tmp.connectionErrorMessage
//                                                  delegate: self
//                                         cancelButtonTitle:@"OK"
//                                         otherButtonTitles:nil];
//    [alert show];
//}
//
//-(void) connection:(NSURLConnection *) connection
//didReceiveResponse:(NSURLResponse *) response {
//    [webData setLength: 0];
//}

-(IBAction) GotoQuoteScreen:(id)sender{
    Globals *tmp = [Globals sharedSingleton];
    self.managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *_fetchReqE = [[NSFetchRequest alloc] init];
    _fetchReqE.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@",@"quoteID <>", nil]];
    NSEntityDescription *entityE = [NSEntityDescription entityForName:@"Quotes" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqE setEntity:entityE];
    
    NSArray *arrayTempE = [self.managedObjectContext executeFetchRequest:_fetchReqE error:nil];
    if([arrayTempE count] > 0){
        QuoteListTableViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"QuoteListTableViewController"];
        [self.navigationController pushViewController:svc animated:YES];
    }
    else{
        tmp.GoToQuoteScreen = @"true";
        tmp.currentQuoteGuid = @"";
        QuoteVehicleTableViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"QuoteVehicleTableViewController"];
        [self.navigationController pushViewController:svc animated:YES];
    }
}



@end
