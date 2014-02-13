//
//  QuoteVehicle.h
//  PioneerPortalDirect
//
//  Created by Brian Kalski on 2/13/14.
//  Copyright (c) 2014 Solution-Stream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Quotes;

@interface QuoteVehicle : NSManagedObject

@property (nonatomic, retain) NSString * annualMileage;
@property (nonatomic, retain) NSString * antiLockBrakes;
@property (nonatomic, retain) NSString * antiLockBrakesValue;
@property (nonatomic, retain) NSString * antiTheftDevice;
@property (nonatomic, retain) NSString * antiTheftDeviceValue;
@property (nonatomic, retain) NSString * assignedDriverID;
@property (nonatomic, retain) NSString * assignedDriverName;
@property (nonatomic, retain) NSString * carpool;
@property (nonatomic, retain) NSString * carpoolValue;
@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) NSString * garagingZipCode;
@property (nonatomic, retain) NSString * make;
@property (nonatomic, retain) NSString * makeValue;
@property (nonatomic, retain) NSString * milesToWork;
@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) NSString * passiveRestraints;
@property (nonatomic, retain) NSString * passiveRestraintsValue;
@property (nonatomic, retain) NSString * quoteID;
@property (nonatomic, retain) NSString * splitCity;
@property (nonatomic, retain) NSString * vehicleID;
@property (nonatomic, retain) NSString * vehicleType;
@property (nonatomic, retain) NSString * vehicleTypeCode;
@property (nonatomic, retain) NSString * vehicleTypeValue;
@property (nonatomic, retain) NSString * vehicleUsage;
@property (nonatomic, retain) NSString * vehicleUsageValue;
@property (nonatomic, retain) NSString * vin;
@property (nonatomic, retain) NSString * workWeek;
@property (nonatomic, retain) NSString * workWeekValue;
@property (nonatomic, retain) NSString * year;
@property (nonatomic, retain) NSSet *quotes;
@end

@interface QuoteVehicle (CoreDataGeneratedAccessors)

- (void)addQuotesObject:(Quotes *)value;
- (void)removeQuotesObject:(Quotes *)value;
- (void)addQuotes:(NSSet *)values;
- (void)removeQuotes:(NSSet *)values;

@end
