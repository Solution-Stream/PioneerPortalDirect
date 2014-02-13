//
//  Occupations.h
//  PortalDirect
//
//  Created by Brian Kalski on 2/27/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Occupations : NSManagedObject

@property (nonatomic, retain) NSString * occupationName;
@property (nonatomic, retain) NSString * occupationCode;


@end
