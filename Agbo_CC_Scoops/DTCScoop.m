//
//  DTCScoop.m
//  Agbo_CC_Scoops
//
//  Created by David de Tena on 29/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import "DTCScoop.h"

@implementation DTCScoop

#pragma mark - Factory init
+(instancetype) scoopWithTitle:(NSString *) aTitle
                        author:(NSString *) anAuthor
                          text:(NSString *) aText
                        coords:(CLLocationCoordinate2D) coords
                         image:(NSData *) anImage{
    
    return [[self alloc] initWithTitle:aTitle
                                author:anAuthor
                                  text:aText
                                coords:coords
                                 image:anImage];
}


//+(instancetype) scoopWithTitle:(NSString *) aTitle
//                        author:(NSString *) anAuthor
//                          text:(NSString *) aText
//                      latitude:(double) aLatitude
//                     longitude:(double) aLongitude
//                         image:(NSData *) anImage{
//
//    return [[self alloc] initWithTitle:aTitle
//                                author:anAuthor
//                                  text:aText
//                              latitude:aLatitude
//                             longitude:aLongitude
//                                 image:anImage];
//}


+(instancetype) scoopWithTitle:(NSString *) aTitle
                        author:(NSString *) anAuthor
                          text:(NSString *) aText
                      latitude:(NSString *) aLatitude
                     longitude:(NSString *) aLongitude
                         image:(NSData *) anImage{
    
    return [[self alloc] initWithTitle:aTitle
                                author:anAuthor
                                  text:aText
                              latitude:aLatitude
                             longitude:aLongitude
                                 image:anImage];
}


#pragma mark - Instance init
// Designated
-(id) initWithTitle:(NSString *) aTitle
             author:(NSString *) anAuthor
               text:(NSString *) aText
             coords:(CLLocationCoordinate2D) coords
              image:(NSData *) anImage{

    if (self = [super init]) {
        _title = aTitle;
        _author = anAuthor;
        _text = aText;
        _rating = @0;
        _counter = @0;
        _coords = coords;
//        _latitude = coords.latitude ;
//        _longitude = coords.longitude;
        _image = anImage;
        _creationDate = [NSDate date];
        _status = @"InReview";

    }
    return self;
}

// Designated
//-(id) initWithTitle:(NSString *) aTitle
//             author:(NSString *) anAuthor
//               text:(NSString *) aText
//           latitude:(double) latitude
//          longitude:(double) longitude
//              image:(NSData *) anImage{
//    
//    if (self = [super init]) {
//        _title = aTitle;
//        _author = anAuthor;
//        _text = aText;
//        _rating = @0;
//        _counter = @0;
//        _latitude = latitude ;
//        _longitude = longitude;
//        _image = anImage;
//        _creationDate = [NSDate date];
//        _status = @"InReview";
//        
//    }
//    return self;
//}


-(id) initWithTitle:(NSString *) aTitle
             author:(NSString *) anAuthor
               text:(NSString *) aText
           latitude:(NSString *) latitude
          longitude:(NSString *) longitude
              image:(NSData *) anImage{
    
    if (self = [super init]) {
        _title = aTitle;
        _author = anAuthor;
        _text = aText;
        _rating = @0;
        _counter = @0;
        _latitude = latitude ;
        _longitude = longitude;
        _image = anImage;
        _creationDate = [NSDate date];
        _status = @"InReview";
        
    }
    return self;
}



#pragma mark - Utils

// Package object in a NSDictionary
-(NSDictionary *) proxyForDictionary{
    NSDictionary *dict = @{@"title": self.title,
                           @"text":self.text,
                           @"author":self.author,
                           @"coords":@"",
                           @"image":self.image,
                           @"status":self.status};
    
    return dict;
}

// Package object in a NSDictionary
//-(NSDictionary *) proxyForAzureDictionary{
//    NSDictionary *dict = @{@"title": self.title,
//                           @"text":self.text,
//                           @"author":self.author,
//                           @"status":self.status,
//                           @"latitude":self.latitude,
//                           @"longitude":self.longitude,
//                           @"rating":self.rating,
//                           @"counter":self.counter};
//    
//    return dict;
//}

-(NSDictionary *) proxyForAzureDictionary{
    NSDictionary *dict = @{@"title": self.title,
                           @"text":self.text,
                           @"author":self.author,
                           @"status":self.status,
                           @"latitude":self.latitude,
                           @"longitude":[NSString stringWithFormat:@"%f",self.coords.latitude],
                           @"rating":[NSString stringWithFormat:@"%f",self.coords.longitude],
                           @"counter":self.counter};
    
    return dict;
}


-(NSString *) stringFromCooordinatePart:(float) coordinatePart{
    NSString *coordString = [NSString stringWithFormat:@"%f",coordinatePart];
    return coordString;
}



#pragma mark - Overwritten

-(NSString*) description{
    return [NSString stringWithFormat:@"<%@ %@>", [self class], self.title];
}


- (BOOL)isEqual:(id)object{
    
    
    return [self.title isEqualToString:[object title]];
}

- (NSUInteger)hash{
    return [_title hash] ^ [_text hash];
}


@end
