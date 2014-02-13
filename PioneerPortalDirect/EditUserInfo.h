//
//  EditUserInfo.h
//  PortalDirect
//
//  Created by Brian Kalski on 5/21/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EditUserInfo : UITableViewController<NSXMLParserDelegate>{
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

-(void) EditUserInfo:(NSString *)clientNumber FirstName:(NSString *)FirstName LastName:(NSString *)LastName Email:(NSString *)Email PhoneHome:(NSString *)PhoneHome PhoneWork:(NSString *)PhoneWork BirthDate:(NSString *)BirthDate;


@end
