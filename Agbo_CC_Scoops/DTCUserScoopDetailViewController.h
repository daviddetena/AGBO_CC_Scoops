//
//  DTCUserScoopDetailViewController.h
//  Agbo_CC_Scoops
//
//  Created by David de Tena on 03/05/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//


#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
@class DTCScoop;
@import UIKit;
@import MapKit;

@interface DTCUserScoopDetailViewController : UIViewController<MKMapViewDelegate>


#pragma mark - Properties
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingCounterLabel;

@property (weak, nonatomic) IBOutlet UILabel *myRatingLabel;
@property (weak, nonatomic) IBOutlet UISlider *myRatingSlider;

// Model and MSAzure client
@property (strong,nonatomic) DTCScoop *model;
@property (strong,nonatomic) MSClient *client;
@property (strong,nonatomic) NSDictionary *dict;


#pragma mark - Init

-(id) initWithModel:(DTCScoop *) model client:(MSClient *) client;


#pragma mark - Actions
- (IBAction)sliderDidChangeValue:(id)sender;


@end
