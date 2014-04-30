//
//  QuoteVehicleTableViewController.m
//  PortalDirect
//
//  Created by Brian Kalski on 8/26/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import "QuoteVehicleTableViewController.h"
#import "QuoteVehicleListUITableViewController.h"
#import "QuoteVehicle.h"
#import "SendEmail.h"
#import "Quotes.h"
#import "JSONKit.h"
#import "DropdownData.h"
#import "QuoteUITabBarController.h"
#import "LookupVINValues.h"
#import "BarCodeViewController.h"

@interface QuoteVehicleTableViewController ()

@end

@implementation QuoteVehicleTableViewController
@synthesize txtAnnualMileage,txtAntiLockBrakes,txtAntiTheftDevice,txtCarpool,txtGaragingZipCode,txtMake,txtMilesToWork,txtModel,txtPassiveRestraints,txtSplitCity,txtVehicleType,txtVehicleUsage,txtVIN,txtWorkWeek,txtYear;
@synthesize quote,currentQuote,activityIndicator,responseData,vehicleYearPicker,vehicleUsagePicker,antiTheftPicker,bodilyInjuryPicker,vehicleTypePicker,antiLockBrakePicker,passiveRestraintPicker,daysOfWeekPicker;
@synthesize btnCancel,vehicleMakePicker,CarpoolSlider;

bool CheckVINReturnedResults;
NSMutableString *VINMake;
NSMutableString *VINModel;
NSMutableString *VINYear;
NSMutableString *VINABS_Text;
NSMutableString *VINRestraint_Text;
NSMutableString *VINABS_Value;
NSMutableString *VINRestraint_Value;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField == txtGaragingZipCode){
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 5) ? NO : YES;
    }
    else if(textField == txtModel){
        if(CheckVINReturnedResults){
            [self DetermineIfUserWantsToClearVIN];
        }
        return YES;
    }
    else{
        return YES;
    }
}

- (BOOL) validateZipCode: (NSString *) zip {
    NSString *zipRegex = @"^[0-9]{5}$";
    
    NSPredicate *zipTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", zipRegex];
    return [zipTest evaluateWithObject:zip];
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
    Globals *tmp = [Globals sharedSingleton];
    
    if([pickerView isEqual:vehicleYearPicker]){
        [pickerLabel setText:[arrVehicleYears objectAtIndex:row]];
        pickerLabel.font = [UIFont boldSystemFontOfSize:22.0];
    }
    if([pickerView isEqual:vehicleUsagePicker]){
        [pickerLabel setText:[tmp.arrVehicleUsage objectAtIndex:row]];
        pickerLabel.font = [UIFont boldSystemFontOfSize:16.0];
    }
    if([pickerView isEqual:antiTheftPicker]){
        [pickerLabel setText:[tmp.arrAntiTheftDevice objectAtIndex:row]];
        pickerLabel.font = [UIFont boldSystemFontOfSize:16.0];
    }
    if([pickerView isEqual:vehicleTypePicker]){
        [pickerLabel setText:[arrVehicleType objectAtIndex:row]];
        pickerLabel.font = [UIFont boldSystemFontOfSize:14.0];
    }
    if([pickerView isEqual:antiLockBrakePicker]){
        [pickerLabel setText:[arrAntiLockBrakeDesc objectAtIndex:row]];
        pickerLabel.font = [UIFont boldSystemFontOfSize:16.0];
    }
    if([pickerView isEqual:passiveRestraintPicker]){
        [pickerLabel setText:[arrPassiveRestraintDesc objectAtIndex:row]];
        pickerLabel.font = [UIFont boldSystemFontOfSize:11.0];
    }
    if([pickerView isEqual:daysOfWeekPicker]){
        [pickerLabel setText:[arrDaysWeekDesc objectAtIndex:row]];
        pickerLabel.font = [UIFont boldSystemFontOfSize:12.0];
    }
    if([pickerView isEqual:vehicleMakePicker]){
        [pickerLabel setText:[arrayMakeList objectAtIndex:row]];
        pickerLabel.font = [UIFont boldSystemFontOfSize:16.0];
    }

    return pickerLabel;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField == txtAnnualMileage){
        annualMileage = txtAnnualMileage.text;
    }
    if(textField == txtMilesToWork){
        milesToWork = txtMilesToWork.text;
    }
    if(textField == txtGaragingZipCode){
        garagingZipCode = txtGaragingZipCode.text;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    Globals *tmp = [Globals sharedSingleton];
    
    [CarpoolSlider addTarget:self
        action:@selector(CarpoolSliderEditingDidEnd:)
        forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside)];
    
    [self.navigationController setToolbarHidden:NO];
    [self.navigationController setNavigationBarHidden:YES];

    
    //toolbar buttons
    UIBarButtonItem *save = [[UIBarButtonItem alloc]
                             initWithTitle:@"Save Vehicle"
                             style:UIBarButtonItemStyleBordered
                             target:self
                             action:@selector(SaveThenNextStep)];
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc]
                               initWithTitle:@"Cancel"
                               style:UIBarButtonItemStyleBordered
                               target:self
                               action:@selector(CancelAddVehicle)];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                              target:nil
                                                                              action:nil];
    
    
    
    //[[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:70/255.0f green:155/255.0f blue:19/255.0f alpha:1.0]];
    
    NSArray *arrBtns = [[NSArray alloc]initWithObjects:save, flexible, cancel, nil];
    self.toolbarItems = arrBtns;
    
    //set background image
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clouds.png"]];
    [tempImageView setFrame:self.tableView.frame];
    self.tableView.backgroundView = tempImageView;
    
    txtYear.delegate = (id)self;
    txtWorkWeek.delegate = (id)self;
    txtVIN.delegate = (id)self;
    txtVehicleUsage.delegate = (id)self;
    txtVehicleType.delegate = (id)self;
    txtSplitCity.delegate = (id)self;
    txtPassiveRestraints.delegate = (id)self;
    txtModel.delegate = (id)self;
    txtMilesToWork.delegate = (id)self;
    txtMake.delegate = (id)self;
    txtGaragingZipCode.delegate = (id)self;
    txtCarpool.delegate = (id)self;
    txtAntiTheftDevice.delegate = (id)self;
    txtAntiLockBrakes.delegate = (id)self;
    txtAnnualMileage.delegate = (id)self;
    
    arrVehicleYears = [[NSMutableArray alloc] init];
    arrVehicleType = [[NSMutableArray alloc] init];
    arrVehicleTypeCode = [[NSMutableArray alloc] init];    
    arrAntiLockBrakeCode = [[NSMutableArray alloc] init];
    arrAntiLockBrakeDesc = [[NSMutableArray alloc] init];
    arrPassiveRestraintDesc = [[NSMutableArray alloc] init];
    arrPassiveRestraintCode = [[NSMutableArray alloc] init];
    arrDaysWeekDesc = [[NSMutableArray alloc] init];
    arrDaysWeekCode = [[NSMutableArray alloc] init];
    arrayMakeList = [[NSMutableArray alloc] init];
    arrayMakeListValue = [[NSMutableArray alloc] init];
    
    [arrVehicleYears addObject:@""];
    [arrVehicleType addObject:@""];
    [arrVehicleTypeCode addObject:@""];
    [arrAntiLockBrakeCode addObject:@""];
    [arrAntiLockBrakeDesc addObject:@""];
    [arrPassiveRestraintDesc addObject:@""];
    [arrPassiveRestraintCode addObject:@""];
    [arrDaysWeekDesc addObject:@""];
    [arrDaysWeekCode addObject:@""];

    
    //Load VehicleType arrays    
    self.managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *_fetchReqVT = [[NSFetchRequest alloc] init];
    _fetchReqVT.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"name =='", @"VEH_TYPE", @"'", nil]];
    NSEntityDescription *entityVT = [NSEntityDescription entityForName:@"DropdownData" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqVT setEntity:entityVT];
    //sorting
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"desc" ascending: YES];
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor, nil];
    [_fetchReqVT setSortDescriptors:sortDescriptors];
    
    NSArray *arrayTemp = [self.managedObjectContext executeFetchRequest:_fetchReqVT error:nil];
    for(int i = 0; i < [arrayTemp count] ; i++){
        DropdownData *vt = (DropdownData*)[arrayTemp objectAtIndex:i];
        [arrVehicleType addObject:vt.desc];
        [arrVehicleTypeCode addObject:vt.code];
    }
    
    //Load AntiLockBrake arrays
    NSFetchRequest *_fetchReqALB = [[NSFetchRequest alloc] init];
    _fetchReqALB.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"name =='", @"ANTI_LOCK_BRAKES", @"'", nil]];
    NSEntityDescription *entityALB = [NSEntityDescription entityForName:@"DropdownData" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqALB setEntity:entityALB];
    //sorting
    NSSortDescriptor* sortDescriptorALB = [[NSSortDescriptor alloc] initWithKey:@"desc" ascending: YES];
    NSArray* sortDescriptorsALB = [[NSArray alloc] initWithObjects: sortDescriptorALB, nil];
    [_fetchReqALB setSortDescriptors:sortDescriptorsALB];
    
    NSArray *arrayTempALB = [self.managedObjectContext executeFetchRequest:_fetchReqALB error:nil];
    for(int i = 0; i < [arrayTempALB count] ; i++){
        DropdownData *vt = (DropdownData*)[arrayTempALB objectAtIndex:i];
        [arrAntiLockBrakeDesc addObject:vt.desc];
        [arrAntiLockBrakeCode addObject:vt.code];
    }
    
    //Load PassiveRestraint arrays
    NSFetchRequest *_fetchReqPR = [[NSFetchRequest alloc] init];
    _fetchReqPR.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"name =='", @"PASSIVE_RESTRAINT", @"'", nil]];
    NSEntityDescription *entityPR = [NSEntityDescription entityForName:@"DropdownData" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqPR setEntity:entityPR];
    //sorting
    NSSortDescriptor* sortDescriptorPR = [[NSSortDescriptor alloc] initWithKey:@"desc" ascending: YES];
    NSArray* sortDescriptorsPR = [[NSArray alloc] initWithObjects: sortDescriptorPR, nil];
    [_fetchReqPR setSortDescriptors:sortDescriptorsPR];
    
    NSArray *arrayTempPR = [self.managedObjectContext executeFetchRequest:_fetchReqPR error:nil];
    for(int i = 0; i < [arrayTempPR count] ; i++){
        DropdownData *vt = (DropdownData*)[arrayTempPR objectAtIndex:i];
        [arrPassiveRestraintDesc addObject:vt.desc];
        [arrPassiveRestraintCode addObject:vt.code];
    }
    
    //Load DaysWeek arrays
    NSFetchRequest *_fetchReqDW = [[NSFetchRequest alloc] init];
    _fetchReqDW.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"name =='", @"DAYS_PER_WEEK", @"'", nil]];
    NSEntityDescription *entityDW = [NSEntityDescription entityForName:@"DropdownData" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqDW setEntity:entityDW];
    //sorting
    NSSortDescriptor* sortDescriptorDW = [[NSSortDescriptor alloc] initWithKey:@"desc" ascending: YES];
    NSArray* sortDescriptorsDW = [[NSArray alloc] initWithObjects: sortDescriptorDW, nil];
    [_fetchReqDW setSortDescriptors:sortDescriptorsDW];
    
    NSArray *arrayTempDW = [self.managedObjectContext executeFetchRequest:_fetchReqDW error:nil];
    for(int i = 0; i < [arrayTempDW count] ; i++){
        DropdownData *vt = (DropdownData*)[arrayTempDW objectAtIndex:i];
        [arrDaysWeekDesc addObject:vt.desc];
        [arrDaysWeekCode addObject:vt.code];
    }
    
    //Load Vehicle Make arrays
    NSFetchRequest *_fetchReqMake = [[NSFetchRequest alloc] init];
    _fetchReqMake.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"name =='", @"VEH_MAKE", @"'", nil]];
    NSEntityDescription *entityMake = [NSEntityDescription entityForName:@"DropdownData" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqMake setEntity:entityMake];
    //sorting
    NSSortDescriptor* sortDescriptorA1 = [[NSSortDescriptor alloc] initWithKey:@"desc" ascending:YES];
    NSArray* sortDescriptorsA1 = [[NSArray alloc] initWithObjects: sortDescriptorA1, nil];
    [_fetchReqMake setSortDescriptors:sortDescriptorsA1];
    NSArray *arrayTempMake = [self.managedObjectContext executeFetchRequest:_fetchReqMake error:nil];
    for(int i = 0; i < [arrayTempMake count] ; i++){
        DropdownData *_dd = (DropdownData*)[arrayTempMake objectAtIndex:i];
        NSString *_ddText = _dd.desc;
        [arrayMakeList addObject:_ddText];
        [arrayMakeListValue addObject:_dd.code];
    }



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

        
    self.title = @"Auto Quote - Add Vehicle";
    CGRect frame = CGRectMake(0, 0, [self.title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f]}].width, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:16.0];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    self.tabBarItem.title = @"Vehicles";
    label.text = self.title;


    
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
    vehicleYearPicker.tag = 1;
    txtYear.inputView = vehicleYearPicker;
    txtYear.inputAccessoryView = DoneButtonViewVehicleYear;
    
    //Vehicle Type
    UIToolbar *DoneButtonViewVehicleType = [[UIToolbar alloc] init];
    DoneButtonViewVehicleType.barStyle = UIBarStyleBlack;
    DoneButtonViewVehicleType.translucent = YES;
    DoneButtonViewVehicleType.tintColor = nil;
    [DoneButtonViewVehicleType sizeToFit];
    UIBarButtonItem *doneButtonVehicleType = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(VehicleTypeDone:)];
    [DoneButtonViewVehicleType setItems:[NSArray arrayWithObjects:doneButtonVehicleType, nil]];
    
    UIPickerView *vehicleTypePickerTemp = [[UIPickerView alloc] initWithFrame:CGRectZero];
    vehicleTypePicker = vehicleTypePickerTemp;
    vehicleTypePicker.dataSource = self;
    vehicleTypePicker.delegate = self;
    vehicleTypePicker.showsSelectionIndicator = YES;
    vehicleTypePicker.tag = 4;
    txtVehicleType.inputView = vehicleTypePicker;
    txtVehicleType.inputAccessoryView = DoneButtonViewVehicleType;
    
    //Vehicle Make List
    UIToolbar *DoneButtonViewVehicleMakeList = [[UIToolbar alloc] init];
    DoneButtonViewVehicleMakeList.barStyle = UIBarStyleBlack;
    DoneButtonViewVehicleMakeList.translucent = YES;
    DoneButtonViewVehicleMakeList.tintColor = nil;
    [DoneButtonViewVehicleMakeList sizeToFit];
    UIBarButtonItem *doneButtonVehicleMakeList = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(VehicleMakeListDonePressed:)];
    [DoneButtonViewVehicleMakeList setItems:[NSArray arrayWithObjects:doneButtonVehicleMakeList, nil]];
    
    UIPickerView *VehicleMakePickerTemp = [[UIPickerView alloc] initWithFrame:CGRectZero];
    vehicleMakePicker = VehicleMakePickerTemp;
    vehicleMakePicker.tag = 8;
    vehicleMakePicker.dataSource = self;
    vehicleMakePicker.delegate = self;
    vehicleMakePicker.showsSelectionIndicator = YES;
    txtMake.inputView = vehicleMakePicker;
    txtMake.inputAccessoryView = DoneButtonViewVehicleMakeList;


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
    antiTheftPicker.tag = 3;
    txtAntiTheftDevice.inputView = antiTheftPicker;
    txtAntiTheftDevice.inputAccessoryView = DoneButtonViewAntiTheft;
    
    //AntiLockBrakes
    UIToolbar *DoneButtonViewAntiLockBrakes = [[UIToolbar alloc] init];
    DoneButtonViewAntiLockBrakes.barStyle = UIBarStyleBlack;
    DoneButtonViewAntiLockBrakes.translucent = YES;
    DoneButtonViewAntiLockBrakes.tintColor = nil;
    [DoneButtonViewAntiLockBrakes sizeToFit];
    UIBarButtonItem *doneButtonAntiLockBrakes = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(AntiLockBrakesDone:)];
    [DoneButtonViewAntiLockBrakes setItems:[NSArray arrayWithObjects:doneButtonAntiLockBrakes, nil]];
    
    UIPickerView *antiLockBrakePickerTemp = [[UIPickerView alloc] initWithFrame:CGRectZero];
    antiLockBrakePicker = antiLockBrakePickerTemp;
    antiLockBrakePicker.dataSource = self;
    antiLockBrakePicker.delegate = self;
    antiLockBrakePicker.showsSelectionIndicator = YES;
    antiLockBrakePicker.tag = 5;
    txtAntiLockBrakes.inputView = antiLockBrakePicker;
    txtAntiLockBrakes.inputAccessoryView = DoneButtonViewAntiLockBrakes;
    
    //Passive Restraint
    UIToolbar *DoneButtonViewPassiveRestraint = [[UIToolbar alloc] init];
    DoneButtonViewPassiveRestraint.barStyle = UIBarStyleBlack;
    DoneButtonViewPassiveRestraint.translucent = YES;
    DoneButtonViewPassiveRestraint.tintColor = nil;
    [DoneButtonViewPassiveRestraint sizeToFit];
    UIBarButtonItem *doneButtonPassiveRestraint = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(PassiveRestraintDone:)];
    [DoneButtonViewPassiveRestraint setItems:[NSArray arrayWithObjects:doneButtonPassiveRestraint, nil]];
    
    UIPickerView *passiveRestraintPickerTemp = [[UIPickerView alloc] initWithFrame:CGRectZero];
    passiveRestraintPicker = passiveRestraintPickerTemp;
    passiveRestraintPicker.dataSource = self;
    passiveRestraintPicker.delegate = self;
    passiveRestraintPicker.showsSelectionIndicator = YES;
    passiveRestraintPicker.tag = 6;
    txtPassiveRestraints.inputView = passiveRestraintPicker;
    txtPassiveRestraints.inputAccessoryView = DoneButtonViewPassiveRestraint;
    
    //Days of Week
    UIToolbar *DoneButtonViewDaysWeek = [[UIToolbar alloc] init];
    DoneButtonViewDaysWeek.barStyle = UIBarStyleBlack;
    DoneButtonViewDaysWeek.translucent = YES;
    DoneButtonViewDaysWeek.tintColor = nil;
    [DoneButtonViewDaysWeek sizeToFit];
    UIBarButtonItem *doneButtonDaysWeek = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(DaysWeekDone:)];
    [DoneButtonViewDaysWeek setItems:[NSArray arrayWithObjects:doneButtonDaysWeek, nil]];
    
    UIPickerView *daysWeekPickerTemp = [[UIPickerView alloc] initWithFrame:CGRectZero];
    daysOfWeekPicker = daysWeekPickerTemp;
    daysOfWeekPicker.dataSource = self;
    daysOfWeekPicker.delegate = self;
    daysOfWeekPicker.showsSelectionIndicator = YES;
    daysOfWeekPicker.tag = 7;
    txtWorkWeek.inputView = daysOfWeekPicker;
    txtWorkWeek.inputAccessoryView = DoneButtonViewDaysWeek;
    
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
    vehicleUsagePicker.tag = 2;
    txtVehicleUsage.inputView = vehicleUsagePicker;
    txtVehicleUsage.inputAccessoryView = DoneButtonViewVehicleUsage;
    
    //Number fields
    UIToolbar* numberToolbarMiles = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbarMiles.barStyle = UIBarStyleBlackTranslucent;
    numberToolbarMiles.items = [NSArray arrayWithObjects:
                              [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPadMiles)],
                              [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                              [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPadMiles)],
                              nil];
    [numberToolbarMiles sizeToFit];
    txtMilesToWork.inputAccessoryView = numberToolbarMiles;
    
    UIToolbar* numberToolbarAnnualMiles = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbarAnnualMiles.barStyle = UIBarStyleBlackTranslucent;
    numberToolbarAnnualMiles.items = [NSArray arrayWithObjects:
                                [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPadAnnualMiles)],
                                [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPadAnnualMiles)],
                                nil];
    [numberToolbarAnnualMiles sizeToFit];
    txtAnnualMileage.inputAccessoryView = numberToolbarAnnualMiles;
    
    UIToolbar* numberToolbarGaragingZipCode = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbarGaragingZipCode.barStyle = UIBarStyleBlackTranslucent;
    numberToolbarGaragingZipCode.items = [NSArray arrayWithObjects:
                                      [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPadGaragingZipCode)],
                                      [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                      [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPadGaragingZipCode)],
                                      nil];
    [numberToolbarGaragingZipCode sizeToFit];
    txtGaragingZipCode.inputAccessoryView = numberToolbarGaragingZipCode;
    
    //get vehicle info
    if(![tmp.createNewVehicle isEqualToString:@"YES"]){
        self.managedObjectContext = tmp.managedObjectContext;
        NSFetchRequest *_fetchReqE = [[NSFetchRequest alloc] init];
        _fetchReqE.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"quoteID =='", tmp.currentQuoteGuid, @"'", nil]];
        NSEntityDescription *entityE = [NSEntityDescription entityForName:@"QuoteVehicle" inManagedObjectContext:self.managedObjectContext];
        [_fetchReqE setEntity:entityE];
            
        NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:_fetchReqE error:nil];
        
        for (NSManagedObject *info in fetchedObjects)
        {
            QuoteVehicle *vehicle = (QuoteVehicle *)info;
            txtVIN.text = vehicle.vin;
            txtMake.text = vehicle.make;
            txtModel.text = vehicle.model;
            txtYear.text = vehicle.year;
            txtVehicleType.text = vehicle.vehicleType;
            txtAntiLockBrakes.text = vehicle.antiLockBrakes;
            txtPassiveRestraints.text = vehicle.passiveRestraints;
            txtAntiTheftDevice.text = vehicle.antiTheftDevice;
            txtVehicleUsage.text = vehicle.vehicleUsage;
            txtAnnualMileage.text = vehicle.annualMileage;
            txtMilesToWork.text = vehicle.milesToWork;
            txtWorkWeek.text = vehicle.workWeek;
            txtGaragingZipCode.text = vehicle.garagingZipCode;
            txtSplitCity.text = vehicle.splitCity;
            
            
            if(vehicle.makeValue != nil) {makeValue = [NSMutableString stringWithString:vehicle.makeValue];}else{txtMake.text = @"";}
            if(vehicle.vehicleTypeCode != nil) {vehicleTypeCodeValue = [NSMutableString stringWithString:vehicle.vehicleTypeCode];}else{txtVehicleType.text = @"";}
            if(vehicle.antiLockBrakesValue != nil) {antLockBrakeCodeValue = [NSMutableString stringWithString:vehicle.antiLockBrakesValue];}else{txtAntiLockBrakes.text = @"";}
            if(vehicle.passiveRestraintsValue != nil) {passiveRestraintCodeValue = [NSMutableString stringWithString:vehicle.passiveRestraintsValue];}else{txtPassiveRestraints.text = @"";}
            if(vehicle.antiTheftDeviceValue != nil) {antiTheftValue = [NSMutableString stringWithString:vehicle.antiTheftDeviceValue];}else{txtAntiTheftDevice.text = @"";}
            if(vehicle.vehicleUsageValue != nil) {vehicleUsageValue = [NSMutableString stringWithString:vehicle.vehicleUsageValue];}else{txtVehicleUsage.text = @"";}
            if(vehicle.workWeekValue != nil) {workWeekValue = [NSMutableString stringWithString:vehicle.workWeekValue];}else{txtWorkWeek.text = @"";}
            
            
            if([vehicle.carpool isEqualToString:@"Y"]){
                //[self CarpoolYesPressed:self];
                CarpoolSlider.value = 0.0f;
            }
            if([vehicle.carpool isEqualToString:@"N"]){
                //[self CarpoolNoPressed:self];
                CarpoolSlider.value = 10.0f;
            }
        }

    }

}

- (void)CarpoolSliderEditingDidEnd:(NSNotification *)notification{
    if(CarpoolSlider.value < 5.0f){
        CarpoolSlider.value = 0.0f;
        carpool = @"Y";
        CarpoolSelected = YES;
    }
    if(CarpoolSlider.value > 5.0f){
        CarpoolSlider.value = 10.0f;
        carpool = @"N";
        CarpoolSelected = YES;
    }
}


- (IBAction)OpenBarCodeReader:(id)sender {
    BarCodeViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"BarCodeViewController"];
    [self.navigationController presentViewController:svc animated:YES completion:nil];
}


-(void)cancelNumberPadMiles{
    [txtMilesToWork resignFirstResponder];
    txtMilesToWork.text = milesToWork;
}

-(void)doneWithNumberPadMiles{
    [txtMilesToWork resignFirstResponder];
}

-(void)cancelNumberPadGaragingZipCode{
    [txtGaragingZipCode resignFirstResponder];
    txtGaragingZipCode.text = garagingZipCode;
}

-(void)doneWithNumberPadGaragingZipCode{
    [txtGaragingZipCode resignFirstResponder];
    if(![self validateZipCode:txtGaragingZipCode.text]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Invalid Information"
                                                       message: @"Garaging Zip Code is invalid"
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        alert.tag = 15;
        [alert show];
    }
    else{
        [self CheckZipCodeForSplitCity:txtGaragingZipCode.text];
        //garagingZipCode = txtGaragingZipCode.text;
    }

}

-(void)cancelNumberPadAnnualMiles{
    [txtAnnualMileage resignFirstResponder];
    txtAnnualMileage.text = annualMileage;
}

-(void)doneWithNumberPadAnnualMiles{
    [txtAnnualMileage resignFirstResponder];
}

-(void)VehicleMakeListDonePressed:(id)sender{
    [txtMake resignFirstResponder];
    [self DetermineIfUserWantsToClearVIN];
}


-(void)VehicleYearDone:(id)sender{
    [txtYear resignFirstResponder];
    [self DetermineIfUserWantsToClearVIN];
}

-(void)VehicleTypeDone:(id)sender{
    [txtVehicleType resignFirstResponder];
}

-(void)VehicleUsageDone:(id)sender{
    [txtVehicleUsage resignFirstResponder];
}

-(void)AntiTheftDone:(id)sender{
    [txtAntiTheftDevice resignFirstResponder];
}

-(void)AntiLockBrakesDone:(id)sender{
    [txtAntiLockBrakes resignFirstResponder];
    [self DetermineIfUserWantsToClearVIN];
}

-(void)PassiveRestraintDone:(id)sender{
    [txtPassiveRestraints resignFirstResponder];
    [self DetermineIfUserWantsToClearVIN];
}

-(void)DaysWeekDone:(id)sender{
    [txtWorkWeek resignFirstResponder];
}

-(void)DetermineIfUserWantsToClearVIN{
    if(CheckVINReturnedResults == YES){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"VIN Notification"
                                                       message: @"This field was determined from the VIN entered. Do you want to clear the VIN and enter a different vehicle?"
                                                      delegate: self
                                             cancelButtonTitle:@"YES"
                                             otherButtonTitles:@"NO", nil];
        alert.tag = 10;
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        if(alertView.tag == 10){
            //Restore VIN data
            txtMake.text = VINMake;
            txtModel.text = VINModel;
            txtYear.text = VINYear;
            txtAntiLockBrakes.text = VINABS_Text;
            txtPassiveRestraints.text = VINRestraint_Text;
            antLockBrakeCodeValue = VINABS_Value;
            passiveRestraintCodeValue = VINRestraint_Value;
        }
    }
    if(buttonIndex == 0){
        if(alertView.tag == 10){
            txtVIN.text = @"";
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)SaveThenNextStep{
    Globals *tmp = [Globals sharedSingleton];
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
    
    if([txtYear.text isEqualToString:@""] || [txtVehicleType.text isEqualToString:@""] || [txtMake.text isEqualToString:@""] || [txtModel.text isEqualToString:@""] || txtYear.text == nil || txtVehicleType.text == nil || txtMake.text == nil || txtModel.text == nil){
        txtYear.backgroundColor = tmp.requiredFieldColor;
        txtMake.backgroundColor = tmp.requiredFieldColor;
        txtModel.backgroundColor = tmp.requiredFieldColor;
        txtVehicleType.backgroundColor = tmp.requiredFieldColor;
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Information Needed"
                                                       message: @"Please enter the make, model, and year of vehicle"
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        alert.tag = 7;
        [alert show];
        return;

    }
    else{
        txtYear.backgroundColor = [UIColor clearColor];
        txtMake.backgroundColor = [UIColor clearColor];
        txtModel.backgroundColor = [UIColor clearColor];
        txtVehicleType.backgroundColor = [UIColor clearColor];
    }
    
    NSString *makeCode = [self GetVehicleMakeCode:txtMake.text];
    
    if([makeCode isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Invalid Vehicle Make"
                                                       message: @"Vehicle make not found."
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        alert.tag = 8;
        [alert show];
        return;
    }
    
    if([txtAntiLockBrakes.text isEqualToString:@""] ||
       [txtPassiveRestraints.text isEqualToString:@""] ||
       [txtAntiTheftDevice.text isEqualToString:@""] ||
       [txtWorkWeek.text isEqualToString:@""] ||
       [txtVehicleUsage.text isEqualToString:@""] ||
       [txtAnnualMileage.text isEqualToString:@""] ||
       [txtMilesToWork.text isEqualToString:@""] ||
       [txtGaragingZipCode.text isEqualToString:@""] ||
       [txtVehicleUsage.text isEqualToString:@""] ){
        
        txtAntiLockBrakes.backgroundColor = tmp.requiredFieldColor;
        txtPassiveRestraints.backgroundColor = tmp.requiredFieldColor;
        txtAntiTheftDevice.backgroundColor = tmp.requiredFieldColor;
        txtWorkWeek.backgroundColor = tmp.requiredFieldColor;
        txtVehicleUsage.backgroundColor = tmp.requiredFieldColor;
        txtAnnualMileage.backgroundColor = tmp.requiredFieldColor;
        txtMilesToWork.backgroundColor = tmp.requiredFieldColor;
        txtGaragingZipCode.backgroundColor = tmp.requiredFieldColor;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Required Information Missing"
                                                       message: @"The fields in red are required."
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        alert.tag = 8;
        [alert show];
        return;
    }
    
    if([carpool isEqualToString:@""] || carpool == nil){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Car Pool"
                                                       message: @"Car Pool is required."
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        alert.tag = 8;
        [alert show];
        return;
    }
    
    
    if(![tmp.createNewVehicle isEqualToString:@"YES"]){
        //existing quote
        NSFetchRequest *_fetchReqE = [[NSFetchRequest alloc] init];
        _fetchReqE.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"vehicleID == '", tmp.currentVehicleID, @"'", nil]];
        NSEntityDescription *entityE = [NSEntityDescription entityForName:@"QuoteVehicle" inManagedObjectContext:self.managedObjectContext];
        [_fetchReqE setEntity:entityE];
        
        NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:_fetchReqE error:nil];
        
        for (NSManagedObject *info in fetchedObjects)
        {
            QuoteVehicle *vehicle = (QuoteVehicle *)info;
            vehicle.make = txtMake.text;
            vehicle.makeValue = makeCode;
            vehicle.model = txtModel.text;
            vehicle.year = txtYear.text;
            vehicle.vin = txtVIN.text;
            vehicle.vehicleTypeCode = vehicleTypeCodeValue;
            vehicle.vehicleType = txtVehicleType.text;
            vehicle.antiLockBrakes = txtAntiLockBrakes.text;
            vehicle.antiLockBrakesValue = antLockBrakeCodeValue;
            vehicle.passiveRestraints = txtPassiveRestraints.text;
            vehicle.passiveRestraintsValue = passiveRestraintCodeValue;
            vehicle.antiTheftDevice = txtAntiTheftDevice.text;
            vehicle.antiTheftDeviceValue = antiTheftValue;
            vehicle.vehicleUsage = txtVehicleUsage.text;
            vehicle.vehicleUsageValue = vehicleUsageValue;
            vehicle.annualMileage = txtAnnualMileage.text;
            vehicle.milesToWork = txtMilesToWork.text;
            vehicle.workWeek = txtWorkWeek.text;
            vehicle.workWeekValue = workWeekValue;
            vehicle.carpool = carpool;
            vehicle.carpoolValue = carpool;
            vehicle.garagingZipCode = txtGaragingZipCode.text;
            vehicle.splitCity = txtSplitCity.text;
            
        }
        currentQuote.quoteStatus = @"In Progress";
        NSError *error;
        if (![self.managedObjectContext save:&error])
        {
            NSLog(@"Problem saving: %@", [error localizedDescription]);
            SendEmail *sEmail = [[SendEmail alloc] init];
            [sEmail sendEmail:@"bjkalski@gmail.com" subject:@"QuoteVehicle Save Error" body:[error localizedDescription]];
            
        }

        
        
    }
    
    if([tmp.createNewVehicle isEqualToString:@"YES"]){
        NSString *guid = tmp.GetUUID;
        tmp.currentVehicleID = guid;
        
        QuoteVehicle *vehicle = (QuoteVehicle *)[NSEntityDescription insertNewObjectForEntityForName:@"QuoteVehicle" inManagedObjectContext:self.managedObjectContext];
        
        vehicle.quoteID = tmp.currentQuoteGuid;
        vehicle.make = txtMake.text;
        vehicle.makeValue = makeCode;
        vehicle.model = txtModel.text;
        vehicle.year = txtYear.text;
        vehicle.vin = txtVIN.text;
        vehicle.vehicleTypeCode = vehicleTypeCodeValue;
        vehicle.vehicleType = txtVehicleType.text;
        vehicle.antiLockBrakes = txtAntiLockBrakes.text;
        vehicle.antiLockBrakesValue = antLockBrakeCodeValue;
        vehicle.passiveRestraints = txtPassiveRestraints.text;
        vehicle.passiveRestraintsValue = passiveRestraintCodeValue;
        vehicle.antiTheftDevice = txtAntiTheftDevice.text;
        vehicle.antiTheftDeviceValue = antiTheftValue;
        vehicle.vehicleUsage = txtVehicleUsage.text;
        vehicle.vehicleUsageValue = vehicleUsageValue;
        vehicle.annualMileage = txtAnnualMileage.text;
        vehicle.milesToWork = txtMilesToWork.text;
        vehicle.workWeek = txtWorkWeek.text;
        vehicle.workWeekValue = workWeekValue;
        vehicle.carpool = carpool;
        vehicle.carpoolValue = carpool;
        vehicle.garagingZipCode = txtGaragingZipCode.text;
        vehicle.splitCity = txtSplitCity.text;
        vehicle.completed = [NSNumber numberWithInt:1];
        vehicle.vehicleID = guid;
        
        [currentQuote addQuoteVehicleObject:vehicle];
        currentQuote.quoteStatus = @"In Progress";
        NSError *error;
        if (![self.managedObjectContext save:&error])
        {
            NSLog(@"Problem saving: %@", [error localizedDescription]);
            SendEmail *sEmail = [[SendEmail alloc] init];
            [sEmail sendEmail:@"bjkalski@gmail.com" subject:@"QuoteVehicle Save Error" body:[error localizedDescription]];

        }

    }
    
    
    if([tmp QuoteReadyForReview:tmp.currentQuoteGuid]){
        [(QuoteUITabBarController *)self.tabBarController EnableReviewButton];
    }
    
    [[self.navigationController popViewControllerAnimated:YES] viewDidAppear:YES];
}

- (void)CancelAddVehicle{
    txtMake.text = @"";
    txtModel.text = @"";
    txtYear.text = @"";
    txtVIN.text = @"";
    txtVehicleType.text = @"";
    txtAntiLockBrakes.text = @"";
    txtPassiveRestraints.text = @"";
    txtAntiTheftDevice.text = @"";
    txtVehicleUsage.text = @"";
    txtAnnualMileage.text = @"";
    txtMilesToWork.text = @"";
    txtWorkWeek.text = @"";
    txtGaragingZipCode.text = @"";
    txtSplitCity.text = @"";
    [[self.navigationController popViewControllerAnimated:YES] viewDidAppear:YES];
}



- (IBAction)CheckVIN:(id)sender {
    Globals *tmp = [Globals sharedSingleton];
    
    if([txtVIN.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Invalid VIN"
                                                       message: @"VIN is invalid. Please check and enter again"
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
    else{
        [tmp ShowWaitScreen:@"Looking up VIN"];
        
        NSString *theURL = [NSString stringWithFormat:@"%@%@%@",tmp.globalServerName, @"/users.svc/checkvin/", txtVIN.text];
        
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
        
        NSURL*URL = [NSURL URLWithString:theURL];
        
        [request setURL:URL];
        
        [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        
        [request setTimeoutInterval:[tmp.GlobalTimeout doubleValue]];
        
        (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];
    }

}



-(void) CheckZipCodeForSplitCity:(NSString *)zipCode{
    Globals *tmp = [Globals sharedSingleton];
    tmp.quoteConnectionFailed = @"";
    NSString *postString = [NSString stringWithFormat:@"%@%@%@",tmp.globalServerName, @"/users.svc/CheckSplitCity/", zipCode];
    //postString = [postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSURL *url=[[NSURL alloc] initWithString:[urlpath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *theURL = [NSURL URLWithString:postString];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:theURL];
    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    [request setTimeoutInterval:[tmp.GlobalTimeout doubleValue]];
    
    (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}


    - (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
        // A response has been received, this is where we initialize the instance var you created
        // so that we can append data to it in the didReceiveData method
        // Furthermore, this method is called each time there is a redirect so reinitializing it
        // also serves to clear it
        responseData = [[NSMutableData alloc] init];
    }
    
    - (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
        // Append the new data to the instance variable you declared
        [responseData appendData:data];
    }
    
    - (NSCachedURLResponse *)connection:(NSURLConnection *)connection
willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}
    
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    Globals *tmp = [Globals sharedSingleton];
    NSDictionary *resultsDictionary = [responseData objectFromJSONData];
    NSArray *arrCodes = [resultsDictionary objectForKey:@"CheckVINResult"];
    NSString *SplitCityValue = [resultsDictionary objectForKey:@"CheckSplitCityResult"];
    LookupVINValues *lookupVINValues = [[LookupVINValues alloc] init];
    NSString *ABS_Text;
    NSString *Restraint_Text;
    
    [tmp HideWaitScreen];
    [txtVIN resignFirstResponder];
    
    if([arrCodes count] > 0){
        for(NSDictionary *occ in arrCodes){
            NSString *returnCode = [occ objectForKey:@"returnCode"];
            if([returnCode isEqualToString:@"0"]){
                txtMake.text = [occ objectForKey:@"Make"];
                txtModel.text = [occ objectForKey:@"Model"];
                txtYear.text = [occ objectForKey:@"Year"];
                ABS_Text = [lookupVINValues LookupABSValue:[occ objectForKey:@"ABS"]];
                Restraint_Text = [lookupVINValues LookupRestraintValue:[occ objectForKey:@"Restraint"]];
                txtAntiLockBrakes.text = ABS_Text;
                txtPassiveRestraints.text = Restraint_Text;
                antLockBrakeCodeValue = [occ objectForKey:@"ABS"];
                passiveRestraintCodeValue = [occ objectForKey:@"Restraint"];
                //Save values to variables to be used to reset values if necessary
                VINMake = [occ objectForKey:@"Make"];
                VINModel = [occ objectForKey:@"Model"];
                VINYear = [occ objectForKey:@"Year"];
                VINABS_Text = [lookupVINValues LookupABSValue:[occ objectForKey:@"ABS"]];
                VINRestraint_Text = [lookupVINValues LookupRestraintValue:[occ objectForKey:@"Restraint"]];
                VINABS_Value = [occ objectForKey:@"ABS"];
                VINRestraint_Value = [occ objectForKey:@"Restraint"];
                CheckVINReturnedResults = YES;
            }
            else{
                CheckVINReturnedResults = NO;
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Invalid VIN"
                                                               message: @"VIN is invalid. Please check and enter again"
                                                              delegate: self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
                [alert show];
            }
        }
        
    }
    if(SplitCityValue != nil){
            NSString *scValue = SplitCityValue;
            if([scValue isEqualToString:@"True"]){
                txtSplitCity.text = @"Yes";
            }
            else{
                txtSplitCity.text = @"No";
            }
    }
    
    [connection cancel];
    
}

    - (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
        Globals *tmp = [Globals sharedSingleton];
        tmp.connectionFailed = @"true";
        //LoginTableViewController *login = [[LoginTableViewController alloc] init];
        //[login ConnectionFailed];
    }

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    Globals *tmp = [Globals sharedSingleton];
    if(pickerView.tag == 1){
        return [arrVehicleYears count];
    }
    if(pickerView.tag == 2){
        return tmp.arrVehicleUsage.count;
    }
    if(pickerView.tag == 3){
        return tmp.arrAntiTheftDevice.count;
    }
    if(pickerView.tag == 4){
        return arrVehicleType.count;
    }
    if(pickerView.tag == 5){
        return arrAntiLockBrakeDesc.count;
    }
    if(pickerView.tag == 6){
        return arrPassiveRestraintDesc.count;
    }
    if(pickerView.tag == 7){
        return arrDaysWeekDesc.count;
    }
    if(pickerView.tag == 8){
        return arrayMakeList.count;
    }
    else{
        return 0;
    }
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    Globals *tmp = [Globals sharedSingleton];
    if(pickerView.tag == 1){
        return [arrVehicleYears objectAtIndex:row];
    }
    if(pickerView.tag == 2){
        return [tmp.arrVehicleUsage objectAtIndex:row];
    }
    if(pickerView.tag == 3){
        return [tmp.arrAntiTheftDevice objectAtIndex:row];
    }
    if(pickerView.tag == 4){
        return [arrVehicleType objectAtIndex:row];
    }
    if(pickerView.tag == 5){
        return [arrAntiLockBrakeDesc objectAtIndex:row];
    }
    if(pickerView.tag == 6){
        return [arrPassiveRestraintDesc objectAtIndex:row];
    }
    if(pickerView.tag == 7){
        return [arrDaysWeekDesc objectAtIndex:row];
    }
    if(pickerView.tag == 8){
        return [arrayMakeList objectAtIndex:row];
    }
    else{
        return @"";
    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    Globals *tmp  = [Globals sharedSingleton];
    if(pickerView.tag == 1){
        txtYear.text = [arrVehicleYears objectAtIndex:row];
    }
    if(pickerView.tag == 2){
        txtVehicleUsage.text = [tmp.arrVehicleUsage objectAtIndex:row];
        vehicleUsageValue = [tmp.arrVehicleUsageValue objectAtIndex:row];
    }
    if(pickerView.tag == 3){
        txtAntiTheftDevice.text = [tmp.arrAntiTheftDevice objectAtIndex:row];
        antiTheftValue = [tmp.arrAntiTheftDeviceValue objectAtIndex:row];
    }
    if(pickerView.tag == 4){
        txtVehicleType.text = [arrVehicleType objectAtIndex:row];
        vehicleTypeCodeValue = [arrVehicleTypeCode objectAtIndex:row];
    }
    if(pickerView.tag == 5){
        txtAntiLockBrakes.text = [arrAntiLockBrakeDesc objectAtIndex:row];
        antLockBrakeCodeValue = [arrAntiLockBrakeCode objectAtIndex:row];
    }
    if(pickerView.tag == 6){
        txtPassiveRestraints.text = [arrPassiveRestraintDesc objectAtIndex:row];
        passiveRestraintCodeValue = [arrPassiveRestraintCode objectAtIndex:row];
    }
    if(pickerView.tag == 7){
        txtWorkWeek.text = [arrDaysWeekDesc objectAtIndex:row];
        workWeekValue = [arrDaysWeekCode objectAtIndex:row];
    }
    if(pickerView.tag == 8){
        txtMake.text = [arrayMakeList objectAtIndex:row];
        vehicleMakeCodeValue = [arrayMakeListValue objectAtIndex:row];
    }
    
}

-(NSString *)GetVehicleMakeCode:(NSString *)make{
    Globals *tmp = [Globals sharedSingleton];
    self.managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *_fetchReqE = [[NSFetchRequest alloc] init];
    _fetchReqE.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"desc == '", make, @"' and name == 'VEH_MAKE'", nil]];
    NSEntityDescription *entityE = [NSEntityDescription entityForName:@"DropdownData" inManagedObjectContext:self.managedObjectContext];
    [_fetchReqE setEntity:entityE];
    
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:_fetchReqE error:nil];
    
    NSString *foundMake = @"";
    
    for (NSManagedObject *info in fetchedObjects)
    {
        DropdownData *data = (DropdownData *)info;
        foundMake = data.code;
    }
    return foundMake;
}





@end
