//
//  AppDelegate.h
//  Travis
//
//  Created by Nax on 03.09.14.
//  Copyright (c) 2014 Naxmeify. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKRevealController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <AuthKit/AuthKit.h>
#import "UserConfig.h"
#import <TravisKit/TravisKit.h>



@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) UserConfig *config;
@property (nonatomic, strong) AKGitHubClient *githubClient;
@property (nonatomic, strong) TKClient *travisOpenSourceClient;
@property (nonatomic, strong) TKClient *travisPrivateClient;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (BOOL)isUserLoggedIn;
- (BOOL)isTravisRunning;
- (void)initTravis;
- (void)unloadTravis;

- (void)showFronView;
- (void)showMenu;
- (void)showSettings;
- (void)showHome;

@end
