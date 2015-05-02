//
//  DTCNewScoopViewController.m
//  Agbo_CC_Scoops
//
//  Created by David de Tena on 30/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import "DTCNewScoopViewController.h"
#import "DTCScoop.h"
#import "DTCAuthProfile.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
@import CoreLocation;

@interface DTCNewScoopViewController ()<CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
    CLLocationCoordinate2D location;
}

@end

@implementation DTCNewScoopViewController


#pragma mark - Init
-(id) initWithAuthorProfile:(DTCAuthProfile *) authorProfile MSClient:(MSClient *) client{
    if (self = [super init]) {
        _authorProfile = authorProfile;
        _client = client;
    }
    return self;
}


#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self configureUI];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - UI

- (void) configureUI{
    
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width/2;
    self.imageView.clipsToBounds = YES;
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAddScoop:)];
    UIBarButtonItem *addScoopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(confirmAddScoop:)];
    
    self.navigationItem.leftBarButtonItem = logoutButton;
    self.navigationItem.rightBarButtonItem = addScoopButton;
}


#pragma mark - Location

- (void) configureLocation{

    NSLog(@"Entro en configureLocation...");
    
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];

    
    /*
    // Check if CL is active
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];

    // If location services are active and the user authorizes location
    if ([CLLocationManager locationServicesEnabled] && ((status == kCLAuthorizationStatusAuthorizedAlways) || (status == kCLAuthorizationStatusAuthorizedWhenInUse) || (status == kCLAuthorizationStatusNotDetermined))) {
        
        // Got location!
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startUpdatingLocation];
        
        // Sólo me interesan datos recientes (5 segs.)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self zapLocationManager];
        });
    }
     */
}

- (void) zapLocationManager{
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
    locationManager = nil;
}



#pragma mark - Actions

// User did tap on cancel button. Dismiss this VC
-(void) cancelAddScoop:(id)sender{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


// Add new scoop to the backend
-(void) confirmAddScoop:(id)sender{
    
    [self addScoopToAzure];
}

// Hide the keyboard when tapping in a non-text view
- (IBAction)hideKeyboard:(id)sender{
    [self.view endEditing:YES];
}


#pragma mark - Azure settings
-(void) addScoopToAzure{

    NSLog(@"Location: (%f,%f)",location.latitude, location.longitude);
//    DTCScoop *scoop = [DTCScoop scoopWithTitle:self.titleLabel.text
//                                        author:self.authorProfile.name
//                                          text:self.textView.text
//                                      latitude:[NSString stringWithFormat:@"%f",location.latitude]
//                                     longitude:[NSString stringWithFormat:@"%f",location.longitude]
//                                         image:nil];
//    DTCScoop *scoop = [DTCScoop scoopWithTitle:self.titleLabel.text
//                                        author:self.authorProfile.name
//                                          text:self.textView.text
//                                        coords:location
//                                         image:nil];
    
    
    // Table from Azure where we save data
    MSTable *scoopsTable = [self.client tableWithName:@"news"];
    
    NSDictionary *scoopDict = @{@"authorId":self.client.currentUser.userId,
                                @"title":self.titleLabel.text,
                                @"author":self.authorProfile.name,
                                @"text":self.textView.text,
                                @"latitude":[NSString stringWithFormat:@"%f",location.latitude],
                                @"longitude":[NSString stringWithFormat:@"%f",location.longitude],
                                @"counter":@0,
                                @"rating":@0,
                                @"status":@"InReview"};
    
    
    [scoopsTable insert:scoopDict completion:^(NSDictionary *item, NSError *error) {
        if (error) {
            NSLog(@"Error when adding new scoop to Azure --> %@",error);
        }
        else{
            NSLog(@"Scoop added successfully --> %@", item);
            // Hide this VC once the scoop has been saved to Azure
            [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
            
                // Let the Editor Dashboard know that a new scoop has been added
                [self notifyThatNewScoopHasBeenAdded];
            }];
        }
    }];
}


#pragma mark - CLLocationManagerDelegate
/*
-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    if (oldLocation == nil) {
        oldLocation = newLocation;
    }
    location = newLocation.coordinate;
    NSLog(@"Current location: (%f,%f)",newLocation.coordinate.latitude,newLocation.coordinate.longitude);

}
*/

// Get some locations. Catch the last locations, which will be the best
-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    NSLog(@"Estoy en didUpdateLocations...");
    
    // Stop using GPS to determine the location
//    [self.locationManager stopUpdatingLocation];
//    self.locationManager = nil;
    
    // Last location
    CLLocation *loc = [locations lastObject];
    
    
    //NSLog(@"Current location: (%f,%f)",loc.coordinate.latitude,loc.coordinate.longitude);
    
    location = loc.coordinate;
    
    /*
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"LOCATION" message:[NSString stringWithFormat:@"Current location: (%f,%f)",loc.coordinate.latitude,loc.coordinate.longitude] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Done", nil];
     */
    
    //[alert show];
    
}




#pragma mark - UITextFieldDelegate

// What to do when Return key pressed
// It's a good time to validate and then hide keyboard (resignFirstResponder)
// Returns NO if it does not validate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    // Title can not be empty
    if ([textField.text length]>0) {
        [textField resignFirstResponder];
        return YES;
    }
    return NO;
}


// What to do when editing ended. Save to the model
- (void) textFieldDidEndEditing:(UITextField *)textField{
    
}



#pragma mark - UITextViewDelegate

// What to do when Return key pressed
// Hide keyboard and stop being FirstResponder
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    [textView resignFirstResponder];
    return YES;
}


// What to do when editing ended. Save to the model
- (void) textViewDidEndEditing:(UITextView *)textView{
    
}






#pragma mark - Notifications
-(void) notifyThatNewScoopHasBeenAdded{
    NSNotification *not = [NSNotification notificationWithName:EDITOR_DID_ADD_SCOOP_NOTIFICATION object:self];
    [[NSNotificationCenter defaultCenter] postNotification:not];    
}



@end
