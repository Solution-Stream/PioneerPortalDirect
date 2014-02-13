//
//  QuoteApplicant.h
//  PioneerPortalDirect
//
//  Created by Brian Kalski on 2/13/14.
//  Copyright (c) 2014 Solution-Stream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Quotes;

@interface QuoteApplicant : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * applicantID;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) NSString * dateBirth;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * middle;
@property (nonatomic, retain) NSString * quoteID;
@property (nonatomic, retain) NSString * residencyType;
@property (nonatomic, retain) NSString * residencyTypeValue;
@property (nonatomic, retain) NSString * ssn;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) NSSet *quotes;
@end

@interface QuoteApplicant (CoreDataGeneratedAccessors)

- (void)addQuotesObject:(Quotes *)value;
- (void)removeQuotesObject:(Quotes *)value;
- (void)addQuotes:(NSSet *)values;
- (void)removeQuotes:(NSSet *)values;

@end
