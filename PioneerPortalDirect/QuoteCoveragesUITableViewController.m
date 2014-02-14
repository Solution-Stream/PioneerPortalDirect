//
//  QuoteCoveragesUITableViewController.m
//  PortalDirect
//
//  Created by Brian Kalski on 8/14/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import "QuoteCoveragesUITableViewController.h"
#import "QuoteUITabBarController.h"
#import "Quotes.h"
#import "QuoteApplicant.h"
#import "QuoteCoverages.h"
#import "QuoteListTableViewController.h"
#import "Globals.h"
#import "DropdownData.h"

@interface QuoteCoveragesUITableViewController ()

@end

@implementation QuoteCoveragesUITableViewController
@synthesize currentQuote,txtBodilyInjury,txtMedicalProvider,txtMiniTort,txtPersonalInjuryProtection,txtPropertyDamage,txtPropertyProtection,txtUnderinsuredMotorist,txtUninsuredMotorist;

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

- (UIView *)pickerView:(UIPickerView *)pickerView

            viewForRow:(NSInteger)row

          forComponent:(NSInteger)component

           reusingView:(UIView *)view {
    
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        pickerLabel = [[UILabel alloc] init];
        
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        
    }
        
    if([pickerView isEqual:BodilyInjuryPicker]){
        [pickerLabel setText:[arrBodilyInjury objectAtIndex:row]];
        pickerLabel.font = [UIFont boldSystemFontOfSize:16.0];
    }
    if([pickerView isEqual:PersonalInjuryProtectionPicker]){
        [pickerLabel setText:[arrPersonalInjuryProtection objectAtIndex:row]];
        pickerLabel.font = [UIFont boldSystemFontOfSize:16.0];
    }
    if([pickerView isEqual:MedicalProviderPicker]){
        [pickerLabel setText:[arrMedicalProvider objectAtIndex:row]];
        pickerLabel.font = [UIFont boldSystemFontOfSize:16.0];
    }
    if([pickerView isEqual:PropertyDamagePicker]){
        [pickerLabel setText:[arrPropertyDamage objectAtIndex:row]];
        pickerLabel.font = [UIFont boldSystemFontOfSize:16.0];
    }
    if([pickerView isEqual:UninsuredMotoristPicker]){
        [pickerLabel setText:[arrUninsured objectAtIndex:row]];
        pickerLabel.font = [UIFont boldSystemFontOfSize:16.0];
    }
    if([pickerView isEqual:UnderInsuredMotoristPicker]){
        [pickerLabel setText:[arrUnderinsured objectAtIndex:row]];
        pickerLabel.font = [UIFont boldSystemFontOfSize:16.0];
    }
    if([pickerView isEqual:MiniTortPicker]){
        [pickerLabel setText:[arrMiniTort objectAtIndex:row]];
        pickerLabel.font = [UIFont boldSystemFontOfSize:16.0];
    }
    if([pickerView isEqual:PropertyProtectionPicker]){
        [pickerLabel setText:[arrPropertyProtection objectAtIndex:row]];
        pickerLabel.font = [UIFont boldSystemFontOfSize:16.0];
    }

    
    
    return pickerLabel;
    
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    [self StartupFunctions];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self StartupFunctions];
}

-(void)StartupFunctions{
    Globals *tmp = [Globals sharedSingleton];
    
    saveStatus = @"";
    
    arrBodilyInjury = [[NSMutableArray alloc] init];
    arrBodilyInjuryValue = [[NSMutableArray alloc] init];
    arrMedicalProvider = [[NSMutableArray alloc] init];
    arrMedicalProviderValue = [[NSMutableArray alloc] init];
    arrMiniTort = [[NSMutableArray alloc] init];
    arrMiniTortValue = [[NSMutableArray alloc] init];
    arrUnderinsured = [[NSMutableArray alloc] init];
    arrUnderinsuredValue = [[NSMutableArray alloc] init];
    arrUninsured = [[NSMutableArray alloc] init];
    arrUninsuredValue = [[NSMutableArray alloc] init];
    arrPropertyDamage = [[NSMutableArray alloc] init];
    arrPropertyDamageValue = [[NSMutableArray alloc] init];
    arrPropertyProtection = [[NSMutableArray alloc] init];
    arrPropertyProtectionValue = [[NSMutableArray alloc] init];
    arrPersonalInjuryProtection = [[NSMutableArray alloc] init];
    arrPersonalInjuryProtectionValue = [[NSMutableArray alloc] init];
    
    [arrBodilyInjury addObject:@""];
    [arrBodilyInjuryValue addObject:@""];
    [arrMedicalProvider addObject:@""];
    [arrMedicalProviderValue addObject:@""];
    [arrMiniTort addObject:@""];
    [arrMiniTortValue addObject:@""];
    [arrUnderinsured addObject:@""];
    [arrUnderinsuredValue addObject:@""];
    [arrUninsured addObject:@""];
    [arrUninsuredValue addObject:@""];
    [arrPropertyDamage addObject:@""];
    [arrPropertyDamageValue addObject:@""];
    [arrPropertyProtection addObject:@""];
    [arrPropertyProtectionValue addObject:@""];
    [arrPersonalInjuryProtection addObject:@""];
    [arrPersonalInjuryProtectionValue addObject:@""];
    
    txtBodilyInjury.delegate = (id)self;
    txtMedicalProvider.delegate = (id)self;
    txtMiniTort.delegate = (id)self;
    txtPersonalInjuryProtection.delegate = (id)self;
    txtPropertyDamage.delegate = (id)self;
    txtPropertyProtection.delegate = (id)self;
    txtUnderinsuredMotorist.delegate = (id)self;
    txtUninsuredMotorist.delegate = (id)self;
    
    self.title = @"Auto Quote - Liability Coverages";
    CGRect frame = CGRectMake(0, 0, [self.title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f]}].width, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15.0];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    self.tabBarItem.title = @"Coverages";
    label.text = self.title;
    
    [self.navigationController setToolbarHidden:YES];
    
//    UIBarButtonItem *buttonSave = [[UIBarButtonItem alloc] initWithTitle:@"Save Quote"
//                                                                   style:UIBarButtonItemStyleBordered
//                                                                  target: self
//                                                                  action:@selector(SaveQuote:) ];
//    
//    UIBarButtonItem *buttonSubmit = [[UIBarButtonItem alloc] initWithTitle:@"Review Quote"
//                                                                     style:UIBarButtonItemStyleBordered
//                                                                    target: self
//                                                                    action:@selector(ReviewQuote:) ];
//    
//    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
//                                                                              target:nil
//                                                                              action:nil];
//    self.toolbarItems = nil;
//    
//    self.toolbarItems = [ NSArray arrayWithObjects: flexible, buttonSave, buttonSubmit, flexible, nil ];
    
    [self LoadData];
    
    //Load dropdown arrays
    self.managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *_fetchReqBI = [[NSFetchRequest alloc] init];
    _fetchReqBI.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"name =='", @"BI_CSL_LIMIT", @"'", nil]];
    NSEntityDescription *entityBI = [NSEntityDescription entityForName:@"DropdownData" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqBI setEntity:entityBI];
    //sorting
    NSSortDescriptor* sortDescriptorBI = [[NSSortDescriptor alloc] initWithKey:@"code" ascending: YES];
    NSArray* sortDescriptorsBI = [[NSArray alloc] initWithObjects: sortDescriptorBI, nil];
    [_fetchReqBI setSortDescriptors:sortDescriptorsBI];
    
    NSArray *arrayTempBI = [self.managedObjectContext executeFetchRequest:_fetchReqBI error:nil];
    for(int i = 0; i < [arrayTempBI count] ; i++){
        DropdownData *vt = (DropdownData*)[arrayTempBI objectAtIndex:i];
        [arrBodilyInjury addObject:vt.desc];
        [arrBodilyInjuryValue addObject:vt.code];
    }
    
    NSFetchRequest *_fetchReqMP = [[NSFetchRequest alloc] init];
    _fetchReqMP.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"name =='", @"MedicalProvider", @"'", nil]];
    NSEntityDescription *entityMP = [NSEntityDescription entityForName:@"DropdownData" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqMP setEntity:entityMP];
    //sorting
    NSSortDescriptor* sortDescriptorMP = [[NSSortDescriptor alloc] initWithKey:@"code" ascending: NO];
    NSArray* sortDescriptorsMP = [[NSArray alloc] initWithObjects: sortDescriptorMP, nil];
    [_fetchReqMP setSortDescriptors:sortDescriptorsMP];
    
    NSArray *arrayTempMP = [self.managedObjectContext executeFetchRequest:_fetchReqMP error:nil];
    for(int i = 0; i < [arrayTempMP count] ; i++){
        DropdownData *vt = (DropdownData*)[arrayTempMP objectAtIndex:i];
        [arrMedicalProvider addObject:vt.desc];
        [arrMedicalProviderValue addObject:vt.code];
    }
    
    NSFetchRequest *_fetchReqVT = [[NSFetchRequest alloc] init];
    _fetchReqVT.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"name =='", @"PROPERTY_DAMAGE", @"'", nil]];
    NSEntityDescription *entityVT = [NSEntityDescription entityForName:@"DropdownData" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqVT setEntity:entityVT];
    //sorting
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"code" ascending: YES];
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor, nil];
    [_fetchReqVT setSortDescriptors:sortDescriptors];
    
    NSArray *arrayTemp = [self.managedObjectContext executeFetchRequest:_fetchReqVT error:nil];
    for(int i = 0; i < [arrayTemp count] ; i++){
        DropdownData *vt = (DropdownData*)[arrayTemp objectAtIndex:i];
        [arrPropertyDamage addObject:vt.desc];
        [arrPropertyDamageValue addObject:vt.code];
    }
    
    NSFetchRequest *_fetchReqUM = [[NSFetchRequest alloc] init];
    _fetchReqUM.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"name =='", @"UNINSURED_LIMIT", @"'", nil]];
    NSEntityDescription *entityUM = [NSEntityDescription entityForName:@"DropdownData" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqUM setEntity:entityUM];
    //sorting
    NSSortDescriptor* sortDescriptorUM = [[NSSortDescriptor alloc] initWithKey:@"code" ascending: YES];
    NSArray* sortDescriptorsUM = [[NSArray alloc] initWithObjects: sortDescriptorUM, nil];
    [_fetchReqUM setSortDescriptors:sortDescriptorsUM];
    
    NSArray *arrayTempUM = [self.managedObjectContext executeFetchRequest:_fetchReqUM error:nil];
    for(int i = 0; i < [arrayTempUM count] ; i++){
        DropdownData *vt = (DropdownData*)[arrayTempUM objectAtIndex:i];
        [arrUninsured addObject:vt.desc];
        [arrUninsuredValue addObject:vt.code];
    }
    
    NSFetchRequest *_fetchReqUnM = [[NSFetchRequest alloc] init];
    _fetchReqUnM.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"name =='", @"UNDERINSD_LIMIT", @"'", nil]];
    NSEntityDescription *entityUnM = [NSEntityDescription entityForName:@"DropdownData" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqUnM setEntity:entityUnM];
    //sorting
    NSSortDescriptor* sortDescriptorUnM = [[NSSortDescriptor alloc] initWithKey:@"code" ascending: YES];
    NSArray* sortDescriptorsUnM = [[NSArray alloc] initWithObjects: sortDescriptorUnM, nil];
    [_fetchReqUnM setSortDescriptors:sortDescriptorsUnM];
    
    NSArray *arrayTempUnM = [self.managedObjectContext executeFetchRequest:_fetchReqUnM error:nil];
    for(int i = 0; i < [arrayTempUnM count] ; i++){
        DropdownData *vt = (DropdownData*)[arrayTempUnM objectAtIndex:i];
        [arrUnderinsured addObject:vt.desc];
        [arrUnderinsuredValue addObject:vt.code];
    }
    
    NSFetchRequest *_fetchReqMT = [[NSFetchRequest alloc] init];
    _fetchReqMT.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"name =='", @"MINI_TORT", @"'", nil]];
    NSEntityDescription *entityMT = [NSEntityDescription entityForName:@"DropdownData" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqMT setEntity:entityMT];
    //sorting
    NSSortDescriptor* sortDescriptorMT = [[NSSortDescriptor alloc] initWithKey:@"code" ascending: YES];
    NSArray* sortDescriptorsMT = [[NSArray alloc] initWithObjects: sortDescriptorMT, nil];
    [_fetchReqMT setSortDescriptors:sortDescriptorsMT];
    
    NSArray *arrayTempMT = [self.managedObjectContext executeFetchRequest:_fetchReqMT error:nil];
    for(int i = 0; i < [arrayTempMT count] ; i++){
        DropdownData *vt = (DropdownData*)[arrayTempMT objectAtIndex:i];
        [arrMiniTort addObject:vt.desc];
        [arrMiniTortValue addObject:vt.code];
    }
    
    NSFetchRequest *_fetchReqPP = [[NSFetchRequest alloc] init];
    _fetchReqPP.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"name =='", @"PROPERTY_PROTECT", @"'", nil]];
    NSEntityDescription *entityPP = [NSEntityDescription entityForName:@"DropdownData" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqPP setEntity:entityPP];
    //sorting
    NSSortDescriptor* sortDescriptorPP = [[NSSortDescriptor alloc] initWithKey:@"code" ascending: YES];
    NSArray* sortDescriptorsPP = [[NSArray alloc] initWithObjects: sortDescriptorPP, nil];
    [_fetchReqPP setSortDescriptors:sortDescriptorsPP];
    
    NSArray *arrayTempPP = [self.managedObjectContext executeFetchRequest:_fetchReqPP error:nil];
    for(int i = 0; i < [arrayTempPP count] ; i++){
        DropdownData *vt = (DropdownData*)[arrayTempPP objectAtIndex:i];
        [arrPropertyProtection addObject:vt.desc];
        [arrPropertyProtectionValue addObject:vt.code];
    }
    
    NSFetchRequest *_fetchReqPIP = [[NSFetchRequest alloc] init];
    _fetchReqPIP.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"name =='", @"PIP", @"'", nil]];
    NSEntityDescription *entityPIP = [NSEntityDescription entityForName:@"DropdownData" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqPIP setEntity:entityPIP];
    //sorting
    NSSortDescriptor* sortDescriptorPIP = [[NSSortDescriptor alloc] initWithKey:@"code" ascending: YES];
    NSArray* sortDescriptorsPIP = [[NSArray alloc] initWithObjects: sortDescriptorPIP, nil];
    [_fetchReqPIP setSortDescriptors:sortDescriptorsPIP];
    
    NSArray *arrayTempPIP = [self.managedObjectContext executeFetchRequest:_fetchReqPIP error:nil];
    for(int i = 0; i < [arrayTempPIP count] ; i++){
        DropdownData *vt = (DropdownData*)[arrayTempPIP objectAtIndex:i];
        [arrPersonalInjuryProtection addObject:vt.desc];
        [arrPersonalInjuryProtectionValue addObject:vt.code];
    }
    
    //PickerView assignments
    UIToolbar *DoneButtonViewBodilyInjury = [[UIToolbar alloc] init];
    DoneButtonViewBodilyInjury.barStyle = UIBarStyleBlack;
    DoneButtonViewBodilyInjury.translucent = YES;
    DoneButtonViewBodilyInjury.tintColor = nil;
    [DoneButtonViewBodilyInjury sizeToFit];
    UIBarButtonItem *doneButtonBodilyInjury = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(BodilyInjuryDonePressed:)];
    [DoneButtonViewBodilyInjury setItems:[NSArray arrayWithObjects:doneButtonBodilyInjury, nil]];
    
    UIPickerView *bodilyInjuryPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    BodilyInjuryPicker = bodilyInjuryPicker;
    BodilyInjuryPicker.tag = 6;
    BodilyInjuryPicker.dataSource = self;
    BodilyInjuryPicker.delegate = self;
    BodilyInjuryPicker.showsSelectionIndicator = YES;
    txtBodilyInjury.inputView = BodilyInjuryPicker;
    txtBodilyInjury.inputAccessoryView = DoneButtonViewBodilyInjury;
    
    UIToolbar *DoneButtonViewMedicalProvider = [[UIToolbar alloc] init];
    DoneButtonViewMedicalProvider.barStyle = UIBarStyleBlack;
    DoneButtonViewMedicalProvider.translucent = YES;
    DoneButtonViewMedicalProvider.tintColor = nil;
    [DoneButtonViewMedicalProvider sizeToFit];
    UIBarButtonItem *doneButtonMedicalProvider = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(MedicalProviderDonePressed:)];
    [DoneButtonViewMedicalProvider setItems:[NSArray arrayWithObjects:doneButtonMedicalProvider, nil]];
    
    UIPickerView *medicalProviderPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    MedicalProviderPicker = medicalProviderPicker;
    MedicalProviderPicker.tag = 7;
    MedicalProviderPicker.dataSource = self;
    MedicalProviderPicker.delegate = self;
    MedicalProviderPicker.showsSelectionIndicator = YES;
    txtMedicalProvider.inputView = MedicalProviderPicker;
    txtMedicalProvider.inputAccessoryView = DoneButtonViewMedicalProvider;
    
    UIToolbar *DoneButtonViewPropertyDamage = [[UIToolbar alloc] init];
    DoneButtonViewPropertyDamage.barStyle = UIBarStyleBlack;
    DoneButtonViewPropertyDamage.translucent = YES;
    DoneButtonViewPropertyDamage.tintColor = nil;
    [DoneButtonViewPropertyDamage sizeToFit];
    UIBarButtonItem *doneButtonPropertyDamage = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(PropertyDamageDonePressed:)];
    [DoneButtonViewPropertyDamage setItems:[NSArray arrayWithObjects:doneButtonPropertyDamage, nil]];
    
    UIPickerView *propertyDamagePicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    PropertyDamagePicker = propertyDamagePicker;
    PropertyDamagePicker.tag = 1;
    PropertyDamagePicker.dataSource = self;
    PropertyDamagePicker.delegate = self;
    PropertyDamagePicker.showsSelectionIndicator = YES;
    txtPropertyDamage.inputView = PropertyDamagePicker;
    txtPropertyDamage.inputAccessoryView = DoneButtonViewPropertyDamage;
    
    
    UIToolbar *DoneButtonViewUninsured = [[UIToolbar alloc] init];
    DoneButtonViewUninsured.barStyle = UIBarStyleBlack;
    DoneButtonViewUninsured.translucent = YES;
    DoneButtonViewUninsured.tintColor = nil;
    [DoneButtonViewUninsured sizeToFit];
    UIBarButtonItem *doneButtonUninsured = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(UninsuredDonePressed:)];
    [DoneButtonViewUninsured setItems:[NSArray arrayWithObjects:doneButtonUninsured, nil]];
    
    UIPickerView *uninsuredPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    UninsuredMotoristPicker = uninsuredPicker;
    UninsuredMotoristPicker.tag = 2;
    UninsuredMotoristPicker.dataSource = self;
    UninsuredMotoristPicker.delegate = self;
    UninsuredMotoristPicker.showsSelectionIndicator = YES;
    txtUninsuredMotorist.inputView = UninsuredMotoristPicker;
    txtUninsuredMotorist.inputAccessoryView = DoneButtonViewUninsured;
    
    
    UIToolbar *DoneButtonViewUnderInsured = [[UIToolbar alloc] init];
    DoneButtonViewUnderInsured.barStyle = UIBarStyleBlack;
    DoneButtonViewUnderInsured.translucent = YES;
    DoneButtonViewUnderInsured.tintColor = nil;
    [DoneButtonViewUnderInsured sizeToFit];
    UIBarButtonItem *doneButtonUnderInsured = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(UnderInsuredDonePressed:)];
    [DoneButtonViewUnderInsured setItems:[NSArray arrayWithObjects:doneButtonUnderInsured, nil]];
    
    UIPickerView *propertyUnderInsured = [[UIPickerView alloc] initWithFrame:CGRectZero];
    UnderInsuredMotoristPicker = propertyUnderInsured;
    UnderInsuredMotoristPicker.tag = 3;
    UnderInsuredMotoristPicker.dataSource = self;
    UnderInsuredMotoristPicker.delegate = self;
    UnderInsuredMotoristPicker.showsSelectionIndicator = YES;
    txtUnderinsuredMotorist.inputView = UnderInsuredMotoristPicker;
    txtUnderinsuredMotorist.inputAccessoryView = DoneButtonViewUnderInsured;
    
    
    UIToolbar *DoneButtonViewMiniTort = [[UIToolbar alloc] init];
    DoneButtonViewMiniTort.barStyle = UIBarStyleBlack;
    DoneButtonViewMiniTort.translucent = YES;
    DoneButtonViewMiniTort.tintColor = nil;
    [DoneButtonViewMiniTort sizeToFit];
    UIBarButtonItem *doneButtonMiniTort = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(MiniTortDonePressed:)];
    [DoneButtonViewMiniTort setItems:[NSArray arrayWithObjects:doneButtonMiniTort, nil]];
    
    UIPickerView *propertyMiniTort = [[UIPickerView alloc] initWithFrame:CGRectZero];
    MiniTortPicker = propertyMiniTort;
    MiniTortPicker.tag = 4;
    MiniTortPicker.dataSource = self;
    MiniTortPicker.delegate = self;
    MiniTortPicker.showsSelectionIndicator = YES;
    txtMiniTort.inputView = MiniTortPicker;
    txtMiniTort.inputAccessoryView = DoneButtonViewMiniTort;
    
    
    UIToolbar *DoneButtonViewPropertyProtection = [[UIToolbar alloc] init];
    DoneButtonViewPropertyProtection.barStyle = UIBarStyleBlack;
    DoneButtonViewPropertyProtection.translucent = YES;
    DoneButtonViewPropertyProtection.tintColor = nil;
    [DoneButtonViewPropertyProtection sizeToFit];
    UIBarButtonItem *doneButtonPropertyProtection = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(PropertyProtectionDonePressed:)];
    [DoneButtonViewPropertyProtection setItems:[NSArray arrayWithObjects:doneButtonPropertyProtection, nil]];
    
    UIPickerView *propertyProtectionPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    PropertyProtectionPicker = propertyProtectionPicker;
    PropertyProtectionPicker.tag = 5;
    PropertyProtectionPicker.dataSource = self;
    PropertyProtectionPicker.delegate = self;
    PropertyProtectionPicker.showsSelectionIndicator = YES;
    txtPropertyProtection.inputView = PropertyProtectionPicker;
    txtPropertyProtection.inputAccessoryView = DoneButtonViewPropertyProtection;
    
    
    UIToolbar *DoneButtonViewPersonalInjuryProtection = [[UIToolbar alloc] init];
    DoneButtonViewPersonalInjuryProtection.barStyle = UIBarStyleBlack;
    DoneButtonViewPersonalInjuryProtection.translucent = YES;
    DoneButtonViewPersonalInjuryProtection.tintColor = nil;
    [DoneButtonViewPersonalInjuryProtection sizeToFit];
    UIBarButtonItem *doneButtonPersonalInjuryProtection = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(PersonalInjuryProtectionDonePressed:)];
    [DoneButtonViewPersonalInjuryProtection setItems:[NSArray arrayWithObjects:doneButtonPersonalInjuryProtection, nil]];
    
    UIPickerView *personalInjuryProtectionPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    PersonalInjuryProtectionPicker = personalInjuryProtectionPicker;
    PersonalInjuryProtectionPicker.tag = 8;
    PersonalInjuryProtectionPicker.dataSource = self;
    PersonalInjuryProtectionPicker.delegate = self;
    PersonalInjuryProtectionPicker.showsSelectionIndicator = YES;
    txtPersonalInjuryProtection.inputView = PersonalInjuryProtectionPicker;
    txtPersonalInjuryProtection.inputAccessoryView = DoneButtonViewPersonalInjuryProtection;
    
    [self SetTabBarImages];
}

-(void)BodilyInjuryDonePressed:(id)sender{
    [txtBodilyInjury resignFirstResponder];
}

-(void)MedicalProviderDonePressed:(id)sender{
    [txtMedicalProvider resignFirstResponder];
}

-(void)PropertyDamageDonePressed:(id)sender{
    [txtPropertyDamage resignFirstResponder];
}

-(void)PropertyProtectionDonePressed:(id)sender{
    [txtPropertyProtection resignFirstResponder];
}

-(void)UninsuredDonePressed:(id)sender{
    [txtUninsuredMotorist resignFirstResponder];
}

-(void)UnderInsuredDonePressed:(id)sender{
    [txtUnderinsuredMotorist resignFirstResponder];
}

-(void)MiniTortDonePressed:(id)sender{
    [txtMiniTort resignFirstResponder];
}

-(void)PersonalInjuryProtectionDonePressed:(id)sender{
    [txtPersonalInjuryProtection resignFirstResponder];
}

-(void)LoadData{
    //get vehicle info
    Globals *tmp = [Globals sharedSingleton];
    self.managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *_fetchReqE = [[NSFetchRequest alloc] init];
    _fetchReqE.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"quoteID =='", tmp.currentQuoteGuid, @"'", nil]];
    NSEntityDescription *entityE = [NSEntityDescription entityForName:@"QuoteCoverages" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqE setEntity:entityE];
    
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:_fetchReqE error:nil];
    
    for (NSManagedObject *info in fetchedObjects)
    {
        QuoteCoverages *app = (QuoteCoverages *)info;
        if(app.medicalProviderValue != nil) {medicalProviderValue = [NSMutableString stringWithString:app.medicalProviderValue];}else{txtMedicalProvider.text = @"";}
        if(app.bodilyInjuryValue != nil) {bodilyInjuryValue = [NSMutableString stringWithString:app.bodilyInjuryValue];}else{txtBodilyInjury.text = @"";}
        if(app.miniTortValue != nil) {miniTortValue = [NSMutableString stringWithString:app.miniTortValue];}else{txtMiniTort.text = @"";}
        if(app.personalInjuryProtectionValue != nil) {personalInjuryProtectionValue = [NSMutableString stringWithString:app.personalInjuryProtectionValue];}else{txtPersonalInjuryProtection.text = @"";}
        if(app.propertyDamage != nil) {propertyDamageValue = [NSMutableString stringWithString:app.propertyDamageValue];}else{txtPropertyDamage.text = @"";}
        if(app.propertyProtectionValue != nil) {propertyProtectionValue = [NSMutableString stringWithString:app.propertyProtectionValue];}else{txtPropertyProtection.text = @"";}
        if(app.underinsuredMotoristValue != nil) {underinsuredValue = [NSMutableString stringWithString:app.underinsuredMotoristValue];}else{txtUnderinsuredMotorist.text = @"";}
        if(app.uninsuredMotoristValue != nil) {uninsuredValue = [NSMutableString stringWithString:app.uninsuredMotoristValue];}else{txtUninsuredMotorist.text = @"";}
        
        txtMedicalProvider.text = app.medicalProvider;
        txtBodilyInjury.text = app.bodilyInjury;
        txtMiniTort.text = app.miniTort;
        txtPersonalInjuryProtection.text = app.personalInjuryProtection;
        txtPropertyDamage.text = app.propertyDamage;
        txtPropertyProtection.text = app.propertyProtection;
        txtUnderinsuredMotorist.text = app.underinsuredMotorist;
        txtUninsuredMotorist.text = app.uninsuredMotorist;
    }
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
   if(pickerView.tag == 1){
        return [arrPropertyDamage count];
    }
    if(pickerView.tag == 2){
        return [arrUninsured count];
    }
    if(pickerView.tag == 3){
        return [arrUnderinsured count];
    }
    if(pickerView.tag == 4){
        return [arrMiniTort count];
    }
    if(pickerView.tag == 5){
        return [arrPropertyProtection count];
    }
    if(pickerView.tag == 6){
        return [arrBodilyInjury count];
    }
    if(pickerView.tag == 7){
        return [arrMedicalProvider count];
    }
    if(pickerView.tag == 8){
        return [arrPersonalInjuryProtection count];
    }
    else{
        return 0;
    }
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(pickerView.tag == 1){
        return [arrPropertyDamage objectAtIndex:row];
    }
    if(pickerView.tag == 2){
        return [arrUninsured objectAtIndex:row];
    }
    if(pickerView.tag == 3){
        return [arrUnderinsured objectAtIndex:row];
    }
    if(pickerView.tag == 4){
        return [arrMiniTort objectAtIndex:row];
    }
    if(pickerView.tag == 5){
        return [arrPropertyProtection objectAtIndex:row];
    }
    if(pickerView.tag == 6){
        return [arrBodilyInjury objectAtIndex:row];
    }
    if(pickerView.tag == 7){
        return [arrMedicalProvider objectAtIndex:row];
    }
    if(pickerView.tag == 8){
        return [arrPersonalInjuryProtection objectAtIndex:row];
    }
    else{
        return @"";
    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(pickerView.tag == 1){
        txtPropertyDamage.text = [arrPropertyDamage objectAtIndex:row];
        propertyDamageValue = [arrPropertyDamageValue objectAtIndex:row];
    }
    if(pickerView.tag == 2){
        txtUninsuredMotorist.text = [arrUninsured objectAtIndex:row];
        uninsuredValue = [arrUninsuredValue objectAtIndex:row];
    }
    if(pickerView.tag == 3){
        txtUnderinsuredMotorist.text = [arrUnderinsured objectAtIndex:row];
        underinsuredValue = [arrUnderinsuredValue objectAtIndex:row];
    }
    if(pickerView.tag == 4){
        txtMiniTort.text = [arrMiniTort objectAtIndex:row];
        miniTortValue = [arrMiniTortValue objectAtIndex:row];
    }
    if(pickerView.tag == 5){
        txtPropertyProtection.text = [arrPropertyProtection objectAtIndex:row];
        propertyProtectionValue = [arrPropertyProtectionValue objectAtIndex:row];
    }
    if(pickerView.tag == 6){
        txtBodilyInjury.text = [arrBodilyInjury objectAtIndex:row];
        bodilyInjuryValue = [arrBodilyInjuryValue objectAtIndex:row];
    }
    if(pickerView.tag == 7){
        txtMedicalProvider.text = [arrMedicalProvider objectAtIndex:row];
        medicalProviderValue = [arrMedicalProviderValue objectAtIndex:row];
    }
    if(pickerView.tag == 8){
        txtPersonalInjuryProtection.text = [arrPersonalInjuryProtection objectAtIndex:row];
        personalInjuryProtectionValue = [arrPersonalInjuryProtectionValue objectAtIndex:row];
    }
}

    
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)SaveQuote:(id)sender{
       
    Globals *tmp = [Globals sharedSingleton];
    
    if([txtBodilyInjury.text isEqualToString:@""] ||
       [txtMedicalProvider.text isEqualToString:@""] ||
       [txtMiniTort.text isEqualToString:@""] ||
       [txtPersonalInjuryProtection.text isEqualToString:@""] ||
       [txtPropertyDamage.text isEqualToString:@""] ||
       [txtPropertyProtection.text isEqualToString:@""] ||
       [txtUnderinsuredMotorist.text isEqualToString:@""] ||
       [txtUninsuredMotorist.text isEqualToString:@""]
       ){
        txtBodilyInjury.backgroundColor = tmp.requiredFieldColor;
        txtMedicalProvider.backgroundColor = tmp.requiredFieldColor;
        txtMiniTort.backgroundColor = tmp.requiredFieldColor;
        txtPersonalInjuryProtection.backgroundColor = tmp.requiredFieldColor;
        txtPropertyDamage.backgroundColor = tmp.requiredFieldColor;
        txtPropertyProtection.backgroundColor = tmp.requiredFieldColor;
        txtUnderinsuredMotorist.backgroundColor = tmp.requiredFieldColor;
        txtUninsuredMotorist.backgroundColor = tmp.requiredFieldColor;
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Information Needed"
                                                       message: @"Please enter the coverage information"
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        alert.tag = 7;
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
        
    NSFetchRequest *_fetchReqE2 = [[NSFetchRequest alloc] init];
    _fetchReqE2.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"quoteID == '", tmp.currentQuoteGuid, @"'", nil]];
    NSEntityDescription *entityE2 = [NSEntityDescription entityForName:@"QuoteCoverages" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqE2 setEntity:entityE2];
    
    NSArray *fetchedObjects2 = [self.managedObjectContext executeFetchRequest:_fetchReqE error:nil];
    
    Quotes *quote1 = (Quotes *)fetchedObjects2[0];
    
        if(quote1.quoteCoverages != nil){
            //existing quote
            quote1.quoteCoverages.bodilyInjury = txtBodilyInjury.text;
            quote1.quoteCoverages.bodilyInjuryValue = bodilyInjuryValue;
            quote1.quoteCoverages.propertyDamage = txtPropertyDamage.text;
            quote1.quoteCoverages.propertyDamageValue = propertyDamageValue;
            quote1.quoteCoverages.medicalProvider = txtMedicalProvider.text;
            quote1.quoteCoverages.medicalProviderValue = medicalProviderValue;
            quote1.quoteCoverages.personalInjuryProtection = txtPersonalInjuryProtection.text;
            quote1.quoteCoverages.personalInjuryProtectionValue = personalInjuryProtectionValue;
            quote1.quoteCoverages.propertyDamage = txtPropertyDamage.text;
            quote1.quoteCoverages.propertyDamageValue = propertyDamageValue;
            quote1.quoteCoverages.propertyProtection = txtPropertyProtection.text;
            quote1.quoteCoverages.propertyProtectionValue = propertyProtectionValue;
            quote1.quoteCoverages.uninsuredMotorist = txtUninsuredMotorist.text;
            quote1.quoteCoverages.uninsuredMotoristValue = uninsuredValue;
            quote1.quoteCoverages.underinsuredMotorist = txtUnderinsuredMotorist.text;
            quote1.quoteCoverages.underinsuredMotoristValue = underinsuredValue;
            quote1.quoteCoverages.miniTort = txtMiniTort.text;
            quote1.quoteCoverages.miniTortValue = miniTortValue;
            quote1.quoteCoverages.quotes = currentQuote;
    
            [self.managedObjectContext save:nil];
    
    
        }
        else{
    
            QuoteCoverages *qa = [NSEntityDescription insertNewObjectForEntityForName:@"QuoteCoverages" inManagedObjectContext:self.managedObjectContext];
            qa.bodilyInjury = txtBodilyInjury.text;
            qa.bodilyInjuryValue = bodilyInjuryValue;
            qa.propertyDamage = txtPropertyDamage.text;
            qa.propertyDamageValue = propertyDamageValue;
            qa.medicalProvider = txtMedicalProvider.text;
            qa.medicalProviderValue = medicalProviderValue;
            qa.personalInjuryProtection = txtPersonalInjuryProtection.text;
            qa.personalInjuryProtectionValue = personalInjuryProtectionValue;
            qa.propertyDamage = txtPropertyDamage.text;
            qa.propertyDamageValue = propertyDamageValue;
            qa.propertyProtection = txtPropertyProtection.text;
            qa.propertyProtectionValue = propertyProtectionValue;
            qa.uninsuredMotorist = txtUninsuredMotorist.text;
            qa.uninsuredMotoristValue = uninsuredValue;
            qa.underinsuredMotorist = txtUnderinsuredMotorist.text;
            qa.underinsuredMotoristValue = underinsuredValue;
            qa.miniTort = txtMiniTort.text;
            qa.miniTortValue = miniTortValue;
            qa.quoteID = tmp.currentQuoteGuid;
            qa.completed = [NSNumber numberWithInt:1];
            qa.quotes = currentQuote;
    
    
            [self.managedObjectContext save:nil];  // write to database
        }
        
    if([tmp QuoteReadyForReview:tmp.currentQuoteGuid]){
        [(QuoteUITabBarController *)self.tabBarController EnableReviewButton];
    }
    
    if(ProceedToDrivers == YES){
        tmp.quoteViewIndex = [NSNumber numberWithInt:1];
        QuoteUITabBarController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"QuoteTabController"];
        [self.navigationController pushViewController:svc animated:YES];
    }
    else if(ProceedToVehicles == YES){
        tmp.quoteViewIndex = [NSNumber numberWithInt:2];
        QuoteUITabBarController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"QuoteTabController"];
        [self.navigationController pushViewController:svc animated:YES];
    }
    else{
        tmp.quoteViewIndex = [NSNumber numberWithInt:4];
        QuoteUITabBarController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"QuoteTabController"];
        [self.navigationController pushViewController:svc animated:YES];
    }
    
}

- (void)SetTabBarImages{
    Globals *tmp = [Globals sharedSingleton];
    NSMutableArray *tempArray = [tmp SetTabBarImages:tmp.currentQuoteGuid];
    
    NSInteger qa = [tempArray[0] integerValue];
    NSInteger qd = [tempArray[1] integerValue];
    NSInteger qv = [tempArray[2] integerValue];
    NSInteger qc = [tempArray[3] integerValue];
    
    if(qd == 0 || qv == 0){
        //don't forward user to driver assign tab
        if(qd == 0){
            ProceedToDrivers = YES;
        }
        if(qv == 0){
            ProceedToVehicles = YES;
        }
    }
    else{
        ProceedToDrivers = NO;
        ProceedToVehicles = NO;
    }
    
    NSArray *viewControllers = [[NSArray alloc] init];
    viewControllers = self.tabBarController.viewControllers;
    //review tab
    ((UIViewController*)viewControllers[4]).tabBarItem.image = [UIImage imageNamed:@"car-side.png"];
    
    
    if((int)qa == 1){
        ((UIViewController*)viewControllers[0]).tabBarItem.image = [UIImage imageNamed:@"tick.png"];
    }
    else{
        ((UIViewController*)viewControllers[0]).tabBarItem.image = [UIImage imageNamed:@"question.png"];
    }
    
    if((int)qd == 1){
        ((UIViewController*)viewControllers[1]).tabBarItem.image = [UIImage imageNamed:@"tick.png"];
    }
    else{
        ((UIViewController*)viewControllers[1]).tabBarItem.image = [UIImage imageNamed:@"question.png"];
    }
    
    if((int)qv == 1){
        ((UIViewController*)viewControllers[2]).tabBarItem.image = [UIImage imageNamed:@"tick.png"];
    }
    else{
        ((UIViewController*)viewControllers[2]).tabBarItem.image = [UIImage imageNamed:@"question.png"];
    }
    
    if((int)qc == 1){
        ((UIViewController*)viewControllers[3]).tabBarItem.image = [UIImage imageNamed:@"tick.png"];
    }
    else{
        ((UIViewController*)viewControllers[3]).tabBarItem.image = [UIImage imageNamed:@"question.png"];
    }

}



@end
