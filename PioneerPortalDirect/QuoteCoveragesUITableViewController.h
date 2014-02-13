//
//  QuoteCoveragesUITableViewController.h
//  PortalDirect
//
//  Created by Brian Kalski on 8/14/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//
#import "Quotes.h"
#import <UIKit/UIKit.h>

@interface QuoteCoveragesUITableViewController : UITableViewController<UIPickerViewDataSource,UIPickerViewDelegate>{
    NSString *saveStatus;
    
    NSMutableArray *arrBodilyInjury;
    NSMutableArray *arrBodilyInjuryValue;
    
    NSMutableArray *arrMedicalProvider;
    NSMutableArray *arrMedicalProviderValue;
    
    NSMutableArray *arrPropertyDamage;
    NSMutableArray *arrPropertyDamageValue;
    
    NSMutableArray *arrPropertyProtection;
    NSMutableArray *arrPropertyProtectionValue;
    
    NSMutableArray *arrUninsured;
    NSMutableArray *arrUninsuredValue;
    
    NSMutableArray *arrUnderinsured;
    NSMutableArray *arrUnderinsuredValue;
    
    NSMutableArray *arrMiniTort;
    NSMutableArray *arrMiniTortValue;
    
    NSMutableArray *arrPersonalInjuryProtection;
    NSMutableArray *arrPersonalInjuryProtectionValue;
    
    UIPickerView *BodilyInjuryPicker;
    UIPickerView *MedicalProviderPicker;
    UIPickerView *PropertyDamagePicker;
    UIPickerView *PropertyProtectionPicker;
    UIPickerView *UninsuredMotoristPicker;
    UIPickerView *UnderInsuredMotoristPicker;
    UIPickerView *MiniTortPicker;
    UIPickerView *PersonalInjuryProtectionPicker;
    
    NSString *bodilyInjuryValue;
    NSString *medicalProviderValue;
    NSString *propertyProtectionValue;
    NSString *propertyDamageValue;
    NSString *uninsuredValue;
    NSString *underinsuredValue;
    NSString *miniTortValue;
    NSString *personalInjuryProtectionValue;
    BOOL ProceedToDrivers;
    BOOL ProceedToVehicles;
}
@property (strong, nonatomic) IBOutlet UIToolbar *BottomToolBar;
@property (strong, nonatomic) IBOutlet UITextField *txtBodilyInjury;
@property (strong, nonatomic) IBOutlet UITextField *txtPropertyDamage;
@property (strong, nonatomic) IBOutlet UITextField *txtMedicalProvider;
@property (strong, nonatomic) IBOutlet UITextField *txtPersonalInjuryProtection;
@property (strong, nonatomic) IBOutlet UITextField *txtPropertyProtection;
@property (strong, nonatomic) IBOutlet UITextField *txtUninsuredMotorist;
@property (strong, nonatomic) IBOutlet UITextField *txtUnderinsuredMotorist;
@property (strong, nonatomic) IBOutlet UITextField *txtMiniTort;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, retain) Quotes *currentQuote;

- (IBAction)SaveQuote:(id)sender;

@end
