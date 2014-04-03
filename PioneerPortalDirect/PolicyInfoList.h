//
//  PolicyInfoList.h
//  PortalDirect
//
//  Created by Brian Kalski on 3/8/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PolicyInfoListProtocol <NSObject>

@required
-(void) PolicyInfoListResponse:(NSString *) response;

@end

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
    id<PolicyInfoListProtocol> _delegate;
    
}
@property (nonatomic,strong) id delegate;
@property (retain, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
-(void) SetPolicyInfo:(NSString *) policyNumber;
@end
