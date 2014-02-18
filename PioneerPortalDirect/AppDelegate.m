//
//  AppDelegate.m
//  Staff Manager
//
//  Created by Tim Roadley on 8/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginTableViewController.h"
#import "VehiclesOnPolicy.h"
#import "Globals.h"
#import "SendEmail.h"
#import "QuoteUITabBarController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // !!!: Use the next line only during beta
    //@try {
    //[TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
    
    
    //}
    //@catch (NSException *exception) {
    //SendEmail *sEmail = [[SendEmail alloc] init];
    //[sEmail sendEmail:@"bjkalski@gmail.com" subject:@"AppDelegate Error" body:exception.reason];
    //}
    //@finally {
    
    //}
    
    
    // Override point for customization after application launch.
    //    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    //    HomeTableViewController *controller = (HomeTableViewController *)navigationController.topViewController;
    //   controller.managedObjectContext = self.managedObjectContext;
    //LoginTableViewController *LoginTblCntrllr = [[LoginTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    //UINavigationController *navCtrlr = [[UINavigationController alloc]initWithRootViewController:LoginTblCntrllr];
    //[self.window setRootViewController:navCtrlr];
    //navCtrlr.delegate = self;
    //navCtrlr.navigationBarHidden = YES;
    
    Globals *tmp = [[Globals sharedSingleton] init];
    tmp.managedObjectContext = self.managedObjectContext;
    tmp.DriversInfoDoneLoading = @"";
    tmp.GlobalTimeout = @"20.0"; //timeout for all web service connections
    tmp.requiredFieldColor = [UIColor colorWithRed:1 green: 0.0 blue:0.0 alpha:.1];
    
    tmp.devMode = @"YES";
    
    //Load dropdown data into Core Data
    [tmp LoadCoreData];
    
    //navigation bar properties
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:(54/255.0) green:(100/255.0) blue:(139/255.0) alpha:1]] ;
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    
    // your bar button text attributes dictionary
    NSDictionary *textAttributes = @{ //NSForegroundColorAttributeName       : [UIColor blackColor],
                                      NSFontAttributeName            : [UIFont systemFontOfSize:12.0f]
                                      };
    [[UIBarButtonItem appearanceWhenContainedIn: [UINavigationController class],nil]
     setTitleTextAttributes:textAttributes
     forState:UIControlStateNormal];

    
    return YES;
}

void uncaughtExceptionHandler(NSException *exception) {
    //[FlurryAPI logError:@"Uncaught" message:@"Crash!" exception:exception];
    NSLog(@"Unresolved error %@", exception.description);
}

-(void)SwitchToTab:(NSInteger*) tab{
    //[QuoteUITabBarController setSelectedIndex:tab];
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController viewWillAppear:animated];
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController viewDidAppear:animated];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             */
            //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            //abort();
            SendEmail *sEmail = [[SendEmail alloc] init];
            [sEmail sendEmail:@"bjkalski@gmail.com" subject:@"AppDelegate Error" body:error.localizedDescription];
        }
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PortalDirect.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //abort();
        SendEmail *sEmail = [[SendEmail alloc] init];
        [sEmail sendEmail:@"bjkalski@gmail.com" subject:@"AppDelegate Error" body:error.localizedDescription];
        
    }
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end