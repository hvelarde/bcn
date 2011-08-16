//
//  BCNAppDelegate.m
//  BCN
//
//  Created by Claudio Horvilleur on 8/5/11.
//  Copyright 2011 Cromasoft. All rights reserved.
//

#import "BCNAppDelegate.h"
#import "HomeViewController.h"
#import "Model.h"
#import "FeedReader.h"

#pragma mark - Private methods

@interface BCNAppDelegate()

-(void)activaHome;
-(void)activaRegistro;
-(void)homeButtonPushed:(id)sender;

@end

@implementation BCNAppDelegate



@synthesize window=_window;
@synthesize model;
@synthesize feedReader;
@synthesize navigationController;

#pragma mark - Application Management

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.model = [Model createFromFile];
    self.feedReader = [FeedReader createWithModel:model];
    BOOL registrado = YES; // TODO Validar si el usuario ya estaba registrado
    if (registrado) {
        [self activaHome];
    } else {
        [self activaRegistro];
    }
    [self.window makeKeyAndVisible];
    [feedReader startOperation];
    [feedReader refreshInfo];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    [feedReader stopOperation];
    [model saveToFile];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    [feedReader startOperation];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark - Memory Management
- (void)dealloc {
    [feedReader release];
    [model release];
    [_window release];
    [super dealloc];
}

#pragma mark - Starting Views Control

-(void)activaHome {
    HomeViewController* hvc = [HomeViewController createWithModel:model];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:hvc];
    _window.rootViewController = navigationController;
}

-(void)activaRegistro {
    // TODO Activar la pantalla de registro como la primera pantalla
}

#pragma mark - Actions

-(void)homeButtonPushed:(id)sender {
    [navigationController popToRootViewControllerAnimated:YES];
}

@end
