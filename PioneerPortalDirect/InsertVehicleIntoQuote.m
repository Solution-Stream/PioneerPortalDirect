//
//  InsertVehicleIntoQuote.m
//  PortalDirect
//
//  Created by Brian Kalski on 1/15/14.
//  Copyright (c) 2014 Pioneer Insurance. All rights reserved.
//

#import "InsertVehicleIntoQuote.h"
#import "Globals.h"
#import "JSONKit.h"

@interface InsertVehicleIntoQuote ()

@end

@implementation InsertVehicleIntoQuote
@synthesize responseData;
@synthesize managedObjectContext = __managedObjectContext;


-(void) InsertVehicleIntoQuote:(NSString *)VIN guid:(NSString *)guid year:(NSString *)year make:(NSString *)make model:(NSString *)model bodilyInjury:(NSString *)bodilyInjury medicalProv:(NSString *)medicalProv miniTort:(NSString *)miniTort personalInjuryProtection:(NSString *)personalInjuryProtection propertyDamage:(NSString *)propertyDamage propertyProtection:(NSString *)propertyProtection uninsuredValue:(NSString *)uninsuredValue underinsuredValue:(NSString *)underinsuredValue vehicleType:(NSString *)vehicleType vehicleUse:(NSString *)vehicleUse carpool:(NSString *)carpool antiLock:(NSString *)antiLock passiveRestraint:(NSString *)passiveRestraint antiTheft:(NSString *)antiTheft annualMiles:(NSString *)annualMiles milesOneWay:(NSString *)milesOneWay daysWeek:(NSString *)daysWeek multiCar:(NSString *)multiCar{
    Globals *tmp = [Globals sharedSingleton];
    tmp.quoteConnectionFailed = @"";
    
    NSString *postString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",tmp.globalServerName, @"/users.svc/InsertVehicleIntoQuote/", guid, @"/", year, @"/", make, @"/", model, @"/", bodilyInjury, @"/", medicalProv, @"/", miniTort, @"/", personalInjuryProtection, @"/", propertyDamage, @"/", propertyProtection, @"/", uninsuredValue, @"/", underinsuredValue, @"/", vehicleType, @"/", vehicleUse, @"/", VIN, @"/", carpool, @"/", antiLock, @"/", passiveRestraint, @"/", antiTheft, @"/", annualMiles, @"/", milesOneWay, @"/", daysWeek, @"/", multiCar];
    
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
    
    NSString *saveResponse = [resultsDictionary objectForKey:@"InsertVehicleIntoQuoteResult"];
    
    if ([saveResponse isEqualToString:@"success"])
    {
        NSInteger numQuoteVehiclesLoaded = tmp.numQuoteVehiclesLoaded;
        NSInteger totalQuotedVehicles = tmp.numberQuoteVehicles;
        NSInteger totalQuotedVehiclesLoaded = tmp.numQuoteVehiclesLoaded;
        totalQuotedVehiclesLoaded++;
        if(totalQuotedVehiclesLoaded == totalQuotedVehicles){
            //tmp.QuoteVehiclesAddedToQuote = @"YES";
            [self ReturnResponse:@"YES"];
        }
//        tmp.vehicleRemoved = saveResponse;
//        elementFound = FALSE;
    }
    else{
        //tmp.QuoteVehiclesAddedToQuote = @"FAILED";
        [self ReturnResponse:@"FAILED"];
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
    [self.delegate performSelector:@selector(insertVehicleResponse:) withObject:response];
}


@end
