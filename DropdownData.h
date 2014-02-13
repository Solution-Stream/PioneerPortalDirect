//
//  DropdownData.h
//  PioneerPortalDirect
//
//  Created by Brian Kalski on 2/13/14.
//  Copyright (c) 2014 Solution-Stream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DropdownData : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * name;

@end
