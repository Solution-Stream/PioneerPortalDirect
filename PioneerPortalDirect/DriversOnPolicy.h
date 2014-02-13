//
//  DriversOnPolicy.h
//  PortalDirect
//
//  Created by Brian Kalski on 3/5/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Globals.h"
#import "KeychainItemWrapper.h"
#import "DriverInfo.h"

@interface DriversOnPolicy : UITableViewController<NSXMLParserDelegate>{
    NSMutableData *webData;
    NSMutableString *soapResults;
    //NSURLConnection *conn;
    NSMutableData *responseData;
    
    //---xml parsing---
    NSXMLParser *xmlParser;
    BOOL elementFound;
    
    NSMutableString *birthDate;
    NSMutableString *fullName;
    NSMutableString *phoneHome;
    NSMutableString *phoneWork;    
    NSMutableString *address1;
    NSMutableString *address2;
    NSMutableString *city;
    NSMutableString *clientNum;
    NSMutableString *email;
    NSMutableString *state;
    NSMutableString *username;
    NSMutableString *zip;
    NSMutableString *policyNum;
    NSMutableString *occupationCode;
    NSMutableString *occupation;
    NSMutableString *annualIncome;
    NSMutableString *nonFault3YearsValue;
    NSMutableString *atFault5Years;
    NSMutableString *speedingTickets;
    NSMutableString *sortOrder;
}
@property (retain, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
-(void) LoadDriversOnPolicyList:(NSString *)policyNumberValue;
@end
