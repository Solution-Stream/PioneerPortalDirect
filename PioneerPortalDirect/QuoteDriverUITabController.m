//
//  QuoteDriverUITabController.m
//  PortalDirect
//
//  Created by Brian Kalski on 9/23/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import "QuoteDriverUITabController.h"
#import "Globals.h"

@interface QuoteDriverUITabController ()

@end

@implementation QuoteDriverUITabController

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
	// Do any additional setup after loading the view.
    self.tabBarController.tabBarItem.title = @"Drivers";
    
    Globals *tmp = [Globals sharedSingleton];
	// Do any additional setup after loading the view.
    self.selectedIndex = [tmp.quoteDriverViewIndex intValue];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
