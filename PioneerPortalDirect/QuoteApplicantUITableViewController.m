//
//  QuoteApplicantUITableViewController.m
//  PortalDirect
//
//  Created by Brian Kalski on 6/19/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import "QuoteApplicantUITableViewController.h"
#import "QuoteAddDriverUITableViewController.h"
#import "QuoteUITabBarController.h"
#import "QuoteApplicant.h"
#import "QuoteCoverages.h"
#import "Quotes.h"
#import "QuoteDriverListUITableViewController.h"
#import "SendEmail.h"
#import "DropdownData.h"

@interface QuoteApplicantUITableViewController ()

@end

@implementation QuoteApplicantUITableViewController
@synthesize btnNextStep,txtAddress,txtCity,txtDateBirth,txtEmail,txtFirstName,txtLastName,txtMiddle,txtResidencyType,txtSSN,txtState,txtZip,BottomToolBar,buttonItemEdit;
@synthesize managedObjectContext = __managedObjectContext,currentQuote;

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



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    Globals *tmp = [Globals sharedSingleton];
    
    if(textField == txtMiddle){
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 1) ? NO : YES;
    }
    else if(textField == txtZip){
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 5) ? NO : YES;
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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    [self StartupFunctions];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self StartupFunctions];

}

-(void)StartupFunctions{
    [self SetTabBarImages];
    
    Globals *tmp = [Globals sharedSingleton];
    
    self.title = @"Auto Quote - Applicant";
    CGRect frame = CGRectMake(0, 0, [self.title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f]}].width, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:17.0];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    self.tabBarItem.title = @"Applicant";
    label.text = self.title;
    
    [self.navigationController setToolbarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES];
    
    //    UIBarButtonItem *buttonLeftNav = [[UIBarButtonItem alloc] initWithTitle:@"Back to Login"
    //                                                                       style:UIBarButtonItemStyleBordered
    //                                                                      target: self
    //                                                                      action:@selector(leftNavButtonFire:) ];
    //    self.navigationItem.leftBarButtonItem = buttonLeftNav;
    
    
    arrayStateList = [[NSMutableArray alloc] init];
    arrayResidencyList = [[NSMutableArray alloc] init];
    arrayResidencyListValue = [[NSMutableArray alloc] init];
    
    [arrayStateList addObject:@""];
    
    txtAddress.delegate = (id)self;
    txtCity.delegate = (id)self;
    txtEmail.delegate = (id)self;
    txtFirstName.delegate = (id)self;
    txtLastName.delegate = (id)self;
    txtMiddle.delegate = (id)self;
    txtSSN.delegate = (id)self;
    txtZip.delegate = (id)self;
    
    //Load Residency List
    self.managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *_fetchReqResidency = [[NSFetchRequest alloc] init];
    _fetchReqResidency.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"name =='", @"BUILDING_USE", @"'", nil]];
    NSEntityDescription *entityResidency = [NSEntityDescription entityForName:@"DropdownData" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqResidency setEntity:entityResidency];
    //sorting
    NSSortDescriptor* sortDescriptorResidency = [[NSSortDescriptor alloc] initWithKey:@"desc" ascending:YES];
    NSArray* sortDescriptorsResidency = [[NSArray alloc] initWithObjects: sortDescriptorResidency, nil];
    [_fetchReqResidency setSortDescriptors:sortDescriptorsResidency];
    NSArray *arrayTempResidency = [self.managedObjectContext executeFetchRequest:_fetchReqResidency error:nil];
    for(int i = 0; i < [arrayTempResidency count] ; i++){
        DropdownData *_dd = (DropdownData*)[arrayTempResidency objectAtIndex:i];
        NSString *_ddText = _dd.desc;
        [arrayResidencyList addObject:_ddText];
        [arrayResidencyListValue addObject:_dd.code];
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
    txtDateBirth.inputView = datePicker;
    txtDateBirth.inputAccessoryView = DoneButtonView;
    
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
    LicenseStatePicker.tag = 2;
    LicenseStatePicker.dataSource = self;
    LicenseStatePicker.delegate = self;
    LicenseStatePicker.showsSelectionIndicator = YES;
    txtState.inputView = LicenseStatePicker;
    txtState.inputAccessoryView = DoneButtonViewLicenseState;
    
    //Residency
    UIToolbar *DoneButtonViewResidency = [[UIToolbar alloc] init];
    DoneButtonViewResidency.barStyle = UIBarStyleBlack;
    DoneButtonViewResidency.translucent = YES;
    DoneButtonViewResidency.tintColor = nil;
    [DoneButtonViewResidency sizeToFit];
    UIBarButtonItem *doneButtonResidency = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(ResidencyDonePressed:)];
    [DoneButtonViewResidency setItems:[NSArray arrayWithObjects:doneButtonResidency, nil]];
    
    UIPickerView *ResidencyPicker1 = [[UIPickerView alloc] initWithFrame:CGRectZero];
    ResidencyPicker = ResidencyPicker1;
    ResidencyPicker.tag = 1;
    ResidencyPicker.dataSource = self;
    ResidencyPicker.delegate = self;
    ResidencyPicker.showsSelectionIndicator = YES;
    txtResidencyType.inputView = ResidencyPicker;
    txtResidencyType.inputAccessoryView = DoneButtonViewResidency;
    
    
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
    
    UIToolbar* numberToolbarZip = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbarZip.barStyle = UIBarStyleBlackTranslucent;
    numberToolbarZip.items = [NSArray arrayWithObjects:
                              [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPadZip)],
                              [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                              [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPadZip)],
                              nil];
    [numberToolbarZip sizeToFit];
    txtZip.inputAccessoryView = numberToolbarZip;
    
    [self LoadData];
}

-(void)leftNavButtonFire:(id)sender{
  
}

- (void)SetTabBarImages{
    Globals *tmp = [Globals sharedSingleton];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    tempArray = [tmp SetTabBarImages:tmp.currentQuoteGuid];
    
    NSInteger qa = [tempArray[0] integerValue];
    NSInteger qd = [tempArray[1] integerValue];
    NSInteger qv = [tempArray[2] integerValue];
    NSInteger qc = [tempArray[3] integerValue];
    
    NSArray *viewControllers = [[NSArray alloc] init];
    viewControllers = self.tabBarController.viewControllers;
    //review tab
    ((UIViewController*)viewControllers[4]).tabBarItem.image = [UIImage imageNamed:@"car-side.png"];

    
    if((int)qa == 1){
        ((UIViewController*)viewControllers[0]).tabBarItem.image = [UIImage imageNamed:@"tick.png"];
        [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:TRUE];
        [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:TRUE];
        [[[[self.tabBarController tabBar]items]objectAtIndex:3]setEnabled:TRUE];
    }
    else{
        ((UIViewController*)viewControllers[0]).tabBarItem.image = [UIImage imageNamed:@"question.png"];
        [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:FALSE];
        [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:FALSE];
        [[[[self.tabBarController tabBar]items]objectAtIndex:3]setEnabled:FALSE];
    }

    if((int)qd == 1){
        ((UIViewController*)viewControllers[1]).tabBarItem.image = [UIImage imageNamed:@"tick.png"];
        [[[[self.tabBarController tabBar]items]objectAtIndex:4]setEnabled:TRUE];
    }
    else{
        ((UIViewController*)viewControllers[1]).tabBarItem.image = [UIImage imageNamed:@"question.png"];
        [[[[self.tabBarController tabBar]items]objectAtIndex:4]setEnabled:FALSE];
    }

    if((int)qv == 1){
        ((UIViewController*)viewControllers[2]).tabBarItem.image = [UIImage imageNamed:@"tick.png"];
        [[[[self.tabBarController tabBar]items]objectAtIndex:4]setEnabled:TRUE];
    }
    else{
        ((UIViewController*)viewControllers[2]).tabBarItem.image = [UIImage imageNamed:@"question.png"];
        [[[[self.tabBarController tabBar]items]objectAtIndex:4]setEnabled:FALSE];
    }

    if((int)qc == 1){
        ((UIViewController*)viewControllers[3]).tabBarItem.image = [UIImage imageNamed:@"tick.png"];
    }
    else{
        ((UIViewController*)viewControllers[3]).tabBarItem.image = [UIImage imageNamed:@"question.png"];
    }
    
}

-(void)LoadData{
    //get applicant info
    Globals *tmp = [Globals sharedSingleton];
    self.managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *_fetchReqE = [[NSFetchRequest alloc] init];
    _fetchReqE.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"applicantID =='", tmp.currentApplicantID, @"'", nil]];
    NSEntityDescription *entityE = [NSEntityDescription entityForName:@"QuoteApplicant" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqE setEntity:entityE];
    
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:_fetchReqE error:nil];
    
    for (NSManagedObject *info in fetchedObjects)
    {
        QuoteApplicant *app = (QuoteApplicant *)info;
        txtAddress.text = app.address;
        txtCity.text = app.city;
        txtDateBirth.text = app.dateBirth;
        txtEmail.text = app.email;
        txtFirstName.text = app.firstName;
        txtLastName.text = app.lastName;
        txtMiddle.text = app.middle;
        txtResidencyType.text = app.residencyType;
        txtSSN.text = app.ssn;
        txtState.text = app.state;
        txtZip.text = app.zip;
    }

}

-(void)cancelNumberPad{
    [txtSSN resignFirstResponder];
    txtSSN.text = @"";
}

-(void)doneWithNumberPad{
    //NSString *numberFromTheKeyboard = txtSSN.text;
    [txtSSN resignFirstResponder];
}

-(void)cancelNumberPadZip{
    [txtZip resignFirstResponder];
    txtZip.text = @"";
}

-(void)doneWithNumberPadZip{
    //NSString *numberFromTheKeyboard = txtSSN.text;
    [txtZip resignFirstResponder];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    Globals *tmp = [Globals sharedSingleton];
    if(pickerView.tag == 1){
        txtResidencyType.text = [arrayResidencyList objectAtIndex:row];
        residencyTypeValue = [arrayResidencyListValue objectAtIndex:row];
    }
    if(pickerView.tag == 2){
        txtState.text = [tmp.stateList objectAtIndex:row];
    }
}

- (IBAction)LicenseStateDonePressed:(id)sender {
    [txtState resignFirstResponder];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{    
    Globals *tmp = [Globals sharedSingleton];
    if(pickerView.tag == 1){
        return [arrayResidencyList objectAtIndex:row];
    }
    if(pickerView.tag == 2){
        return [tmp.stateList objectAtIndex:row];
    }
    else{
        return @"";
    }
    
}

- (IBAction)ResidencyDonePressed:(id)sender {
    [txtResidencyType resignFirstResponder];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    Globals *tmp = [Globals sharedSingleton];
    if(pickerView.tag == 1){
        return [arrayResidencyList count];
    }
    if(pickerView.tag == 2){
        return [tmp.stateList count];
    }
    else{
        return 0;
    }
}



- (IBAction)DateOfBirthDonePressed:(id)sender {
    Globals *tmp = [Globals sharedSingleton];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M/d/yyyy"];
    NSString *dateString = [formatter stringFromDate:pickerDate];
        
    BOOL isBirthDateValidForDriver = [tmp IsValidDriverBirthDate:pickerDate];
    
    if(isBirthDateValidForDriver == NO && dateString != nil){
        txtDateBirth.text = @"";
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Date of Birth"
                                                       message: @"Drivers must be at least 16 years old"
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        alert.tag = 7;
        [alert show];
    }else{
        if(dateString != nil){
            txtDateBirth.text = dateString;
        }
    }
    
    [txtDateBirth resignFirstResponder];
}

- (IBAction)datePickerChanged:(id)sender{
    pickerDate = datePicker.date;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SendUserToLoginScreen:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)SaveThenNextStep:(id)sender {
    Globals *tmp = [Globals sharedSingleton];
    
    if(![tmp validateEmail:txtEmail.text]){
        txtEmail.backgroundColor = tmp.requiredFieldColor;
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Email Address is invalid"
                                                       message: @"Please check email address"
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if([txtFirstName.text isEqualToString:@""] || [txtLastName.text isEqualToString:@""]){
        txtFirstName.backgroundColor = tmp.requiredFieldColor;
        txtLastName.backgroundColor = tmp.requiredFieldColor;
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Information Needed"
                                                       message: @"Please enter the applicant's first and last name"
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        alert.tag = 7;
        [alert show];
        return;
        
    }
    
    self.managedObjectContext = tmp.managedObjectContext;
    
    if([tmp.currentQuoteGuid isEqualToString:@""]){
        //new quote
        NSString *guid = tmp.GetUUID;
        tmp.currentQuoteGuid = guid;
        
        Quotes *qt = [NSEntityDescription insertNewObjectForEntityForName:@"Quotes" inManagedObjectContext:self.managedObjectContext];
        
        qt.quoteID = guid;
        qt.quoteName = [NSString stringWithFormat:@"%@%@%@", txtFirstName.text, @" ", txtLastName.text];
        qt.quoteStatus = @"In Progress";
        qt.quoteSubmitted = @"test";
        
        NSError *error;
        if (![self.managedObjectContext save:&error])
        {
            NSLog(@"Problem saving: %@", [error localizedDescription]);
            SendEmail *sEmail = [[SendEmail alloc] init];
            [sEmail sendEmail:@"bjkalski@gmail.com" subject:@"QuoteApplicant Save Error" body:[error localizedDescription]];
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Error"
                                                           message: @"Error saving applicant. Please exit and try again."
                                                          delegate: self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            alert.tag = 7;
            [alert show];
            return;
        }
    }
    
    
    if(![tmp.currentQuoteGuid isEqualToString:@""]){
        NSFetchRequest *_fetchReqE = [[NSFetchRequest alloc] init];
        _fetchReqE.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"quoteID == '", tmp.currentQuoteGuid, @"'", nil]];
        NSEntityDescription *entityE = [NSEntityDescription entityForName:@"Quotes" inManagedObjectContext:self.managedObjectContext];
        [_fetchReqE setEntity:entityE];
        
        NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:_fetchReqE error:nil];
        
        for (NSManagedObject *info in fetchedObjects)
        {
            currentQuote = (Quotes *)info;
        }
    }
    
    
    NSFetchRequest *_fetchReqD = [[NSFetchRequest alloc] init];
    _fetchReqD.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"applicantID == '", tmp.currentApplicantID, @"'", nil]];
    NSEntityDescription *entityD = [NSEntityDescription entityForName:@"QuoteApplicant" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqD setEntity:entityD];
    
    NSArray *fetchedObjectsD = [self.managedObjectContext executeFetchRequest:_fetchReqD error:nil];
    
    if((![tmp.createNewApplicant isEqualToString:@"YES"]) && fetchedObjectsD.count > 0){
        for (NSManagedObject *info in fetchedObjectsD)
        {
            QuoteApplicant *qa = (QuoteApplicant *)info;
            qa.firstName = txtFirstName.text;
            qa.middle = txtMiddle.text;
            qa.lastName = txtLastName.text;
            qa.address = txtAddress.text;
            qa.city = txtCity.text;
            qa.state = txtState.text;
            qa.zip = txtZip.text;
            qa.dateBirth = txtDateBirth.text;
            qa.ssn = txtSSN.text;
            qa.email = txtEmail.text;
            qa.residencyType = txtResidencyType.text;
            qa.residencyTypeValue = residencyTypeValue;
        }
        currentQuote.quoteStatus = @"In Progress";
        [self.managedObjectContext save:nil];
    }
    
    if([tmp.createNewApplicant isEqualToString:@"YES"]){
        NSString *guid = tmp.GetUUID;
        tmp.currentApplicantID = guid;
        
        QuoteApplicant *qa = [NSEntityDescription insertNewObjectForEntityForName:@"QuoteApplicant" inManagedObjectContext:self.managedObjectContext];
        qa.firstName = txtFirstName.text;
        qa.middle = txtMiddle.text;
        qa.lastName = txtLastName.text;
        qa.address = txtAddress.text;
        qa.city = txtCity.text;
        qa.state = txtState.text;
        qa.zip = txtZip.text;
        qa.dateBirth = txtDateBirth.text;
        qa.ssn = txtSSN.text;
        qa.email = txtEmail.text;
        qa.residencyType = txtResidencyType.text;
        qa.residencyTypeValue = residencyTypeValue;
        qa.applicantID = guid;
        
        tmp.createNewDriver = @"";
        
        [currentQuote addQuoteApplicantObject:qa];
        
        [self.managedObjectContext save:nil];  // write to database
    }
    
    [self SetTabBarImages];
    
    if([tmp QuoteReadyForReview:tmp.currentQuoteGuid]){
        [(QuoteUITabBarController *)self.tabBarController EnableReviewButton];
    }
    
    [[self.navigationController popViewControllerAnimated:YES] viewWillAppear:YES];
}

- (IBAction)CancelAddApplicant:(id)sender {
    txtFirstName.text = @"";
    txtLastName.text = @"";
    txtMiddle.text = @"";
    txtDateBirth.text = @"";
    txtAddress.text = @"";
    txtCity.text = @"";
    txtEmail.text = @"";
    txtResidencyType.text = @"";
    txtSSN.text = @"";
    txtState.text = @"";
    txtZip.text = @"";
    
    [[self.navigationController popViewControllerAnimated:YES] viewWillAppear:YES];
    
}


@end
