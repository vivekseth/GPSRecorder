//
//  ViewController.m
//  GPSRecorder
//
//  Created by Vivek Seth on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "NVPolylineAnnotationView.h"

@interface ViewController()
- (void) displayComposerSheet;
    
@end


@implementation ViewController 
@synthesize DistanceFilterSlider;
@synthesize message;
@synthesize MainMapView;
@synthesize ShouldStartUpdatingLocation = _ShouldStartUpdatingLocation;
@synthesize locationMgr = _locationMgr;
@synthesize GPSPointArray = _GPSPointArray;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.locationMgr = [[CLLocationManager alloc] init];
    self.locationMgr.delegate = self;
    self.locationMgr.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locationMgr.distanceFilter = 150;
    self.DistanceFilterSlider.value = self.locationMgr.distanceFilter;
    
    self.GPSPointArray = [[NSMutableArray alloc] init];
    
    
    [Singleton sharedSingleton].GPSLocations = @"latitude, longitude, time, accuracy, distanceFilter, speed\n";
    
}

- (void)viewDidUnload
{
    [self setMainMapView:nil];
    [self setMessage:nil];
    [self setDistanceFilterSlider:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)launchEmailCompser:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        [self displayComposerSheet];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status:" message:@"Your phone is not currently configured to send mail." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        
        [alert show];
    }
    
}

- (void) displayComposerSheet {
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"GPS Data"];
    
    
    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObjects:@"viveks3th@gmail.com", @"deepakseth.us@gmail.com", nil]; 
    //NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil]; 
    //NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"]; 
    
    [picker setToRecipients:toRecipients];
    //[picker setCcRecipients:ccRecipients];  
    //[picker setBccRecipients:bccRecipients];
    
    // Attach an image to the email
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"png"];
    //NSData *myData = [NSData dataWithContentsOfFile:path];
    //[picker addAttachmentData:myData mimeType:@"image/png" fileName:@"rainy"];
    
    // Fill out the email body text
    NSString *emailBody = [Singleton sharedSingleton].GPSLocations;
    [picker setMessageBody:emailBody isHTML:NO];
    
    [self presentModalViewController:picker animated:YES];

    
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{   
    message.hidden = NO;
    // Notifies users about errors associated with the interface
    switch (result)
    {
            
        case MFMailComposeResultCancelled:
            message.text = @"Result: canceled";
            break;
        case MFMailComposeResultSaved:
            message.text = @"Result: saved";
            break;
        case MFMailComposeResultSent:
            message.text = @"Result: sent";
            break;
        case MFMailComposeResultFailed:
            message.text = @"Result: failed";
            break;
        default:
            message.text = @"Result: not sent";
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"didUpdateLocation");
    
    [self.GPSPointArray addObject:newLocation];
    NSLog(@"array count: %d", self.GPSPointArray.count);
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, METERS_PER_MILE, METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [self.MainMapView regionThatFits:viewRegion];
    [self.MainMapView setRegion:adjustedRegion];
    
    double newLatitude = newLocation.coordinate.latitude;
    double newLongitude = newLocation.coordinate.longitude;
    
    NSDate * newTimeStamp = newLocation.timestamp;
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm:ss"];
    NSString * newTimeString = [NSString stringWithFormat:@"%@", [timeFormatter stringFromDate:newTimeStamp]];
    
    NSLog(@"%@", newTimeString);
    
    double horizontalAccuracy = newLocation.horizontalAccuracy;
    
    NSString * GPSLocationWithTimeStamp = [NSString stringWithFormat:@"Time: %@\nLat: %f\nLong: %f\nAccuracy: %f", newTimeString, newLatitude, newLongitude, horizontalAccuracy];
    
    self.message.text = GPSLocationWithTimeStamp;
    
    NSString * newGPSPosLine = [NSString stringWithFormat:@"%f, %f, %@, %f, %f, %f\n", newLatitude, newLongitude, newTimeString, horizontalAccuracy, self.locationMgr.distanceFilter, newLocation.speed];
    NSString * oldGPSLocations = [Singleton sharedSingleton].GPSLocations;
    NSString * newGPSLocations = [NSString stringWithFormat:@"%@%@", oldGPSLocations, newGPSPosLine ];
    
    [Singleton sharedSingleton].GPSLocations = newGPSLocations;
    
    
    
    
}



- (IBAction)StartGPS:(id)sender {
    [self.locationMgr startUpdatingLocation];
    self.message.text = @"started tracking location";
}
- (IBAction)StopGPS:(id)sender {
    [self.locationMgr stopUpdatingLocation];
    //NSArray *array = [NSArray arrayWithArray:self.GPSPointArray];
    NVPolylineAnnotation *annotation = [[NVPolylineAnnotation alloc] initWithPoints:self.GPSPointArray mapView:self.MainMapView];
    [self.MainMapView addAnnotation:annotation ];
    
    self.message.text = @"stopped tracking location";
}
- (IBAction)DistanceFilterChanged:(id)sender {
    self.locationMgr.distanceFilter = ((UISlider*)sender).value;
    NSLog(@"DistanceFilter: %f", ((UISlider*)sender).value);
    self.message.text = [NSString stringWithFormat:@"Distance Filter is now %f meters", ((UISlider*)sender).value];
}
@end
