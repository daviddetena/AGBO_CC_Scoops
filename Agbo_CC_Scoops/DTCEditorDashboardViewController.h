//
//  DTCEditorDashboardViewController.h
//  Agbo_CC_Scoops
//
//  Created by David de Tena on 29/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

@import UIKit;
@class DTCAuthProfile;
@class MSClient;

@interface DTCEditorDashboardViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>


#pragma mark - Properties
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalScoopsLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishedScoopsLabel;
@property (weak, nonatomic) IBOutlet UITableView *scoopsTableView;

@property (strong,nonatomic) MSClient *client;
@property (strong,nonatomic) DTCAuthProfile *model;


#pragma mark - Init
-(id) initWithModel:(DTCAuthProfile *) model MSClient:(MSClient *) client;


@end
