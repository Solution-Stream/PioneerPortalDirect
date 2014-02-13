//
//  QuoteDriverListUITableViewController.h
//  PortalDirect
//
//  Created by Brian Kalski on 9/12/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuoteDriverListUITableViewController : UITableViewController{
    NSMutableArray *arrayQuoteDriver;
    NSMutableArray *arrayQuoteDriverID;
}
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(IBAction)NextStep:(id)sender;
-(IBAction)AddAnotherDriver:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *DriverListTableView;

@end
