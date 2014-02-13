//
//  SendEmail.h
//  PortalDirect
//
//  Created by Brian Kalski on 6/11/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h> 
#import "Globals.h"

@interface SendEmail : UIViewController<NSXMLParserDelegate>{
    NSMutableData *webData;
    NSMutableString *soapResults;
    NSURLConnection *conn;
    NSMutableData *responseData;
    
    //---xml parsing---
    NSXMLParser *xmlParser;
    BOOL elementFound;
}

@property (retain, nonatomic) NSMutableData *responseData;


- (void)sendEmail:(NSString *)to subject:(NSString *)subject body:(NSString *)body;

@end
