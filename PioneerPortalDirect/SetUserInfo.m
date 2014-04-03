//
//  SetUserInfo.m
//  PortalDirect
//
//  Created by Brian Kalski on 3/5/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//


#import "SetUserInfo.h"
#import "UserInfo.h"
#import "Globals.h"
#import "KeychainItemWrapper.h"
#import "JSONKit.h"

@implementation SetUserInfo

@synthesize responseData;
@synthesize managedObjectContext = __managedObjectContext;

- (void)SetUserInfo:(NSString *) policyNumber{
    
    //delete all records in entity
    Globals *tmp = [Globals sharedSingleton];
    self.managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *_fetchReq = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:self.managedObjectContext];
    [_fetchReq setEntity:entity];
    NSArray *arrayTemp = [self.managedObjectContext executeFetchRequest:_fetchReq error:nil];
    for (NSManagedObject * rec in arrayTemp) {
        [self.managedObjectContext deleteObject:rec];
    }
    NSError *saveError = nil;
    [self.managedObjectContext save:&saveError];
    
    
    NSString *theURL = [NSString stringWithFormat:@"%@%@%@",tmp.globalServerName, @"/users.svc/GetUserInfo/", policyNumber];
            
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
    
    NSArray *arrCodes = [resultsDictionary objectForKey:@"GetUserInfoResult"];
    
    for(NSDictionary *occ in arrCodes){
        UserInfo *userInfoList = [NSEntityDescription insertNewObjectForEntityForName:@"UserInfo" inManagedObjectContext:self.managedObjectContext];
        userInfoList.address1 = [occ objectForKey:@"address1"];
        userInfoList.address2 = [occ objectForKey:@"address2"];
        userInfoList.birthDate = [occ objectForKey:@"BirthDate"];
        userInfoList.firstName = [occ objectForKey:@"FirstName"];
        userInfoList.lastName = [occ objectForKey:@"LastName"];
        userInfoList.email = [occ objectForKey:@"email"];
        //userInfoList.fullName = [occ objectForKey:@"FullName"];
        userInfoList.phoneHome = [occ objectForKey:@"PhoneHome"];
        userInfoList.phoneWork = [occ objectForKey:@"PhoneWork"];
        userInfoList.policyNumber = [occ objectForKey:@"PolicyNumber"];
        userInfoList.city = [occ objectForKey:@"city"];
        userInfoList.clientNumber = [occ objectForKey:@"clientNumber"];
        userInfoList.state = [occ objectForKey:@"state"];
        userInfoList.zip = [occ objectForKey:@"zip"];
    }
    [self.managedObjectContext save:nil];  // write to database
    [connection cancel];
    NSLog(@"UserInfo Loaded");
    tmp.SetUserInfoDoneLoading = @"done";
    [self ReturnResponse:@"success"];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    Globals *tmp = [Globals sharedSingleton];
    NSLog(@"SetUserInfo failed");
    tmp.connectionFailed = @"true";
    [self ReturnResponse:@"connectionError"];
}

-(void)ReturnResponse:(NSString *) response{
    [self.delegate performSelector:@selector(SetUserInfoResponse:) withObject:response];
}




@end