//
//  DTCHomeScreenViewController.m
//  Agbo_CC_Scoops
//
//  Created by David de Tena on 29/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "DTCHomeScreenViewController.h"
#import "DTCEditorDashboardViewController.h"
#import "AzureSettings.h"
#import "DTCAuthProfile.h"

@interface DTCHomeScreenViewController (){
    MSClient *client;
    NSString *userFBId;
    NSString *tokenFB;
}

@end

@implementation DTCHomeScreenViewController


#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup Azure client
    [self warmupAzure];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Azure settings
- (void) warmupAzure{
    client = [MSClient clientWithApplicationURL:[NSURL URLWithString:AZURE_END_POINT]
                                 applicationKey:AZURE_APP_KEY];
    
    NSLog(@"%@", client);
}


#pragma mark - Authentication
- (void) loginAppInViewController:(UIViewController *) controller{
    
    // Check if user already exists
    if ([self loadUserAuthInfo]) {
        // If exists => call backend API to get info about FB login API, in this case, the profile picture
        
        [client invokeAPI:@"getuserinfofromauthprovider"
                     body:nil
               HTTPMethod:@"GET"
               parameters:nil
                  headers:nil
               completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
                   
                   if (error) {
                       NSLog(@"Error when fetching FB data from Azure's backend API -> %@", error);
                   }
                   else{
                       NSLog(@"%@", result);
                       
                       // Present a new VC with data of the user logged in
                       NSURL *imgUrl = [NSURL URLWithString:result[@"picture"][@"data"][@"url"]];
                       DTCAuthProfile *userProfile = [DTCAuthProfile authProfileWithName:result[@"name"] imageUrl:imgUrl];
                       [self presentDashboardForUser:userProfile withMSClient:client];
                   }
               }];
        
        return;
    }
    else{
        // New user => call backend API so that it call FB API and presents
        // FB login in a WebView over current ViewController
        [client loginWithProvider:@"facebook"
                       controller:controller
                         animated:YES
                       completion:^(MSUser *user, NSError *error) {
                           if (error) {
                               NSLog(@"Error when connecting to Facebook through Azure's backend API --> %@", error);
                           }
                           else{
                               // Successfully logged in with FB. Save current user data to NSUserDefaults
                               NSLog(@"user -> %@", user);
                               [self saveUserAuthInfo];
                               
                               // Call backend API to get some FB public data from the logged user
                               [client invokeAPI:@"getuserinfofromauthprovider"
                                            body:nil
                                      HTTPMethod:@"GET"
                                      parameters:nil
                                         headers:nil
                                      completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
                                          
                                          if (error) {
                                              NSLog(@"Error when fetching FB user data from Azure's backend API -> %@", error);
                                          }
                                          else{
                                              NSLog(@"%@", result);
                                              
                                              // Present a new VC with data of the user logged in
                                              NSURL *imgUrl = [NSURL URLWithString:result[@"picture"][@"data"][@"url"]];
                                              DTCAuthProfile *userProfile = [DTCAuthProfile authProfileWithName:result[@"name"] imageUrl:imgUrl];
                                              [self presentDashboardForUser:userProfile withMSClient:client];
                                          }
                                      }];
                           }
        }];
    }
}


// Get the data of the current authenticated user. Returns NO if no user
- (BOOL) loadUserAuthInfo{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    userFBId = [defaults objectForKey:@"userID"];
    tokenFB = [defaults objectForKey:@"tokenFB"];
    
    // If data, save them to the MSClient
    if (userFBId) {
        client.currentUser = [[MSUser alloc]initWithUserId:userFBId];
        client.currentUser.mobileServiceAuthenticationToken = tokenFB;
        
        // Return new instance of the MSClient with userFBId saved
        return YES;
    }
    
    return NO;
}

// Save in NSUserDefaults settings of the current authenticated user
- (void) saveUserAuthInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:client.currentUser.userId forKey:@"userId"];
    [defaults setObject:client.currentUser.mobileServiceAuthenticationToken forKey:@"tokenFB"];
    
    [defaults synchronize];
}

#pragma mark - Utils
         
- (void) presentDashboardForUser:(DTCAuthProfile *) user withMSClient:(MSClient *) msClient{
    //DTCEditorDashboardViewController *editorDashboardVC = [[DTCEditorDashboardViewController alloc] initWithModel:user];
    DTCEditorDashboardViewController *editorDashboardVC = [[DTCEditorDashboardViewController alloc] initWithModel:user MSClient:msClient];
    [self presentViewController:editorDashboardVC animated:YES completion:nil];
}

#pragma mark - Actions

// In chase the editor's button is touched, the FB connect login webview will
// be displayed
- (IBAction)displayEditorView:(id)sender {
    
    [self loginAppInViewController:self];
}

- (IBAction)displayUserView:(id)sender {
}
@end
