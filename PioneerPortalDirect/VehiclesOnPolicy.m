//
//  VehiclesOnPolicy.m
//  PortalDirect
//
//  Created by Brian Kalski on 2/28/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import "VehiclesOnPolicy.h"
#import "VehicleList.h"
#import "Globals.h"
#import "KeychainItemWrapper.h"
#import "JSONKit.h"

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? @"" : obj; })

@implementation VehiclesOnPolicy

@synthesize responseData;
@synthesize managedObjectContext = __managedObjectContext;

- (void)LoadVehiclesOnPolicyList:(NSString *)policyNumber{
    Globals *tmp = [Globals sharedSingleton];
    self.managedObjectContext = tmp.managedObjectContext;
    if([policyNumber isEqualToString:@""]){
        
    }
    else{
        //delete all records in entity
        Globals *tmp = [Globals sharedSingleton];
        self.managedObjectContext = tmp.managedObjectContext;
        NSFetchRequest *_fetchReq = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"VehicleList" inManagedObjectContext:self.managedObjectContext];
        [_fetchReq setEntity:entity];
        NSArray *arrayTemp = [self.managedObjectContext executeFetchRequest:_fetchReq error:nil];
        for (NSManagedObject * rec in arrayTemp) {
            [self.managedObjectContext deleteObject:rec];
        }
        NSError *saveError = nil;
        [self.managedObjectContext save:&saveError];
        
        
        NSString *theURL = [NSString stringWithFormat:@"%@%@%@",tmp.globalServerName, @"/users.svc/GetVehiclesOnPolicy/", policyNumber];
        
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
        
        NSURL*URL = [NSURL URLWithString:theURL];
        
        [request setURL:URL];
        
        [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        
        [request setTimeoutInterval:[tmp.GlobalTimeout doubleValue]];
        
        (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];

    }
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    Globals *tmp = [Globals sharedSingleton];
    tmp.connectionFailed = @"";

    NSDictionary *resultsDictionary = [responseData objectFromJSONData];
    
    NSArray *arrCodes = [resultsDictionary objectForKey:@"GetVehiclesOnPolicyResult"];
    
    
    for(NSDictionary *occ in arrCodes){
        VehicleList *vehicleList = [NSEntityDescription insertNewObjectForEntityForName:@"VehicleList" inManagedObjectContext:self.managedObjectContext];
        vehicleList.bodilyInjury = NULL_TO_NIL([occ objectForKey:@"BodilyInjury"]);
        vehicleList.comprehensive = NULL_TO_NIL([occ objectForKey:@"Comprehensive"]);
        vehicleList.make = NULL_TO_NIL([occ objectForKey:@"Make"]);
        vehicleList.model = NULL_TO_NIL([occ objectForKey:@"Model"]);
        vehicleList.uninsuredMotorist = NULL_TO_NIL([occ objectForKey:@"UninsuredMotorist"]);
        vehicleList.vin = NULL_TO_NIL([occ objectForKey:@"VIN"]);
        vehicleList.year = NULL_TO_NIL([occ objectForKey:@"Year"]);
    }
    [self.managedObjectContext save:nil];  // write to database
    [connection cancel];
    NSLog(@"VehiclesOnPolicy Loaded");
    tmp.VehiclesDoneLoading = @"done";
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    Globals *tmp = [Globals sharedSingleton];
    NSLog(@"VehiclesOnPolicy failed");
    tmp.connectionFailed = @"true";
}



@end