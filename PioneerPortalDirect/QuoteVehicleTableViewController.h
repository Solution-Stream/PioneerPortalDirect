//
//  QuoteVehicleTableViewController.h
//  PortalDirect
//
//  Created by Brian Kalski on 8/26/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuoteVehicle.h"
#import "BarCodeViewController.h"

@interface QuoteVehicleTableViewController : UITableViewController<UIPickerViewDataSource,UIPickerViewDelegate,InsertBarcodeDelegate>{
    NSMutableArray *arrVehicleYears;
    NSMutableArray *arrVehicleType;
    NSMutableArray *arrVehicleTypeCode;
    
    NSMutableArray *arrAntiLockBrakeDesc;
    NSMutableArray *arrAntiLockBrakeCode;
    
    NSMutableArray *arrPassiveRestraintDesc;
    NSMutableArray *arrPassiveRestraintCode;
    
    NSMutableArray *arrDaysWeekDesc;
    NSMutableArray *arrDaysWeekCode;
    
    NSMutableArray *arrayMakeList;
    NSMutableArray *arrayMakeListValue;
    
    
    NSMutableString *vehicleUsageValue;
    NSMutableString *antiTheftValue;
    NSMutableString *bodilyInjuryValue;
    
    NSMutableString *antLockBrakeCodeValue;
    NSMutableString *passiveRestraintCodeValue;
    NSMutableString *vehicleMakeCodeValue;
    NSMutableString *makeValue;
    NSMutableString *workWeekValue;
    NSMutableString *carpoolValue;
    
    NSString *annualMileage;
    NSString *milesToWork;
    NSString *garagingZipCode;
    NSMutableString *vehicleTypeCodeValue;
    
    BOOL CarpoolSelected;
    NSString *carpool;
}

@property (strong, nonatomic) IBOutlet UITextField *txtYear;
@property (strong, nonatomic) IBOutlet UITextField *txtVehicleType;
@property (strong, nonatomic) IBOutlet UITextField *txtVIN;
@property (strong, nonatomic) IBOutlet UITextField *txtMake;
@property (strong, nonatomic) IBOutlet UITextField *txtModel;
@property (strong, nonatomic) IBOutlet UITextField *txtAntiLockBrakes;
@property (strong, nonatomic) IBOutlet UITextField *txtPassiveRestraints;
@property (strong, nonatomic) IBOutlet UITextField *txtAntiTheftDevice;
@property (strong, nonatomic) IBOutlet UITextField *txtVehicleUsage;
@property (strong, nonatomic) IBOutlet UITextField *txtAnnualMileage;
@property (strong, nonatomic) IBOutlet UITextField *txtMilesToWork;
@property (strong, nonatomic) IBOutlet UITextField *txtWorkWeek;
@property (strong, nonatomic) IBOutlet UITextField *txtCarpool;
@property (strong, nonatomic) IBOutlet UITextField *txtGaragingZipCode;
@property (strong, nonatomic) IBOutlet UITextField *txtSplitCity;
@property (strong, nonatomic) IBOutlet UIButton *btnCheckVIN;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (retain, nonatomic) NSMutableData *responseData;
@property (nonatomic, retain) IBOutlet UIPickerView *vehicleYearPicker;
@property (nonatomic, retain) IBOutlet UIPickerView *vehicleTypePicker;
@property (nonatomic, retain) IBOutlet UIPickerView *vehicleMakePicker;

@property (nonatomic, retain) IBOutlet UIPickerView *vehicleUsagePicker;
@property (nonatomic, retain) IBOutlet UIPickerView *antiTheftPicker;
@property (nonatomic, retain) IBOutlet UIPickerView *bodilyInjuryPicker;


@property (nonatomic, retain) IBOutlet UIPickerView *antiLockBrakePicker;
@property (nonatomic, retain) IBOutlet UIPickerView *passiveRestraintPicker;
@property (nonatomic, retain) IBOutlet UIPickerView *daysOfWeekPicker;

@property (strong, nonatomic) IBOutlet UIButton *CarpoolYesButton;
@property (strong, nonatomic) IBOutlet UIButton *CarpoolNoButton;

@property (strong, nonatomic) IBOutlet UISlider *CarpoolSlider;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) Quotes *quote;

@property (nonatomic, retain) Quotes *currentQuote;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;

- (IBAction)CheckVIN:(id)sender;
- (void)CarpoolSliderEditingDidEnd:(NSNotification *)notification;
- (IBAction)OpenBarCodeReader:(id)sender;


@end
