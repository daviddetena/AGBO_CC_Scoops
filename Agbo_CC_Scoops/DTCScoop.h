//
//  DTCScoop.h
//  Agbo_CC_Scoops
//
//  Created by David de Tena on 29/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

@import Foundation;
@import CoreLocation;

@interface DTCScoop : NSObject

#pragma mark - Properties

@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *author;
@property (strong,nonatomic) NSString *text;
@property (nonatomic) CLLocationCoordinate2D *coords;
@property (strong,nonatomic) NSData *image;
@property (strong,nonatomic) NSDate *creationDate;


#pragma mark - Factory init
+(instancetype) scoopWithTitle:(NSString *) aTitle
                        author:(NSString *) anAuthor
                          text:(NSString *) aText
                        coords:(CLLocationCoordinate2D *) coords
                         image:(NSData *) anImage;

#pragma mark - Init
-(id) initWithTitle:(NSString *) aTitle
             author:(NSString *) anAuthor
               text:(NSString *) aText
             coords:(CLLocationCoordinate2D *) coords
              image:(NSData *) anImage;

@end
