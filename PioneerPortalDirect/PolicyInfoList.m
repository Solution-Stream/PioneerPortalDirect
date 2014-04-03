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
    
    NSLog(@"PolicyInfo Loaded");
    tmp.PolicyInfoDoneLoading = @"done";
    [self ReturnResponse:@"success"];
}


-(void) connection:(NSURLConnection *) connection
  didFailWithError:(NSError *) error {
    Globals *tmp = [Globals sharedSingleton];
    NSLog(@"PolicyInfo failed");
    tmp.connectionFailed = @"true";
    [self ReturnResponse:@"connectionError"];
}

-(void)ReturnResponse:(NSString *) response{
    [self.delegate performSelector:@selector(PolicyInfoListResponse:) withObject:response];
}


@end