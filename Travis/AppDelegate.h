//
//  AppDelegate.h
//  Travis
//
//  Created by Nax on 03.09.14.
//  Copyright (c) 2014 Naxmeify. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKRevealController.h"
#import <AuthKit/AuthKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) AKGitHubClient *githubClient;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void)showFronView;
- (void)showMenu;
- (void)showSettings;
- (void)showHome;

@end
