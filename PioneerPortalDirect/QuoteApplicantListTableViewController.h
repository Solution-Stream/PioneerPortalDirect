//
//  QuoteApplicantListTableViewController.h
//  PortalDirect
//
//  Created by Brian Kalski on 12/18/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuoteApplicantListTableViewController : UITableViewController{
    NSMutableArray *arrayQuoteApplicant;
    NSMutableArray *arrayQuoteApplicantID;
}
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(IBAction)NextStep:(id)sender;
-(IBAction)AddAnotherApplicant:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *ApplicantListTableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;

@end
