//
//  DTCAuthProfile.m
//  Agbo_CC_Scoops
//
//  Created by David de Tena on 29/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import "DTCAuthProfile.h"

@implementation DTCAuthProfile


#pragma mark - Factory init
+(instancetype) authProfileWithName:(NSString *) name imageUrl:(NSURL *) profileImageUrl{
    return [[self alloc]initWithName:name imageUrl:profileImageUrl];
}


#pragma mark - Init
-(id) initWithName:(NSString *) name imageUrl:(NSURL *) profileImageUrl{
    if (self = [super init]) {
        _name = name;
        _profileImageUrl = profileImageUrl;
    }
    return self;
}

@end
