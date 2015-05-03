//
//  AppDelegate.m
//  Agbo_CC_Scoops
//
//  Created by David de Tena on 29/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import "AppDelegate.h"
#import "DTCHomeScreenViewController.h"
#import "AzureSettings.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>

@interface AppDelegate (){
    MSClient *client;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    // Set Azure's client
    client = [MSClient clientWithApplicationURL:[NSURL URLWithString:AZURE_END_POINT] applicationKey:AZURE_APP_KEY];
    
    
    // Versión iOS <8
    //[[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    
    // iOS 8>
    [self registerNotificationRemotes];
    
    DTCHomeScreenViewController *homeScreenVC = [[DTCHomeScreenViewController alloc]init];
    self.window.rootViewController = homeScreenVC;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Notifications

// Error al registrarse
- (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    if (error) {
        NSLog(@"Error al registrarse --> %@", error);
    }
}

// Recibimos notificación
- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    NSLog(@"%@",userInfo);
}

// Registramos el dispositivo para recibir notificaciones remotas a través del servicio de Azure
- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [client.push registerNativeWithDeviceToken:deviceToken tags:@[@""] completion:^(NSError *error) {
        
        if (error) {
            NSLog(@"Error al recibir notificación --> %@", error.description);
        }
        else{
            NSLog(@"Exito al registrarse en notificaciones -->");
        }
    }];
}


- (void) registerNotificationRemotes{
    UIApplication *application = [UIApplication sharedApplication];
    
    // Tipos de notificacions que se podrán recibir
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound
                                                                             categories:nil ];
    
    [application registerUserNotificationSettings:settings];
}



@end
