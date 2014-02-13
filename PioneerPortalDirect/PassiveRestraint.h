//
//  PassiveRestraint.h
//  PortalDirect
//
//  Created by Brian Kalski on 9/6/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PassiveRestraint : NSManagedObject

@property (nonatomic, retain) NSString * passiveRestraintDescription;
@property (nonatomic, retain) NSString * passiveRestraintCode;

@end
