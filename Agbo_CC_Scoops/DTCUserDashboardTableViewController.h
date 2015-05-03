//
//  DTCUserDashboardTableViewController.h
//  Agbo_CC_Scoops
//
//  Created by David de Tena on 02/05/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

@import UIKit;
@class DTCAuthProfile;
@class MSClient;

@interface DTCUserDashboardTableViewController : UITableViewController



#pragma mark - Properties
@property (strong,nonatomic) MSClient *client;


#pragma mark - Init
-(id) initWithMSClient:(MSClient *) client;


@end
