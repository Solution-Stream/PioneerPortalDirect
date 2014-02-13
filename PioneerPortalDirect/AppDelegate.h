//
//  AppDelegate.h
//  PioneerPortalDirect
//
//  Created by Brian Kalski on 2/12/14.
//  Copyright (c) 2014 Solution-Stream. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SendEmail.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

void uncaughtExceptionHandler(NSException *exception);

@end
