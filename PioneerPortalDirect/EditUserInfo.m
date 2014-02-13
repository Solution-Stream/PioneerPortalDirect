//
//  EditUserInfo.m
//  PortalDirect
//
//  Created by Brian Kalski on 5/21/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import "EditUserInfo.h"
#import "Globals.h"
#import "JSONKit.h"

@implementation EditUserInfo
@synthesize responseData;
@synthesize managedObjectContext = __managedObjectContext;

-(void) EditUserInfo:(NSString *)clientNumber FirstName:(NSString *)FirstName LastName:(NSString *)LastName Email:(NSString *)Email PhoneHome:(NSString *)PhoneHome PhoneWork:(NSString *)PhoneWork BirthDate:(NSString *)BirthDate{
    if([Email isEqualToString:@""]){
        Email = @"none";
    }
    if([PhoneHome isEqualToString:@""]){
        PhoneHome = @"0";
    }
    if([PhoneWork isEqualToString:@""]){
        PhoneWork = @"0";
    }
    
    BirthDate = [BirthDate stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
        
    Globals *tmp = [Globals sharedSingleton];
    NSString *_postString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",tmp.globalServerName, @"/users.svc/EditUserInfo/", clientNumber, @"/", FirstName, @"/", LastName, @"/", Email, @"/", PhoneHome, @"/", PhoneWork, @"/", BirthDate];
    
    NSString *theURL = [_postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL*URL = [NSURL URLWithString:theURL];
        
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
    
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
    NSDictionary *resultsDictionary = [responseData objectFromJSONData];
    
    NSString *saveResponse = [resultsDictionary objectForKey:@"EditUserInfoResult"];
    
    tmp.userInfoUpdated = @"done";
    if(![saveResponse isEqualToString:@"success"]){
        tmp.userInfoUpdated = @"failed";
    }
    
    [conn cancel];
    NSLog(@"EditUserInfo completed");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    Globals *tmp = [Globals sharedSingleton];
    tmp.connectionFailed = @"true";
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: tmp.connectionErrorTitle
                                                   message: tmp.connectionErrorMessage
                                                  delegate: self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    [alert show];
    
}





@end
