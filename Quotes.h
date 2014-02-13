//
//  Quotes.h
//  PioneerPortalDirect
//
//  Created by Brian Kalski on 2/13/14.
//  Copyright (c) 2014 Solution-Stream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QuoteApplicant, QuoteCoverages, QuoteDriver, QuoteVehicle;

@interface Quotes : NSManagedObject

@property (nonatomic, retain) NSString * quoteID;
@property (nonatomic, retain) NSString * quoteName;
@property (nonatomic, retain) NSString * quoteStatus;
@property (nonatomic, retain) NSString * quoteSubmitted;
@property (nonatomic, retain) NSSet *quoteApplicant;
@property (nonatomic, retain) QuoteCoverages *quoteCoverages;
@property (nonatomic, retain) NSSet *quoteDriver;
@property (nonatomic, retain) NSSet *quoteVehicle;
@end

@interface Quotes (CoreDataGeneratedAccessors)

- (void)addQuoteApplicantObject:(QuoteApplicant *)value;
- (void)removeQuoteApplicantObject:(QuoteApplicant *)value;
- (void)addQuoteApplicant:(NSSet *)values;
- (void)removeQuoteApplicant:(NSSet *)values;

- (void)addQuoteDriverObject:(QuoteDriver *)value;
- (void)removeQuoteDriverObject:(QuoteDriver *)value;
- (void)addQuoteDriver:(NSSet *)values;
- (void)removeQuoteDriver:(NSSet *)values;

- (void)addQuoteVehicleObject:(QuoteVehicle *)value;
- (void)removeQuoteVehicleObject:(QuoteVehicle *)value;
- (void)addQuoteVehicle:(NSSet *)values;
- (void)removeQuoteVehicle:(NSSet *)values;

@end
