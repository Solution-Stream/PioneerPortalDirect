//
//  LoginTableViewController.m
//  PortalDirect
//
//  Created by Brian Kalski on 1/28/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import "LoginTableViewController.h"
#import "QuoteUITabBarController.h"
#import "TabBarContainerViewController.h"
#import "ForgotPasswordTableViewController.h"
#import "HomeTableViewController.h"
#import "QuoteVehicleTableViewController.h"
#import "QuoteListTableViewController.h"
#import "KeychainItemWrapper.h"
#import "Globals.h"
#import "DriversOnPolicy.h"
#import "SetUserInfo.h"
#import <QuartzCore/QuartzCore.h>
#import "JSONKit.h"

@interface LoginTableViewController ()

@end

@implementation LoginTableViewController

@synthesize txtUserName, txtPassword, btnLogin, activityIndicator, responseData, btnAutoQuote,managedObjectContext;
@synthesize LoginTableView,LoginTableView_Landscape;
BOOL bStayLoggedIn = false;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    UIDeviceOrientation orientation =  [[UIDevice currentDevice] orientation];
    if((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation == UIInterfaceOrientationLandscapeRight)){
        
    }
    else{
        
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lightHouse640-960.png"]];
    //UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lightHouse640-960.png"]];
    //[self.view addSubview:backgroundView];
    
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lightHouse320-480.png"]]];
    
    Globals *tmp = [Globals sharedSingleton];
    if([tmp.DropdownListLoaded isEqualToString:@"YES"]){
        [self EnableButtons];
    }
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [self.navigationController setToolbarHidden:NO];    
    
    
    buttonForgotPassword = [[ UIBarButtonItem alloc ] initWithTitle: @"Forgot Password?"
                                                                     style: UIBarButtonItemStyleBordered
                                                                    target: self
                                                                    action: @selector(ForgotPassword:) ];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    buttonGetQuote = [[UIBarButtonItem alloc]initWithTitle:@"Get Auto Insurance Quote" style:UIBarButtonItemStyleBordered target:self action:@selector(NavigateToAutoQuote:)];
    buttonGetQuote.enabled = NO;
    buttonForgotPassword.enabled = NO;
    self.toolbarItems = [ NSArray arrayWithObjects: buttonForgotPassword, flexible, buttonGetQuote, nil ];
    
    timerDDLoaded = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(WaitForDropdownDataToLoad) userInfo:nil repeats:YES];
    
    timerRetryConn = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(TestConnection) userInfo:nil repeats:YES];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    [self.navigationController setToolbarHidden:NO];
    
    Globals *tmp = [Globals sharedSingleton];
    if([tmp.DropdownListLoaded isEqualToString:@"YES"]){
        [self EnableButtons];
    }
    
}

-(void)TestConnection{
    Globals *tmp = [Globals sharedSingleton];
    if([tmp.connectionFailed isEqualToString:@"true"]){
        [self ConnectionFailed];
    }
}

-(void) WaitForDropdownDataToLoad{
    Globals *tmp = [Globals sharedSingleton];
    
    if(connectionAttempts > 15){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Network Error"
                                                       message: @"Unable to connect to server. Please try again later."
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
        [timerDDLoaded invalidate];
        timerDDLoaded = nil;
    }
    
    if([tmp.DropdownListLoaded isEqualToString:@"YES"] || [tmp.devMode isEqualToString:@"YES"]){
    if(timerDDLoaded){
            [timerDDLoaded invalidate];
            timerDDLoaded = nil;
        }
        [self EnableButtons];
    }
    connectionAttempts++;
}

-(void)EnableButtons{
    btnLogin.enabled = YES;
    btnLogin.titleLabel.textAlignment = NSTextAlignmentCenter;
    //[btnLogin.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18.0]];
    btnLogin.titleLabel.text = @"Login";
    buttonForgotPassword.enabled = YES;
    buttonGetQuote.enabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LoginUser:(id)sender {
    Globals *tmp = [Globals sharedSingleton];
    [txtPassword resignFirstResponder];
    NSString *usernameTrimmed = [self.txtUserName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *passwordTrimmed = [self.txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    userName = usernameTrimmed;
    passWord = passwordTrimmed;
    
    if([usernameTrimmed isEqualToString:@""] || [passwordTrimmed isEqualToString:@""]){
        [self ShowLoginInfoRequiredDialog];
    }else{
        [activityIndicator startAnimating];        
        NSString *theURL = [NSString stringWithFormat:@"%@%@%@%@%@",tmp.globalServerName, @"/users.svc/validateUser/", usernameTrimmed, @"/", passwordTrimmed];
        
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
        
        NSURL*URL = [NSURL URLWithString:theURL];
        
        [request setURL:URL];
        
        [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        
        [request setTimeoutInterval:[tmp.GlobalTimeout doubleValue]];
        
        (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];
        
                
    }
}

-(void)WaitForUserDataToLoad{
    Globals *tmp = [Globals sharedSingleton];
    if((([tmp.DriversInfoDoneLoading isEqualToString:@"done"] && [tmp.SetUserInfoDoneLoading isEqualToString:@"done"] && [tmp.PolicyInfoDoneLoading isEqualToString:@"done"] && [tmp.VehiclesDoneLoading isEqualToString:@"done"])) || ([tmp.devMode isEqualToString: @"DEVMODE"])){
        
        tmp.VehiclesDoneLoading = @"";
        tmp.userJustLoggedIn = @"true";
        
        btnLogin.titleLabel.text = @"Login";
        
        if(timer){
            [timer invalidate];
            timer = nil;
        }
        
        //Goto home page
        [activityIndicator stopAnimating];
        HomeTableViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeTableViewController"];
        [self.navigationController pushViewController:svc animated:YES];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
    NSDictionary *resultsDictionary = [responseData objectFromJSONData];
    
    NSString *loginResult = [resultsDictionary objectForKey:@"ValidateUserDBResult"];
    
    [connection cancel];
    
    if([loginResult isEqualToString:@"username"])
    {
        [self ShowLoginFailedDialog:@"Username does not exist"];
    }
    if([loginResult isEqualToString:@"false"])
    {
        [self ShowLoginFailedDialog:@"Password is incorrect. Please try again."];
    }
    if([loginResult isEqualToString:@"true"]){
        Globals *tmp = [Globals sharedSingleton];
        tmp.mainPolicyNumber = userName;
        [self CreateNewKeyChain:userName: passWord];
        
        [tmp LoadPolicyDataForUser:userName];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(WaitForUserDataToLoad) userInfo:nil repeats:YES];
        
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    Globals *tmp = [Globals sharedSingleton];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: tmp.connectionErrorTitle
                                                   message: tmp.connectionErrorMessage
                                                  delegate: self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    [alert show];
    [activityIndicator stopAnimating];
}





-(void)ShowLoginFailedDialog:(NSString *) errorMessage{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Login Problem"
                                                   message: errorMessage
                                                  delegate: self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    [alert show];
}

-(void)ShowLoginInfoRequiredDialog{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Login Problem"
                                                   message: @"Please enter a username and password"
                                                  delegate: self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    [alert show];
}

-(void)CreateNewKeyChain:(NSString *)username : (NSString *)password {
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"PortalDirect" accessGroup:nil];
    [keychainItem setObject:password forKey:(__bridge id)(kSecValueData)];
    [keychainItem setObject:username forKey:(__bridge id)(kSecAttrAccount)];
}

-(void)ConnectionFailed{
    Globals *tmp = [Globals sharedSingleton];
    if(connectionPromptOpen != YES){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: tmp.connectionErrorTitle
                                                       message: tmp.connectionErrorMessage
                                                      delegate: self
                                             cancelButtonTitle:@"Retry"
                                             otherButtonTitles:@"Exit", nil];
        alert.tag = 7;
        [alert show];
        connectionPromptOpen = YES;
    }
    [tmp LoadCoreData];
    timerDDLoaded = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(WaitForDropdownDataToLoad) userInfo:nil repeats:YES];
}

- (IBAction)NavigateToAutoQuote:(id)sender {
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
        //QuoteVehicleTableViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"QuoteVehicleTableViewController"];
        QuoteUITabBarController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"QuoteTabController"];
        [self.navigationController pushViewController:svc animated:YES];
    }
    
}

- (IBAction)ForgotPassword:(id)sender{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"Login"
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    
    [self.navigationItem setBackBarButtonItem: backButton];
    ForgotPasswordTableViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordTableViewController"];
    [self.navigationController pushViewController:svc animated:YES];

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    Globals *tmp = [Globals sharedSingleton];
    if(alertView.tag == 7){
        if(buttonIndex == 0){
            connectionPromptOpen = NO;
            tmp.connectionFailed = @"";
        }
        else{
            exit(0);
        }
        
    }
    
}


@end
