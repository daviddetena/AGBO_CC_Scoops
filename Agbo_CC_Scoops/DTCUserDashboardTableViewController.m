//
//  DTCUserDashboardTableViewController.m
//  Agbo_CC_Scoops
//
//  Created by David de Tena on 02/05/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import "DTCScoop.h"
#import "DTCUserDashboardTableViewController.h"
#import "DTCUserScoopDetailViewController.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
@import CoreLocation;


@interface DTCUserDashboardTableViewController (){
    NSMutableArray *arrayScoops;
}

@end

@implementation DTCUserDashboardTableViewController


#pragma mark - Init
// Designated
-(id) initWithMSClient:(MSClient *) client{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        _client = client;
        self.title = @"Published scoops";
        arrayScoops = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchScoopsFromAzure];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}





#pragma mark - Memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Azure
- (void) fetchScoopsFromAzure{
    
    NSLog(@"MS client en user table: %@", self.client);
    
    // Table
    MSTable *scoopsTable = [self.client tableWithName:@"news"];

    // MSQuery to get all scoops ordered by _updatedAt descending
    MSQuery *query = [scoopsTable query];
    [query orderByDescending:@"modificationDate"];
    NSString *status = @"Published";
    query.predicate = [NSPredicate predicateWithFormat:@"status == %@",status];
    
    [query readWithCompletion:^(NSArray *items, NSInteger totalCount, NSError *error) {
        if (error) {
            NSLog(@"Error when reading scoops from Azure --> %@", error);
        }
        else{
            [self populateScoopsInTable:items];
        }
    }];
}


- (void) populateScoopsInTable:(NSArray *) items{
    
    // Create a new Scoop for each item
    for (id item in items) {
        
        CLLocationCoordinate2D currentCoords = CLLocationCoordinate2DMake([[NSDecimalNumber decimalNumberWithString:item[@"latitude"]] doubleValue],[[NSDecimalNumber decimalNumberWithString:item[@"longitude"]] doubleValue]);
        
        DTCScoop *scoop = [DTCScoop scoopFromAzureWithID:item[@"id"]
                                                   title:item[@"title"]
                                                  author:item[@"author"]
                                                    text:item[@"text"]
                                                  status:item[@"status"]
                                                 counter:item[@"counter"]
                                                  rating:item[@"rating"]
                                                  coords:currentCoords
                                                   image:nil
                                            creationDate:item[@"creationDate"]
                                        modificationDate:item[@"modificationDate"]];

        NSLog(@"Current location: (%f,%f)",scoop.coords.latitude,scoop.coords.longitude);
        
        // Add scoops
        if (![arrayScoops containsObject:scoop]) {
            [arrayScoops addObject:scoop];
        }
    }
    [self.tableView reloadData];
}



#pragma mark - Table view data source

// Get published scoops => 1 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


// Number of scoops
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrayScoops count];
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
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Last modified: %@",scoop.modificationDateWithPrettyFormat];
    if (scoop.image) {
        cell.imageView.image = [UIImage imageWithData:scoop.image];
    }
    else{
        cell.imageView.image = [UIImage imageNamed:@"noimageThumb"];
        cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width/2;
        cell.imageView.clipsToBounds = YES;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


-(DTCScoop *) scoopAtIndexPath:(NSIndexPath *) indexPath{
    
    DTCScoop *scoop = (DTCScoop *) [arrayScoops objectAtIndex:indexPath.row];
    return scoop;
}



#pragma mark - UITableViewDelegate
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Deselect highlighted
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // Present scoop detailed view
    DTCScoop *scoop = [self scoopAtIndexPath:indexPath];
    DTCUserScoopDetailViewController *scoopDetailVC = [[DTCUserScoopDetailViewController alloc]initWithModel:scoop client:self.client];
    [self.navigationController pushViewController:scoopDetailVC animated:YES];
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
