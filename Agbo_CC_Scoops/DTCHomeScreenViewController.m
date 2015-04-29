//
//  DTCHomeScreenViewController.m
//  Agbo_CC_Scoops
//
//  Created by David de Tena on 29/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "DTCHomeScreenViewController.h"
#import "AzureSettings.h"

@interface DTCHomeScreenViewController (){
    MSClient *client;
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
- (void) facebookLogin{
    
    // Check if user already exists
    if ([self loadUserAuthInfo]) {
        // If exists => call backend API to get info about FB login API
        
        [client invokeAPI:@"getuserinfofromauthprovider" body:nil HTTPMethod:@"GET" parameters:nil headers:nil completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
            
            if (error) {
                NSLog(@"Error al recuperar datos de FB desde el API backend de Azure -> %@", error);
            }
            else{
                NSLog(@"%@", result);
                
                // Obtenemos imagen de FB del usuario activo logado
                //self.profilePicture = [NSURL URLWithString:result[@"picture"][@"data"][@"url"]];
            }
        }];
        
        
        return;
    }
    else{
        // New user => call backend API so that it call FB API and presents
        // FB login in a WebView over current ViewController
        
        
        // Present another View Controller with the author's dashboard and FB profile picture
    }
    
}


// Get the data of the current authenticated user. Returns NO if no user
- (BOOL) loadUserAuthInfo{
    
    return NO;
}




#pragma mark - Actions

// In chase the editor's button is touched, the FB connect login webview will
// be displayed
- (IBAction)displayEditorView:(id)sender {
    
    [self facebookLogin];
}

- (IBAction)displayUserView:(id)sender {
}
@end
