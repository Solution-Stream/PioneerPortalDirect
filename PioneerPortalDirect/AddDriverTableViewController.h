//
//  AddDriverTableViewController.h
//  PortalDirect
//
//  Created by Brian Kalski on 2/19/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDriverTableViewController : UITableViewController<UIPickerViewDataSource,UIPickerViewDelegate,NSXMLParserDelegate>{
    UIDatePicker *datePicker;
    UIPickerView *LicenseStatePicker;
    UIPickerView *OccupationListPicker;
    UIPickerView *EmploymentListPicker;
    UIPickerView *AnnualIncomeListPicker;
    NSDate *pickerDate;
    
    NSMutableData *webData;
    NSMutableString *soapResults;
    NSURLConnection *conn;
    NSMutableData *responseData;
    
    NSXMLParser *xmlParser;
    BOOL elementFound;
    NSString *HasDependents;
    NSString *MaritalStatus;
    NSString *Gender;
    NSString *AnnualIncomeValue;
    NSString *OccupationValue;
    
    BOOL DependentsSelected;
    BOOL MaritalStatusSelected;
    BOOL GenderSelected;
    
    NSMutableArray *arrOccupationList;
    NSMutableArray *arrOccupationListValue;
    NSMutableArray *arrEmploymentList;
    NSMutableArray *arrEmploymentListValue;
    NSMutableArray *arrAnnualIncomeList;
    NSMutableArray *arrAnnualIncomeListValue;
    
}
@property (strong, nonatomic) IBOutlet UIButton *DependentYesButton;
@property (strong, nonatomic) IBOutlet UIButton *DependentNoButton;
@property (strong, nonatomic) IBOutlet UIButton *MaritalStatusMButton;
@property (strong, nonatomic) IBOutlet UIButton *MaritalStatusSButton;
@property (strong, nonatomic) IBOutlet UIButton *GenderFStatusButton;
@property (strong, nonatomic) IBOutlet UIButton *GenderMStatusButton;
@property (strong, nonatomic) IBOutlet UITextField *txtDateOfBirth;
@property (strong, nonatomic) IBOutlet UITextField *txtLicenseState;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) IBOutlet UIPickerView *LicenseStatePicker;
@property (nonatomic, retain) IBOutlet UIPickerView *OccupationListPicker;
@property (nonatomic, retain) IBOutlet UIPickerView *EmploymentListPicker;
@property (nonatomic, retain) IBOutlet UIPickerView *AnnualIncomeListPicker;
@property (strong, nonatomic) IBOutlet UITextField *txtFirstName;
@property (strong, nonatomic) IBOutlet UITextField *txtMiddleInitial;
@property (strong, nonatomic) IBOutlet UITextField *txtLastName;
@property (strong, nonatomic) IBOutlet UITextField *txtLicenseNumber;
@property (strong, nonatomic) IBOutlet UITextField *txtOccupation;
@property (strong, nonatomic) IBOutlet UITextField *txtEmploymentStatus;
@property (strong, nonatomic) IBOutlet UITextField *txtAnnualIncome;
@property (strong, nonatomic) IBOutlet UITextField *txtSSN;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (retain, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (retain, nonatomic) NSTimer *timer;

- (IBAction)DependentYesPressed:(id)sender;
- (IBAction)DependentNoPressed:(id)sender;
- (IBAction)DateOfBirthDonePressed:(id)sender;
- (IBAction)LicenseStateDonePressed:(id)sender;
- (IBAction)datePickerChanged:(id)sender;

- (IBAction)OccupationListDonePressed:(id)sender;
- (IBAction)EmploymentListDonePressed:(id)sender;
- (IBAction)AnnualIncomeListDonePressed:(id)sender;

- (IBAction)MaritalStatusMPressed:(id)sender;
- (IBAction)MaritalStatusSPressed:(id)sender;

- (IBAction)GenderFPressed:(id)sender;
- (IBAction)GenderMPressed:(id)sender;



-(void)AddDriver;
-(void)ReleadDriverDataAndForwardUser;





@end
