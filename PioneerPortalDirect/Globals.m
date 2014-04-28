//
//  Globals.m
//  PortalDirect
//
//  Created by Brian Kalski on 1/31/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import "Globals.h"
#import "Quotes.h"
#import "QuoteApplicant.h"
#import "QuoteCoverages.h"
#import "VehiclesOnPolicy.h"
#import "SetUserInfo.h"
#import "DriversOnPolicy.h"
#import "PolicyInfoList.h"
#import "DropDownDataList.h"


@implementation Globals

static Globals *shared = NULL;

@synthesize globalServerName,arrayGlobalPolicyNumbers,clientNumber,connectionErrorMessage,connectionErrorTitle,mainPolicyNumber,userInfoUpdated;
@synthesize stateList,arrAntiTheftDevice,arrBodilyInjuryLimit,arrVehicleUsage,managedObjectContext,VIN,DriversInfoDoneLoading,SetUserInfoDoneLoading,PolicyInfoDoneLoading,VehiclesDoneLoading;
@synthesize policyeffectiveDate,policyexpirationDate,arrAntiTheftDeviceValue,arrBodilyInjuryLimitValue,arrVehicleUsageValue,vehicleAdded,vehicleRemoved,userJustLoggedIn;
@synthesize connectionFailed,GlobalTimeout,GoToQuoteScreen,NavigationMode,EmployeeStatusListLoaded,AnnualIncomeListLoaded,OccupationListLoaded,currentQuoteGuid;
@synthesize VehicleTypeListLoaded,AntiLockBrakeListLoaded,PassiveRestraintListLoaded,DaysWeekListLoaded,MiniTortListLoaded,UninsuredMotoristLoaded,UnderInsuredMotoristListLoaded,PropertyDamageLoaded,PropertyProtectionLoaded;
@synthesize currentDriverID,createNewDriver,quoteViewIndex,currentVehicleID,createNewVehicle,vcAddDriver,quoteDriverViewIndex,quoteSelectedVehicle,requiredFieldColor,DropdownListLoaded,currentApplicantID,createNewApplicant;
@synthesize quoteApplicantViewIndex,annualPremium,QuoteDriversAddedToQuote,QuoteVehiclesAddedToQuote,numberQuoteVehicles,numberQuoteDrivers,numQuoteDriversLoaded,numQuoteVehiclesLoaded,quoteConnectionFailed;
@synthesize TableViewListFont;

-(id)init{
    if(self = [super init])
    {
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        
        //DEV Mode
        if([def objectForKey:@"devMode"] == nil){
            [def setObject:NavigationMode forKey:@"devMode"];
            [def synchronize];
        }
        else{
            self.devMode = [def stringForKey:@"devMode"];
        }
        
        //required field color
        if([def objectForKey:@"requiredFieldColor"] == nil){
            [def setObject:requiredFieldColor forKey:@"requiredFieldColor"];
            [def synchronize];
        }
        else{
            self.requiredFieldColor = [def objectForKey:@"requiredFieldColor"];
        }
        
        //TableViewListFont
        if([def objectForKey:@"TableViewListFont"] == nil){
            [def setObject:TableViewListFont forKey:@"TableViewListFont"];
            [def synchronize];
        }
        else{
            self.TableViewListFont = [def objectForKey:@"TableViewListFont"];
        }
        
        //quoteConnectionFailed
        if([def objectForKey:@"quoteConnectionFailed"] == nil){
            [def setObject:quoteConnectionFailed forKey:@"quoteConnectionFailed"];
            [def synchronize];
        }
        else{
            self.quoteConnectionFailed = [def objectForKey:@"quoteConnectionFailed"];
        }
        
        //annual premium
        if([def objectForKey:@"annualPremium"] == nil){
            [def setObject:annualPremium forKey:@"annualPremium"];
            [def synchronize];
        }
        else{
            self.annualPremium = [def stringForKey:@"annualPremium"];
        }
        
        //number of quote drivers loaded
        if([def objectForKey:@"numQuoteDriversLoaded"] == nil){
            [def setInteger:numQuoteDriversLoaded forKey:@"numQuoteDriversLoaded"];
            [def synchronize];
        }
        else{
            self->numQuoteDriversLoaded = [[def stringForKey:@"numQuoteDriversLoaded"] integerValue];
        }
        
        //number of quote vehicles loaded
        if([def objectForKey:@"numQuoteVehiclesLoaded"] == nil){
            [def setInteger:numQuoteVehiclesLoaded forKey:@"numQuoteVehiclesLoaded"];
            [def synchronize];
        }
        else{
            self->numQuoteVehiclesLoaded = [[def stringForKey:@"numQuoteVehiclesLoaded"] integerValue];
        }
        
        //number of quote drivers
        if([def objectForKey:@"numberQuoteDrivers"] == nil){
            [def setInteger:numberQuoteDrivers forKey:@"numberQuoteDrivers"];
            [def synchronize];
        }
        else{
            self->numberQuoteDrivers = [[def stringForKey:@"numberQuoteDrivers"] integerValue];
        }
        
        //number of quote vehicles
        if([def objectForKey:@"numberQuoteVehicles"] == nil){
            [def setInteger:numberQuoteVehicles forKey:@"numberQuoteVehicles"];
            [def synchronize];
        }
        else{
            self->numberQuoteVehicles = [[def stringForKey:@"numberQuoteVehicles"] integerValue];
        }
        
        //QuoteDriversAddedToQuote
        if([def objectForKey:@"QuoteDriversAddedToQuote"] == nil){
            [def setObject:QuoteDriversAddedToQuote forKey:@"QuoteDriversAddedToQuote"];
            [def synchronize];
        }
        else{
            self.QuoteDriversAddedToQuote = [def stringForKey:@"QuoteDriversAddedToQuote"];
        }
        
        //QuoteVehiclesAddedToQuote
        if([def objectForKey:@"QuoteVehiclesAddedToQuote"] == nil){
            [def setObject:QuoteVehiclesAddedToQuote forKey:@"QuoteVehiclesAddedToQuote"];
            [def synchronize];
        }
        else{
            self.QuoteVehiclesAddedToQuote = [def stringForKey:@"QuoteVehiclesAddedToQuote"];
        }
        
        if([def objectForKey:@"currentQuoteGuid"] == nil){
            [def setObject:currentQuoteGuid forKey:@"currentQuoteGuid"];
            [def synchronize];
        }
        else{
            self.currentQuoteGuid = [def stringForKey:@"currentQuoteGuid"];
        }
        
        if([def objectForKey:@"vcAddDriver"] == nil){
            [def setObject:vcAddDriver forKey:@"vcAddDriver"];
            [def synchronize];
        }
        else{
            self.vcAddDriver = [def objectForKey:@"vcAddDriver"];
        }
        
        //quoteViewIndex
        if([def objectForKey:@"quoteViewIndex"] == nil){
            [def setObject:quoteViewIndex forKey:@"quoteViewIndex"];
            [def synchronize];
        }
        else{
            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            NSNumber * myNumber = [f numberFromString:[def stringForKey:@"quoteViewIndex"]];
            self.quoteViewIndex = myNumber;
        }
        
        //quoteApplicantViewIndex
        if([def objectForKey:@"quoteApplicantViewIndex"] == nil){
            [def setObject:quoteApplicantViewIndex forKey:@"quoteApplicantViewIndex"];
            [def synchronize];
        }
        else{
            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            NSNumber * myNumber = [f numberFromString:[def stringForKey:@"quoteApplicantViewIndex"]];
            self.quoteApplicantViewIndex = myNumber;
        }
        
        //createNewApplicant
        if([def objectForKey:@"createNewApplicant"] == nil){
            [def setObject:createNewApplicant forKey:@"createNewApplicant"];
            [def synchronize];
        }
        else{
            self.createNewApplicant = [def stringForKey:@"createNewApplicant"];
        }
        
        //quoteSelectedVehicle
        if([def objectForKey:@"quoteSelectedVehicle"] == nil){
            [def setObject:quoteSelectedVehicle forKey:@"quoteSelectedVehicle"];
            [def synchronize];
        }
        else{
            self.quoteSelectedVehicle = [def stringForKey:@"quoteSelectedVehicle"];
        }
        
        //quoteDriverViewIndex
        if([def objectForKey:@"quoteDriverViewIndex"] == nil){
            [def setObject:quoteDriverViewIndex forKey:@"quoteDriverViewIndex"];
            [def synchronize];
        }
        else{
            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            NSNumber * myNumber = [f numberFromString:[def stringForKey:@"quoteDriverViewIndex"]];
            self.quoteDriverViewIndex = myNumber;
        }
        
        //MiniTortListLoaded
        if([def objectForKey:@"MiniTortListLoaded"] == nil){
            [def setObject:MiniTortListLoaded forKey:@"MiniTortListLoaded"];
            [def synchronize];
        }
        else{
            self.MiniTortListLoaded = [def stringForKey:@"MiniTortListLoaded"];
        }
        
        //DriverID
        if([def objectForKey:@"currentDriverID"] == nil){
            [def setObject:currentDriverID forKey:@"currentDriverID"];
            [def synchronize];
        }
        else{
            self.currentDriverID = [def stringForKey:@"currentDriverID"];
        }
        
        //VehicleID
        if([def objectForKey:@"currentVehicleID"] == nil){
            [def setObject:currentVehicleID forKey:@"currentVehicleID"];
            [def synchronize];
        }
        else{
            self.currentVehicleID = [def stringForKey:@"currentVehicleID"];
        }
        
        //currentApplicantID
        if([def objectForKey:@"currentApplicantID"] == nil){
            [def setObject:currentApplicantID forKey:@"currentApplicantID"];
            [def synchronize];
        }
        else{
            self.currentApplicantID = [def stringForKey:@"currentApplicantID"];
        }
        
        //createNewDriver
        if([def objectForKey:@"createNewDriver"] == nil){
            [def setObject:createNewDriver forKey:@"createNewDriver"];
            [def synchronize];
        }
        else{
            self.createNewDriver = [def stringForKey:@"createNewDriver"];
        }
        
        //createNewVehicle
        if([def objectForKey:@"createNewVehicle"] == nil){
            [def setObject:createNewVehicle forKey:@"createNewVehicle"];
            [def synchronize];
        }
        else{
            self.createNewVehicle = [def stringForKey:@"createNewVehicle"];
        }
        
        //PropertyProtection
        if([def objectForKey:@"PropertyProtectionLoaded"] == nil){
            [def setObject:PropertyProtectionLoaded forKey:@"PropertyProtectionLoaded"];
            [def synchronize];
        }
        else{
            self.PropertyProtectionLoaded = [def stringForKey:@"PropertyProtectionLoaded"];
        }
        
        //UnderinsuredMotorist
        if([def objectForKey:@"UnderInsuredMotoristListLoaded"] == nil){
            [def setObject:UnderInsuredMotoristListLoaded forKey:@"UnderInsuredMotoristListLoaded"];
            [def synchronize];
        }
        else{
            self.UnderInsuredMotoristListLoaded = [def stringForKey:@"UnderInsuredMotoristListLoaded"];
        }
        
        //UninsuredMotorist
        if([def objectForKey:@"UninsuredMotoristLoaded"] == nil){
            [def setObject:UninsuredMotoristLoaded forKey:@"UninsuredMotoristLoaded"];
            [def synchronize];
        }
        else{
            self.UninsuredMotoristLoaded = [def stringForKey:@"UninsuredMotoristLoaded"];
        }
        
        //PropertyDamage
        if([def objectForKey:@"PropertyDamageLoaded"] == nil){
            [def setObject:PropertyDamageLoaded forKey:@"PropertyDamageLoaded"];
            [def synchronize];
        }
        else{
            self.PropertyDamageLoaded = [def stringForKey:@"PropertyDamageLoaded"];
        }
        
        if([def objectForKey:@"managedObjectContext"] == nil){
            [def setObject:managedObjectContext forKey:@"managedObjectContext"];
            [def synchronize];
        }
        else{
            self.managedObjectContext = [def objectForKey:@"managedObjectContext"];
        }
        
        //vehicleTypelist
        if([def objectForKey:@"VehicleTypeListLoaded"] == nil){
            [def setObject:VehicleTypeListLoaded forKey:@"VehicleTypeListLoaded"];
            [def synchronize];
        }
        else{
            self.VehicleTypeListLoaded = [def objectForKey:@"VehicleTypeListLoaded"];
        }
        
        //antiLockBrakeList
        if([def objectForKey:@"AntiLockBrakeListLoaded"] == nil){
            [def setObject:AntiLockBrakeListLoaded forKey:@"AntiLockBrakeListLoaded"];
            [def synchronize];
        }
        else{
            self.AntiLockBrakeListLoaded = [def objectForKey:@"AntiLockBrakeListLoaded"];
        }
        
        //PassiveRestraintList
        if([def objectForKey:@"PassiveRestraintListLoaded"] == nil){
            [def setObject:PassiveRestraintListLoaded forKey:@"PassiveRestraintListLoaded"];
            [def synchronize];
        }
        else{
            self.PassiveRestraintListLoaded = [def objectForKey:@"PassiveRestraintListLoaded"];
        }
        
        //DaysWeekList
        if([def objectForKey:@"DaysWeekListLoaded"] == nil){
            [def setObject:DaysWeekListLoaded forKey:@"DaysWeekListLoaded"];
            [def synchronize];
        }
        else{
            self.DaysWeekListLoaded = [def objectForKey:@"DaysWeekListLoaded"];
        }
        
        //globalservername
        if([def objectForKey:@"globalServerName"] == nil){
            globalServerName = @"http://10.200.50.62";
            [def setObject:globalServerName forKey:@"globalServerName"];
            [def synchronize];
        }
        else{
            self.globalServerName = [def stringForKey:@"globalServerName"];
        }
        
        //NavigationMode
        if([def objectForKey:@"NavigationMode"] == nil){
            [def setObject:NavigationMode forKey:@"NavigationMode"];
            [def synchronize];
        }
        else{
            self.NavigationMode = [def stringForKey:@"NavigationMode"];
        }
        
        //EmployeeStatusListLoaded
        if([def objectForKey:@"EmployeeStatusListLoaded"] == nil){
            [def setObject:EmployeeStatusListLoaded forKey:@"EmployeeStatusListLoaded"];
            [def synchronize];
        }
        else{
            self.EmployeeStatusListLoaded = [def stringForKey:@"EmployeeStatusListLoaded"];
        }
        
        //OccupationListLoaded
        if([def objectForKey:@"OccupationListLoaded"] == nil){
            [def setObject:OccupationListLoaded forKey:@"OccupationListLoaded"];
            [def synchronize];
        }
        else{
            self.OccupationListLoaded = [def stringForKey:@"OccupationListLoaded"];
        }
        
        //DropdownListLoaded
        if([def objectForKey:@"DropdownListLoaded"] == nil){
            [def setObject:DropdownListLoaded forKey:@"DropdownListLoaded"];
            [def synchronize];
        }
        else{
            self.DropdownListLoaded = [def stringForKey:@"DropdownListLoaded"];
        }
        
        //AnnualIncomeListLoaded
        if([def objectForKey:@"AnnualIncomeListLoaded"] == nil){
            [def setObject:AnnualIncomeListLoaded forKey:@"AnnualIncomeListLoaded"];
            [def synchronize];
        }
        else{
            self.AnnualIncomeListLoaded = [def stringForKey:@"AnnualIncomeListLoaded"];
        }
        
        //GoToQuoteScreen
        if([def objectForKey:@"GoToQuoteScreen"] == nil){
            [def setObject:GoToQuoteScreen forKey:@"GoToQuoteScreen"];
            [def synchronize];
        }
        else{
            self.GoToQuoteScreen = [def stringForKey:@"GoToQuoteScreen"];
        }
        
        //userJustLoggedIn
        if([def objectForKey:@"userJustLoggedIn"] == nil){
            [def setObject:userJustLoggedIn forKey:@"userJustLoggedIn"];
            [def synchronize];
        }
        else{
            self.userJustLoggedIn = [def stringForKey:@"userJustLoggedIn"];
        }
        
        //GlobalTimeout
        if([def objectForKey:@"GlobalTimeout"] == nil){            
            [def setObject:GlobalTimeout forKey:@"GlobalTimeout"];
            [def synchronize];
        }
        else{
            self.GlobalTimeout = [def stringForKey:@"GlobalTimeout"];
        }
        
        //connectionFailed
        if([def objectForKey:@"connectionFailed"] == nil){
            [def setObject:connectionFailed forKey:@"connectionFailed"];
            [def synchronize];
        }
        else{
            self.connectionFailed = [def stringForKey:@"connectionFailed"];
        }
        
        //vehicleRemoved
        if([def objectForKey:@"vehicleRemoved"] == nil){            
            [def setObject:vehicleRemoved forKey:@"vehicleRemoved"];
            [def synchronize];
        }
        else{
            self.vehicleRemoved = [def stringForKey:@"vehicleRemoved"];
        }
        
        //VIN
        if([def objectForKey:@"VIN"] == nil){            
            [def setObject:VIN forKey:@"VIN"];
            [def synchronize];
        }
        else{
            self.VIN = [def stringForKey:@"VIN"];
        }
        
        if([def objectForKey:@"policyeffectiveDate"] == nil){
            [def setObject:policyeffectiveDate forKey:@"policyeffectiveDate"];
            [def synchronize];
        }
        else{
            self.policyeffectiveDate = [def stringForKey:@"policyeffectiveDate"];
        }
        
        if([def objectForKey:@"policyexpirationDate"] == nil){
            [def setObject:policyexpirationDate forKey:@"policyexpirationDate"];
            [def synchronize];
        }
        else{
            self.policyexpirationDate = [def stringForKey:@"policyexpirationDate"];
        }
        
        if([def objectForKey:@"mainPolicyNumber"] == nil){
            [def setObject:mainPolicyNumber forKey:@"mainPolicyNumber"];
            [def synchronize];
        }
        else{
            self.mainPolicyNumber = [def stringForKey:@"mainPolicyNumber"];
        }
        
        if([def objectForKey:@"DriversInfoDoneLoading"] == nil){
            [def setObject:DriversInfoDoneLoading forKey:@"DriversInfoDoneLoading"];
            [def synchronize];
        }
        else{
            self.DriversInfoDoneLoading = [def stringForKey:@"DriversInfoDoneLoading"];
        }
        
        if([def objectForKey:@"SetUserInfoDoneLoading"] == nil){
            [def setObject:SetUserInfoDoneLoading forKey:@"SetUserInfoDoneLoading"];
            [def synchronize];
        }
        else{
            self.SetUserInfoDoneLoading = [def stringForKey:@"SetUserInfoDoneLoading"];
        }
        
        if([def objectForKey:@"userInfoUpdated"] == nil){
            [def setObject:userInfoUpdated forKey:@"userInfoUpdated"];
            [def synchronize];
        }
        else{
            self.userInfoUpdated = [def stringForKey:@"userInfoUpdated"];
        }
        
        if([def objectForKey:@"PolicyInfoDoneLoading"] == nil){
            [def setObject:PolicyInfoDoneLoading forKey:@"PolicyInfoDoneLoading"];
            [def synchronize];
        }
        else{
            self.PolicyInfoDoneLoading = [def stringForKey:@"PolicyInfoDoneLoading"];
        }
        
        if([def objectForKey:@"VehiclesDoneLoading"] == nil){
            [def setObject:VehiclesDoneLoading forKey:@"VehiclesDoneLoading"];
            [def synchronize];
        }
        else{
            self.VehiclesDoneLoading = [def stringForKey:@"VehiclesDoneLoading"];
        }
        
        if([def objectForKey:@"arrayGlobalPolicyNumbers"] == nil){            
            [def setObject:arrayGlobalPolicyNumbers forKey:@"arrayGlobalPolicyNumbers"];
            [def synchronize];
        }
        else{
            self->arrayGlobalPolicyNumbers = [def objectForKey:@"arrayGlobalPolicyNumbers"];
        }
        if([def objectForKey:@"clientNumber"] == nil){
            [def setObject:clientNumber forKey:@"clientNumber"];
            [def synchronize];
        }
        else{
            self->clientNumber = [def objectForKey:@"clientNumber"];
        }
        if([def objectForKey:@"connectionErrorMessage"] == nil){
            connectionErrorMessage = @"Problem communicating with server. Please try again later.";
            [def setObject:connectionErrorMessage forKey:@"connectionErrorMessage"];
            [def synchronize];
        }
        else{
            self.connectionErrorMessage = [def stringForKey:@"connectionErrorMessage"];
        }
        if([def objectForKey:@"connectionErrorTitle"] == nil){
            connectionErrorTitle = @"Connection Problem";
            [def setObject:connectionErrorTitle forKey:@"connectionErrorTitle"];
            [def synchronize];
        }
        else{
            self.connectionErrorTitle = [def stringForKey:@"connectionErrorTitle"];
        }
        
        if([def objectForKey:@"stateList"] == nil){
            stateList = [NSArray arrayWithObjects:@"Alabama", @"Alaska", @"Arizona", @"Arkansas", @"California",
                         @"Colorado", @"Connecticut", @"Delaware", @"Florida", @"Georgia", @"Hawaii", @"Idaho",
                         @"Illinois", @"Indiana", @"Iowa", @"Kansas", @"Kentucky", @"Louisiana", @"Maine",
                         @"Maryland", @"Massachusetts", @"Michigan", @"Minnesota", @"Mississippi", @"Missouri",
                         @"Montana", @"Nebraska", @"Nevada", @"New Hampshire", @"New Jersey", @"New Mexico",
                         @"New York", @"North Carolina", @"North Dakota", @"Ohio", @"Oklahoma", @"Oregon",
                         @"Pennsylvania", @"Rhode Island", @"South Carolina", @"South Dakota", @"Tennessee",
                         @"Texas", @"Utah", @"Vermont", @"Virginia", @"Washington", @"West Virginia", @"Wisconsin",
                         @"Wyoming", nil];
            [def setObject:stateList forKey:@"stateList"];
            [def synchronize];
        }
        else{
            self.stateList = [def objectForKey:@"stateList"];
        }
        
        
        if([def objectForKey:@"arrVehicleUsage"] == nil){
            arrVehicleUsage = [NSArray arrayWithObjects:
                               @"",
                               @"Pleasure Use Only",
                               @"Commute to Work or School",
                               @"Farm Use",
                               @"Business Use (comp only)",
                               nil];
            [def setObject:arrVehicleUsage forKey:@"arrVehicleUsage"];
            [def synchronize];
        }
        else{
            self.arrVehicleUsage = [def objectForKey:@"arrVehicleUsage"];
        }
        if([def objectForKey:@"arrVehicleUsageValue"] == nil){
            arrVehicleUsageValue = [NSArray arrayWithObjects:
                               @"",
                               @"P",
                               @"C",
                               @"F",
                               @"B",
                               nil];
            [def setObject:arrVehicleUsageValue forKey:@"arrVehicleUsageValue"];
            [def synchronize];
        }
        else{
            self.arrVehicleUsageValue = [def objectForKey:@"arrVehicleUsageValue"];
        }
        
        
        if([def objectForKey:@"arrAntiTheftDevice"] == nil){
            arrAntiTheftDevice = [NSArray arrayWithObjects:
                               @"",
                               @"Alarm or active disabling device",
                               @"No anti-theft device",
                               @"Passive disabling device",
                               @"Vehicle recovery system",
                               nil];
            [def setObject:arrAntiTheftDevice forKey:@"arrAntiTheftDevice"];
            [def synchronize];
        }
        else{
            self.arrAntiTheftDevice = [def objectForKey:@"arrAntiTheftDevice"];
        }
        if([def objectForKey:@"arrAntiTheftDeviceValue"] == nil){
            arrAntiTheftDeviceValue = [NSArray arrayWithObjects:
                               @"",
                               @"1",
                               @"N",
                               @"3",
                               @"V",
                               nil];
            [def setObject:arrAntiTheftDeviceValue forKey:@"arrAntiTheftDeviceValue"];
            [def synchronize];
        }
        else{
            self.arrAntiTheftDeviceValue = [def objectForKey:@"arrAntiTheftDeviceValue"];
        }      
        
        
        
        if([def objectForKey:@"arrBodilyInjuryLimit"] == nil){
            arrBodilyInjuryLimit = [NSArray arrayWithObjects:
                                  @"",
                                  @"100,000",
                                  @"300,000",
                                  @"500,000",
                                  nil];
            [def setObject:arrBodilyInjuryLimit forKey:@"arrBodilyInjuryLimit"];
            [def synchronize];
        }
        else{
            self.arrBodilyInjuryLimit = [def objectForKey:@"arrBodilyInjuryLimit"];
        }
        if([def objectForKey:@"arrBodilyInjuryLimitValue"] == nil){
            arrBodilyInjuryLimitValue = [NSArray arrayWithObjects:
                                    @"",
                                    @"001",
                                    @"003",
                                    @"005",
                                    nil];
            [def setObject:arrBodilyInjuryLimitValue forKey:@"arrBodilyInjuryLimitValue"];
            [def synchronize];
        }
        else{
            self.arrBodilyInjuryLimitValue = [def objectForKey:@"arrBodilyInjuryLimitValue"];
        }
    }
    return self;
}

+ (Globals *)sharedSingleton
{
    @synchronized(shared){
        if(!shared || shared == NULL)
        {
            shared = [[Globals alloc]init];
        }
        return shared;
    }
}

-(void)ShowLoadingScreen{          
    alert = [[UIAlertView alloc] initWithTitle:@"Loading...\nPlease Wait..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] ;
    [alert show];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    // Adjust the indicator so it is up a few pixels from the bottom of the alert
    indicator.center = CGPointMake(alert.bounds.size.width / 2, alert.bounds.size.height - 50);
    [indicator startAnimating];
    alert.tag = 1;
    [alert addSubview:indicator];    
}

-(void)HideLoadingScreen{    
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)ShowWaitScreen:(NSString *)customMessage{
    alert = [[UIAlertView alloc] initWithTitle:customMessage message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] ;
    [alert show];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    // Adjust the indicator so it is up a few pixels from the bottom of the alert
    indicator.center = CGPointMake(alert.bounds.size.width / 2, alert.bounds.size.height - 50);
    [indicator startAnimating];
    alert.tag = 1;
    [alert addSubview:indicator];
}

-(void)HideWaitScreen{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

-(NSString *)GetAnnualIncomeText:(NSString *)incomeCode{
//    Globals *tmp = [Globals sharedSingleton];
//    NSString *incomeText = @"";
//    NSFetchRequest *_fetchReq = [[NSFetchRequest alloc] init];
//    _fetchReq.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@",@"level ==", incomeCode]];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AnnualIncome" inManagedObjectContext:tmp.managedObjectContext];
//    [_fetchReq setEntity:entity];
//    NSArray *list = [tmp.managedObjectContext executeFetchRequest:_fetchReq error:nil];
//    for(int i = 0; i < [list count] ; i++){
//        AnnualIncome *_annualIncome = (AnnualIncome*)[list objectAtIndex:i];
//        incomeText = _annualIncome.incomeText;
//    }
//    return incomeText;
    return @"";
}

-(void)LoadCoreData{
    DropDownDataList *dropdownList = [[DropDownDataList alloc] init];
    [dropdownList LoadDropDownDataList];    
}

-(void)LoadPolicyDataForUser:(NSString *)username{
    VehiclesOnPolicy *vehicleList = [[VehiclesOnPolicy alloc] init];
    [vehicleList LoadVehiclesOnPolicyList:username];
    
    SetUserInfo *userInfo = [[SetUserInfo alloc] init];
    [userInfo SetUserInfo:username];
    
    DriversOnPolicy *driverList = [[DriversOnPolicy alloc] init];
    [driverList LoadDriversOnPolicyList:username];
    
    PolicyInfoList *policyList = [[PolicyInfoList alloc] init];
    [policyList SetPolicyInfo:username];
    
}

-(NSMutableArray *)SetTabBarImages:(NSString *) quoteGuid{
    Globals *tmp = [Globals sharedSingleton];
    self.managedObjectContext = tmp.managedObjectContext;
    NSMutableArray *tabArray = [[NSMutableArray alloc] init];
    NSFetchRequest *_fetchReqE = [[NSFetchRequest alloc] init];
    
    _fetchReqE.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"quoteID =='", quoteGuid, @"'", nil]];
    NSEntityDescription *entityE = [NSEntityDescription entityForName:@"Quotes" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqE setEntity:entityE];
    
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:_fetchReqE error:nil];
    
    for (NSManagedObject *info in fetchedObjects)
    {
        Quotes *app = (Quotes *)info;
        
        NSInteger qa = app.quoteApplicant != nil ? app.quoteApplicant.count : 0;
        NSNumber *qc = app.quoteCoverages.completed;
        NSInteger qv = app.quoteVehicle != nil ? app.quoteVehicle.count : 0;
        NSInteger qd = app.quoteDriver != nil ? app.quoteDriver.count : 0;
        
    
        if(qa > 0){
            [tabArray addObject: [ NSNumber numberWithInteger: 1]];
        }
        else{
            [tabArray addObject: [ NSNumber numberWithInteger: 0]];
        }
        
        
        
        if(qd > 0){
            [tabArray addObject: [ NSNumber numberWithInteger: 1]];
        }
        else{
            [tabArray addObject: [ NSNumber numberWithInteger: 0]];
        }
        
        
    
        if(qv > 0){
            [tabArray addObject: [ NSNumber numberWithInteger: 1]];
        }
        else{
            [tabArray addObject: [ NSNumber numberWithInteger: 0]];
        }
        
        
        if(qc != nil){
            if([qc isEqualToNumber:[NSNumber numberWithInt:1]]){
                [tabArray addObject: [ NSNumber numberWithInteger: 1]];
            }
            else{
                [tabArray addObject: [ NSNumber numberWithInteger: 0]];
            }
        }
        else{
            [tabArray addObject: [ NSNumber numberWithInteger: 0]];
        }
        
    }
    
    if([tabArray count] == 0){
        [tabArray addObject: [ NSNumber numberWithInteger: 0]];
        [tabArray addObject: [ NSNumber numberWithInteger: 0]];
        [tabArray addObject: [ NSNumber numberWithInteger: 0]];
        [tabArray addObject: [ NSNumber numberWithInteger: 0]];
    }
    
    return tabArray;
}

- (NSString *)GetUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}

- (BOOL) IsValidDriverBirthDate:(NSDate*) endDate
{
    //dates needed to be reset to represent only yyyy-mm-dd to get correct number of days between two days.
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//	int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
//    NSDateComponents *comps = [gregorian components:unitFlags fromDate:endDate toDate:[NSDate date] options:0];
//    int days = [comps day];
//    int years = [comps year];
//    return years;
    // Manage Date Formation same for both dates
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    NSDate *startDate = [NSDate date];
    //NSDate *endDate = [formatter dateFromString:endDate];
    
    
    unsigned flags = NSDayCalendarUnit;
    NSDateComponents *difference = [[NSCalendar currentCalendar] components:flags fromDate:startDate toDate:endDate options:0];
    
    long dayDiff = [difference day] * -1;
    
    if(dayDiff > 5844 && dayDiff > 0){
        return YES;
    }
    else{
        return NO;
    }
}

- (NSString *)filteredStringFromStringWithFilter:(NSString*) string filterText:(NSString *)filter
{
    NSUInteger onOriginal = 0, onFilter = 0, onOutput = 0;
    char outputString[([filter length])];
    BOOL done = NO;
    
    while(onFilter < [filter length] && !done)
    {
        char filterChar = [filter characterAtIndex:onFilter];
        char originalChar = onOriginal >= string.length ? '\0' : [string characterAtIndex:onOriginal];
        switch (filterChar) {
            case '#':
                if(originalChar=='\0')
                {
                    // We have no more input numbers for the filter.  We're done.
                    done = YES;
                    break;
                }
                if(isdigit(originalChar))
                {
                    outputString[onOutput] = originalChar;
                    onOriginal++;
                    onFilter++;
                    onOutput++;
                }
                else
                {
                    onOriginal++;
                }
                break;
            default:
                // Any other character will automatically be inserted for the user as they type (spaces, - etc..) or deleted as they delete if there are more numbers to come.
                outputString[onOutput] = filterChar;
                onOutput++;
                onFilter++;
                if(originalChar == filterChar)
                    onOriginal++;
                break;
        }
    }
    outputString[onOutput] = '\0'; // Cap the output string
    return [NSString stringWithUTF8String:outputString];
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}


- (BOOL)QuoteReadyForReview:(NSString *)quoteGuid {
    Globals *tmp = [Globals sharedSingleton];
    self.managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *_fetchReqE = [[NSFetchRequest alloc] init];
    _fetchReqE.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"quoteID =='", quoteGuid, @"'", nil]];
    NSEntityDescription *entityE = [NSEntityDescription entityForName:@"Quotes" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqE setEntity:entityE];
    
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:_fetchReqE error:nil];
    
    NSManagedObject *info;
    
    for (NSManagedObject *_info in fetchedObjects)
    {
        info = _info;
    }
        Quotes *app = (Quotes *)info;
        
        NSInteger qa = app.quoteApplicant.count;
        NSNumber *qc = app.quoteCoverages != nil ? app.quoteCoverages.completed : 0;
        NSInteger qv = app.quoteVehicle != nil ? app.quoteVehicle.count : 0;
        NSInteger qd = app.quoteDriver.count;
        
    
        if(qa > 0 && qv > 0 && qd > 0 && qc > 0){
            return YES;
        }
        else{
            return NO;
        }
    
}

-(void)BroadCastErrorMessage:(NSString *)errorMessage{
    
}

-(void)SetTabBarImagesForTabBarController:(UITabBarController *)tabBarController{
    Globals *tmp = [Globals sharedSingleton];
    NSMutableArray *tempArray = [tmp SetTabBarImages:tmp.currentQuoteGuid];
    
    NSInteger qa = [tempArray[0] integerValue];
    NSInteger qd = [tempArray[1] integerValue];
    NSInteger qv = [tempArray[2] integerValue];
    NSInteger qc = [tempArray[3] integerValue];
    
    NSArray *viewControllers = [[NSArray alloc] init];
    viewControllers = tabBarController.viewControllers;
    //review tab
    ((UIViewController*)viewControllers[4]).tabBarItem.image = [UIImage imageNamed:@"car-side.png"];
    
    
    if((int)qa == 1){
        ((UIViewController*)viewControllers[0]).tabBarItem.image = [UIImage imageNamed:@"tick.png"];
        [[[[tabBarController tabBar]items]objectAtIndex:1]setEnabled:TRUE];
        [[[[tabBarController tabBar]items]objectAtIndex:2]setEnabled:TRUE];
        [[[[tabBarController tabBar]items]objectAtIndex:3]setEnabled:TRUE];
    }
    else{
        ((UIViewController*)viewControllers[0]).tabBarItem.image = [UIImage imageNamed:@"question.png"];
        [[[[tabBarController tabBar]items]objectAtIndex:1]setEnabled:FALSE];
        [[[[tabBarController tabBar]items]objectAtIndex:2]setEnabled:FALSE];
        [[[[tabBarController tabBar]items]objectAtIndex:3]setEnabled:FALSE];
    }
    
    if((int)qd == 1){
        ((UIViewController*)viewControllers[1]).tabBarItem.image = [UIImage imageNamed:@"tick.png"];
        [[[[tabBarController tabBar]items]objectAtIndex:4]setEnabled:TRUE];
    }
    else{
        ((UIViewController*)viewControllers[1]).tabBarItem.image = [UIImage imageNamed:@"question.png"];
        [[[[tabBarController tabBar]items]objectAtIndex:4]setEnabled:FALSE];
    }
    
    if((int)qv == 1){
        ((UIViewController*)viewControllers[2]).tabBarItem.image = [UIImage imageNamed:@"tick.png"];
        [[[[tabBarController tabBar]items]objectAtIndex:4]setEnabled:TRUE];
    }
    else{
        ((UIViewController*)viewControllers[2]).tabBarItem.image = [UIImage imageNamed:@"question.png"];
        [[[[tabBarController tabBar]items]objectAtIndex:4]setEnabled:FALSE];
    }
    
    if((int)qc == 1){
        ((UIViewController*)viewControllers[3]).tabBarItem.image = [UIImage imageNamed:@"tick.png"];
    }
    else{
        ((UIViewController*)viewControllers[3]).tabBarItem.image = [UIImage imageNamed:@"question.png"];
    }
    
}


@end
