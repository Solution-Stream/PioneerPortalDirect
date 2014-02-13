//
//  GetQuoteRate.m
//  PortalDirect
//
//  Created by Brian Kalski on 1/15/14.
//  Copyright (c) 2014 Pioneer Insurance. All rights reserved.
//

#import "GetQuoteRate.h"
#import "Globals.h"
#import "JSONKit.h"

@interface GetQuoteRate ()

@end

@implementation GetQuoteRate
@synthesize responseData;
@synthesize managedObjectContext = __managedObjectContext;


-(void) RateQuote:(NSString *)guid{
    Globals *tmp = [Globals sharedSingleton];
    tmp.quoteConnectionFailed = @"";
    NSString *postString = [NSString stringWithFormat:@"%@%@%@",tmp.globalServerName, @"/users.svc/RateQuote/", guid];
    //postString = [postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSURL *url=[[NSURL alloc] initWithString:[urlpath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *theURL = [NSURL URLWithString:postString];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:theURL];
    
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
    
    NSDictionary *resultsDictionary = [responseData objectFromJSONData];
    
    NSString *saveResponse = [resultsDictionary objectForKey:@"RateQuoteResult"];
    

    Globals *tmp = [Globals sharedSingleton];
    tmp.annualPremium = saveResponse;
    elementFound = FALSE;
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    Globals *tmp = [Globals sharedSingleton];
    tmp.connectionFailed = @"true";
    tmp.quoteConnectionFailed = @"YES";
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: tmp.connectionErrorTitle
                                                   message: error.description
                                                  delegate: self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    [alert show];
    
}


@end
