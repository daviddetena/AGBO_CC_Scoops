//
//  DTCEditorScoopDetailViewController.h
//  Agbo_CC_Scoops
//
//  Created by David de Tena on 30/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

@import UIKit;
@import MapKit;
@class DTCScoop;

@interface DTCEditorScoopDetailViewController : UIViewController<MKMapViewDelegate>

#pragma mark - Properties
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;


// Model
@property (strong,nonatomic) DTCScoop *model;

#pragma mark - Init
-(id) initWithModel:(DTCScoop *) model;

@end
