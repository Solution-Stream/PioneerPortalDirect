//
//  OccupationList.h
//  PortalDirect
//
//  Created by Brian Kalski on 2/27/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OccupationList : UITableViewController{
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

-(void) LoadOccupationList;
@end
