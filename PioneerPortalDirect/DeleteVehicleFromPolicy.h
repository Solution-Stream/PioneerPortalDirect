//
//  DeleteVehicleFromPolicy.h
//  PortalDirect
//
//  Created by Brian Kalski on 5/8/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeleteVehicleFromPolicy : UITableViewController<NSXMLParserDelegate>{
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

-(void) RemoveVehicleFromPolicy:(NSString *)policyNumber VIN:(NSString *)VIN;


@end

