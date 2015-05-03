//
//  DTCUserScoopDetailViewController.m
//  Agbo_CC_Scoops
//
//  Created by David de Tena on 03/05/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import "DTCUserScoopDetailViewController.h"
#import "DTCScoop.h"

@interface DTCUserScoopDetailViewController (){
    NSString *address;
    MKPointAnnotation *annotation;
}


@end

@implementation DTCUserScoopDetailViewController


#pragma mark - Init
-(id) initWithModel:(DTCScoop *) model client:(MSClient *) client{
    if (self = [super init]) {
        _model = model;
        _client = client;
        self.title = model.title;
    }
    return self;
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self configureUI];
}



#pragma mark - Memory
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UI

-(void) configureUI{
    
    // Right bar button to rate
    UIBarButtonItem *rateButton = [[UIBarButtonItem alloc] initWithTitle:@"Rate" style:UIBarButtonItemStyleDone target:self action:@selector(rateScoop:)];
    self.navigationItem.rightBarButtonItem = rateButton;
    
    // Top-left alignment for textView
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSLog(@"Scoop location: (%f,%f)",self.model.coords.latitude,self.model.coords.longitude);
    
    // Labels
    self.titleLabel.text = self.model.title;    
    self.textView.text = self.model.text;
    self.textView.font = [UIFont fontWithName:@"Helvetica Neue" size:15];
    
   // NSDecimalNumber decimalNumberWithString:item[@"latitude"]] doubleValue]
    self.ratingLabel.text = [NSString stringWithFormat:@"%@",self.model.rating];
    
    // Image
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width/2;
    self.imageView.clipsToBounds = YES;
    //[self performSelector:@selector(displayImage) withObject:self afterDelay:0.7];
    
    // Map
    [self configureMapView];
    
    // Rating
    self.ratingLabel.text = [NSString stringWithFormat:@"%@", self.model.rating];
}


-(void) displayImage{
    self.imageView.image = [UIImage imageWithData:self.model.image];
}



#pragma mark - Utils

// Apply inverse geoLocater from the scoop location
-(void) configureMapView{
    
    // Map
    annotation = [[MKPointAnnotation alloc]init];
    annotation.coordinate = self.model.coords;
    annotation.title = [NSString stringWithFormat:@"► %@",self.model.title];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:self.model.coords.latitude longitude:self.model.coords.longitude];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count]>0) {
            CLPlacemark *placemark = [placemarks lastObject];
            
            annotation.subtitle = [NSString stringWithFormat:@"%@ %@. %@, %@",
                                   placemark.postalCode,
                                   placemark.thoroughfare,
                                   placemark.locality,
                                   placemark.country];
            
            
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.model.coords, 680, 680);
            MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
            [self.mapView setRegion:adjustedRegion animated:YES];
            [self.mapView addAnnotation:annotation];
            
        }
        else{
            annotation.subtitle = @"N/A";
            
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.model.coords, 680, 680);
            MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
            [self.mapView setRegion:adjustedRegion animated:YES];
            [self.mapView addAnnotation:annotation];
        }
        
    }];
}


#pragma mark - Actions

- (IBAction)sliderDidChangeValue:(id)sender {
    self.myRatingLabel.text = [NSString stringWithFormat:@"My rating: %d",(int)self.myRatingSlider.value];
}

// Save rating to Azure
- (void) rateScoop:(id) sender{
    
    // Some math calcs
    int currentCounter = (int) [self.model.counter integerValue];
    int counter = currentCounter + 1;
    
    double currentRating = (double) self.myRatingSlider.value;
    double overallRating = (double) [self.model.rating doubleValue];
    double rating = (overallRating + currentRating)/counter;
    
    //MSTable
    MSTable *scoopsTable = [self.client tableWithName:@"news"];
    self.model.rating = [NSNumber numberWithDouble:rating];
    self.model.counter = [NSNumber numberWithInt:counter];
    NSDictionary *updated = [self.model proxyForAzureDictionary];
    
    [scoopsTable update:updated completion:^(NSDictionary *item, NSError *error) {
        if (error) {
            NSLog(@"Error when updating");
        }
        else{
            NSLog(@"Updated");
        }
    }];
}


@end
