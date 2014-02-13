//
//  MiniTort.h
//  PortalDirect
//
//  Created by Brian Kalski on 9/9/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MiniTort : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * code;

@end
