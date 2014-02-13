//
//  ViewCertificateViewController.m
//  PortalDirect
//
//  Created by Brian Kalski on 3/4/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import "ViewCertificateViewController.h"
#import "Globals.h"
#import "UserInfo.h"
#import "VehicleList.h"
#import "PolicyInfo.h"

@interface ViewCertificateViewController ()

@end

@implementation ViewCertificateViewController

@synthesize txtEffectiveDates,txtInsured,txtInsuredAddress1,txtInsuredAddress2,txtMake,txtModel,txtPolicyNumber,txtVIN,txtYear;
@synthesize txtInsuredCity,txtInsuredState,txtInsuredZip,TableViewCellAddress2;

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
    //Load userinfo
	Globals *tmp = [Globals sharedSingleton];
    
    txtEffectiveDates.text = [NSString stringWithFormat:@"%@%@%@", tmp.policyeffectiveDate, @" to ", tmp.policyexpirationDate];
    
    self.managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *_fetchReqE = [[NSFetchRequest alloc] init];
    _fetchReqE.predicate = [NSPredicate predicateWithFormat:@"firstName != nil"];
    NSEntityDescription *entityE = [NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqE setEntity:entityE];
    NSArray *arrayTempE = [self.managedObjectContext executeFetchRequest:_fetchReqE error:nil];
    for(int i = 0; i < [arrayTempE count] ; i++){
        UserInfo *_list = (UserInfo*)[arrayTempE objectAtIndex:i];
        txtInsuredAddress1.text = _list.address1;
        txtInsuredAddress2.text = _list.address2;
        txtInsuredCity.text = [NSString stringWithFormat:@"%@%@%@%@%@",_list.city, @", ", _list.state, @" ", _list.zip];
        txtInsured.text = [NSString stringWithFormat:@"%@%@%@", _list.firstName, @" ", _list.lastName];
        txtPolicyNumber.text = _list.policyNumber;
    }   
    
    
    //Load VehicleInfo
    NSFetchRequest *_fetchReqV = [[NSFetchRequest alloc] init];
    NSString *selectedVIN = tmp.VIN;
    _fetchReqV.predicate = [NSPredicate predicateWithFormat:@"vin == %@", selectedVIN];
    NSEntityDescription *entityV = [NSEntityDescription entityForName:@"VehicleList" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqV setEntity:entityV];
    NSArray *arrayTempV = [self.managedObjectContext executeFetchRequest:_fetchReqV error:nil];
    for(int i = 0; i < [arrayTempV count] ; i++){
        VehicleList *_vehicleList = (VehicleList*)[arrayTempV objectAtIndex:i];
        txtYear.text = _vehicleList.year;
        txtMake.text = _vehicleList.make;
        txtModel.text = _vehicleList.model;
        txtVIN.text = _vehicleList.vin;
    }
    
    //Load PolicyInfo
    NSFetchRequest *_fetchReqP = [[NSFetchRequest alloc] init];
    _fetchReqP.predicate = [NSPredicate predicateWithFormat:@"effectiveDate != null"];
    NSEntityDescription *entityP = [NSEntityDescription entityForName:@"PolicyInfo" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqP setEntity:entityP];
    NSArray *arrayTempP = [self.managedObjectContext executeFetchRequest:_fetchReqP error:nil];
    for(int i = 0; i < [arrayTempP count] ; i++){
        PolicyInfo *_policyList = (PolicyInfo*)[arrayTempP objectAtIndex:i];
        txtEffectiveDates.text = [NSString stringWithFormat:@"%@%@%@", _policyList.effectiveDate, @" to ", _policyList.expirationDate];
    }
}
         
 -(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     if(indexPath.section == 0){
            return 128;
     }

     if(indexPath.section == 1){
         return 30;
     }
     
     if(indexPath.section == 2){
         if([txtInsuredAddress2.text isEqualToString:@""]){
             if(indexPath.row == 1){
                 return 0;
             }
             else{
                 return 30;
             }
         }
         else{
             return 30;
         }
     }
     else
     {
         return 30;
     }
     
     
 }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
