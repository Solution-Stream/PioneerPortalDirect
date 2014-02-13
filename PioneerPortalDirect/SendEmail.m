//
//  SendEmail.m
//  PortalDirect
//
//  Created by Brian Kalski on 6/11/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import "SendEmail.h"

@implementation SendEmail

@synthesize responseData;

- (void)sendEmail:(NSString *)to subject:(NSString *)subject body:(NSString *)body {
    Globals *tmp = [Globals sharedSingleton];
    NSString *_postString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",@"http://mobile.actainstalls.com", @"/test.svc/SendEmail/", to, @"/", body, @"/", subject, @"/", @"186826"];
    
    NSString *postString = [_postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:postString];
    double timeOut = [tmp.GlobalTimeout doubleValue];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOut];
    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (conn) {
        webData = [NSMutableData data];
    }
}

-(void) connectionDidFinishLoading:(NSURLConnection *) connection {
    xmlParser = [[NSXMLParser alloc] initWithData: webData];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities:YES];
    [xmlParser parse];
}

//---when the start of an element is found---
-(void) parser:(NSXMLParser *) parser
didStartElement:(NSString *) elementName
  namespaceURI:(NSString *) namespaceURI
 qualifiedName:(NSString *) qName
    attributes:(NSDictionary *) attributeDict {
    
    if( [elementName isEqualToString:@"SendEmailResult"])
    {
        if (!soapResults)
        {
            soapResults = [[NSMutableString alloc] init];
        }
        elementFound = YES;
    }
}

-(void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string
{
    if (elementFound)
    {
        [soapResults appendString: string];
    }
}

//---when the end of element is found---
-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"SendEmailResult"])
    {
        Globals *tmp = [Globals sharedSingleton];
        NSString *soapValue = [NSString stringWithString:soapResults];
        tmp.userInfoUpdated = @"done";
        if(![soapValue isEqualToString:@"success"]){
            tmp.userInfoUpdated = @"failed";
        }
        [soapResults setString:@""];
        elementFound = FALSE;
    }
}

-(void) connection:(NSURLConnection *) connection
    didReceiveData:(NSData *) data {
    [webData appendData:data];
}

-(void) connection:(NSURLConnection *) connection
  didFailWithError:(NSError *) error {
    Globals *tmp = [Globals sharedSingleton];
    tmp.connectionFailed = @"true";
}

-(void) connection:(NSURLConnection *) connection
didReceiveResponse:(NSURLResponse *) response {
    [webData setLength: 0];
}


@end
