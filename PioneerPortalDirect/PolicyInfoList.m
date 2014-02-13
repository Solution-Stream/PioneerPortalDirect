//
//  PolicyInfoList.m
//  PortalDirect
//
//  Created by Brian Kalski on 3/8/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import "PolicyInfoList.h"
#import "PolicyInfo.h"
#import "Globals.h"
#import "JSONKit.h"

@implementation PolicyInfoList

@synthesize responseData;
@synthesize managedObjectContext = __managedObjectContext;

- (void)SetPolicyInfo:(NSString *) policyNumber{
    
    //delete all records in entity
    Globals *tmp = [Globals sharedSingleton];
    self.managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *_fetchReq = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PolicyInfo" inManagedObjectContext:self.managedObjectContext];
    [_fetchReq setEntity:entity];
    NSArray *arrayTemp = [self.managedObjectContext executeFetchRequest:_fetchReq error:nil];
    for (NSManagedObject * rec in arrayTemp) {
        [self.managedObjectContext deleteObject:rec];
    }
    NSError *saveError = nil;
    [self.managedObjectContext save:&saveError];
    
//    NSString *theURL = [NSString stringWithFormat:@"%@%@%@",tmp.globalServerName, @"/users.svc/GetPolicyInfo/", policyNumber];
//    
//    NSError* err = nil;
//    
//    NSURLResponse* response = nil;
//    
//    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
//    
//    NSURL*URL = [NSURL URLWithString:theURL];
//    
//    [request setURL:URL];
//    
//    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
//    
//    [request setTimeoutInterval:[tmp.GlobalTimeout doubleValue];];
//    
//    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
//    
//    NSDictionary *resultsDictionary = [data objectFromJSONData];
//    
//    NSArray *arrCodes = [resultsDictionary objectForKey:@"GetPolicyInfoResult"];
    
    //for(NSDictionary *occ in arrCodes){
        //PolicyInfo *policyInfoList = [NSEntityDescription insertNewObjectForEntityForName:@"PolicyInfo" inManagedObjectContext:self.managedObjectContext];
        //policyInfoList.effectiveDate = [occ objectForKey:@"effectiveDate"];;
        //policyInfoList.expirationDate = [occ objectForKey:@"expirationDate"];;
    //}
//    [self.managedObjectContext save:nil];  // write to database
//    [conn cancel];
    NSLog(@"PolicyInfo Loaded");
    tmp.PolicyInfoDoneLoading = @"done";
    
}


-(void) connection:(NSURLConnection *) connection
  didFailWithError:(NSError *) error {
    Globals *tmp = [Globals sharedSingleton];
    NSLog(@"PolicyInfo failed");
    tmp.connectionFailed = @"true";
}


@end