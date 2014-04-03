//
//  DropDownDataList.m
//  PortalDirect
//
//  Created by Brian Kalski on 12/16/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import "DropDownDataList.h"
#import "Globals.h"
#import "JSONKit.h"
#import "DropDownData.h"

@interface DropDownDataList ()

@end

@implementation DropDownDataList@synthesize responseData;
@synthesize managedObjectContext = __managedObjectContext;

- (void)LoadDropDownDataList{
    
    Globals *tmp = [Globals sharedSingleton];
    self.managedObjectContext = tmp.managedObjectContext;
    
    //delete all objects
    NSFetchRequest *_fetchReq = [[NSFetchRequest alloc] init];
    NSError *error;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DropdownData" inManagedObjectContext:self.managedObjectContext];
    [_fetchReq setEntity:entity];
    
    NSArray *arrayTemp = [self.managedObjectContext executeFetchRequest:_fetchReq error:&error];
    for (NSManagedObject * rec in arrayTemp) {
        [self.managedObjectContext deleteObject:rec];
    }
    NSError *saveError = nil;
    [self.managedObjectContext save:&saveError];
    
    NSString *theURL = [NSString stringWithFormat:@"%@%@",tmp.globalServerName, @"/users.svc/getdropdowndata/"];
    
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
    
    NSArray *arrCodes = [resultsDictionary objectForKey:@"GetDropdownDataResult"];
    
    //if only one record is returned it is an error. Handle appropriately.
    if([arrCodes count] == 1){
        NSDictionary *occE = arrCodes[0];
        NSString *value = [occE objectForKey:@"Code"];
        //NSString *desc = [occE objectForKey:@"Description"];
        if([value isEqualToString:@"error"]){
            [self ReturnResponse:@"webServiceError"];
            return;
        }
    }
    
    NSString *occCode = nil;
    NSString *occDesc = nil;
    NSString *occName = nil;
    
    for(NSDictionary *occ in arrCodes){
        occCode = [occ objectForKey:@"Code"];
        occDesc = [occ objectForKey:@"Description"];
        occName = [occ objectForKey:@"Name"];
        DropdownData *vt = [NSEntityDescription insertNewObjectForEntityForName:@"DropdownData" inManagedObjectContext:self.managedObjectContext];
        
        vt.code = occCode;
        vt.desc = occDesc;
        vt.name = occName;
    }
    [self.managedObjectContext save:nil];  // write to database
    [connection cancel];
    
    if([arrCodes count] > 0){
        [self ReturnResponse:@"success"];
        NSLog(@"DropdownData Loaded");
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self ReturnResponse:@"connectionError"];
}

-(void)ReturnResponse:(NSString *) response{
    [self.delegate performSelector:@selector(downloadResponse:) withObject:response];
}






@end