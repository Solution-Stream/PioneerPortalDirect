//
//  MiniTortList.m
//  PortalDirect
//
//  Created by Brian Kalski on 9/9/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import "MiniTortList.h"
#import "Globals.h"
#import "JSONKit.h"
#import "MiniTort.h"

@interface MiniTortList ()

@end

@implementation MiniTortList
@synthesize responseData;
@synthesize managedObjectContext = __managedObjectContext;

- (void)LoadMiniTortList{
    
    Globals *tmp = [Globals sharedSingleton];
    self.managedObjectContext = tmp.managedObjectContext;
    
    //delete all objects
    NSFetchRequest *_fetchReq = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MiniTort" inManagedObjectContext:self.managedObjectContext];
    [_fetchReq setEntity:entity];
    NSArray *arrayTemp = [self.managedObjectContext executeFetchRequest:_fetchReq error:nil];
    for (NSManagedObject * rec in arrayTemp) {
        [self.managedObjectContext deleteObject:rec];
    }
    NSError *saveError = nil;
    [self.managedObjectContext save:&saveError];
    
    NSString *theURL = [NSString stringWithFormat:@"%@%@",tmp.globalServerName, @"/users.svc/getminitortlist/"];
    
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
    
    NSArray *arrCodes = [resultsDictionary objectForKey:@"GetMiniTortResult"];
    
    NSString *occCode = nil;
    NSString *occName = nil;
    
    for(NSDictionary *occ in arrCodes){
        occCode = [occ objectForKey:@"Code"];
        occName = [occ objectForKey:@"Description"];
        MiniTort *vt = [NSEntityDescription insertNewObjectForEntityForName:@"MiniTort" inManagedObjectContext:self.managedObjectContext];
        vt.code = occCode;
        vt.desc = occName;
    }
    [self.managedObjectContext save:nil];  // write to database
    [connection cancel];
    NSLog(@"MiniTortList Loaded");
    tmp.MiniTortListLoaded = @"YES";
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    Globals *tmp = [Globals sharedSingleton];
    NSLog(@"MiniTortList failed");
    tmp.connectionFailed = @"true";
}






@end