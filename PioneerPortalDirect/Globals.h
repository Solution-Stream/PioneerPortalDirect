//
//  Globals.h
//  PortalDirect
//
//  Created by Brian Kalski on 1/31/13.
//  Copyright (c) 2013 Pioneer Insurance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Globals : NSObject{
    UIAlertView *alert;
}
@property (nonatomic, assign) NSInteger numberQuoteVehicles;
@property (nonatomic, assign) NSInteger numberQuoteDrivers;
@property (nonatomic, assign) NSInteger numQuoteVehiclesLoaded;
@property (nonatomic, assign) NSInteger numQuoteDriversLoaded;
@property (nonatomic, assign) NSMutableArray *arrayGlobalPolicyNumbers;
@property (nonatomic, assign) UIViewController *vcAddDriver;
@property (nonatomic, assign) NSString *globalServerName;
@property (nonatomic, assign) NSMutableString *clientNumber;
@property (nonatomic, assign) NSString *connectionErrorMessage;
@property (nonatomic, assign) NSString *connectionErrorTitle;
@property (nonatomic, assign) NSArray *stateList;
@property (nonatomic, assign) NSArray *arrVehicleUsage;
@property (nonatomic, assign) NSArray *arrVehicleUsageValue;
@property (nonatomic, assign) NSArray *arrAntiTheftDevice;
@property (nonatomic, assign) NSArray *arrAntiTheftDeviceValue;
@property (nonatomic, assign) NSArray *arrBodilyInjuryLimit;
@property (nonatomic, assign) NSArray *arrBodilyInjuryLimitValue;
@property (nonatomic, assign) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSString *VIN;
@property (nonatomic, retain) NSString *DriversInfoDoneLoading;
@property (nonatomic, retain) NSString *SetUserInfoDoneLoading;
@property (nonatomic, retain) NSString *PolicyInfoDoneLoading;
@property (nonatomic, retain) NSString *VehiclesDoneLoading;
@property (nonatomic, retain) NSString *userInfoUpdated;
@property (nonatomic, retain) NSString *mainPolicyNumber;
@property (nonatomic, retain) NSString *policyeffectiveDate;
@property (nonatomic, retain) NSString *policyexpirationDate;
@property (nonatomic, retain) UIAlertView *customAlert;
@property (nonatomic, retain) NSString *vehicleAdded;
@property (nonatomic, retain) NSString *GoToQuoteScreen;

@property (nonatomic, retain) NSString *vehicleRemoved;
@property (nonatomic, retain) NSString *userJustLoggedIn;
@property (nonatomic, retain) NSString *connectionFailed;
@property (nonatomic, retain) NSString *GlobalTimeout;

@property (nonatomic, retain) NSString *NavigationMode;

@property (nonatomic, retain) NSString *EmployeeStatusListLoaded;
@property (nonatomic, retain) NSString *OccupationListLoaded;
@property (nonatomic, retain) NSString *AnnualIncomeListLoaded;
@property (nonatomic, retain) NSString *VehicleTypeListLoaded;

@property (nonatomic, retain) NSString *AntiLockBrakeListLoaded;
@property (nonatomic, retain) NSString *PassiveRestraintListLoaded;
@property (nonatomic, retain) NSString *DaysWeekListLoaded;

@property (nonatomic, retain) NSString *MiniTortListLoaded;
@property (nonatomic, retain) NSString *UnderInsuredMotoristListLoaded;
@property (nonatomic, retain) NSString *UninsuredMotoristLoaded;
@property (nonatomic, retain) NSString *PropertyDamageLoaded;
@property (nonatomic, retain) NSString *PropertyProtectionLoaded;
@property (nonatomic, retain) NSString *DropdownListLoaded;

@property (nonatomic, retain) NSString *annualPremium;
@property (nonatomic, retain) NSString *devMode;
@property (nonatomic, retain) NSString *currentQuoteGuid;
@property (nonatomic, retain) NSString *currentDriverID;

@property (nonatomic, retain) NSString *createNewDriver;
@property (nonatomic, retain) NSString *QuoteDriversAddedToQuote;
@property (nonatomic, retain) NSString *QuoteVehiclesAddedToQuote;


@property (nonatomic, retain) NSNumber *quoteViewIndex;
@property (nonatomic, retain) NSNumber *quoteDriverViewIndex;
@property (nonatomic, retain) NSNumber *quoteApplicantViewIndex;

@property (nonatomic, retain) NSString *currentVehicleID;
@property (nonatomic, retain) NSString *currentApplicantID;

@property (nonatomic, retain) NSString *createNewVehicle;
@property (nonatomic, retain) NSString *createNewApplicant;

@property (nonatomic, retain) NSString *quoteSelectedVehicle;
@property (nonatomic, retain) NSString *quoteConnectionFailed;


@property (nonatomic, retain) UIColor *requiredFieldColor;

@property UIFont *TableViewListFont;


- (void)LoadPolicyDataForUser:(NSString *)username;
- (void)ShowLoadingScreen;
- (void)HideLoadingScreen;
- (void)LoadCoreData;

- (void)ShowWaitScreen:(NSString *)customMessage;
- (void)HideWaitScreen;

- (NSString *)GetAnnualIncomeText:(NSString *)incomeCode;

- (NSString *)GetUUID;

- (BOOL) IsValidDriverBirthDate:(NSDate*) endDate;

- (BOOL) validateEmail: (NSString *) candidate;

- (NSString *)filteredStringFromStringWithFilter:(NSString*) string filterText:(NSString *)filter;

- (NSMutableArray *)SetTabBarImages:(NSString *) quoteGuid;

- (BOOL)QuoteReadyForReview:(NSString *) quoteGuid;

+ (Globals *) sharedSingleton;

@end
