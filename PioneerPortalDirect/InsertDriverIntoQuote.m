//
//  InsertDriverIntoQuote.m
//  PortalDirect
//
//  Created by Brian Kalski on 1/15/14.
//  Copyright (c) 2014 Pioneer Insurance. All rights reserved.
//

#import "InsertDriverIntoQuote.h"
#import "Globals.h"
#import "JSONKit.h"

@interface InsertDriverIntoQuote ()

@end

@implementation InsertDriverIntoQuote
@synthesize responseData;
@synthesize managedObjectContext = __managedObjectContext;


-(void) InsertDriverIntoQuote:(NSString *)guid firstName:(NSString *)firstName middle:(NSString *)middle lastName:(NSString *)lastName dateBirth:(NSString *)dateBirth gender:(NSString *)gender maritalStatus:(NSString *)maritalStatus relationApplicant:(NSString *)relationApplicant dependents:(NSString *)dependents licenseState:(NSString *)licenseState licenseNum:(NSString *)licenseNum occupation:(NSString *)occupation incomeLevel:(NSString *)incomeLevel driverNum:(NSString *)driverNum{
    Globals *tmp = [Globals sharedSingleton];
    tmp.quoteConnectionFailed = @"";
    
    if([middle isEqualToString:@""] || middle == nil){
        middle = @"AA";
    }
    
    NSString *postString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",tmp.globalServerName, @"/users.svc/InsertDriverIntoQuote/", guid, @"/", firstName, @"/", middle, @"/", lastName, @"/", dateBirth, @"/", gender, @"/", maritalStatus, @"/", relationApplicant, @"/", dependents, @"/", licenseState, @"/", licenseNum, @"/", occupation, @"/", incomeLevel, @"/", driverNum];
    
    //NSURL *theURL = [NSURL URLWithString:postString];
    
    postString = [postString stringByReplacingOccurrencesOfString:@"(null)" withString:@"00"];
    
    NSURL *theURL = [NSURL URLWithString:[postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
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
    Globals *tmp = [Globals sharedSingleton];
    NSDictionary *resultsDictionary = [responseData objectFromJSONData];
    
    NSString *saveResponse = [resultsDictionary objectForKey:@"InsertDriverIntoQuoteResult"];
    
    if ([saveResponse isEqualToString:@"success"])
    {
        NSInteger numQuoteDriversLoaded = tmp.numQuoteDriversLoaded;
        NSInteger totalQuotedDrivers = tmp.numberQuoteDrivers;
        tmp.numQuoteDriversLoaded = numQuoteDriversLoaded + 1;
        NSInteger totalQuotedDriversLoaded = tmp.numQuoteDriversLoaded;
        if(totalQuotedDriversLoaded == totalQuotedDrivers){
            //tmp.QuoteDriversAddedToQuote = @"YES";
            [self ReturnResponse:@"YES"];
        }
//        tmp.vehicleRemoved = saveResponse;
//        elementFound = FALSE;
    }
    else{
        [self ReturnResponse:@"FAILED"];
        //tmp.QuoteDriversAddedToQuote = @"FAILED";
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    Globals *tmp = [Globals sharedSingleton];
    tmp.connectionFailed = @"true";
    tmp.quoteConnectionFailed = @"YES";
    [self ReturnResponse:@"FAILED"];
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: tmp.connectionErrorTitle
//                                                   message: tmp.connectionErrorMessage
//                                                  delegate: self
//                                         cancelButtonTitle:@"OK"
//                                         otherButtonTitles:nil];
//    [alert show];
    
}

-(void)ReturnResponse:(NSString *) response{
    [self.delegate performSelector:@selector(insertDriverResponse:) withObject:response];
}


@end
