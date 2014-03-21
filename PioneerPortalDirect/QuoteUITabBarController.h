//
//  QuoteUITabBarController.h
//  PortalDirect
//
//  Created by Brian Kalski on 9/17/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Quotes.h"

@interface QuoteUITabBarController : UITabBarController<UITabBarControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, retain) Quotes *currentQuote;
@property (strong, nonatomic) UIBarButtonItem *rightButton;
-(IBAction)SubmitQuote:(id)sender;
-(void)CheckQuote;
-(void)DisableReviewButton;
-(void)EnableReviewButton;

@end
