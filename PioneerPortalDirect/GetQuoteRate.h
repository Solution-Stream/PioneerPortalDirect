//
//  GetQuoteRate.h
//  PortalDirect
//
//  Created by Brian Kalski on 1/15/14.
//  Copyright (c) 2014 Pioneer Insurance. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GetRateProtocol

@required
-(void) GetRateResponse:(NSString *) response;

@end

@interface GetQuoteRate : UITableViewController<NSXMLParserDelegate>{
    NSMutableData *webData;
    NSMutableString *soapResults;
    NSURLConnection *conn;
    NSMutableData *responseData;
    
    //---xml parsing---
    NSXMLParser *xmlParser;
    BOOL elementFound;
}

@property (nonatomic,strong) id delegate;
@property (retain, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(void) RateQuote:(NSString *)guid;


@end
