//
//  DTCEditorDashboardViewController.m
//  Agbo_CC_Scoops
//
//  Created by David de Tena on 29/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import "DTCEditorDashboardViewController.h"
#import "DTCEditorScoopDetailViewController.h"
#import "DTCNewScoopViewController.h"
#import "UIViewController+Navigation.h"
#import "DTCScoop.h"
#import "DTCAuthProfile.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>

@import CoreLocation;

@interface DTCEditorDashboardViewController ()

@property (strong,nonatomic) NSMutableArray *inReviewScoops;
@property (strong,nonatomic) NSMutableArray *publishedScoops;

@end

@implementation DTCEditorDashboardViewController


#pragma mark - Init
-(id) initWithModel:(DTCAuthProfile *) authorProfile MSClient:(MSClient *)client{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _authorProfile = authorProfile;
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
    
    [self setupNewScoopNotifications];
}


- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self tearDownNewScoopNotifications];
}



#pragma mark - Memory

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
    self.profileNameLabel.text = self.authorProfile.name;
    
    [self loadProfilePicture];    
    //[self populateTableWithScoops];
}

- (void) loadProfilePicture{
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        // Download image of profile in background
        NSData *imgData = [NSData dataWithContentsOfURL:self.authorProfile.profileImageUrl];
        
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
    
    /*
        Query from MSTable
     */
    /*
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"status == %@",self.authorProfile.name];
    
    [scoopsTable readWithPredicate:predicate completion:^(NSArray *items, NSInteger totalCount, NSError *error) {
        if (error) {
            NSLog(@"Error when reading scoops from Azure --> %@", error);
        }
        else{
            [self populateScoopsInTable:items];
        }
    }];
    */
    
    /**
        Query from MSQuery
     */
    
    // MSQuery to get all scoops
    MSQuery *query = [scoopsTable query];
    //query.selectFields = @[@"author",@"status",@"title",@"text",@"rating"];
    query.predicate = [NSPredicate predicateWithFormat:@"author == %@",self.authorProfile.name];
    
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
    
        //NSLog(@"(%@,%@)",item[@"latitude"],item[@"longitude"]);
        
        //
        
        CLLocationCoordinate2D current = CLLocationCoordinate2DMake([[NSDecimalNumber decimalNumberWithString:item[@"latitude"]] doubleValue],[[NSDecimalNumber decimalNumberWithString:item[@"longitude"]] doubleValue]);
        
        
        //NSLog(@"%@",current);
        
        DTCScoop *scoop = [DTCScoop scoopWithTitle:item[@"title"]
                                            author:item[@"author"]
                                              text:item[@"text"]
                                            coords:current
                                             image:nil];
//        DTCScoop *scoop = [DTCScoop scoopWithTitle:item[@"title"]
//                                            author:item[@"title"]
//                                              text:item[@"text"]
//                                          latitude:item[@"latitude"]
//                                         longitude:item[@"longitude"]
//                                             image:nil];
        
        //DTCScoop *scoop = [DTCScoop scoopWithTitle:item[@"title"] author:item[@"author"] text:item[@"text"] rating:item[@"rating"]  image:nil];
        
        NSLog(@"Current location: (%f,%f)",scoop.coords.latitude,scoop.coords.longitude);
        
        if ([item[@"status"] isEqualToString:@"InReview"]) {

            if (![self.inReviewScoops containsObject:scoop]) {
                // Add to in-review
                [self.inReviewScoops addObject:scoop];
            }
        }
        else{
            if (![self.inReviewScoops containsObject:scoop]) {
                // Add to published
                [self.publishedScoops addObject:scoop];
            }
        }
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
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

    // Deselect highlighted
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // Present scoop detailed view
    DTCScoop *scoop = [self scoopAtIndexPath:indexPath];
    DTCEditorScoopDetailViewController *scoopDetailVC = [[DTCEditorScoopDetailViewController alloc]initWithModel:scoop];
    [self.navigationController pushViewController:scoopDetailVC animated:YES];
}



#pragma mark - Actions

-(void) addNewScoop:(id)sender{
    // Present modal view controller to create a new scoop
    DTCNewScoopViewController *newScoopVC = [[DTCNewScoopViewController alloc] initWithAuthorProfile:self.authorProfile MSClient:self.client];
    [self presentViewController:[newScoopVC wrappedInNavigation] animated:YES completion:^{
        // Reload data when new scoopd saved
        //[self fetchScoopsFromAzure];
    }];
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



#pragma mark - Notifications

-(void) setupNewScoopNotifications{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(notifyThatEditorDidAddScoop:)
                   name:EDITOR_DID_ADD_SCOOP_NOTIFICATION
                 object:nil];
}

- (void) tearDownNewScoopNotifications{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}

// When a new scoop is added we need to reload data
-(void) notifyThatEditorDidAddScoop:(NSDictionary *) info{
    NSLog(@"Table did notice that new scoop was added");
    [self fetchScoopsFromAzure];
}
    


@end
