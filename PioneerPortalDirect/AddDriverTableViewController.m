//
//  AddDriverTableViewController.m
//  PortalDirect
//
//  Created by Brian Kalski on 2/19/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import "AddDriverTableViewController.h"
#import "Globals.h"
#import "AppDelegate.h"
#import "DriversOnPolicy.h"
#import "DropdownData.h"

@interface AddDriverTableViewController ()

@end

@implementation AddDriverTableViewController

@synthesize DependentYesButton,DependentNoButton,txtDateOfBirth,datePicker,LicenseStatePicker;
@synthesize txtLicenseState,txtAnnualIncome,txtEmploymentStatus,txtFirstName,txtLastName,txtLicenseNumber,txtMiddleInitial,txtOccupation;
@synthesize activityIndicator,responseData,OccupationListPicker,EmploymentListPicker,AnnualIncomeListPicker,timer,GenderFStatusButton;
@synthesize GenderMStatusButton,MaritalStatusMButton,MaritalStatusSButton,txtSSN;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    Globals *tmp = [Globals sharedSingleton];
    
    if(textField == txtMiddleInitial){
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 1) ? NO : YES;
    }
    else if(textField == txtSSN){
        NSString *filter = @"###-##-####";
        
        NSString *changedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if(range.length == 1 && // Only do for single deletes
           string.length < range.length &&
           [[textField.text substringWithRange:range] rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]].location == NSNotFound)
        {
            // Something was deleted.  Delete past the previous number
            NSInteger location = changedString.length-1;
            if(location > 0)
            {
                for(; location > 0; location--)
                {
                    if(isdigit([changedString characterAtIndex:location]))
                    {
                        break;
                    }
                }
                changedString = [changedString substringToIndex:location];
            }
        }
        NSString *filteredText = [tmp filteredStringFromStringWithFilter:changedString filterText:filter];
        textField.text = filteredText;
        
        return NO;
    }
    else{
        return YES;
    }
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set background image
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clouds.png"]];
    [tempImageView setFrame:self.tableView.frame];
    self.tableView.backgroundView = tempImageView;
    
    //set up toolbar
    [self.navigationController setToolbarHidden:NO];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Save Driver"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(AddDriverDone)];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                  initWithTitle:@"Cancel"
                                  style:UIBarButtonItemStyleBordered
                                  target:self
                                  action:@selector(CancelAddDriver)];
    
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                              target:nil
                                                                              action:nil];
    
    NSArray *arrBtns = [[NSArray alloc]initWithObjects:saveButton, flexible, cancelButton, nil];
    self.toolbarItems = arrBtns;
    
    txtFirstName.delegate = (id)self;
    txtLastName.delegate = (id)self;
    txtMiddleInitial.delegate = (id)self;
    txtLicenseNumber.delegate = (id)self;
    txtSSN.delegate = (id)self;
    
    arrOccupationList = [[NSMutableArray alloc] init];
    arrEmploymentList = [[NSMutableArray alloc] init];
    arrAnnualIncomeList = [[NSMutableArray alloc] init];
    arrAnnualIncomeListValue = [[NSMutableArray alloc] init];
    arrEmploymentListValue = [[NSMutableArray alloc] init];
    arrOccupationListValue = [[NSMutableArray alloc] init];
                                                            
    
    HasDependents = @"";
    MaritalStatusSelected = NO;
    GenderSelected = NO;
        
    //Load PickerView arrays from DB
    Globals *tmp = [Globals sharedSingleton];
    self.managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *_fetchReq = [[NSFetchRequest alloc] init];
    _fetchReq.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"name =='", @"OCCUPATION_CODE", @"'", nil]];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DropdownData" inManagedObjectContext:self.managedObjectContext];
    [_fetchReq setEntity:entity];
    NSArray *arrayTemp = [self.managedObjectContext executeFetchRequest:_fetchReq error:nil];
    for(int i = 0; i < [arrayTemp count] ; i++){
        DropdownData *_dd = (DropdownData*)[arrayTemp objectAtIndex:i];
        [arrOccupationList addObject:_dd.desc];
        [arrOccupationListValue addObject:_dd.code];
    }
    
    NSFetchRequest *_fetchReqE = [[NSFetchRequest alloc] init];
    _fetchReqE.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"name =='", @"EmployeeStatusList", @"'", nil]];
    NSEntityDescription *entityE = [NSEntityDescription entityForName:@"DropdownData" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqE setEntity:entityE];
    NSArray *arrayTempE = [self.managedObjectContext executeFetchRequest:_fetchReqE error:nil];
    for(int i = 0; i < [arrayTempE count] ; i++){
        DropdownData *_dd = (DropdownData*)[arrayTempE objectAtIndex:i];
        [arrEmploymentList addObject:_dd.desc];
    }
    
    NSFetchRequest *_fetchReqA = [[NSFetchRequest alloc] init];
    _fetchReqA.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"name =='", @"AnnualIncomeList", @"'", nil]];
    NSEntityDescription *entityA = [NSEntityDescription entityForName:@"DropdownData" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqA setEntity:entityA];
    NSArray *arrayTempA = [self.managedObjectContext executeFetchRequest:_fetchReqA error:nil];
    for(int i = 0; i < [arrayTempA count] ; i++){
        DropdownData *_dd = (DropdownData*)[arrayTempA objectAtIndex:i];
        [arrAnnualIncomeList addObject:_dd.desc];
        [arrEmploymentListValue addObject:_dd.code];
    }

    
    //Date of Birth field
    UIToolbar *DoneButtonView = [[UIToolbar alloc] init];
    DoneButtonView.barStyle = UIBarStyleBlack;
    DoneButtonView.translucent = YES;
    DoneButtonView.tintColor = nil;
    [DoneButtonView sizeToFit];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(DateOfBirthDonePressed:)];
    [DoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
    
    UIDatePicker *theDatePicker = [[UIDatePicker alloc] init];
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *formatterD = [[NSDateFormatter alloc] init];
    NSDateFormatter *formatterM = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    [formatterD setDateFormat:@"dd"];
    [formatterM setDateFormat:@"MM"];
    NSString *year = [formatter stringFromDate:now];
    NSString *day = [formatterD stringFromDate:now];
    NSString *month = [formatterM stringFromDate:now];
    int iYear = [year intValue];
    
    NSString *modifiedYear = [NSString stringWithFormat:@"%d", iYear - 16];
    
    NSString *dateString = [NSString stringWithFormat:@"%@%@%@%@%@", month, @"-", day, @"-", modifiedYear];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSDate *modifiedDate = [[NSDate alloc] init];
    modifiedDate = [dateFormatter dateFromString:dateString];
    theDatePicker.datePickerMode = UIDatePickerModeDate;
    datePicker = theDatePicker;
    [datePicker setDate:modifiedDate];
    [datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    txtDateOfBirth.inputView = datePicker;
    txtDateOfBirth.inputAccessoryView = DoneButtonView;

    
    //License State
    UIToolbar *DoneButtonViewLicenseState = [[UIToolbar alloc] init];
    DoneButtonViewLicenseState.barStyle = UIBarStyleBlack;
    DoneButtonViewLicenseState.translucent = YES;
    DoneButtonViewLicenseState.tintColor = nil;
    [DoneButtonViewLicenseState sizeToFit];
    UIBarButtonItem *doneButtonLicenseState = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(LicenseStateDonePressed:)];
    [DoneButtonViewLicenseState setItems:[NSArray arrayWithObjects:doneButtonLicenseState, nil]];
    
    UIPickerView *StatePicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    LicenseStatePicker = StatePicker;
    LicenseStatePicker.tag = 1;
    LicenseStatePicker.dataSource = self;
    LicenseStatePicker.delegate = self;
    LicenseStatePicker.showsSelectionIndicator = YES;
    txtLicenseState.inputView = LicenseStatePicker;
    txtLicenseState.inputAccessoryView = DoneButtonViewLicenseState;
    
    //Occupation List
    UIToolbar *DoneButtonViewOccupationList = [[UIToolbar alloc] init];
    DoneButtonViewOccupationList.barStyle = UIBarStyleBlack;
    DoneButtonViewOccupationList.translucent = YES;
    DoneButtonViewOccupationList.tintColor = nil;
    [DoneButtonViewOccupationList sizeToFit];
    UIBarButtonItem *doneButtonOccupationList = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(OccupationListDonePressed:)];
    [DoneButtonViewOccupationList setItems:[NSArray arrayWithObjects:doneButtonOccupationList, nil]];
    
    UIPickerView *OccupationPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    OccupationListPicker = OccupationPicker;
    OccupationListPicker.tag = 2;
    OccupationListPicker.dataSource = self;
    OccupationListPicker.delegate = self;
    OccupationListPicker.showsSelectionIndicator = YES;
    txtOccupation.inputView = OccupationListPicker;
    txtOccupation.inputAccessoryView = DoneButtonViewOccupationList;
    
    //Employment List
    UIToolbar *DoneButtonViewEmploymentList = [[UIToolbar alloc] init];
    DoneButtonViewEmploymentList.barStyle = UIBarStyleBlack;
    DoneButtonViewEmploymentList.translucent = YES;
    DoneButtonViewEmploymentList.tintColor = nil;
    [DoneButtonViewEmploymentList sizeToFit];
    UIBarButtonItem *doneButtonEmploymentList = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(EmploymentListDonePressed:)];
    [DoneButtonViewEmploymentList setItems:[NSArray arrayWithObjects:doneButtonEmploymentList, nil]];
    
    UIPickerView *EmploymentPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    EmploymentListPicker = EmploymentPicker;
    EmploymentListPicker.tag = 3;
    EmploymentListPicker.dataSource = self;
    EmploymentListPicker.delegate = self;
    EmploymentListPicker.showsSelectionIndicator = YES;
    txtEmploymentStatus.inputView = EmploymentListPicker;
    txtEmploymentStatus.inputAccessoryView = DoneButtonViewEmploymentList;
    
    //Annual Income
    UIToolbar *DoneButtonViewAnnualIncomeList = [[UIToolbar alloc] init];
    DoneButtonViewAnnualIncomeList.barStyle = UIBarStyleBlack;
    DoneButtonViewAnnualIncomeList.translucent = YES;
    DoneButtonViewAnnualIncomeList.tintColor = nil;
    [DoneButtonViewAnnualIncomeList sizeToFit];
    UIBarButtonItem *doneButtonAnnualIncomeList = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(AnnualIncomeListDonePressed:)];
    [DoneButtonViewAnnualIncomeList setItems:[NSArray arrayWithObjects:doneButtonAnnualIncomeList, nil]];
    
    UIPickerView *AnnualIncomePicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    AnnualIncomeListPicker = AnnualIncomePicker;
    AnnualIncomeListPicker.tag = 4;
    AnnualIncomeListPicker.dataSource = self;
    AnnualIncomeListPicker.delegate = self;
    AnnualIncomeListPicker.showsSelectionIndicator = YES;
    txtAnnualIncome.inputView = AnnualIncomeListPicker;
    txtAnnualIncome.inputAccessoryView = DoneButtonViewAnnualIncomeList;
    
    //Number Pad
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    txtSSN.inputAccessoryView = numberToolbar;
}

-(void)CancelAddDriver{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)cancelNumberPad{
    [txtSSN resignFirstResponder];
    txtSSN.text = @"";
}

-(void)doneWithNumberPad{
    //NSString *numberFromTheKeyboard = txtSSN.text;
    [txtSSN resignFirstResponder];
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
        return tmp.stateList.count;
    }
    if(pickerView.tag == 2){
        return arrOccupationList.count;
    }
    if(pickerView.tag == 3){
        return arrEmploymentList.count;
    }
    if(pickerView.tag == 4){
        return arrAnnualIncomeList.count;
    }
    else{
        return 0;
    }
    
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    Globals *tmp = [Globals sharedSingleton];
    if(pickerView.tag == 1){
        return [tmp.stateList objectAtIndex:row];
    }
    if(pickerView.tag == 2){        
        return [arrOccupationList objectAtIndex:row];        
    }
    if(pickerView.tag == 3){
        return [arrEmploymentList objectAtIndex:row];
    }
    if(pickerView.tag == 4){
        return [arrAnnualIncomeList objectAtIndex:row];
    }
    else{
        return @"";
    }

}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    Globals *tmp = [Globals sharedSingleton];
    if(pickerView.tag == 1){
        txtLicenseState.text = [tmp.stateList objectAtIndex:row];
    }
    if(pickerView.tag == 2){
        txtOccupation.text = [arrOccupationList objectAtIndex:row];
        OccupationValue = [arrOccupationListValue objectAtIndex:row];
    }
    if(pickerView.tag == 3){
        txtEmploymentStatus.text = [arrEmploymentList objectAtIndex:row];        
    }
    if(pickerView.tag == 4){
        txtAnnualIncome.text = [arrAnnualIncomeList objectAtIndex:row];
        AnnualIncomeValue = [arrEmploymentListValue objectAtIndex:row];
    }
}


- (IBAction)DependentYesPressed:(id)sender {
    UIColor *darkBlueColor = [UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
    self.DependentYesButton.backgroundColor = darkBlueColor;
    self.DependentNoButton.backgroundColor = [UIColor whiteColor];
    [self.DependentYesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.DependentNoButton setTitleColor:darkBlueColor forState:UIControlStateNormal];
    HasDependents = @"YES";
    DependentsSelected = YES;
}

- (IBAction)DependentNoPressed:(id)sender {
    UIColor *darkBlueColor = [UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
    self.DependentYesButton.backgroundColor = [UIColor whiteColor];
    self.DependentNoButton.backgroundColor = darkBlueColor;
    [self.DependentYesButton setTitleColor:darkBlueColor forState:UIControlStateNormal];
    [self.DependentNoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    HasDependents = @"NO";
    DependentsSelected = YES;
}

- (IBAction)DateOfBirthDonePressed:(id)sender {
    Globals *tmp = [Globals sharedSingleton];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M/d/yyyy"];
    NSString *dateString = [formatter stringFromDate:pickerDate];
    txtDateOfBirth.text = dateString;
    
    BOOL isBirthDateValidForDriver = [tmp IsValidDriverBirthDate:pickerDate];
    
    if(isBirthDateValidForDriver == NO && dateString != nil){
        txtDateOfBirth.text = @"";
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Date of Birth"
                                                       message: @"Drivers must be at least 16 years old"
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        alert.tag = 7;
        [alert show];
    }else{
        if(dateString != nil){
            txtDateOfBirth.text = dateString;
        }
    }

    
    [txtDateOfBirth resignFirstResponder];
}

- (IBAction)LicenseStateDonePressed:(id)sender {
    [txtLicenseState resignFirstResponder];
}
     
     
 - (IBAction)datePickerChanged:(id)sender{
     pickerDate = datePicker.date;
 }

- (IBAction)OccupationListDonePressed:(id)sender{
    [txtOccupation resignFirstResponder];
}

- (IBAction)EmploymentListDonePressed:(id)sender{
    [txtEmploymentStatus resignFirstResponder];
}

- (IBAction)AnnualIncomeListDonePressed:(id)sender{
    [txtAnnualIncome resignFirstResponder];
}

-(void) AddDriverDone{
    if([self.txtFirstName.text isEqualToString:@""]
       || [self.txtLastName.text isEqualToString:@""]
       || [self.txtAnnualIncome.text isEqualToString:@""]
       || [self.txtDateOfBirth.text isEqualToString:@""]
       || [self.txtEmploymentStatus.text isEqualToString:@""]
       || [self.txtLicenseNumber.text isEqualToString:@""]
       || [self.txtLicenseState.text isEqualToString:@""]
       || [self.txtMiddleInitial.text isEqualToString:@""]
       || [self.txtOccupation.text isEqualToString:@""]
       || MaritalStatusSelected == NO
       || GenderSelected == NO
       || DependentsSelected == NO
        ){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Missing Information"
                                                       message: @"Please fill in all fields before adding a driver"
                                                      delegate: nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Add Driver Confirmation"
                                                       message: @"Are you sure you want to add this driver to your policy?"
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
            [self AddDriver];
            Globals *tmp = [Globals sharedSingleton];
            [tmp ShowWaitScreen:@"Adding Driver...\nPlease Wait..."];
        }
    }
    if(buttonIndex == 0){
        //[self.navigationController popViewControllerAnimated:YES];
    }
    
    if(alertView.tag == 12){
        Globals *tmp = [Globals sharedSingleton];
        if([tmp.DriversInfoDoneLoading isEqualToString:@"done"]){
            tmp.DriversInfoDoneLoading = @"";
            //[self LoadVehicleGrid];
        }
        else{
            [tmp ShowWaitScreen:@"Reloading Vehicle List"];
            //timerReloadVehicleList = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerReloadVehicleListFiring) userInfo:nil repeats:YES];
        }
    }
}

-(void)ShowLoginFailedDialog:(NSString *) errorMessage{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Network Error"
                                                   message: @"Error adding driver. Please try again later."
                                                  delegate: self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    alert.tag = 0;
    [alert show];
    Globals *tmp = [Globals sharedSingleton];
    [tmp HideWaitScreen];
}

-(void)AddDriver{
    Globals *tmp = [Globals sharedSingleton];
    [tmp HideLoadingScreen];
    NSString *_postString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",tmp.globalServerName, @"/users.svc/adddrivertopolicy/", tmp.mainPolicyNumber, @"/", txtDateOfBirth.text, @"/", @"EmployementStatus", @"/", txtFirstName.text, @"/", txtLastName.text, @"/", txtLicenseNumber.text, @"/", txtLicenseState.text, @"/", txtMiddleInitial.text, @"/", OccupationValue, @"/", AnnualIncomeValue, @"/", MaritalStatus, @"/", HasDependents, @"/", txtSSN.text, @"/", Gender ];
    
    NSString *postString = [_postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:postString];
    double timeOut = [tmp.GlobalTimeout doubleValue];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOut];

    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (conn) {
        webData = [NSMutableData data];
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
    
    if( [elementName isEqualToString:@"AddDriverToPolicyResult"])
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
    Globals *tmp = [Globals sharedSingleton];
    if ([elementName isEqualToString:@"AddDriverToPolicyResult"])
    {
        if([soapResults isEqualToString:@"success"]){
            tmp.DriversInfoDoneLoading = @"";
            [tmp HideWaitScreen];
            DriversOnPolicy *driverList = [[DriversOnPolicy alloc] init];
            [driverList LoadDriversOnPolicyList:tmp.mainPolicyNumber];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Driver Added"
                                                           message: @"Driver Added Successfully"
                                                          delegate: self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            alert.tag = 12;
            [alert show];
        }        
        else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Error Adding Driver"
                                                           message: @"Please try again later"
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


-(void)ReleadDriverDataAndForwardUser{
    Globals *tmp = [Globals sharedSingleton];
    if(timer){
        [timer invalidate];
        timer = nil;
    }
    if([tmp.DriversInfoDoneLoading isEqualToString:@"done"]){
        
        tmp.DriversInfoDoneLoading = @"";
        [tmp HideWaitScreen];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Driver Added"
                                                       message: @"Driver Added Successfully"
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
    if([tmp.DriversInfoDoneLoading isEqualToString:@"done"]){
        tmp.DriversInfoDoneLoading = @"";
        [timer invalidate];
        timer = nil;
        [tmp HideWaitScreen];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Driver Added"
                                                       message: @"Driver Added Successfully"
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        alert.tag = 2;
        [alert show];
        
    }
}

-(IBAction)MaritalStatusMPressed:(id)sender{
    UIColor *darkBlueColor = [UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
    self.MaritalStatusSButton.backgroundColor = [UIColor whiteColor];
    self.MaritalStatusMButton.backgroundColor = darkBlueColor;
    [self.MaritalStatusSButton setTitleColor:darkBlueColor forState:UIControlStateNormal];
    [self.MaritalStatusMButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    MaritalStatus = @"M";
    MaritalStatusSelected = YES;
}

-(IBAction)MaritalStatusSPressed:(id)sender{
    UIColor *darkBlueColor = [UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
    self.MaritalStatusMButton.backgroundColor = [UIColor whiteColor];
    self.MaritalStatusSButton.backgroundColor = darkBlueColor;
    [self.MaritalStatusMButton setTitleColor:darkBlueColor forState:UIControlStateNormal];
    [self.MaritalStatusSButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    MaritalStatus = @"S";
    MaritalStatusSelected = YES;
}

-(IBAction)GenderFPressed:(id)sender{
    UIColor *darkBlueColor = [UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
    self.GenderMStatusButton.backgroundColor = [UIColor whiteColor];
    self.GenderFStatusButton.backgroundColor = darkBlueColor;
    [self.GenderMStatusButton setTitleColor:darkBlueColor forState:UIControlStateNormal];
    [self.GenderFStatusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    Gender = @"F";
    GenderSelected = YES;
}

-(IBAction)GenderMPressed:(id)sender{
    UIColor *darkBlueColor = [UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
    self.GenderFStatusButton.backgroundColor = [UIColor whiteColor];
    self.GenderMStatusButton.backgroundColor = darkBlueColor;
    [self.GenderFStatusButton setTitleColor:darkBlueColor forState:UIControlStateNormal];
    [self.GenderMStatusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    Gender = @"M";
    GenderSelected = YES;
}

@end

