//
//  DTCAuthProfile.h
//  Agbo_CC_Scoops
//
//  Created by David de Tena on 29/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

@import Foundation;

@interface DTCAuthProfile : NSObject

#pragma mark - Properties
@property (copy,nonatomic) NSString *name;
@property (strong,nonatomic) NSURL *profileImageUrl;


#pragma mark - Factory init
+(instancetype) authProfileWithName:(NSString *) name imageUrl:(NSURL *) profileImageUrl;

#pragma mark - Init
-(id) initWithName:(NSString *) name imageUrl:(NSURL *) profileImageUrl;

@end
