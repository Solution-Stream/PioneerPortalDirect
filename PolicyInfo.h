//
//  PolicyInfo.h
//  PioneerPortalDirect
//
//  Created by Brian Kalski on 2/13/14.
//  Copyright (c) 2014 Solution-Stream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PolicyInfo : NSManagedObject

@property (nonatomic, retain) NSString * effectiveDate;
@property (nonatomic, retain) NSString * expirationDate;

@end
