//
//  VehiclesOnPolicy.h
//  PortalDirect
//
//  Created by Brian Kalski on 2/28/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VehiclesOnPolicyProtocol <NSObject>

@required
-(void) VehiclesOnPolicyResponse:(NSString *) response;

@end

@interface VehiclesOnPolicy : UITableViewController<NSXMLParserDelegate>{
    NSMutableData *webData;
    NSMutableString *soapResults;
    //NSURLConnection *conn;
    NSMutableData *responseData;
    
    //---xml parsing---
    NSXMLParser *xmlParser;
    BOOL elementFound;
    
    NSMutableString *vehicleYear;
    NSMutableString *vehicleMake;
    NSMutableString *vehicleModel;
    NSMutableString *vehicleVIN;
    NSMutableString *bodilyInjury;
    NSMutableString *comprehensive;
    NSMutableString *uninsuredMotorist;
    id<VehiclesOnPolicyProtocol> _delegate;
    
}
@property (nonatomic,strong) id delegate;
@property (retain, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
-(void) LoadVehiclesOnPolicyList:(NSString *)policyNumber;
@end
