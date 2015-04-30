//
//  DTCNewScoopViewController.h
//  Agbo_CC_Scoops
//
//  Created by David de Tena on 30/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#define EDITOR_DID_ADD_SCOOP_NOTIFICATION @"EDITOR_DID_ADD_SCOOP_NOTIFICATION"
#define EDITOR_DID_ADD_SCOOP @"EDITOR_DID_ADD_SCOOP"

@import UIKit;
@class DTCScoop;
@class MSClient;
@class DTCAuthProfile;

@interface DTCNewScoopViewController : UIViewController<UITextViewDelegate, UITextFieldDelegate>

#pragma mark - Properties
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong,nonatomic) MSClient *client;
@property (strong,nonatomic) DTCAuthProfile *authorProfile;


#pragma mark - Init
-(id) initWithAuthorProfile:(DTCAuthProfile *) authorProfile MSClient:(MSClient *) client;


@end
