//
//  QuoteReviewTableViewController.h
//  PortalDirect
//
//  Created by Brian Kalski on 9/24/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Quotes.h"

@interface QuoteAssignDriversTableViewController : UITableViewController{
    NSMutableArray *arrayQuoteVehicle;
    NSMutableArray *arrayQuoteVehicleID;
    NSMutableArray *arrayQuoteDriver;
    NSMutableArray *arrayQuoteDriverID;
    NSMutableArray *arrayQuoteVehicleDriver;
    NSString *saveStatus;
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UITableView *ReviewTableView;
@property (strong, retain) Quotes *currentQuote;

-(IBAction)SaveQuote:(id)sender;
-(IBAction)SubmitQuote:(id)sender;

@end
