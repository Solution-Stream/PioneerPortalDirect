//
//  QuoteDriver.h
//  PioneerPortalDirect
//
//  Created by Brian Kalski on 3/23/14.
//  Copyright (c) 2014 Solution-Stream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Quotes;

@interface QuoteDriver : NSManagedObject

@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) NSString * dateBirth;
@property (nonatomic, retain) NSString * dependents;
@property (nonatomic, retain) NSString * driverID;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * incomeLevel;
@property (nonatomic, retain) NSString * incomeLevelValue;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * licenseNum;
@property (nonatomic, retain) NSString * licenseState;
@property (nonatomic, retain) NSString * licenseStateValue;
@property (nonatomic, retain) NSString * maritalStatus;
@property (nonatomic, retain) NSString * middleInitial;
@property (nonatomic, retain) NSString * occupation;
@property (nonatomic, retain) NSString * occupationValue;
@property (nonatomic, retain) NSString * quoteID;
@property (nonatomic, retain) NSString * relationApplicant;
@property (nonatomic, retain) NSString * relationApplicantValue;
@property (nonatomic, retain) NSString * infoNeeded;
@property (nonatomic, retain) NSSet *quotes;
@end

@interface QuoteDriver (CoreDataGeneratedAccessors)

- (void)addQuotesObject:(Quotes *)value;
- (void)removeQuotesObject:(Quotes *)value;
- (void)addQuotes:(NSSet *)values;
- (void)removeQuotes:(NSSet *)values;

@end
