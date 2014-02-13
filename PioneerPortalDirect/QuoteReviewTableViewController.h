//
//  QuoteReviewTableViewController.h
//  PortalDirect
//
//  Created by Brian Kalski on 12/31/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuoteReviewTableViewController : UITableViewController{
    NSString *annualPremium;
    NSTimer *timer;
    NSTimer *timerStartGetRate;
    NSMutableArray *arrVehicles;
    NSMutableArray *arrDrivers;
}

@property (strong, nonatomic) IBOutlet UITableView *QuoteReviewTableView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UILabel *txtAnnualPremium;

@property (strong, nonatomic) IBOutlet UILabel *txtReviewText;

- (void)GetRate:(NSString *)guid;

@end
