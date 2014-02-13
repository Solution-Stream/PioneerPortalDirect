//
//  AddVehicleTableViewController.h
//  PortalDirect
//
//  Created by Brian Kalski on 2/26/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddVehicleTableViewController : UITableViewController<UIPickerViewDataSource,UIPickerViewDelegate,NSXMLParserDelegate>{
    NSMutableArray *arrVehicleYears;
    NSMutableData *webData;
    NSMutableString *soapResults;
    NSURLConnection *conn;
    NSMutableData *responseData;
    BOOL elementFound;
    NSInteger VINReturnCode;
    NSXMLParser *xmlParser;
    
    NSMutableString *vehicleUsageValue;
    NSMutableString *antiTheftValue;
    NSMutableString *bodilyInjuryValue;
}
@property (strong, nonatomic) IBOutlet UITextField *txtZipCode;
@property (strong, nonatomic) IBOutlet UITextField *txtVIN;
@property (strong, nonatomic) IBOutlet UITextField *txtYear;
@property (strong, nonatomic) IBOutlet UITextField *txtMake;
@property (strong, nonatomic) IBOutlet UITextField *txtModel;
@property (readonly, nonatomic) IBOutlet UITextField *txtVehicleUsage;
@property (readonly, nonatomic) IBOutlet UITextField *txtAntiTheftDevice;
@property (readonly, nonatomic) IBOutlet UITextField *txtBodilyInjuryLimit;

@property (nonatomic, retain) IBOutlet UIPickerView *vehicleUsagePicker;
@property (nonatomic, retain) IBOutlet UIPickerView *antiTheftPicker;
@property (nonatomic, retain) IBOutlet UIPickerView *bodilyInjuryPicker;
@property (nonatomic, retain) IBOutlet UIPickerView *vehicleYearPicker;
@property (strong, nonatomic) IBOutlet UIButton *btnLookupVIN;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (retain, nonatomic) NSTimer *timer;

@property (retain, nonatomic) NSMutableData *responseData;

-(void)AddVehicle;
-(void)ReleadVehicleDataAndForwardUser;

- (IBAction)VehicleUsageDone:(id)sender;
- (IBAction)AntiTheftDone:(id)sender;
- (IBAction)BodilyInjuryDone:(id)sender;
- (IBAction)VehicleYearDone:(id)sender;
- (IBAction)LookupVin:(id)sender;
- (IBAction)AddVehicleToPolicy:(id)sender;


@end
