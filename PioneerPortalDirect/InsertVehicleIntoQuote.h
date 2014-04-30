//
//  InsertVehicleIntoQuote.h
//  PortalDirect
//
//  Created by Brian Kalski on 1/15/14.
//  Copyright (c) 2014 Pioneer Insurance. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InsertVehicleintoQuoteProtocol

@required
-(void) insertVehicleResponse:(NSString *) response;

@end

@interface InsertVehicleIntoQuote : UITableViewController<NSXMLParserDelegate>{
    NSMutableData *webData;
    NSMutableString *soapResults;
    NSURLConnection *conn;
    NSMutableData *responseData;
    
    //---xml parsing---
    NSXMLParser *xmlParser;
    BOOL elementFound;
}
@property (nonatomic,strong) id delegate;
@property (retain, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(void) InsertVehicleIntoQuote:(NSString *)VIN guid:(NSString *)guid year:(NSString *)year make:(NSString *)make model:(NSString *)model bodilyInjury:(NSString *)bodilyInjury medicalProv:(NSString *)medicalProv miniTort:(NSString *)miniTort personalInjuryProtection:(NSString *)personalInjuryProtection propertyDamage:(NSString *)propertyDamage propertyProtection:(NSString *)propertyProtection uninsuredValue:(NSString *)uninsuredValue underinsuredValue:(NSString *)underinsuredValue vehicleType:(NSString *)vehicleType vehicleUse:(NSString *)vehicleUse carpool:(NSString *)carpool antiLock:(NSString *)antiLock passiveRestraint:(NSString *)passiveRestraint antiTheft:(NSString *)antiTheft annualMiles:(NSString *)annualMiles milesOneWay:(NSString *)milesOneWay daysWeek:(NSString *)daysWeek multiCar:(NSString *)multiCar;


@end
