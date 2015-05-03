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
                        status:(NSString *) aStatus
                        coords:(CLLocationCoordinate2D) coords
                         image:(NSData *) anImage{
    
    return [[self alloc] initWithTitle:aTitle
                                author:anAuthor
                                  text:aText
                                status:(NSString *) aStatus
                                coords:coords
                                 image:anImage];
}


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
                    modificationDate:(NSString *) aModificationDate{
    
    return [[self alloc] initFromAzureWithID:idScoop
                                       title:aTitle
                                      author:anAuthor
                                        text:aText
                                      status:aStatus
                                     counter:aCounter
                                      rating:aRating
                                      coords:coords
                                       image:anImage
                                creationDate:aCreationDate
                            modificationDate:aModificationDate];
}


#pragma mark - Instance init
// Designated
-(id) initWithTitle:(NSString *) aTitle
             author:(NSString *) anAuthor
               text:(NSString *) aText
             status:(NSString *) aStatus
             coords:(CLLocationCoordinate2D) coords
              image:(NSData *) anImage{

    if (self = [super init]) {
        _title = aTitle;
        _author = anAuthor;
        _text = aText;
        _status = aStatus;
        _rating = @0;
        _counter = @0;
        _coords = coords;
        _image = anImage;
        _creationDate = [NSDate date];
        _modificationDate = [NSDate date];

    }
    return self;
}


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
         modificationDate:(NSString *) aModificationDate{

    if (self = [super init]) {
        _idScoop = idScoop;
        _title = aTitle;
        _author = anAuthor;
        _text = aText;
        _status = aStatus;
        _counter = aCounter;
        _rating = aRating;
        _coords = coords;
        _image = anImage;
        _creationDateString = aCreationDate;
        _modificationDateString = aModificationDate;
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

-(NSDictionary *) proxyForAzureDictionary{
    NSDictionary *dict = @{@"id":self.idScoop,
                           @"title": self.title,
                           @"text":self.text,
                           @"authorId":self.author,
                           @"status":self.status,
                           @"latitude":[NSString stringWithFormat:@"%f",self.coords.latitude],
                           @"longitude":[NSString stringWithFormat:@"%f",self.coords.longitude],
                           @"rating":self.rating,
                           @"counter":self.counter,
                           @"modificationDate":[NSString stringWithFormat:@"%@",self.modificationDate]};
    
    return dict;
}


-(NSString *) stringFromCooordinatePart:(float) coordinatePart{
    NSString *coordString = [NSString stringWithFormat:@"%f",coordinatePart];
    return coordString;
}


#pragma mark - Dates


-(NSString *) creationDateWithPrettyFormat{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm:ss"];

    NSString *formattedDateString = [dateFormatter stringFromDate:self.creationDateString];
    return  formattedDateString;
}


-(NSString *) modificationDateWithPrettyFormat{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm:ss"];
    
    NSString *formattedDateString = [dateFormatter stringFromDate:self.modificationDateString];
    return  formattedDateString;
}



-(NSDate *) dateFromRFC3339DateTimeString:(NSString *) rfc3339DateTimeString{
//    NSDateFormatter *rfc3339DateFormatter = [[NSDateFormatter alloc] init];
//    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
//    
//    [rfc3339DateFormatter setLocale:enUSPOSIXLocale];
//    [rfc3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
//    [rfc3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
//    
//    // Convert the RFC 3339 date time string to an NSDate.
//    NSDate *date = [rfc3339DateFormatter dateFromString:[rfc3339DateTimeString stringByReplacingOccurrencesOfString:@"+00:00" withString:@""]];
//    return date;
    /*
     Returns a user-visible date time string that corresponds to the specified
     RFC 3339 date time string. Note that this does not handle all possible
     RFC 3339 date time strings, just one of the most common styles.
     */
    
    NSDateFormatter *rfc3339DateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    [rfc3339DateFormatter setLocale:enUSPOSIXLocale];
    [rfc3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    [rfc3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    // Convert the RFC 3339 date time string to an NSDate.
    NSDate *date = [rfc3339DateFormatter dateFromString:rfc3339DateTimeString];
    
//    NSString *userVisibleDateTimeString;
//    if (date != nil) {
//        // Convert the date object to a user-visible date string.
//        NSDateFormatter *userVisibleDateFormatter = [[NSDateFormatter alloc] init];
//        assert(userVisibleDateFormatter != nil);
//        
//        [userVisibleDateFormatter setDateStyle:NSDateFormatterShortStyle];
//        [userVisibleDateFormatter setTimeStyle:NSDateFormatterShortStyle];
//        
//        userVisibleDateTimeString = [userVisibleDateFormatter stringFromDate:date];
//    }
    return date;
}



- (NSString *)userVisibleDateTimeStringForRFC3339DateTimeString:(NSString *)rfc3339DateTimeString {
    /*
     Returns a user-visible date time string that corresponds to the specified
     RFC 3339 date time string. Note that this does not handle all possible
     RFC 3339 date time strings, just one of the most common styles.
     */
    
    NSDateFormatter *rfc3339DateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    [rfc3339DateFormatter setLocale:enUSPOSIXLocale];
    [rfc3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    [rfc3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    // Convert the RFC 3339 date time string to an NSDate.
    NSDate *date = [rfc3339DateFormatter dateFromString:rfc3339DateTimeString];
    
    NSString *userVisibleDateTimeString;
    if (date != nil) {
        // Convert the date object to a user-visible date string.
        NSDateFormatter *userVisibleDateFormatter = [[NSDateFormatter alloc] init];
        assert(userVisibleDateFormatter != nil);
        
        [userVisibleDateFormatter setDateStyle:NSDateFormatterShortStyle];
        [userVisibleDateFormatter setTimeStyle:NSDateFormatterShortStyle];
        
        userVisibleDateTimeString = [userVisibleDateFormatter stringFromDate:date];
    }
    return userVisibleDateTimeString;
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
