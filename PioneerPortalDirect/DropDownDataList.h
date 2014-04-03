//
//  DropDownDataList.h
//  PortalDirect
//
//  Created by Brian Kalski on 12/16/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DropDownDataListProtocol <NSObject>

@required
-(void) downloadResponse:(NSString *) response;

@end

@interface DropDownDataList : UITableViewController{
    NSMutableData *webData;
    NSMutableString *soapResults;
    //NSURLConnection *conn;
    NSMutableData *responseData;
    
    NSMutableString *occupationName;
    NSMutableString *occupationCode;
    
    id<DropDownDataListProtocol> _delegate;
    
}
@property (nonatomic,strong) id delegate;
@property (retain, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) UIAlertView *alert;

-(void) LoadDropDownDataList;

@end
