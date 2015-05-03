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

@property (copy,nonatomic) NSString *idScoop;
@property (copy,nonatomic) NSString *title;
@property (copy,nonatomic) NSString *author;
@property (copy,nonatomic) NSString *text;
@property (copy,nonatomic) NSString *status;
@property (nonatomic) NSNumber *rating;
@property (nonatomic) NSNumber *counter;
@property (nonatomic) CLLocationCoordinate2D coords;
@property (copy,nonatomic) NSString *latitude;
@property (copy,nonatomic) NSString *longitude;
@property (strong,nonatomic) NSData *image;
@property (strong,nonatomic) NSDate *creationDate;
@property (strong,nonatomic) NSDate *modificationDate;
@property (copy,nonatomic) NSString *creationDateString;
@property (copy,nonatomic) NSString *modificationDateString;


#pragma mark - Factory init
+(instancetype) scoopWithTitle:(NSString *) aTitle
                        author:(NSString *) anAuthor
                          text:(NSString *) aText
                        status:(NSString *) aStatus
                        coords:(CLLocationCoordinate2D) coords
                         image:(NSData *) anImage;


+(instancetype) scoopFromAzureWithID:(NSString *) idScoop
                               title:(NSString *) aTitle
                              author:(NSString *) anAuthor
                                text:(NSString *) aText
                              status:(NSString *) aStatus
                             counter:(NSNumber *) aCounter
                              rating:(NSNumber *) aRating
                              coords:(CLLocationCoordinate2D) coords
                               image:(NSData *) anImage
                        creationDate:(NSString *) aCreationDate
                    modificationDate:(NSString *) aModificationDate;




#pragma mark - Instance methods
// Designated
-(id) initWithTitle:(NSString *) aTitle
             author:(NSString *) anAuthor
               text:(NSString *) aText
             status:(NSString *) aStatus
             coords:(CLLocationCoordinate2D) coords
              image:(NSData *) anImage;


-(id) initFromAzureWithID:(NSString *) idScoop
                    title:(NSString *) aTitle
                   author:(NSString *) anAuthor
                     text:(NSString *) aText
                   status:(NSString *) aStatus
                  counter:(NSNumber *) aCounter
                   rating:(NSNumber *) aRating
                   coords:(CLLocationCoordinate2D) coords
                    image:(NSData *) anImage
             creationDate:(NSString *) aCreationDate
         modificationDate:(NSString *) aModificationDate;

-(NSDictionary *) proxyForDictionary;
-(NSDictionary *) proxyForAzureDictionary;

-(NSString *) creationDateWithPrettyFormat;
-(NSString *) modificationDateWithPrettyFormat;





@end
