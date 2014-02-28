//
//  QuoteUITabBarController.m
//  PortalDirect
//
//  Created by Brian Kalski on 9/17/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import "QuoteUITabBarController.h"
#import "QuoteReviewTableViewController.h"
#import "QuoteListTableViewController.h"
#import "QuoteApplicant.h"
#import "QuoteCoverages.h"
#import "QuoteDriver.h"
#import "QuoteVehicle.h"
#import "Globals.h"

@interface QuoteUITabBarController ()

@end

@implementation QuoteUITabBarController
@synthesize currentQuote,rightButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self StartupFunction];
}



- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    [self StartupFunction];
}

-(void)StartupFunction{
    Globals *tmp = [Globals sharedSingleton];
    
    
    CGRect frame = CGRectMake(0.0, 0, self.view.bounds.size.width, 48);
    
    UIView *trans_view = [[UIView alloc] initWithFrame:frame];
    
    [trans_view setBackgroundColor:[[UIColor alloc] initWithRed:0.0
                                                          green:0.0
                                                           blue:0.0
                                                          alpha:0.5]];//you can change alpha value also
    
    [self.tabBar insertSubview:trans_view atIndex:0];//tabBar1 = your tabbar reference
	
    
    
    
    
    self.selectedIndex = [tmp.quoteViewIndex intValue];
    [self.navigationController setToolbarHidden:YES];
    self.title = @"Auto Quote";
    
    rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Review Quote" style:UIBarButtonItemStyleDone target:self action:@selector(ReviewQuote:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    rightButton.enabled = NO;
    
    [self CheckQuote];
}

-(void)DisableReviewButton{
    rightButton.enabled = NO;
}

-(void)EnableReviewButton{
    rightButton.enabled = YES;
}


- (void)CheckQuote{
    Globals *tmp = [Globals sharedSingleton];
    self.managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *_fetchReqE = [[NSFetchRequest alloc] init];
    _fetchReqE.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"quoteID =='", tmp.currentQuoteGuid, @"'", nil]];
    NSEntityDescription *entityE = [NSEntityDescription entityForName:@"Quotes" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqE setEntity:entityE];
    
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:_fetchReqE error:nil];
    
    for (NSManagedObject *info in fetchedObjects)
    {
        Quotes *app = (Quotes *)info;
        
        NSInteger qa = app.quoteApplicant.count;
        NSNumber *qc = app.quoteCoverages != nil ? app.quoteCoverages.completed : 0;
        NSInteger qv = app.quoteVehicle != nil ? app.quoteVehicle.count : 0;
        NSInteger qd = app.quoteDriver != nil ? app.quoteDriver.count : 0;
        
    
        if(qa > 0 && qv > 0 && qd > 0 && [qc isEqualToNumber:[NSNumber numberWithInt:1]]){
            rightButton.enabled = YES;
        }
        else{
            rightButton.enabled = NO;
        }
        
        
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)SubmitQuote:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Submit Quote Confirmation"
                                                   message: @"Are you sure you want to submit this quote? It will no longer be editable."
                                                  delegate: self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"OK",nil];
    alert.tag = 10;
    [alert show];
}

-(IBAction)ReviewQuote:(id)sender{
    QuoteReviewTableViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"QuoteReviewTableViewController"];
    [self.navigationController pushViewController:svc animated:YES];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        if(alertView.tag == 10){
            [self CommitSubmitQuote];
        }
    }
}

-(void)CommitSubmitQuote{
    Globals *tmp = [Globals sharedSingleton];
    self.managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *_fetchReqE = [[NSFetchRequest alloc] init];
    _fetchReqE.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"quoteID == '", tmp.currentQuoteGuid, @"'", nil]];
    NSEntityDescription *entityE = [NSEntityDescription entityForName:@"Quotes" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqE setEntity:entityE];
    
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:_fetchReqE error:nil];
    
    for (NSManagedObject *info in fetchedObjects)
    {
        currentQuote = (Quotes *)info;
    }
    currentQuote.quoteStatus = @"Submitted";
    
    QuoteListTableViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"QuoteListTableViewController"];
    [self.navigationController pushViewController:svc animated:YES];

}

@end
