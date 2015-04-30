//
//  DTCNewScoopViewController.m
//  Agbo_CC_Scoops
//
//  Created by David de Tena on 30/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import "DTCNewScoopViewController.h"
#import "DTCScoop.h"
#import "DTCAuthProfile.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>

@interface DTCNewScoopViewController ()

@end

@implementation DTCNewScoopViewController


#pragma mark - Init
-(id) initWithAuthorProfile:(DTCAuthProfile *) authorProfile MSClient:(MSClient *) client{
    if (self = [super init]) {
        _authorProfile = authorProfile;
        _client = client;
    }
    return self;
}


#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self configureUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - UI

- (void) configureUI{
    
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width/2;
    self.imageView.clipsToBounds = YES;
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAddScoop:)];
    UIBarButtonItem *addScoopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(confirmAddScoop:)];
    
    self.navigationItem.leftBarButtonItem = logoutButton;
    self.navigationItem.rightBarButtonItem = addScoopButton;
}



#pragma mark - Actions

// User did tap on cancel button. Dismiss this VC
-(void) cancelAddScoop:(id)sender{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


// Add new scoop to the backend
-(void) confirmAddScoop:(id)sender{
    
    [self addScoopToAzure];
}


#pragma mark - Azure settings
-(void) addScoopToAzure{

    NSNumber *rating = @0;
    DTCScoop *scoop = [DTCScoop scoopWithTitle:self.titleLabel.text
                                        author:self.authorProfile.name
                                          text:self.textView.text
                                        rating:rating
                                        coords:CLLocationCoordinate2DMake(0, 0)
                                         image:nil];
    
    // Table from Azure where we save data
    MSTable *scoopsTable = [self.client tableWithName:@"news"];
    [scoopsTable insert:[scoop proxyForAzureDictionary] completion:^(NSDictionary *item, NSError *error) {
        if (error) {
            NSLog(@"Error when adding new scoop to Azure --> %@",error);
        }
        else{
            NSLog(@"Scoop added successfully --> %@", item);
            // Hide this VC once the scoop has been saved to Azure
            [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
            
                // Let the Editor Dashboard know that a new scoop has been added
                [self notifyThatNewScoopHasBeenAdded];
            }];
        }
    }];
}



#pragma mark - UITextFieldDelegate

// What to do when Return key pressed
// It's a good time to validate and then hide keyboard (resignFirstResponder)
// Returns NO if it does not validate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    // Title can not be empty
    if ([textField.text length]>0) {
        [textField resignFirstResponder];
        return YES;
    }
    return NO;
}


// What to do when editing ended. Save to the model
- (void) textFieldDidEndEditing:(UITextField *)textField{
    
}



#pragma mark - UITextViewDelegate

// What to do when Return key pressed
// Hide keyboard and stop being FirstResponder
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    [textView resignFirstResponder];
    return YES;
}


// What to do when editing ended. Save to the model
- (void) textViewDidEndEditing:(UITextView *)textView{
    
}


#pragma mark - Notifications
-(void) notifyThatNewScoopHasBeenAdded{
    NSNotification *not = [NSNotification notificationWithName:EDITOR_DID_ADD_SCOOP_NOTIFICATION object:self];
    [[NSNotificationCenter defaultCenter] postNotification:not];    
}



@end
