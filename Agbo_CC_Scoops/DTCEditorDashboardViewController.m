//
//  DTCEditorDashboardViewController.m
//  Agbo_CC_Scoops
//
//  Created by David de Tena on 29/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import "DTCEditorDashboardViewController.h"
#import "DTCAuthProfile.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>

@interface DTCEditorDashboardViewController ()

@end

@implementation DTCEditorDashboardViewController


#pragma mark - Init
-(id) initWithModel:(DTCAuthProfile *) model MSClient:(MSClient *)client{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _model = model;
        _client = client;
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scoopsTableView.delegate = self;
}


- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self syncViewWithModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UI
- (void) syncViewWithModel{
    self.profileNameLabel.text = self.model.name;
    self.totalScoopsLabel.text = @"10 scoops";
    self.publishedScoopsLabel.text = @"4 scoops";
    
    [self loadProfilePicture];
    
//    self.scoopsTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.scoopsTableView.frame.origin.x, self.scoopsTableView.frame.origin.y, self.scoopsTableView.frame.size.width, self.scoopsTableView.frame.size.height) style:UITableViewStyleGrouped];
    //[self populateTableWithScoops];
}

- (void) loadProfilePicture{
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        // Download image of profile in background
        NSData *imgData = [NSData dataWithContentsOfURL:self.model.profileImageUrl];
        
        // Load image in main queue
        dispatch_async(dispatch_get_main_queue(), ^{
            self.profileImageView.image = [UIImage imageWithData:imgData];
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
            self.profileImageView.clipsToBounds = YES;
        });
        
    });
}



#pragma mark - UITableViewDataSource

/*
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
*/



#pragma mark - UITableViewDelegate




#pragma mark - Actions



@end
