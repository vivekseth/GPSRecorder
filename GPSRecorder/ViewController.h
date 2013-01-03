//
//  ViewController.h
//  GPSRecorder
//
//  Created by Vivek Seth on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "Singleton.h"
#define METERS_PER_MILE 1609.344


@interface ViewController : UIViewController <MFMailComposeViewControllerDelegate, CLLocationManagerDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *MainMapView;
- (IBAction)launchEmailCompser:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (nonatomic) bool ShouldStartUpdatingLocation;
@property (retain) CLLocationManager * locationMgr;
- (IBAction)StartGPS:(id)sender;
- (IBAction)StopGPS:(id)sender;
@property (weak, nonatomic) IBOutlet UISlider *DistanceFilterSlider;
- (IBAction)DistanceFilterChanged:(id)sender;
@property (retain)  NSMutableArray * GPSPointArray;


@end
