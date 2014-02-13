//
//  QuoteAddDriverUITableViewController.h
//  PortalDirect
//
//  Created by Brian Kalski on 6/24/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuoteAddDriverUITableViewController : UITableViewController<UIPickerViewDataSource,UIPickerViewDelegate>{
    UIDatePicker *datePicker;
    UIPickerView *LicenseStatePicker;
    UIPickerView *OccupationListPicker;
    UIPickerView *EmploymentListPicker;
    UIPickerView *AnnualIncomeListPicker;
    UIPickerView *RelationPicker;
    NSDate *pickerDate;
    UIPickerView *MaritalStatusPicker;
    NSMutableArray *arrayMaritalStatusList;
    
    NSString *HasDependents;
    NSString *MaritalStatus;
    NSString *Gender;
    NSString *AnnualIncomeValue;
    NSString *OccupationValue;
    NSString *RelationApplicantValue;
    NSString *LicenseStateValue;
    NSString *IncomeLevelValue;
    
    
    BOOL DependentsSelected;
    BOOL MaritalStatusSelected;
    BOOL GenderSelected;
    
    NSMutableArray *arrOccupationList;
    NSMutableArray *arrOccupationListValue;
    NSMutableArray *arrEmploymentList;
    NSMutableArray *arrEmploymentListValue;
    NSMutableArray *arrAnnualIncomeList;
    NSMutableArray *arrAnnualIncomeListValue;
    NSMutableArray *arrayRelationList;
    NSMutableArray *arrayRelationListValue;
    NSMutableArray *arrayLicenseState;
    NSMutableArray *arrayLicenseStateValue;
    
}
@property (strong, nonatomic) IBOutlet UITextField *txtFirstName;
@property (strong, nonatomic) IBOutlet UITextField *txtMiddleInitial;
@property (strong, nonatomic) IBOutlet UITextField *txtLastName;
@property (strong, nonatomic) IBOutlet UITextField *txtDateBirth;
@property (strong, nonatomic) IBOutlet UITextField *txtGender;
@property (strong, nonatomic) IBOutlet UITextField *txtMaritalStatus;
@property (strong, nonatomic) IBOutlet UITextField *txtRelationApplicant;
@property (strong, nonatomic) IBOutlet UITextField *txtDependents;
@property (strong, nonatomic) IBOutlet UITextField *txtLicenseState;
@property (strong, nonatomic) IBOutlet UITextField *txtLicenseNum;
@property (strong, nonatomic) IBOutlet UITextField *txtOccupation;
@property (strong, nonatomic) IBOutlet UITextField *txtEmploymentStatus;
@property (strong, nonatomic) IBOutlet UITextField *txtIncomeLevel;
@property (strong, nonatomic) IBOutlet UIButton *DependentYesButton;
@property (strong, nonatomic) IBOutlet UIButton *DependentNoButton;
@property (strong, nonatomic) IBOutlet UIButton *MaritalStatusSButton;
@property (strong, nonatomic) IBOutlet UIButton *MaritalStatusMButton;
@property (strong, nonatomic) IBOutlet UIButton *GenderMStatusButton;
@property (strong, nonatomic) IBOutlet UIButton *GenderFStatusButton;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UIToolbar *BottomToolBar;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;



@property (nonatomic, retain) Quotes *currentQuote;

- (IBAction)DependentYesPressed:(id)sender;
- (IBAction)DependentNoPressed:(id)sender;

-(IBAction)MaritalStatusMPressed:(id)sender;
-(IBAction)MaritalStatusSPressed:(id)sender;

-(IBAction)GenderFPressed:(id)sender;
-(IBAction)GenderMPressed:(id)sender;
-(IBAction)SaveThenNextStep:(id)sender;
- (IBAction)CancelAddDriver:(id)sender;

@end
