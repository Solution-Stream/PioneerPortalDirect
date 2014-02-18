//
//  LookupVINValues.m
//  PioneerPortalDirect
//
//  Created by Brian Kalski on 2/17/14.
//  Copyright (c) 2014 Solution-Stream. All rights reserved.
//

#import "LookupVINValues.h"
#import "Globals.h"
#import "DropdownData.h"

@implementation LookupVINValues

-(NSString*)LookupABSValue:(NSString *)code{
    Globals *tmp = [Globals sharedSingleton];
    self.managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *_fetchReqE = [[NSFetchRequest alloc] init];
    
    _fetchReqE.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"code =='", code, @"' and name =='ANTI_LOCK_BRAKES'", nil]];
    NSEntityDescription *entityE = [NSEntityDescription entityForName:@"DropdownData" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqE setEntity:entityE];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:_fetchReqE error:&error];
    
    NSString *dd_desc = @"";
    
    for (NSManagedObject *info in fetchedObjects)
    {
        DropdownData *dd = (DropdownData *)info;
        dd_desc = dd.desc;
    }
    
    return dd_desc;

}

-(NSString*)LookupRestraintValue:(NSString *)code{
    Globals *tmp = [Globals sharedSingleton];
    self.managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *_fetchReqE = [[NSFetchRequest alloc] init];
    
    _fetchReqE.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"code =='", code, @"' and name =='PASSIVE_RESTRAINT'", nil]];
    NSEntityDescription *entityE = [NSEntityDescription entityForName:@"DropdownData" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqE setEntity:entityE];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:_fetchReqE error:&error];
    
    NSString *dd_desc = @"";
    
    for (NSManagedObject *info in fetchedObjects)
    {
        DropdownData *dd = (DropdownData *)info;
        dd_desc = dd.desc;
    }
    
    return dd_desc;
}

@end
