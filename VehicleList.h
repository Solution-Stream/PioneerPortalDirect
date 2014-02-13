//
//  VehicleList.h
//  PioneerPortalDirect
//
//  Created by Brian Kalski on 2/13/14.
//  Copyright (c) 2014 Solution-Stream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface VehicleList : NSManagedObject

@property (nonatomic, retain) NSString * bodilyInjury;
@property (nonatomic, retain) NSString * comprehensive;
@property (nonatomic, retain) NSString * make;
@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) NSString * uninsuredMotorist;
@property (nonatomic, retain) NSString * vin;
@property (nonatomic, retain) NSString * year;

@end
