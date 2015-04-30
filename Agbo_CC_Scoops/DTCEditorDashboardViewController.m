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
#import "DTCScoop.h"
@import CoreLocation;

@interface DTCEditorDashboardViewController ()

@property (strong,nonatomic) NSMutableArray *inReviewScoops;
@property (strong,nonatomic) NSMutableArray *publishedScoops;

@end

@implementation DTCEditorDashboardViewController


#pragma mark - Init
-(id) initWithModel:(DTCAuthProfile *) model MSClient:(MSClient *)client{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _model = model;
        _client = client;
        _inReviewScoops = [@[]mutableCopy];
        _publishedScoops = [@[]mutableCopy];
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set delegate and data source for the tableView
    self.scoopsTableView.delegate = self;
    self.scoopsTableView.dataSource = self;
    
    [self fetchScoopsFromAzure];
}


- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self configureUI];
    [self syncViewWithModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UI

- (void) configureUI{
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleDone target:self action:@selector(configureLogout:)];
    UIBarButtonItem *addScoopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(addNewScoop:)];
    
    self.navigationItem.leftBarButtonItem = logoutButton;
    self.navigationItem.rightBarButtonItem = addScoopButton;
}

- (void) syncViewWithModel{
    self.profileNameLabel.text = self.model.name;    
    
    [self loadProfilePicture];    
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

#pragma mark - Azure settings
- (void) fetchScoopsFromAzure{

    // Table
    MSTable *scoopsTable = [self.client tableWithName:@"news"];
    
    // MSQuery to get all scoops
    MSQuery *query = [scoopsTable query];
    
    
    [query readWithCompletion:^(NSArray *items, NSInteger totalCount, NSError *error) {
        if (error) {
            NSLog(@"Error when reading scoops from Azure --> %@", error);
        }
        else{
            [self populateScoopsInTable:items];
        }
    }];
    
    
    // Add in-review scoops to in-review array
    
    // Add published scoops to published array

}


- (void) populateScoopsInTable:(NSArray *) items{

    // Create a new Scoop for each item
    for (id item in items) {
        DTCScoop *scoop = [DTCScoop scoopWithTitle:item[@"titulo"] author:@"" text:item[@"text"] coords:CLLocationCoordinate2DMake(0, 0) image:nil];
        [self.inReviewScoops addObject:scoop];
        [self.publishedScoops addObject:scoop];
        
        /*
        if ([item[@"status"] isEqualToString:@"InReview"]) {

            // Add to in-review
            [self.inReviewScoops addObject:scoop];
        }
        else{
            // Addo to published
            [self.publishedScoops addObject:scoop];
        }
         */
    }
    [self.scoopsTableView reloadData];
}


#pragma mark - UITableViewDataSource

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return [self.inReviewScoops count];
    }
    else{
        return [self.publishedScoops count];
    }
}


-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"In Review";
    }
    else{
        return @"Published";
    }
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DTCScoop *scoop = [self scoopAtIndexPath:indexPath];
    
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    // Format for the modification date
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateStyle = NSDateFormatterFullStyle;
    
    cell.textLabel.text = scoop.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Created at: %@",[fmt stringFromDate:scoop.creationDate]];
    
    return cell;
}


-(DTCScoop *) scoopAtIndexPath:(NSIndexPath *) indexPath{

    DTCScoop *scoop = nil;
    
    if (indexPath.section == 0) {
            // In-review scoops
        scoop = (DTCScoop *)[self.inReviewScoops objectAtIndex:indexPath.row];
    }
    else{
        // Published scoops
        scoop = (DTCScoop *)[self.publishedScoops objectAtIndex:indexPath.row];
    }
    return scoop;
}



#pragma mark - UITableViewDelegate
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    //DTCScoop *scoop = [self scoopAtIndexPath:indexPath];
}



#pragma mark - Actions

-(void) addNewScoop:(id)sender{
    // Present modal view controller to create a new scoop
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"HOLA" message:@"prueba" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Done", nil];
    [alert show];
}

-(void) configureLogout:(id)sender{
    
    // Logout if there is a current user    
    if (self.client.currentUser) {
        // Remove settings in NSUserDefaults
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"userFBId"];
        [defaults removeObjectForKey:@"tokenFB"];
        [defaults synchronize];
        
        // Erase cookies and cache
        for (NSHTTPCookie *value in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:value];
        }
        
        // Logout from Azure
        [self.client logout];
        
        // Go to the main screen
        [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
            // Some stuff
        }];
    }
}


@end
