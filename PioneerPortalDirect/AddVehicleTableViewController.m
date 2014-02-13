//
//  AddVehicleTableViewController.m
//  PortalDirect
//
//  Created by Brian Kalski on 2/26/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import "AddVehicleTableViewController.h"
#import "Globals.h"
#import "VehiclesOnPolicy.h"

@interface AddVehicleTableViewController ()

@end

@implementation AddVehicleTableViewController

@synthesize txtAntiTheftDevice,txtBodilyInjuryLimit,txtMake,txtModel,txtVehicleUsage,txtVIN,txtYear,txtZipCode;
@synthesize vehicleUsagePicker,antiTheftPicker,bodilyInjuryPicker,vehicleYearPicker,btnLookupVIN,activityIndicator;
@synthesize responseData,timer;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    txtVIN.delegate = (id)self;
    txtZipCode.delegate = (id)self;
    txtYear.delegate = (id)self;
    txtMake.delegate = (id)self;
    txtModel.delegate = (id)self;
    
    
    
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *sCurrentYear = [dateFormatter stringFromDate:now];
    int currentYear = [sCurrentYear intValue];
    arrVehicleYears = [[NSMutableArray alloc] init];
    [arrVehicleYears addObject:@""];
    for(int i = currentYear + 1; i > currentYear - 100; i = i - 1){
        NSNumber *intYear = [NSNumber numberWithInteger:i];
        NSString *sYear = [intYear stringValue];
        [arrVehicleYears addObject:sYear];
    }

    //Vehicle Usage
    UIToolbar *DoneButtonViewVehicleUsage = [[UIToolbar alloc] init];
    DoneButtonViewVehicleUsage.barStyle = UIBarStyleBlack;
    DoneButtonViewVehicleUsage.translucent = YES;
    DoneButtonViewVehicleUsage.tintColor = nil;
    [DoneButtonViewVehicleUsage sizeToFit];
    UIBarButtonItem *doneButtonVehicleUsage = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(VehicleUsageDone:)];
    [DoneButtonViewVehicleUsage setItems:[NSArray arrayWithObjects:doneButtonVehicleUsage, nil]];
    
    UIPickerView *vehicleUsagePickerTemp = [[UIPickerView alloc] initWithFrame:CGRectZero];
    vehicleUsagePicker = vehicleUsagePickerTemp;
    vehicleUsagePicker.dataSource = self;
    vehicleUsagePicker.delegate = self;
    vehicleUsagePicker.showsSelectionIndicator = YES;
    vehicleUsagePicker.tag = 1;
    txtVehicleUsage.inputView = vehicleUsagePicker;
    txtVehicleUsage.inputAccessoryView = DoneButtonViewVehicleUsage;
    
    //Anti-theft Device
    UIToolbar *DoneButtonViewAntiTheft = [[UIToolbar alloc] init];
    DoneButtonViewAntiTheft.barStyle = UIBarStyleBlack;
    DoneButtonViewAntiTheft.translucent = YES;
    DoneButtonViewAntiTheft.tintColor = nil;
    [DoneButtonViewAntiTheft sizeToFit];
    UIBarButtonItem *doneButtonAntiTheft = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(AntiTheftDone:)];
    [DoneButtonViewAntiTheft setItems:[NSArray arrayWithObjects:doneButtonAntiTheft, nil]];
    
    UIPickerView *antiTheftPickerTemp = [[UIPickerView alloc] initWithFrame:CGRectZero];
    antiTheftPicker = antiTheftPickerTemp;
    antiTheftPicker.dataSource = self;
    antiTheftPicker.delegate = self;
    antiTheftPicker.showsSelectionIndicator = YES;
    antiTheftPicker.tag = 2;
    txtAntiTheftDevice.inputView = antiTheftPicker;
    txtAntiTheftDevice.inputAccessoryView = DoneButtonViewAntiTheft;
    
    //Bodily Injury
    UIToolbar *DoneButtonViewBodilyInjury = [[UIToolbar alloc] init];
    DoneButtonViewBodilyInjury.barStyle = UIBarStyleBlack;
    DoneButtonViewBodilyInjury.translucent = YES;
    DoneButtonViewBodilyInjury.tintColor = nil;
    [DoneButtonViewBodilyInjury sizeToFit];
    UIBarButtonItem *doneButtonBodilyInjury = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(BodilyInjuryDone:)];
    [DoneButtonViewBodilyInjury setItems:[NSArray arrayWithObjects:doneButtonBodilyInjury, nil]];
    
    UIPickerView *bodilyInjuryPickerTemp = [[UIPickerView alloc] initWithFrame:CGRectZero];
    antiTheftPicker = bodilyInjuryPickerTemp;
    antiTheftPicker.dataSource = self;
    antiTheftPicker.delegate = self;
    antiTheftPicker.showsSelectionIndicator = YES;
    antiTheftPicker.tag = 3;
    txtBodilyInjuryLimit.inputView = antiTheftPicker;
    txtBodilyInjuryLimit.inputAccessoryView = DoneButtonViewBodilyInjury;
    
    //Vehicle Year
    UIToolbar *DoneButtonViewVehicleYear = [[UIToolbar alloc] init];
    DoneButtonViewVehicleYear.barStyle = UIBarStyleBlack;
    DoneButtonViewVehicleYear.translucent = YES;
    DoneButtonViewVehicleYear.tintColor = nil;
    [DoneButtonViewVehicleYear sizeToFit];
    UIBarButtonItem *doneButtonVehicleYear = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(VehicleYearDone:)];
    [DoneButtonViewVehicleYear setItems:[NSArray arrayWithObjects:doneButtonVehicleYear, nil]];
    
    UIPickerView *vehicleYearPickerTemp = [[UIPickerView alloc] initWithFrame:CGRectZero];
    vehicleYearPicker = vehicleYearPickerTemp;
    vehicleYearPicker.dataSource = self;
    vehicleYearPicker.delegate = self;
    vehicleYearPicker.showsSelectionIndicator = YES;
    vehicleYearPicker.tag = 4;
    txtYear.inputView = vehicleYearPicker;
    txtYear.inputAccessoryView = DoneButtonViewVehicleYear;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    Globals *tmp = [Globals sharedSingleton];
    if(pickerView.tag == 1){
        return tmp.arrVehicleUsage.count;
    }
    if(pickerView.tag == 2){
        return tmp.arrAntiTheftDevice.count;
    }
    if(pickerView.tag == 3){
        return tmp.arrBodilyInjuryLimit.count;
    }
    if(pickerView.tag == 4){
        return [arrVehicleYears count];
    }
    else{
        return 0;
    }
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    Globals *tmp = [Globals sharedSingleton];
    if(pickerView.tag == 1){
        return [tmp.arrVehicleUsage objectAtIndex:row];
    }
    if(pickerView.tag == 2){
        return [tmp.arrAntiTheftDevice objectAtIndex:row];
    }
    if(pickerView.tag == 3){
        return [tmp.arrBodilyInjuryLimit objectAtIndex:row];
    }
    if(pickerView.tag == 4){
        return [arrVehicleYears objectAtIndex:row];
    }
    else{
        return @"";
    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    Globals *tmp = [Globals sharedSingleton];
    if(pickerView.tag == 1){
        txtVehicleUsage.text = [tmp.arrVehicleUsage objectAtIndex:row];
        vehicleUsageValue = [tmp.arrVehicleUsageValue objectAtIndex:row];
    }
    if(pickerView.tag == 2){
        txtAntiTheftDevice.text = [tmp.arrAntiTheftDevice objectAtIndex:row];
        antiTheftValue = [tmp.arrAntiTheftDeviceValue objectAtIndex:row];
    }
    if(pickerView.tag == 3){
        txtBodilyInjuryLimit.text = [tmp.arrBodilyInjuryLimit objectAtIndex:row];
        bodilyInjuryValue = [tmp.arrBodilyInjuryLimitValue objectAtIndex:row];
    }
    if(pickerView.tag == 4){
        txtYear.text = [arrVehicleYears objectAtIndex:row];
    }

}

-(void)VehicleUsageDone:(id)sender{
    [txtVehicleUsage resignFirstResponder];
}

-(void)AntiTheftDone:(id)sender{
    [txtAntiTheftDevice resignFirstResponder];
}

-(void)BodilyInjuryDone:(id)sender{
    [txtBodilyInjuryLimit resignFirstResponder];
}
-(void)VehicleYearDone:(id)sender{
    [txtYear resignFirstResponder];
}

- (IBAction)LookupVin:(id)sender {
    if([txtVIN.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Invalid VIN"
                                                       message: @"VIN is invalid. Please check and enter again"
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
    else{
        [activityIndicator startAnimating];
        Globals *tmp = [Globals sharedSingleton];
        NSString *postString = [NSString stringWithFormat:@"%@%@%@",tmp.globalServerName, @"/users.svc/checkvin/", txtVIN.text];
        
        NSURL *url = [NSURL URLWithString:postString];
        double timeOut = [tmp.GlobalTimeout doubleValue];
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOut];

        conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
        if (conn) {
            webData = [NSMutableData data];
        }
    }
}

-(void) connectionDidFinishLoading:(NSURLConnection *) connection {
    //NSLog(@"DONE. Received Bytes: %d", [webData length]);
    
    
    [activityIndicator stopAnimating];
    
    xmlParser = [[NSXMLParser alloc] initWithData: webData];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities:YES];
    [xmlParser parse];
}

//---when the start of an element is found---
-(void) parser:(NSXMLParser *) parser
didStartElement:(NSString *) elementName
  namespaceURI:(NSString *) namespaceURI
 qualifiedName:(NSString *) qName
    attributes:(NSDictionary *) attributeDict {
    
    if( [elementName isEqualToString:@"a:returnCode"])
    {
        if (!soapResults)
        {
            soapResults = [[NSMutableString alloc] init];
        }
        elementFound = YES;
    }
    if( [elementName isEqualToString:@"a:Make"])
    {
        if (!soapResults)
        {
            soapResults = [[NSMutableString alloc] init];
        }
        elementFound = YES;
    }
    if( [elementName isEqualToString:@"a:Model"])
    {
        if (!soapResults)
        {
            soapResults = [[NSMutableString alloc] init];
        }
        elementFound = YES;
    }
    if( [elementName isEqualToString:@"a:Year"])
    {
        if (!soapResults)
        {
            soapResults = [[NSMutableString alloc] init];
        }
        elementFound = YES;
    }
    if( [elementName isEqualToString:@"AddVehicleToPolicyResult"])
    {
        if (!soapResults)
        {
            soapResults = [[NSMutableString alloc] init];
        }
        elementFound = YES;
    }
}

-(void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string
{
    if (elementFound)
    {
        [soapResults appendString: string];
    }
}

//---when the end of element is found---
-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{    
    if ([elementName isEqualToString:@"a:returnMessage"])
    {
        if([soapResults isEqualToString:@"0"]){
            //Successful VIN lookup
            VINReturnCode = 0;
        }
        else if ([soapResults isEqualToString:@"-100"])
        {
            VINReturnCode = -100;
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"VIN Service Error"
                                                           message: @"Error connecting to VIN Service. Please try again later."
                                                          delegate: self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            [alert show];
        }
        else{
            VINReturnCode = -1;
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Invalid VIN"
                                                           message: @"VIN is invalid. Please check and enter again"
                                                          delegate: self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            [alert show];
        }
        [soapResults setString:@""];
        elementFound = FALSE;
    }
    if ([elementName isEqualToString:@"a:Make"])
    {
        NSString *soapValue = [NSString stringWithString:soapResults];
        if(VINReturnCode == 0){
            txtMake.text = soapValue;
        }
        [soapResults setString:@""];
        elementFound = FALSE;
    }
    if ([elementName isEqualToString:@"a:Model"])
    {
        NSString *soapValue = [NSString stringWithString:soapResults];
        if(VINReturnCode == 0){
            txtModel.text = soapValue;
        }
        [soapResults setString:@""];
        elementFound = FALSE;
    }
    if ([elementName isEqualToString:@"a:Year"])
    {
        NSString *soapValue = [NSString stringWithString:soapResults];
        if(VINReturnCode == 0){
            txtYear.text = soapValue;
        }
        [soapResults setString:@""];
        elementFound = FALSE;
    }
    
    if ([elementName isEqualToString:@"AddVehicleToPolicyResult"])
    {
        if([soapResults isEqualToString:@"success"])
        {
            Globals *tmp = [Globals sharedSingleton];
            tmp.vehicleAdded = @"added";
            sleep(2);
            VehiclesOnPolicy *vehicleList = [[VehiclesOnPolicy alloc] init];
            [vehicleList LoadVehiclesOnPolicyList:tmp.mainPolicyNumber];
            //[tmp HideWaitScreen];
            
            [self ReleadVehicleDataAndForwardUser];
        }
        else{
            Globals *tmp = [Globals sharedSingleton];
            [tmp HideWaitScreen];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Problem Adding Vehicle"
                                                           message: @"Problem Adding Vehcicle.  Please Try Again Later."
                                                          delegate: self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            [alert show];

        }
        [soapResults setString:@""];
        elementFound = FALSE;
    }

}

-(void) connection:(NSURLConnection *) connection
    didReceiveData:(NSData *) data {
    [webData appendData:data];
}

-(void) connection:(NSURLConnection *) connection
  didFailWithError:(NSError *) error {
    Globals *tmp = [Globals sharedSingleton];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: tmp.connectionErrorTitle
                                                   message: tmp.connectionErrorMessage
                                                  delegate: self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    [alert show];
    [tmp HideWaitScreen];
}

-(void) connection:(NSURLConnection *) connection
didReceiveResponse:(NSURLResponse *) response {
    [webData setLength: 0];
}
 
-(void) AddVehicleToPolicy:(id)sender{
    if([self.txtZipCode.text isEqualToString:@""] || [self.txtVIN.text isEqualToString:@""] || [self.txtYear.text isEqualToString:@""] || [self.txtMake.text isEqualToString:@""]
       || [self.txtModel.text isEqualToString:@""] || [self.txtAntiTheftDevice.text isEqualToString:@""] || [self.txtBodilyInjuryLimit.text isEqualToString:@""]
       || [self.txtVehicleUsage.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Missing Information"
                                                       message: @"Please fill in all fields before adding a vehicle"
                                                      delegate: nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
    else if([self.txtZipCode.text length] < 5){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Zip Code Problem"
                                                       message: @"Zip Code is invalid"
                                                      delegate: nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];        
    }
    else if([self.txtVIN.text length] < 17){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"VIN Problem"
                                                       message: @"VIN is an invalid length"
                                                      delegate: nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Add Vehicle Confirmation"
                                                       message: @"Are you sure you want to add this vehicle to your policy?"
                                                      delegate: self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"OK",nil];
        alert.tag = 3;
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
            if(alertView.tag == 3){
            [self AddVehicle];
            Globals *tmp = [Globals sharedSingleton];
            [tmp ShowWaitScreen:@"Adding Vehicle...\nPlease Wait..."];
        }
    }
    if(buttonIndex == 0){
        //[self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)ShowLoginFailedDialog:(NSString *) errorMessage{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Network Error"
                                                   message: @"Error adding vehicle. Please try again later."
                                                  delegate: self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    alert.tag = 0;
    [alert show];
    Globals *tmp = [Globals sharedSingleton];
    [tmp HideWaitScreen];
}

-(void)AddVehicle{
    Globals *tmp = [Globals sharedSingleton];
    [tmp HideLoadingScreen];
    NSString *_postString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",tmp.globalServerName, @"/users.svc/addvehicletopolicy/", tmp.mainPolicyNumber, @"/", txtZipCode.text, @"/", txtVIN.text, @"/", txtYear.text, @"/", txtMake.text, @"/", txtModel.text, @"/", vehicleUsageValue, @"/", antiTheftValue, @"/", bodilyInjuryValue  ];
    
    NSString *postString = [_postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:postString];
    double timeOut = [tmp.GlobalTimeout doubleValue];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOut];

    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (conn) {
        webData = [NSMutableData data];
    }
}

-(void)ReleadVehicleDataAndForwardUser{
    Globals *tmp = [Globals sharedSingleton];
    if(timer){
        [timer invalidate];
        timer = nil;
    }
    if([tmp.VehiclesDoneLoading isEqualToString:@"done"]){
        
        tmp.VehiclesDoneLoading = @"";
        [tmp HideWaitScreen];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Vehicle Added"
                                                       message: @"Vehicle Added Successfully"
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        alert.tag = 2;
        [alert show];
    }
    else{
        [tmp ShowLoadingScreen];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFiring) userInfo:nil repeats:YES];
    }
}

-(void)timerFiring{
    Globals *tmp = [Globals sharedSingleton];
    if([tmp.VehiclesDoneLoading isEqualToString:@"done"]){
        tmp.VehiclesDoneLoading = @"";
        [timer invalidate];
        timer = nil;
        [tmp HideWaitScreen];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Vehicle Added"
                                                       message: @"Vehicle Added Successfully"
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        alert.tag = 2;
        [alert show];
        
    }
}

@end
