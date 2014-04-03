//
//  LoginTableViewController.h
//  PortalDirect
//
//  Created by Brian Kalski on 1/28/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginTableViewController : UITableViewController<NSXMLParserDelegate,UINavigationControllerDelegate>{
    NSMutableData *webData;
    NSMutableString *soapResults;
    NSURLConnection *conn;
    NSMutableData *responseData;
    NSTimer *timer;
    NSTimer *timerRetryConn;
    NSTimer *timerDDLoaded;
    
    //---xml parsing---
    NSXMLParser *xmlParser;
    BOOL elementFound;
    UIBarButtonItem *buttonForgotPassword;
    UIBarButtonItem *buttonGetQuote;
    NSString *userName;
    NSString *passWord;
    NSInteger connectionAttempts;
    BOOL stopLogin;
}
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (retain, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) IBOutlet UIButton *btnAutoQuote;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property(nonatomic) UIViewAutoresizing autoresizingMask;
@property (strong, nonatomic) IBOutlet UITableView *LoginTableView;
@property (strong, nonatomic) IBOutlet UITableView *LoginTableView_Landscape;

- (IBAction)LoginUser:(id)sender;
- (void)ShowLoginInfoRequiredDialog;
- (IBAction)NavigateToAutoQuote:(id)sender;
- (IBAction)ForgotPassword:(id)sender;
- (void)ConnectionFailed;





@end
