//
//  QuoteApplicantUITableViewController.h
//  PortalDirect
//
//  Created by Brian Kalski on 6/19/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuoteApplicant.h"
#import "Quotes.h"
#import "Globals.h"

@interface QuoteApplicantUITableViewController : UITableViewController<UIPickerViewDataSource,UIPickerViewDelegate>{
    UIDatePicker *datePicker;
    NSDate *pickerDate;
    UIPickerView *ResidencyPicker;
    NSMutableArray *arrayResidencyList;
    NSMutableArray *arrayResidencyListValue;
    NSMutableArray *arrayStateList;
    UIPickerView *LicenseStatePicker;
    NSString *residencyTypeValue;
}

@property (strong, nonatomic) IBOutlet UIButton *btnNextStep;
@property (strong, nonatomic) IBOutlet UITextField *txtFirstName;
@property (strong, nonatomic) IBOutlet UITextField *txtMiddle;
@property (strong, nonatomic) IBOutlet UITextField *txtLastName;
@property (strong, nonatomic) IBOutlet UITextField *txtAddress;
@property (strong, nonatomic) IBOutlet UITextField *txtCity;
@property (strong, nonatomic) IBOutlet UITextField *txtState;
@property (strong, nonatomic) IBOutlet UITextField *txtZip;
@property (strong, nonatomic) IBOutlet UITextField *txtDateBirth;
@property (strong, nonatomic) IBOutlet UITextField *txtSSN;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtResidencyType;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, retain) Quotes *currentQuote;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonItemEdit;
@property (strong, nonatomic) IBOutlet UISwitch *CreateDriverSlider;

- (void)leftNavButtonFire:(id)sender;
- (IBAction)SendUserToLoginScreen:(id)sender;


@property (strong, nonatomic) IBOutlet UIToolbar *BottomToolBar;

@end
