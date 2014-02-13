//
//  MiniTortList.h
//  PortalDirect
//
//  Created by Brian Kalski on 9/9/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MiniTortList : UITableViewController{
    NSMutableData *webData;
    NSMutableString *soapResults;
    //NSURLConnection *conn;
    NSMutableData *responseData;
    
    NSMutableString *occupationName;
    NSMutableString *occupationCode;
    
    
}
@property (retain, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) UIAlertView *alert;

-(void) LoadMiniTortList;

@end
