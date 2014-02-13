//
//  TabBarContainerViewController.m
//  PortalDirect
//
//  Created by Brian Kalski on 9/23/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import "TabBarContainerViewController.h"

@interface TabBarContainerViewController ()

@end

@implementation TabBarContainerViewController

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
    [self.navigationController setToolbarHidden:YES];
    self.title = @"Auto Quote";
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController popViewControllerAnimated:NO];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
