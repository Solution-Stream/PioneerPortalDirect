//
//  HomeTableViewController.h
//  PortalDirect
//
//  Created by Brian Kalski on 1/30/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeychainItemWrapper.h"
#import "Globals.h"

@interface HomeTableViewController : UITableViewController<NSXMLParserDelegate>{
    NSMutableData *webData;
    NSMutableString *soapResults;
    NSMutableData *responseData;
    NSURLConnection *conn;
    NSDate *pickerDate;
    
    
    //---xml parsing---
    NSXMLParser *xmlParser;
    BOOL elementFound;
    BOOL hideQuoteSection;
    
    int numDrivers;
    bool LoggedIn;
    bool UserInfoEditing;
    bool landscape;
    
    NSString *clientNumber;

}
@property (strong, nonatomic) IBOutlet UITextField *txtFullName;
@property (weak, nonatomic) IBOutlet UIButton *btnLogoutUser;
@property (strong, nonatomic) IBOutlet UITextField *txtFirstName;
@property (strong, nonatomic) IBOutlet UITextField *txtLastName;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtPhoneHome;
@property (strong, nonatomic) IBOutlet UITextField *txtPhoneWork;
@property (strong, nonatomic) IBOutlet UITextField *txtBirthdate;
@property (weak, nonatomic) IBOutlet UITableViewCell *tcManageDrivers;
@property (strong, nonatomic) IBOutlet UITableView *UserInfoTableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *EditButton;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;

@property (strong, nonatomic) IBOutlet UIToolbar *BottomToolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *SaveToolbarButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *CancelToolbarButton;
@property (retain, nonatomic) NSTimer *timer;
@property (retain, nonatomic) NSTimer *timerEditUserInfo;
@property (strong, nonatomic) IBOutlet UITableViewCell *TableViewCellGetQuote;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonItemSave;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonItemCancel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonItemEdit;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonGetQuote;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *flexible;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) IBOutlet UITableViewCell *TableViewCellName;

- (IBAction)SaveUserInfo:(id)sender;
- (IBAction)GotoQuoteScreen:(id)sender;
- (IBAction)CancelEditUserInfo:(id)sender;
- (IBAction)EditUserInfo:(id)sender;
- (IBAction)LogoutUser:(id)sender;
- (void) DataFinishedLoading;
- (void) EditingOff;
- (void) EditingOn;
- (void) LogUserOut;
- (void) timerEditUserInfoFiring;
- (void) SetToolBarButtons:(bool)editing;

@end
