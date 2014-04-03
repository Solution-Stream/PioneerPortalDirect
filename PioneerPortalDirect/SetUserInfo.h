//
//  SetUserInfo.h
//  PortalDirect
//
//  Created by Brian Kalski on 3/5/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SetUserInfoProtocol <NSObject>

@required
-(void) SetUserInfoResponse:(NSString *) response;

@end


@interface SetUserInfo : UITableViewController<NSXMLParserDelegate>{
    NSMutableData *webData;
    NSMutableString *soapResults;
    //NSURLConnection *conn;
    NSMutableData *responseData;
    
    //---xml parsing---
    NSXMLParser *xmlParser;
    BOOL elementFound;
    
    NSMutableString *firstName;
    NSMutableString *lastName;
    NSMutableString *birthDate;
    NSMutableString *phoneHome;
    NSMutableString *phoneWork;
    NSMutableString *address1;
    NSMutableString *address2;
    NSMutableString *city;
    NSMutableString *state;
    NSMutableString *zip;
    NSMutableString *email;
    NSMutableString *policyNumberValue;
    NSMutableString *clientNumber;
    id<SetUserInfoProtocol> _delegate;
    
}
@property (nonatomic,strong) id delegate;
@property (retain, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
-(void) SetUserInfo:(NSString *) policyNumber;
@end
