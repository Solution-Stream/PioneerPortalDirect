//
//  DriverDetailViewController.m
//  PortalDirect
//
//  Created by Brian Kalski on 2/7/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import "DriverDetailViewController.h"

@interface DriverDetailViewController ()

@end

@implementation DriverDetailViewController
@synthesize btnRemoveDriver,lblDateOfBirth,txtEmploymentStatus,txtDriverName,txtAnnualIncome,txtOccupation,segFaultAccidents,segNoFaultAccidents,segSpeedingTickets;
@synthesize managedObjectContext = _managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad{
    Globals *tmp = [Globals sharedSingleton];
    self.managedObjectContext = tmp.managedObjectContext;
    
    [self.navigationController setToolbarHidden:YES];
    
    //set background image
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clouds.png"]];
    [tempImageView setFrame:self.tableView.frame];
    self.tableView.backgroundView = tempImageView;
    
    NSFetchRequest *_fetchReq = [[NSFetchRequest alloc] init];
    _fetchReq.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@",@"clientNumber =", tmp.clientNumber]];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DriverInfo" inManagedObjectContext:self.managedObjectContext];
    [_fetchReq setEntity:entity];
    NSArray *drivers = [self.managedObjectContext executeFetchRequest:_fetchReq error:nil];
    for(int i = 0; i < [drivers count] ; i++){
        DriverInfo *_driverInfo = (DriverInfo*)[drivers objectAtIndex:i];
        self.title = _driverInfo.fullName;        
        lblDateOfBirth.text = _driverInfo.birthDate;
        txtOccupation.text = _driverInfo.occupation;
        txtAnnualIncome.text = [tmp GetAnnualIncomeText:_driverInfo.annualIncome];
        segFaultAccidents.selectedSegmentIndex = [_driverInfo.atFault5Years intValue];
        segNoFaultAccidents.selectedSegmentIndex = [_driverInfo.notFault3Years intValue];
        segSpeedingTickets.selectedSegmentIndex = [_driverInfo.speedingTickets intValue];
    }
    
    

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
