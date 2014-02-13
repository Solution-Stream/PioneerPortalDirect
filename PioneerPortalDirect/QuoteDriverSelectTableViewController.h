//
//  QuoteDriverSelectTableViewController.h
//  PortalDirect
//
//  Created by Brian Kalski on 9/24/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuoteDriverSelectTableViewController : UITableViewController{
    NSMutableArray *arrayQuoteDriver;
    NSMutableArray *arrayQuoteDriverID;
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
