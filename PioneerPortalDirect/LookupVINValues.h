//
//  LookupVINValues.h
//  PioneerPortalDirect
//
//  Created by Brian Kalski on 2/17/14.
//  Copyright (c) 2014 Solution-Stream. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LookupVINValues : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
-(NSString*)LookupABSValue:(NSString *)code;
-(NSString*)LookupRestraintValue:(NSString *)code;

@end
