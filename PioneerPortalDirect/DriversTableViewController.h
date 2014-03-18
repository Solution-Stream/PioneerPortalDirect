//
//  DriversTableViewController.h
//  PortalDirect
//
//  Created by Brian Kalski on 2/5/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DriverInfo.h"
#import <CoreData/CoreData.h>

@interface DriversTableViewController : UITableViewController<NSXMLParserDelegate>{
    NSMutableData *webData;
    NSMutableString *soapResults;
    NSURLConnection *conn;
    NSMutableData *responseData;
    
    //---xml parsing---
    NSXMLParser *xmlParser;
    BOOL elementFound;
    BOOL editModeTblDriver;
    NSMutableString *fullName;
    NSNumber *clientNumber;
    NSNumber *policyNumber;
    NSMutableString *birthDate;

    IBOutlet UITableView *tblDriverList;
    NSMutableArray *arrayDrivers;
    NSMutableArray *arrayPolicyNumbers;
    NSMutableArray *arrayClientNumbers;
    
}
- (IBAction)RemoveDriverEditMode:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnEditDrivers;
@property int numDrivers;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property UIBarButtonItem *cancelButton;


@end
