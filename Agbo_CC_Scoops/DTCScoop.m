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
                        coords:(CLLocationCoordinate2D *) coords
                         image:(NSData *) anImage{
    
    return [[self alloc] initWithTitle:aTitle
                                author:anAuthor
                                  text:aText
                                coords:coords
                                 image:anImage];
}


#pragma mark - Instance init
// Designated
-(id) initWithTitle:(NSString *) aTitle
             author:(NSString *) anAuthor
               text:(NSString *) aText
             coords:(CLLocationCoordinate2D *) coords
              image:(NSData *) anImage{

    if (self = [super init]) {
        _title = aTitle;
        _author = anAuthor;
        _text = aText;
        _coords = coords;
        _image = anImage;
        _creationDate = [NSDate date];
    }
    return self;
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
