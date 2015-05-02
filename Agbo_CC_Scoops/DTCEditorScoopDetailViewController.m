//
//  DTCEditorScoopDetailViewController.m
//  Agbo_CC_Scoops
//
//  Created by David de Tena on 30/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import "DTCEditorScoopDetailViewController.h"
#import "DTCScoop.h"

@interface DTCEditorScoopDetailViewController (){
    NSString *address;
    MKPointAnnotation *annotation;
}

@end

@implementation DTCEditorScoopDetailViewController


#pragma mark - Init
-(id) initWithModel:(DTCScoop *) model{
    if (self = [super init]) {
        _model = model;
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
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSLog(@"Scoop location: (%f,%f)",self.model.coords.latitude,self.model.coords.longitude);
    
    self.titleLabel.text = self.model.title;
    
    self.textView.text = self.model.text;
    self.textView.font = [UIFont fontWithName:@"Helvetica Neue" size:15];
    
    self.latitudeLabel.text = [NSString stringWithFormat:@"%f",self.model.coords.latitude];
    self.longitudeLabel.text = [NSString stringWithFormat:@"%f",self.model.coords.longitude];
    
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


@end
