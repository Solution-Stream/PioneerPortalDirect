//
//  InsertDriverIntoQuote.h
//  PortalDirect
//
//  Created by Brian Kalski on 1/15/14.
//  Copyright (c) 2014 Pioneer Insurance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InsertDriverIntoQuote : UITableViewController<NSXMLParserDelegate>{
    NSMutableData *webData;
    NSMutableString *soapResults;
    NSURLConnection *conn;
    NSMutableData *responseData;
    
    //---xml parsing---
    NSXMLParser *xmlParser;
    BOOL elementFound;
}

@property (retain, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(void) InsertDriverIntoQuote:(NSString *)guid firstName:(NSString *)firstName middle:(NSString *)middle lastName:(NSString *)lastName dateBirth:(NSString *)dateBirth gender:(NSString *)gender maritalStatus:(NSString *)maritalStatus relationApplicant:(NSString *)relationApplicant dependents:(NSString *)dependents licenseState:(NSString *)licenseState licenseNum:(NSString *)licenseNum occupation:(NSString *)occupation incomeLevel:(NSString *)incomeLevel driverNum:(NSString *)driverNum;


@end
