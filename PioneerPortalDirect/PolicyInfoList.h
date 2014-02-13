//
//  PolicyInfoList.h
//  PortalDirect
//
//  Created by Brian Kalski on 3/8/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PolicyInfoList : UITableViewController<NSXMLParserDelegate>{
    NSMutableData *webData;
    NSMutableString *soapResults;
    //NSURLConnection *conn;
    NSMutableData *responseData;
    
    //---xml parsing---
    NSXMLParser *xmlParser;
    BOOL elementFound;
    
    NSMutableString *effectiveDate;
    NSMutableString *expirationDate;
}
@property (retain, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
-(void) SetPolicyInfo:(NSString *) policyNumber;
@end
