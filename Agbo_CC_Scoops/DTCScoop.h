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

@property (copy,nonatomic) NSString *title;
@property (copy,nonatomic) NSString *author;
@property (copy,nonatomic) NSString *text;
@property (copy,nonatomic) NSString *status;
@property (nonatomic) NSNumber *rating;
@property (nonatomic) NSNumber *counter;
@property (nonatomic) CLLocationCoordinate2D coords;
//@property (nonatomic) double latitude;
//@property (nonatomic) double longitude;
@property (copy,nonatomic) NSString *latitude;
@property (copy,nonatomic) NSString *longitude;

@property (strong,nonatomic) NSData *image;
@property (strong,nonatomic) NSDate *creationDate;


#pragma mark - Factory init
+(instancetype) scoopWithTitle:(NSString *) aTitle
                        author:(NSString *) anAuthor
                          text:(NSString *) aText
                        coords:(CLLocationCoordinate2D) coords
                         image:(NSData *) anImage;

//+(instancetype) scoopWithTitle:(NSString *) aTitle
//                        author:(NSString *) anAuthor
//                          text:(NSString *) aText
//                      latitude:(double) aLatitude
//                     longitude:(double) aLongitude
//                         image:(NSData *) anImage;

+(instancetype) scoopWithTitle:(NSString *) aTitle
                        author:(NSString *) anAuthor
                          text:(NSString *) aText
                      latitude:(NSString *) aLatitude
                     longitude:(NSString *) aLongitude
                         image:(NSData *) anImage;


#pragma mark - Instance methods
// Designated
-(id) initWithTitle:(NSString *) aTitle
             author:(NSString *) anAuthor
               text:(NSString *) aText
             coords:(CLLocationCoordinate2D) coords
              image:(NSData *) anImage;

//-(id) initWithTitle:(NSString *) aTitle
//             author:(NSString *) anAuthor
//               text:(NSString *) aText
//           latitude:(double) aLatitude
//          longitude:(double) aLongitude
//              image:(NSData *) anImage;

-(id) initWithTitle:(NSString *) aTitle
             author:(NSString *) anAuthor
               text:(NSString *) aText
           latitude:(NSString *) aLatitude
          longitude:(NSString *) aLongitude
              image:(NSData *) anImage;

-(NSDictionary *) proxyForDictionary;
-(NSDictionary *) proxyForAzureDictionary;

@end
