//
//  QuoteCoverages.h
//  PioneerPortalDirect
//
//  Created by Brian Kalski on 2/13/14.
//  Copyright (c) 2014 Solution-Stream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Quotes;

@interface QuoteCoverages : NSManagedObject

@property (nonatomic, retain) NSString * bodilyInjury;
@property (nonatomic, retain) NSString * bodilyInjuryValue;
@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) NSString * medicalProvider;
@property (nonatomic, retain) NSString * medicalProviderValue;
@property (nonatomic, retain) NSString * miniTort;
@property (nonatomic, retain) NSString * miniTortValue;
@property (nonatomic, retain) NSString * personalInjuryProtection;
@property (nonatomic, retain) NSString * personalInjuryProtectionValue;
@property (nonatomic, retain) NSString * propertyDamage;
@property (nonatomic, retain) NSString * propertyDamageValue;
@property (nonatomic, retain) NSString * propertyProtection;
@property (nonatomic, retain) NSString * propertyProtectionValue;
@property (nonatomic, retain) NSString * quoteID;
@property (nonatomic, retain) NSString * underinsuredMotorist;
@property (nonatomic, retain) NSString * underinsuredMotoristValue;
@property (nonatomic, retain) NSString * uninsuredMotorist;
@property (nonatomic, retain) NSString * uninsuredMotoristValue;
@property (nonatomic, retain) Quotes *quotes;

@end
