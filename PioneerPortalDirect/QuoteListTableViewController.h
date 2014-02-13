//
//  QuoteListTableViewController.h
//  PortalDirect
//
//  Created by Brian Kalski on 8/26/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuoteListTableViewController : UITableViewController{
    NSMutableArray *arrayQuoteID;
    NSMutableArray *arrayQuoteName;
    NSMutableArray *arrayQuoteSubmitted;
    NSMutableArray *arrayQuoteStatus;
    NSMutableArray *arrayQuoteVehicle;
}
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(IBAction)NewQuote:(id)sender;
@end
