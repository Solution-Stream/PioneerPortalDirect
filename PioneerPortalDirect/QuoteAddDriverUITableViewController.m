//
//  QuoteAddDriverUITableViewController.m
//  PortalDirect
//
//  Created by Brian Kalski on 6/24/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import "QuoteVehicleTableViewController.h"
#import "QuoteAddDriverUITableViewController.h"
#import "QuoteDriverListUITableViewController.h"
#import "QuoteUITabBarController.h"
#import "QuoteDriver.h"
#import "Globals.h"
#import "AppDelegate.h"
#import "DropdownData.h"
#import "Quotes.h"

@interface QuoteAddDriverUITableViewController ()

@end

@implementation QuoteAddDriverUITableViewController
@synthesize txtDateBirth,txtDependents,txtEmploymentStatus,txtFirstName,txtGender,txtIncomeLevel,txtLastName,txtLicenseNum,txtLicenseState,txtMaritalStatus,txtMiddleInitial,txtOccupation,txtRelationApplicant;
@synthesize currentQuote,btnCancel,MaritalStatusSlider,GenderSlider,DependentsSlider;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField == txtMiddleInitial){
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 1) ? NO : YES;
    }
    else{
        return YES;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}



- (void)viewDidLoad{
    [super viewDidLoad];
    
    [MaritalStatusSlider addTarget:self
                      action:@selector(MaritalStatusSliderEditingDidEnd:)
            forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside)];
    
    [GenderSlider addTarget:self
                            action:@selector(GenderSliderEditingDidEnd:)
                  forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside)];
    
    [DependentsSlider addTarget:self
                            action:@selector(DependentsSliderEditingDidEnd:)
                  forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside)];
    
    [self.navigationController setToolbarHidden:NO];
    [self.navigationController setNavigationBarHidden:YES];
    
    //set background image
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clouds.png"]];
    [tempImageView setFrame:self.tableView.frame];
    self.tableView.backgroundView = tempImageView;
    
    [self LoadToolbars];
    
    [self LoadData];
    
    [self LoadPickers];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self LoadToolbars];
    
    [self LoadData];
    
    [self LoadPickers];

}

-(void)LoadToolbars{
    self.title = @"Auto Quote - Add Driver";
    CGRect frame = CGRectMake(0, 0, [self.title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f]}].width, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:17.0];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    self.tabBarItem.title = @"Add";
    label.text = self.title;
    
    
    [self.navigationController setToolbarHidden:NO];
    
    //toolbar buttons
    UIBarButtonItem *save = [[UIBarButtonItem alloc]
                             initWithTitle:@"Save Driver"
                             style:UIBarButtonItemStyleBordered
                             target:self
                             action:@selector(SaveThenNextStep)];
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc]
                               initWithTitle:@"Cancel"
                               style:UIBarButtonItemStyleBordered
                               target:self
                               action:@selector(CancelAddDriver)];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                              target:nil
                                                                              action:nil];
    
    
    
    //[[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:70/255.0f green:155/255.0f blue:19/255.0f alpha:1.0]];
    
    NSArray *arrBtns = [[NSArray alloc]initWithObjects:save, flexible, cancel, nil];
    self.toolbarItems = arrBtns;

}

-(void)LoadPickers{
    arrayRelationList = [[NSMutableArray alloc] init];
    arrayRelationListValue = [[NSMutableArray alloc] init];
    
    arrayMaritalStatusList = [[NSMutableArray alloc] init];
    [arrayMaritalStatusList addObject:@""];
    [arrayMaritalStatusList addObject:@"Single"];
    [arrayMaritalStatusList addObject:@"Married"];
    
    arrOccupationList = [[NSMutableArray alloc] init];
    arrEmploymentList = [[NSMutableArray alloc] init];
    arrAnnualIncomeList = [[NSMutableArray alloc] init];
    arrAnnualIncomeListValue = [[NSMutableArray alloc] init];
    arrEmploymentListValue = [[NSMutableArray alloc] init];
    arrOccupationListValue = [[NSMutableArray alloc] init];
    arrayLicenseState = [[NSMutableArray alloc] init];
    arrayLicenseStateValue = [[NSMutableArray alloc] init];
    
    
    [arrOccupationList addObject:@""];
    [arrEmploymentList addObject:@""];
    [arrAnnualIncomeList addObject:@""];
    [arrAnnualIncomeListValue addObject:@""];
    [arrEmploymentListValue addObject:@""];
    [arrOccupationListValue addObject:@""];
    
    
    
    txtFirstName.delegate = (id)self;
    txtLastName.delegate = (id)self;
    txtLicenseNum.delegate = (id)self;
    txtMiddleInitial.delegate = (id)self;
    
    //Load PickerView arrays from DB
    Globals *tmp = [Globals sharedSingleton];
    self.managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *_fetchReq = [[NSFetchRequest alloc] init];
    _fetchReq.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"name =='", @"OCCUPATION_CODE", @"'", nil]];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DropdownData" inManagedObjectContext:self.managedObjectContext];
    [_fetchReq setEntity:entity];
    //sorting
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"desc" ascending:YES];
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor, nil];
    [_fetchReq setSortDescriptors:sortDescriptors];
    NSArray *arrayTemp = [self.managedObjectContext executeFetchRequest:_fetchReq error:nil];
    for(int i = 0; i < [arrayTemp count] ; i++){
        DropdownData *_dropdowndata = (DropdownData*)[arrayTemp objectAtIndex:i];
        NSString *ddName = _dropdowndata.desc;
        [arrOccupationList addObject:ddName];
        [arrOccupationListValue addObject:_dropdowndata.code];
    }
    
    NSFetchRequest *_fetchReqLS = [[NSFetchRequest alloc] init];
    _fetchReqLS.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"name =='", @"LICENSE_STATE", @"'", nil]];
    NSEntityDescription *entityLS = [NSEntityDescription entityForName:@"DropdownData" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqLS setEntity:entityLS];
    //sorting
    NSSortDescriptor* sortDescriptorLS = [[NSSortDescriptor alloc] initWithKey:@"desc" ascending:YES];
    NSArray* sortDescriptorsLS = [[NSArray alloc] initWithObjects: sortDescriptorLS, nil];
    [_fetchReqLS setSortDescriptors:sortDescriptorsLS];
    NSArray *arrayTempLS = [self.managedObjectContext executeFetchRequest:_fetchReqLS error:nil];
    for(int i = 0; i < [arrayTempLS count] ; i++){
        DropdownData *_dropdowndata = (DropdownData*)[arrayTempLS objectAtIndex:i];
        NSString *ddName = _dropdowndata.desc;
        [arrayLicenseState addObject:ddName];
        [arrayLicenseStateValue addObject:_dropdowndata.code];
    }
    
    
    NSFetchRequest *_fetchReqRE = [[NSFetchRequest alloc] init];
    _fetchReqRE.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"name =='", @"RELATION_TO_APPL", @"'", nil]];
    NSEntityDescription *entityRE = [NSEntityDescription entityForName:@"DropdownData" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqRE setEntity:entityRE];
    //sorting
    NSSortDescriptor* sortDescriptorRE = [[NSSortDescriptor alloc] initWithKey:@"desc" ascending:YES];
    NSArray* sortDescriptorsRE = [[NSArray alloc] initWithObjects: sortDescriptorRE, nil];
    [_fetchReqRE setSortDescriptors:sortDescriptorsRE];
    
    NSArray *arrayTempRE = [self.managedObjectContext executeFetchRequest:_fetchReqRE error:nil];
    for(int i = 0; i < [arrayTempRE count] ; i++){
        DropdownData *_dropdowndata = (DropdownData*)[arrayTempRE objectAtIndex:i];
        [arrayRelationList addObject:_dropdowndata.desc];
        [arrayRelationListValue addObject:_dropdowndata.code];
    }
    
    NSFetchRequest *_fetchReqE = [[NSFetchRequest alloc] init];
    _fetchReqE.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"name =='", @"EmployeeStatusList", @"'", nil]];
    NSEntityDescription *entityE = [NSEntityDescription entityForName:@"DropdownData" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqE setEntity:entityE];
    //sorting
    NSSortDescriptor* sortDescriptorE = [[NSSortDescriptor alloc] initWithKey:@"desc" ascending:YES];
    NSArray* sortDescriptorsE = [[NSArray alloc] initWithObjects: sortDescriptorE, nil];
    [_fetchReqE setSortDescriptors:sortDescriptorsE];
    
    NSArray *arrayTempE = [self.managedObjectContext executeFetchRequest:_fetchReqE error:nil];
    for(int i = 0; i < [arrayTempE count] ; i++){
        DropdownData *_dropdowndata = (DropdownData*)[arrayTempE objectAtIndex:i];
        [arrEmploymentList addObject:_dropdowndata.desc];
        [arrEmploymentListValue addObject:_dropdowndata.code];
    }
    
    
    NSFetchRequest *_fetchReqA = [[NSFetchRequest alloc] init];
    _fetchReqA.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"name =='", @"AnnualIncomeList", @"'", nil]];
    NSEntityDescription *entityA = [NSEntityDescription entityForName:@"DropdownData" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqA setEntity:entityA];
    //sorting
    NSSortDescriptor* sortDescriptorA = [[NSSortDescriptor alloc] initWithKey:@"desc" ascending:YES];
    NSArray* sortDescriptorsA = [[NSArray alloc] initWithObjects: sortDescriptorA, nil];
    [_fetchReqA setSortDescriptors:sortDescriptorsA];
    NSArray *arrayTempA = [self.managedObjectContext executeFetchRequest:_fetchReqA error:nil];
    for(int i = 0; i < [arrayTempA count] ; i++){
        DropdownData *_dropdowndata = (DropdownData*)[arrayTempA objectAtIndex:i];
        [arrAnnualIncomeList addObject:_dropdowndata.desc];
        [arrAnnualIncomeListValue addObject:_dropdowndata.code];
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
    
    NSString *dateString = @"";
    
    if([txtDateBirth.text isEqualToString:@""] || txtDateBirth.text == nil){
        dateString = [NSString stringWithFormat:@"%@%@%@%@%@", month, @"-", day, @"-", modifiedYear];
    }else{
        dateString = [txtDateBirth.text stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    }
    
    
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
    
    //Marital Status
    UIToolbar *DoneButtonViewMaritalStatus = [[UIToolbar alloc] init];
    DoneButtonViewMaritalStatus.barStyle = UIBarStyleBlack;
    DoneButtonViewMaritalStatus.translucent = YES;
    DoneButtonViewMaritalStatus.tintColor = nil;
    [DoneButtonViewMaritalStatus sizeToFit];
    UIBarButtonItem *doneButtonMaritalStatus = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(MaritalStatusDonePressed:)];
    [DoneButtonViewMaritalStatus setItems:[NSArray arrayWithObjects:doneButtonMaritalStatus, nil]];
    
    UIPickerView *MaritalStatusPicker1 = [[UIPickerView alloc] initWithFrame:CGRectZero];
    MaritalStatusPicker = MaritalStatusPicker1;
    MaritalStatusPicker.tag = 1;
    MaritalStatusPicker.dataSource = self;
    MaritalStatusPicker.delegate = self;
    MaritalStatusPicker.showsSelectionIndicator = YES;
    txtMaritalStatus.inputView = MaritalStatusPicker;
    txtMaritalStatus.inputAccessoryView = DoneButtonViewMaritalStatus;
    
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
    LicenseStatePicker.tag = 5;
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
    
    //Relation List
    UIToolbar *DoneButtonViewRelationList = [[UIToolbar alloc] init];
    DoneButtonViewRelationList.barStyle = UIBarStyleBlack;
    DoneButtonViewRelationList.translucent = YES;
    DoneButtonViewRelationList.tintColor = nil;
    [DoneButtonViewRelationList sizeToFit];
    UIBarButtonItem *doneButtonRelationList = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(RelationListDonePressed:)];
    [DoneButtonViewRelationList setItems:[NSArray arrayWithObjects:doneButtonRelationList, nil]];
    
    UIPickerView *RelationPicker1 = [[UIPickerView alloc] initWithFrame:CGRectZero];
    RelationPicker = RelationPicker1;
    RelationPicker.tag = 6;
    RelationPicker.dataSource = self;
    RelationPicker.delegate = self;
    RelationPicker.showsSelectionIndicator = YES;
    txtRelationApplicant.inputView = RelationPicker;
    txtRelationApplicant.inputAccessoryView = DoneButtonViewRelationList;
    
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
    txtIncomeLevel.inputView = AnnualIncomeListPicker;
    txtIncomeLevel.inputAccessoryView = DoneButtonViewAnnualIncomeList;
}

-(void)LoadData{
    //get vehicle info
    Globals *tmp = [Globals sharedSingleton];
    self.managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *_fetchReqE = [[NSFetchRequest alloc] init];
    _fetchReqE.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"driverID =='", tmp.currentDriverID, @"'", nil]];
    NSEntityDescription *entityE = [NSEntityDescription entityForName:@"QuoteDriver" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqE setEntity:entityE];
    
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:_fetchReqE error:nil];
    
    for (NSManagedObject *info in fetchedObjects)
    {
        QuoteDriver *qa = (QuoteDriver *)info;
        txtFirstName.text = qa.firstName;
        txtLastName.text = qa.lastName;
        txtMiddleInitial.text = qa.middleInitial;
        txtDateBirth.text = qa.dateBirth;
        txtGender.text = qa.gender;
        txtMaritalStatus.text = qa.maritalStatus;
        txtRelationApplicant.text = qa.relationApplicant;
        txtDependents.text = qa.dependents;
        txtLicenseState.text = qa.licenseState;
        txtLicenseNum.text = qa.licenseNum;
        txtOccupation.text = qa.occupation;
        txtIncomeLevel.text = qa.incomeLevel;
        
        IncomeLevelValue = qa.incomeLevelValue;
        LicenseStateValue = qa.licenseStateValue;
        OccupationValue = qa.occupationValue;
        RelationApplicantValue = qa.relationApplicantValue;
        
        if([qa.gender isEqualToString:@"M"]){
            GenderSlider.value = 0.0f;
            Gender = qa.gender;
            GenderSelected = YES;
        }
        if([qa.gender isEqualToString:@"F"]){
            GenderSlider.value = 10.0f;
            Gender = qa.gender;
            GenderSelected = YES;
        }
        
        if([qa.maritalStatus isEqualToString:@"M"]){
            MaritalStatusSlider.value = 0.0f;
            MaritalStatus = qa.maritalStatus;
            MaritalStatusSelected = YES;
        }
        if([qa.maritalStatus isEqualToString:@"S"]){
            MaritalStatusSlider.value = 10.0f;
            MaritalStatus = qa.maritalStatus;
            MaritalStatusSelected = YES;
        }
        
        if([qa.dependents isEqualToString:@"Y"]){
            DependentsSlider.value = 0.0f;
            HasDependents = qa.dependents;
            DependentsSelected = YES;
        }
        
        if([qa.dependents isEqualToString:@"N"]){
            DependentsSlider.value = 10.0f;
            HasDependents = qa.dependents;
            DependentsSelected = YES;
        }
    }
    
}


//- (IBAction)DependentYesPressed:(id)sender {
//    UIColor *darkBlueColor = [UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
//    self.DependentYesButton.backgroundColor = darkBlueColor;
//    self.DependentNoButton.backgroundColor = [UIColor whiteColor];
//    [self.DependentYesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.DependentNoButton setTitleColor:darkBlueColor forState:UIControlStateNormal];
//    HasDependents = @"Y";
//    DependentsSelected = YES;
//}

//- (IBAction)DependentNoPressed:(id)sender {
//    UIColor *darkBlueColor = [UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
//    self.DependentYesButton.backgroundColor = [UIColor whiteColor];
//    self.DependentNoButton.backgroundColor = darkBlueColor;
//    [self.DependentYesButton setTitleColor:darkBlueColor forState:UIControlStateNormal];
//    [self.DependentNoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    HasDependents = @"N";
//    DependentsSelected = YES;
//}

//-(IBAction)MaritalStatusMPressed:(id)sender{
//    UIColor *darkBlueColor = [UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
//    self.MaritalStatusSButton.backgroundColor = [UIColor whiteColor];
//    self.MaritalStatusMButton.backgroundColor = darkBlueColor;
//    [self.MaritalStatusSButton setTitleColor:darkBlueColor forState:UIControlStateNormal];
//    [self.MaritalStatusMButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    MaritalStatus = @"M";
//    MaritalStatusSelected = YES;
//}
//
//-(IBAction)MaritalStatusSPressed:(id)sender{
//    UIColor *darkBlueColor = [UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
//    self.MaritalStatusMButton.backgroundColor = [UIColor whiteColor];
//    self.MaritalStatusSButton.backgroundColor = darkBlueColor;
//    [self.MaritalStatusMButton setTitleColor:darkBlueColor forState:UIControlStateNormal];
//    [self.MaritalStatusSButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    MaritalStatus = @"S";
//    MaritalStatusSelected = YES;
//}

//-(IBAction)GenderFPressed:(id)sender{
//    UIColor *darkBlueColor = [UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
//    self.GenderMStatusButton.backgroundColor = [UIColor whiteColor];
//    self.GenderFStatusButton.backgroundColor = darkBlueColor;
//    [self.GenderMStatusButton setTitleColor:darkBlueColor forState:UIControlStateNormal];
//    [self.GenderFStatusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    Gender = @"F";
//    GenderSelected = YES;
//}
//
//-(IBAction)GenderMPressed:(id)sender{
//    UIColor *darkBlueColor = [UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
//    self.GenderFStatusButton.backgroundColor = [UIColor whiteColor];
//    self.GenderMStatusButton.backgroundColor = darkBlueColor;
//    [self.GenderFStatusButton setTitleColor:darkBlueColor forState:UIControlStateNormal];
//    [self.GenderMStatusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    Gender = @"M";
//    GenderSelected = YES;
//}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(pickerView.tag == 1){
        txtMaritalStatus.text = [arrayMaritalStatusList objectAtIndex:row];
    }
    if(pickerView.tag == 2){
        txtOccupation.text = [arrOccupationList objectAtIndex:row];
        OccupationValue = [arrOccupationListValue objectAtIndex:row];
    }
    if(pickerView.tag == 3){
        txtEmploymentStatus.text = [arrEmploymentList objectAtIndex:row];
        
    }
    if(pickerView.tag == 4){
        txtIncomeLevel.text = [arrAnnualIncomeList objectAtIndex:row];
        AnnualIncomeValue = [arrAnnualIncomeListValue objectAtIndex:row];
    }
    if(pickerView.tag == 5){
        txtLicenseState.text = [arrayLicenseState objectAtIndex:row];
        LicenseStateValue = [arrayLicenseStateValue objectAtIndex:row];
    }
    if(pickerView.tag == 6){
        txtRelationApplicant.text = [arrayRelationList objectAtIndex:row];
        RelationApplicantValue = [arrayRelationListValue objectAtIndex:row];
    }

}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(pickerView.tag == 1){
        return [arrayMaritalStatusList objectAtIndex:row];
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
    if(pickerView.tag == 5){
        return [arrayLicenseState objectAtIndex:row];
    }
    if(pickerView.tag == 6){
        return [arrayRelationList objectAtIndex:row];
    }
    else{
        return @"";
    }
    
}

- (IBAction)LicenseStateDonePressed:(id)sender {
    [txtLicenseState resignFirstResponder];
}

- (IBAction)MaritalStatusDonePressed:(id)sender {
    [txtMaritalStatus resignFirstResponder];
}

- (IBAction)OccupationListDonePressed:(id)sender{
    [txtOccupation resignFirstResponder];
}

- (IBAction)RelationListDonePressed:(id)sender{
    [txtRelationApplicant resignFirstResponder];
}

- (IBAction)EmploymentListDonePressed:(id)sender{
    [txtEmploymentStatus resignFirstResponder];
}

- (IBAction)AnnualIncomeListDonePressed:(id)sender{
    [txtIncomeLevel resignFirstResponder];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(pickerView.tag == 1){
        return [arrayMaritalStatusList count];
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
    if(pickerView.tag == 5){
        return arrayLicenseState.count;
    }
    if(pickerView.tag == 6){
        return arrayRelationList.count;
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
    
    if(![dateString isEqualToString:@""] && dateString != nil){
        txtDateBirth.text = dateString;
    }
    
    
    
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

- (void)SaveThenNextStep {
    Globals *tmp = [Globals sharedSingleton];
    
    if([txtFirstName.text isEqualToString:@""] || [txtLastName.text isEqualToString:@""]){
        txtFirstName.backgroundColor = tmp.requiredFieldColor;
        txtLastName.backgroundColor = tmp.requiredFieldColor;
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Information Needed"
                                                       message: @"Please enter the driver's first and last name"
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        alert.tag = 7;
        [alert show];
        return;
        
    }
    else{
        txtFirstName.backgroundColor = nil;
        txtLastName.backgroundColor = nil;

    }
    
    if([txtDateBirth.text isEqualToString:@""] || txtDateBirth.text == nil){
        txtDateBirth.backgroundColor = tmp.requiredFieldColor;
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Date of Birth is required"
                                                       message: @"Please enter Date of Birth"
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
        return;
    }
    else{
        txtDateBirth.backgroundColor = nil;
    }
    
    BOOL fieldMissing = NO;
    if(GenderSelected == NO || MaritalStatusSelected == NO || DependentsSelected == NO )
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Information Needed"
                                                       message: @"Please enter Gender, Marital Status, and Dependents"
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if(([txtIncomeLevel.text isEqualToString:@""] || txtIncomeLevel.text == nil)){
        txtIncomeLevel.backgroundColor = tmp.requiredFieldColor;
        fieldMissing = YES;
    }
    else{
        txtIncomeLevel.backgroundColor = nil;
    }
    
    if(([txtOccupation.text isEqualToString:@""] || txtOccupation.text == nil)){
        txtOccupation.backgroundColor = tmp.requiredFieldColor;
        fieldMissing = YES;
    }
    else{
        txtOccupation.backgroundColor = nil;
    }
    
    if(([txtLicenseNum.text isEqualToString:@""] || txtLicenseNum.text == nil)){
        txtLicenseNum.backgroundColor = tmp.requiredFieldColor;
        fieldMissing = YES;
    }
    else{
        txtLicenseNum.backgroundColor = nil;
    }
    
    if(([txtLicenseState.text isEqualToString:@""] || txtLicenseState.text == nil)){
        txtLicenseState.backgroundColor = tmp.requiredFieldColor;
        fieldMissing = YES;
    }
    else{
        txtLicenseState.backgroundColor = nil;
    }
    
    if(([txtRelationApplicant.text isEqualToString:@""] || txtRelationApplicant.text == nil)){
        txtRelationApplicant.backgroundColor = tmp.requiredFieldColor;
        fieldMissing = YES;
    }
    else{
        txtRelationApplicant.backgroundColor = nil;
    }
    
    if(fieldMissing == YES){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Information Needed"
                                                       message: @"Please enter information in the fields highlighted"
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    self.managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *_fetchReqE = [[NSFetchRequest alloc] init];
    _fetchReqE.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"quoteID == '", tmp.currentQuoteGuid, @"'", nil]];
    NSEntityDescription *entityE = [NSEntityDescription entityForName:@"Quotes" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqE setEntity:entityE];
    
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:_fetchReqE error:nil];
    
    for (NSManagedObject *info in fetchedObjects)
    {
        currentQuote = (Quotes *)info;
    }
    
    NSFetchRequest *_fetchReqD = [[NSFetchRequest alloc] init];
    _fetchReqD.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"driverID == '", tmp.currentDriverID, @"'", nil]];
    NSEntityDescription *entityD = [NSEntityDescription entityForName:@"QuoteDriver" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqD setEntity:entityD];
    
    NSArray *fetchedObjectsD = [self.managedObjectContext executeFetchRequest:_fetchReqD error:nil];
    
    if(![tmp.createNewDriver isEqualToString:@"YES"]){
        for (NSManagedObject *info in fetchedObjectsD)
        {
            QuoteDriver *driver = (QuoteDriver *)info;
            driver.firstName = txtFirstName.text;
            driver.lastName = txtLastName.text;
            driver.middleInitial = txtMiddleInitial.text;
            driver.dateBirth = txtDateBirth.text;
            driver.gender = Gender;
            driver.maritalStatus = MaritalStatus;
            driver.relationApplicant = txtRelationApplicant.text;
            driver.relationApplicantValue = RelationApplicantValue;
            driver.dependents = HasDependents;
            driver.licenseState = txtLicenseState.text;
            driver.licenseStateValue = LicenseStateValue;
            driver.licenseNum = txtLicenseNum.text;
            driver.occupation = txtOccupation.text;
            driver.occupationValue = OccupationValue;
            driver.incomeLevel = txtIncomeLevel.text;
            driver.incomeLevelValue = AnnualIncomeValue;
            driver.infoNeeded = @"";
        }
        currentQuote.quoteStatus = @"In Progress";
        [self.managedObjectContext save:nil];
    }

    if([tmp.createNewDriver isEqualToString:@"YES"]){
        NSString *guid = tmp.GetUUID;
        tmp.currentDriverID = guid;
        
        QuoteDriver *qa = [NSEntityDescription insertNewObjectForEntityForName:@"QuoteDriver" inManagedObjectContext:self.managedObjectContext];
        qa.firstName = txtFirstName.text;
        qa.lastName = txtLastName.text;
        qa.middleInitial = txtMiddleInitial.text;
        qa.dateBirth = txtDateBirth.text;
        qa.gender = Gender;
        qa.maritalStatus = MaritalStatus;
        qa.relationApplicant = txtRelationApplicant.text;
        qa.relationApplicantValue = RelationApplicantValue;
        qa.dependents = HasDependents;
        qa.licenseState = txtLicenseState.text;
        qa.licenseStateValue = LicenseStateValue;
        qa.licenseNum = txtLicenseNum.text;
        qa.occupation = txtOccupation.text;
        qa.occupationValue = OccupationValue;
        qa.incomeLevel = txtIncomeLevel.text;
        qa.incomeLevelValue = AnnualIncomeValue;
        qa.quoteID = tmp.currentQuoteGuid;
        qa.completed = [NSNumber numberWithInt:1];
        //qa.quotes = currentQuote;
        qa.driverID = guid;
        qa.infoNeeded = @"";
        
        tmp.createNewDriver = @"";
        
        [currentQuote addQuoteDriverObject:qa];
        currentQuote.quoteStatus = @"In Progress";
        
        [self.managedObjectContext save:nil];  // write to database
    }
    
    if([tmp QuoteReadyForReview:tmp.currentQuoteGuid]){
        [(QuoteUITabBarController *)self.tabBarController EnableReviewButton];
    }
    
    [[self.navigationController popViewControllerAnimated:YES] viewWillAppear:YES];
}

- (void)MaritalStatusSliderEditingDidEnd:(NSNotification *)notification{
    if(MaritalStatusSlider.value < 5.0f){
        MaritalStatusSlider.value = 0.0f;
        MaritalStatus = @"M";
        MaritalStatusSelected = YES;
    }
    if(MaritalStatusSlider.value > 5.0f){
        MaritalStatusSlider.value = 10.0f;
        MaritalStatus = @"S";
        MaritalStatusSelected = YES;
    }
}

- (void)GenderSliderEditingDidEnd:(NSNotification *)notification{
    if(GenderSlider.value < 5.0f){
        GenderSlider.value = 0.0f;
        Gender = @"M";
        GenderSelected = YES;
    }
    if(GenderSlider.value > 5.0f){
        GenderSlider.value = 10.0f;
        Gender = @"F";
        GenderSelected = YES;
    }
}

- (void)DependentsSliderEditingDidEnd:(NSNotification *)notification{
    if(DependentsSlider.value < 5.0f){
        DependentsSlider.value = 0.0f;
        HasDependents = @"Y";
        DependentsSelected = YES;
    }
    if(DependentsSlider.value > 5.0f){
        DependentsSlider.value = 10.0f;
        HasDependents = @"N";
        DependentsSelected = YES;
    }
}

- (void)CancelAddDriver{
    txtFirstName.text = @"";
    txtLastName.text = @"";
    txtMiddleInitial.text = @"";
    txtDateBirth.text = @"";
    txtGender.text = @"";
    txtMaritalStatus.text = @"";
    txtRelationApplicant.text = @"";
    txtDependents.text = @"";
    txtLicenseState.text = @"";
    txtLicenseNum.text = @"";
    txtOccupation.text = @"";
    txtIncomeLevel.text = @"";

    [[self.navigationController popViewControllerAnimated:YES] viewWillAppear:YES];

}



@end
