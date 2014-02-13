//
//  DriversOnPolicy.m
//  PortalDirect
//
//  Created by Brian Kalski on 3/5/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import "DriversOnPolicy.h"
#import "HomeTableViewController.h"
#import "JSONKit.h"

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? @"" : obj; })

@implementation DriversOnPolicy

@synthesize responseData,managedObjectContext;


-(void) LoadDriversOnPolicyList:(NSString *)policyNumberValue{
    
    //delete all records in entity
    Globals *tmp = [Globals sharedSingleton];
    tmp.DriversInfoDoneLoading = @"";
    self.managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *_fetchReq = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DriverInfo" inManagedObjectContext:self.managedObjectContext];
    [_fetchReq setEntity:entity];
    NSArray *arrayTemp = [self.managedObjectContext executeFetchRequest:_fetchReq error:nil];
    for (NSManagedObject * rec in arrayTemp) {
        [self.managedObjectContext deleteObject:rec];
    }
    NSError *saveError = nil;
    [self.managedObjectContext save:&saveError];
        
    NSString *theURL = [NSString stringWithFormat:@"%@%@%@",tmp.globalServerName, @"/users.svc/GetDriversOnPolicy/", policyNumberValue ];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
    
    NSURL*URL = [NSURL URLWithString:theURL];
    
    [request setURL:URL];
    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    [request setTimeoutInterval:[tmp.GlobalTimeout doubleValue]];
    
    (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];

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
    
    NSArray *arrCodes = [resultsDictionary objectForKey:@"GetDriversOnPolicyResult"];
    
    for(NSDictionary *occ in arrCodes){
        DriverInfo *driverInfoList = [NSEntityDescription insertNewObjectForEntityForName:@"DriverInfo" inManagedObjectContext:self.managedObjectContext];
        NSNumber *sortOrderValue = [occ objectForKey:@"sortOrder"];
        driverInfoList.address1 = NULL_TO_NIL([occ objectForKey:@"address1"]);
        driverInfoList.address2 = NULL_TO_NIL([occ objectForKey:@"address2"]);
        driverInfoList.birthDate = NULL_TO_NIL([occ objectForKey:@"BirthDate"]);
        driverInfoList.email = NULL_TO_NIL([occ objectForKey:@"email"]);
        driverInfoList.fullName = NULL_TO_NIL([occ objectForKey:@"FullName"]);
        driverInfoList.phoneHome = NULL_TO_NIL([occ objectForKey:@"PhoneHome"]);
        driverInfoList.phoneWork = NULL_TO_NIL([occ objectForKey:@"PhoneWork"]);
        driverInfoList.policyNumber = NULL_TO_NIL([occ objectForKey:@"PolicyNumber"]);
        driverInfoList.city = NULL_TO_NIL([occ objectForKey:@"city"]);
        driverInfoList.clientNumber = NULL_TO_NIL([occ objectForKey:@"clientNumber"]);
        driverInfoList.state = NULL_TO_NIL([occ objectForKey:@"state"]);
        driverInfoList.zip = NULL_TO_NIL([occ objectForKey:@"zip"]);
        driverInfoList.sortOrder = [sortOrderValue stringValue];
    }
    [self.managedObjectContext save:nil];  // write to database
    [connection cancel];
    NSLog(@"DriversOnPolicy Loaded");
    tmp.DriversInfoDoneLoading = @"done";
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    Globals *tmp = [Globals sharedSingleton];
    NSLog(@"DriversOnPolicy failed");
    tmp.connectionFailed = @"true";
}



@end
