//
//  BarCodeViewController.h
//  VinReader
//
//  Created by Stephen Vilotti on 3/19/14.
//  Copyright (c) 2014 SolutionStream. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol InsertBarcodeDelegate <NSObject>

-(void) insertBarcodeResponse:(NSString *) response;

@end


@interface BarCodeViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bbitemStart;
@property (weak, nonatomic) IBOutlet UILabel *lblPrompt;

@property (nonatomic, strong) id delegate;


- (IBAction)startStopReading:(id)sender;

@end
