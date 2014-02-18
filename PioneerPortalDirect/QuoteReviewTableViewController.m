//
//  QuoteReviewTableViewController.m
//  PortalDirect
//
//  Created by Brian Kalski on 12/31/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import "QuoteReviewTableViewController.h"
#import "QuoteReviewTableViewCell.h"
#import "QuoteListTableViewCell.h"
#import "Quotes.h"
#import "QuoteApplicant.h"
#import "QuoteDriver.h"
#import "QuoteVehicle.h"
#import "QuoteCoverages.h"
#import "Globals.h"
#import "InsertVehicleIntoQuote.h"
#import "InsertDriverIntoQuote.h"
#import "GetQuoteRate.h"
#import "QuoteListTableViewController.h"

@interface QuoteReviewTableViewController ()

@end

@implementation QuoteReviewTableViewController
@synthesize txtAnnualPremium,QuoteReviewTableView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arrDrivers = [[NSMutableArray alloc] init];
    arrVehicles = [[NSMutableArray alloc] init];
    
    [self LoadQuoteDetails];
    [QuoteReviewTableView reloadData];

    self.title = @"Auto Quote - Rate/Review";
    [self.navigationController setNavigationBarHidden:NO];
    
    self.title = @"Auto Quote - Rate/Review";
    CGRect frame = CGRectMake(0, 0, [self.title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}].width, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:17.0];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    label.text = self.title;
    
    [self SubmitQuoteForRate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)SubmitQuoteForRate{
    Globals *tmp = [Globals sharedSingleton];
    self.managedObjectContext = tmp.managedObjectContext;
    
    [tmp ShowWaitScreen:@"Getting quote. Please wait."];
    
    NSFetchRequest *_fetchReq = [[NSFetchRequest alloc] init];
    _fetchReq.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"quoteID =='", tmp.currentQuoteGuid, @"'", nil]];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Quotes" inManagedObjectContext:self.managedObjectContext];
    [_fetchReq setEntity:entity];
    
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:_fetchReq error:nil];
    
//    NSString *path = [[NSBundle mainBundle] bundlePath];
//    NSString *xmlQuotePath = [path stringByAppendingPathComponent:@"QuoteXML.xml"];
//    NSString *xmlQuoteString = [NSString stringWithContentsOfFile:xmlQuotePath encoding:NSUTF8StringEncoding error:nil];
    
    //int iDriverNum = 1;
    
    for (NSManagedObject *info in fetchedObjects)
    {
        Quotes *quote = (Quotes *)info;
        
        QuoteCoverages *cov = quote.quoteCoverages;
        NSString *bodilyInjuryValue = cov.bodilyInjuryValue;
        NSString *medicalProviderValue = cov.medicalProviderValue;
        NSString *miniTortValue = cov.miniTortValue;
        NSString *personalInjuryProtectionValue = cov.personalInjuryProtectionValue;
        NSString *propertyDamage = cov.propertyDamageValue;
        NSString *propertyProtection = cov.propertyProtectionValue;
        NSString *uninsuredValue = cov.uninsuredMotoristValue;
        NSString *underinsuredValue = cov.underinsuredMotoristValue;
        
        NSInteger driverCount = quote.quoteDriver.count;
        NSInteger vehicleCount = quote.quoteVehicle.count;
        tmp.numberQuoteDrivers = driverCount;
        tmp.numberQuoteVehicles = vehicleCount;
        tmp.QuoteDriversAddedToQuote = @"NO";
        tmp.QuoteVehiclesAddedToQuote = @"YES";
        
        int driverNum = 0;
        
        for(QuoteDriver *Driver in quote.quoteDriver)
        {
            //1986-04-24T00:00:00-04:00
            NSString *str = Driver.dateBirth;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
            [dateFormatter setDateFormat:@"MM/dd/yyyy"]; //// here set format of date which is in your output date (means above str with format)
            
            NSDate *date = [dateFormatter dateFromString: str]; // here you can fetch date from string with define format
            
            dateFormatter = [[NSDateFormatter alloc] init];
            //[dateFormatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss'-5:00'"];
            [dateFormatter setDateFormat:@"MM-dd-yyyy"];
            
            NSString *dateBirth = [dateFormatter stringFromDate:date];
            NSString *_driverNum = [NSString stringWithFormat:@"%d", driverNum];
            
            InsertDriverIntoQuote *insertDriver = [[InsertDriverIntoQuote alloc] init];
            [insertDriver InsertDriverIntoQuote:tmp.currentQuoteGuid firstName:Driver.firstName middle:Driver.middleInitial lastName:Driver.lastName dateBirth:dateBirth gender:Driver.gender maritalStatus:Driver.maritalStatus relationApplicant:Driver.relationApplicantValue dependents:Driver.dependents licenseState:Driver.licenseStateValue licenseNum:Driver.licenseNum occupation:Driver.occupationValue incomeLevel:Driver.incomeLevelValue driverNum:_driverNum];
            
            driverNum++;
//            NSString *pathDriver = [[NSBundle mainBundle] bundlePath];
//            NSString *xmlDriverPath = [pathDriver stringByAppendingPathComponent:@"QuoteDriver.xml"];
//            NSString *xmlDriverString = [NSString stringWithContentsOfFile:xmlDriverPath encoding:NSUTF8StringEncoding error:nil];
//            
//            xmlDriverString = [xmlDriverString stringByReplacingOccurrencesOfString:@"<DEPENDENTS></DEPENDENTS>" withString:[NSString stringWithFormat:@"%@%@%@",@"<DEPENDENTS>", _driver.dependents, @"</DEPENDENTS>"]];
//            xmlDriverString = [xmlDriverString stringByReplacingOccurrencesOfString:@"<MARITAL_STATUS></MARITAL_STATUS>" withString:[NSString stringWithFormat:@"%@%@%@",@"<MARITAL_STATUS>", _driver.maritalStatus, @"</MARITAL_STATUS>"]];
//            xmlDriverString = [xmlDriverString stringByReplacingOccurrencesOfString:@"<OCCUPATION_CODE></OCCUPATION_CODE>" withString:[NSString stringWithFormat:@"%@%@%@",@"<OCCUPATION_CODE>", _driver.occupation, @"</OCCUPATION_CODE>"]];
//            
//            xmlQuoteString = [xmlQuoteString stringByReplacingOccurrencesOfString:@"<DRIVER_PLACEHOLDER/>" withString:[NSString stringWithFormat:@"%@%@", xmlDriverString, @"<DRIVER_PLACEHOLDER/>"]];
            
        }
        
        
        for(QuoteVehicle *_vehicle in quote.quoteVehicle)
        {
            NSString *multiCarValue = @"";
            if(quote.quoteVehicle.count > 1){
                multiCarValue = @"Y";
            }
            else{
                multiCarValue = @"N";
            }
            
            NSString *vinValue = _vehicle.vin;
            if([vinValue isEqualToString:@""] || vinValue == nil){
                vinValue = @"0";
            }
//
//            //InsertVehicleIntoQuote *insertVehicle = [[InsertVehicleIntoQuote alloc] init];
//            //[insertVehicle InsertVehicleIntoQuote:vinValue guid:tmp.currentQuoteGuid year:_vehicle.year make:_vehicle.makeValue model:_vehicle.model bodilyInjury:bodilyInjuryValue medicalProv:medicalProviderValue miniTort:miniTortValue personalInjuryProtection:personalInjuryProtectionValue propertyDamage:propertyDamage propertyProtection:propertyProtection uninsuredValue:uninsuredValue underinsuredValue:underinsuredValue];
//            NSString *path = [[NSBundle mainBundle] bundlePath];
//            NSString *xmlPath = [path stringByAppendingPathComponent:@"QuoteVehicle.xml"];
//            NSString *xmlVehicleString = [NSString stringWithContentsOfFile:xmlPath encoding:NSUTF8StringEncoding error:nil];
//            
//            xmlVehicleString = [xmlVehicleString stringByReplacingOccurrencesOfString:@"<VIN></VIN>" withString:[NSString stringWithFormat:@"%@%@%@",@"<VIN>", vinValue, @"</VIN>"]];
//            xmlVehicleString = [xmlVehicleString stringByReplacingOccurrencesOfString:@"<VEH_YEAR></VEH_YEAR>" withString:[NSString stringWithFormat:@"%@%@%@",@"<VEH_YEAR>", _vehicle.year, @"</VEH_YEAR>"]];
//            xmlVehicleString = [xmlVehicleString stringByReplacingOccurrencesOfString:@"<VEH_USE></VEH_USE>" withString:[NSString stringWithFormat:@"%@%@%@",@"<VEH_USE>", _vehicle.vehicleUsageValue, @"</VEH_USE>"]];
//            xmlVehicleString = [xmlVehicleString stringByReplacingOccurrencesOfString:@"<VEH_TYPE></VEH_TYPE>" withString:[NSString stringWithFormat:@"%@%@%@",@"<VEH_TYPE>", _vehicle.vehicleTypeCode, @"</VEH_TYPE>"]];
//            xmlVehicleString = [xmlVehicleString stringByReplacingOccurrencesOfString:@"<VEH_MODELS></VEH_MODELS>" withString:[NSString stringWithFormat:@"%@%@%@",@"<VEH_MODELS>", _vehicle.model, @"</VEH_MODELS>"]];
//            xmlVehicleString = [xmlVehicleString stringByReplacingOccurrencesOfString:@"<VEH_MAKE></VEH_MAKE>" withString:[NSString stringWithFormat:@"%@%@%@%@%@",@"<VEH_MAKE valueDescription=\"",_vehicle.make  ,@"\">", _vehicle.makeValue, @"</VEH_MAKE>"]];
//            xmlVehicleString = [xmlVehicleString stringByReplacingOccurrencesOfString:@"<MULTI_CAR_DISCOUNT></MULTI_CAR_DISCOUNT>" withString:[NSString stringWithFormat:@"%@%@%@",@"<MULTI_CAR_DISCOUNT>", multiCarValue, @"</MULTI_CAR_DISCOUNT>"]];
//            
//            xmlQuoteString = [xmlQuoteString stringByReplacingOccurrencesOfString:@"<VEHICLE_PLACEHOLDER/>" withString:[NSString stringWithFormat:@"%@%@", xmlVehicleString, @"<VEHICLE_PLACEHOLDER/>"]];
            
            InsertVehicleIntoQuote *insertVehicle = [[InsertVehicleIntoQuote alloc] init];
            [insertVehicle InsertVehicleIntoQuote:vinValue guid:tmp.currentQuoteGuid year:_vehicle.year make:_vehicle.makeValue model:_vehicle.model bodilyInjury:bodilyInjuryValue medicalProv:medicalProviderValue miniTort:miniTortValue personalInjuryProtection:personalInjuryProtectionValue propertyDamage:propertyDamage propertyProtection:propertyProtection uninsuredValue:uninsuredValue underinsuredValue:underinsuredValue vehicleType:_vehicle.vehicleTypeCode vehicleUse:_vehicle.vehicleUsageValue carpool:_vehicle.carpool antiLock:_vehicle.antiLockBrakesValue passiveRestraint:_vehicle.passiveRestraintsValue antiTheft:_vehicle.antiTheftDeviceValue annualMiles:_vehicle.annualMileage milesOneWay:_vehicle.milesToWork daysWeek:_vehicle.workWeekValue multiCar:multiCarValue];
            
            
        }
        
//        xmlQuoteString = [xmlQuoteString stringByReplacingOccurrencesOfString:@"<DRIVER_PLACEHOLDER/>" withString:@""];
//        xmlQuoteString = [xmlQuoteString stringByReplacingOccurrencesOfString:@"<VEHICLE_PLACEHOLDER/>" withString:@""];
//        xmlQuoteString = [xmlQuoteString stringByReplacingOccurrencesOfString:@"/" withString:@"\\/"];

        
    }
    
    [self GetRate:tmp.currentQuoteGuid];

}



- (void)GetRate:(NSString *)guid{
    Globals *tmp = [Globals sharedSingleton];
    tmp.annualPremium = @"";
    
    timerStartGetRate = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(CheckIfVehiclesDriversAreAdded:) userInfo:guid repeats:YES];
}

-(void)CheckIfVehiclesDriversAreAdded:(NSTimer*)theTimer{
    NSString *guid = (NSString*)[theTimer userInfo];
    Globals *tmp = [Globals sharedSingleton];
    if([tmp.QuoteVehiclesAddedToQuote isEqualToString:@"YES"] && [tmp.QuoteDriversAddedToQuote isEqualToString:@"YES"]){
        [timerStartGetRate invalidate];
        timerStartGetRate = nil;
        GetQuoteRate *getQuote = [[GetQuoteRate alloc] init];
        [getQuote RateQuote:guid];
        timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(CheckIfRateHasArrived) userInfo:nil repeats:YES];
    }
    
    if([tmp.QuoteVehiclesAddedToQuote isEqualToString:@"FAILED"] || [tmp.QuoteDriversAddedToQuote isEqualToString:@"FAILED"] || [tmp.quoteConnectionFailed isEqualToString:@"YES"])
    {
        [tmp HideWaitScreen];
        [timerStartGetRate invalidate];
        timerStartGetRate = nil;
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Error Getting Quote Rate"
                                                       message: @"Error getting rate. Please try again later."
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        alert.tag = 7;
        [alert show];
        
    }

}


-(void)CheckIfRateHasArrived{
    Globals *tmp = [Globals sharedSingleton];

    if(![tmp.annualPremium isEqualToString:@""])
    {
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber * _annualPremium = [f numberFromString:tmp.annualPremium];
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        NSString *groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
        [formatter setGroupingSeparator:groupingSeparator];
        [formatter setGroupingSize:3];
        [formatter setAlwaysShowsDecimalSeparator:NO];
        [formatter setUsesGroupingSeparator:YES];
        
        NSString *formattedString = [formatter stringFromNumber:_annualPremium];
                                     
        annualPremium = formattedString;
        [timer invalidate];
        timer = nil;
        tmp.annualPremium = @"";
        tmp.QuoteVehiclesAddedToQuote = @"";
        tmp.QuoteDriversAddedToQuote = @"";
        tmp.numQuoteDriversLoaded = 0;
        tmp.numQuoteVehiclesLoaded = 0;
        tmp.numberQuoteDrivers = 0;
        tmp.numberQuoteVehicles = 0;
        [tmp HideWaitScreen];
        [QuoteReviewTableView reloadData];
        [self UpdateQuoteStatus];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        if(alertView.tag == 7){
            UIStoryboard *storyboard = self.storyboard;
            QuoteListTableViewController *quoteList = [storyboard instantiateViewControllerWithIdentifier:@"QuoteListTableViewController"];
            [self.navigationController pushViewController:quoteList animated:YES];
        }
    }
    if(buttonIndex == 1){
        
    }
    
}

-(void)UpdateQuoteStatus{
    Globals *tmp = [Globals sharedSingleton];
    NSFetchRequest *_fetchReqD = [[NSFetchRequest alloc] init];
    _fetchReqD.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"quoteID == '", tmp.currentQuoteGuid, @"'", nil]];
    NSEntityDescription *entityD = [NSEntityDescription entityForName:@"Quotes" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqD setEntity:entityD];
    
    NSArray *fetchedObjectsD = [self.managedObjectContext executeFetchRequest:_fetchReqD error:nil];
    
    if(fetchedObjectsD.count > 0){
        for (NSManagedObject *info in fetchedObjectsD)
        {
            Quotes *quote = (Quotes *)info;
            quote.quoteStatus = annualPremium;
        }
        [self.managedObjectContext save:nil];
    }

}

-(void)LoadQuoteDetails{
    Globals *tmp = [Globals sharedSingleton];
    self.managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *_fetchReqD = [[NSFetchRequest alloc] init];
    _fetchReqD.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"quoteID =='", tmp.currentQuoteGuid, @"'", nil]];
    NSEntityDescription *entityD = [NSEntityDescription entityForName:@"Quotes" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqD setEntity:entityD];
    
    NSArray *fetchedObjectsD = [self.managedObjectContext executeFetchRequest:_fetchReqD error:nil];
    
    //    NSString *path = [[NSBundle mainBundle] bundlePath];
    //    NSString *xmlQuotePath = [path stringByAppendingPathComponent:@"QuoteXML.xml"];
    //    NSString *xmlQuoteString = [NSString stringWithContentsOfFile:xmlQuotePath encoding:NSUTF8StringEncoding error:nil];
    
    //int iDriverNum = 1;
    
    for (NSManagedObject *info in fetchedObjectsD)
    {
        Quotes *quote = (Quotes *)info;
        
        for(QuoteDriver *Driver in quote.quoteDriver)
        {
            [arrDrivers addObject:[NSString stringWithFormat:@"%@%@%@", Driver.firstName, @" ", Driver.lastName]];
        }
        
        for(QuoteVehicle *_vehicle in quote.quoteVehicle)
        {
            [arrVehicles addObject:[NSString stringWithFormat:@"%@%@%@%@%@", _vehicle.year, @" ", _vehicle.make, @" ", _vehicle.model]];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section == 0){
        return 1;
    }
    else if(section == 1){
        return [arrVehicles count];
    }
    else if(section == 2){
        return [arrDrivers count];
    }
    else{
        return 0;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(indexPath.section == 0 ){
        [[cell textLabel] setText:annualPremium];
    }else if(indexPath.section == 1){
        [[cell textLabel] setText:[arrVehicles objectAtIndex:indexPath.row]];
    }else if(indexPath.section == 2){
        [[cell textLabel] setText:[arrDrivers objectAtIndex:indexPath.row]];
    }else{
        [[cell textLabel] setText:@""];
    }
    
    return cell;
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return @"Annual Premium";
    }
    else if(section == 1){
        return @"Quoted Vehicles";
    }
    else if(section == 2){
        return @"Quoted Drivers";
    }
    else{
        return @"";
    }
}



@end
