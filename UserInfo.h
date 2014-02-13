//
//  UserInfo.h
//  PioneerPortalDirect
//
//  Created by Brian Kalski on 2/13/14.
//  Copyright (c) 2014 Solution-Stream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserInfo : NSManagedObject

@property (nonatomic, retain) NSString * address1;
@property (nonatomic, retain) NSString * address2;
@property (nonatomic, retain) NSString * birthDate;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * clientNumber;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * phoneHome;
@property (nonatomic, retain) NSString * phoneWork;
@property (nonatomic, retain) NSString * policyNumber;
@property (nonatomic, retain) NSString * sortOrder;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * zip;

@end
