//
//  AppDelegate.m
//  Travis
//
//  Created by Nax on 03.09.14.
//  Copyright (c) 2014 Naxmeify. All rights reserved.
//

#import "AppDelegate.h"
#import "APIKeys.h"
#import "UIConstants.h"

#import "MasterViewController.h"
#import "MenuTableViewController.h"

@interface AppDelegate()<PKRevealing> {
    bool menuOpen;
    bool friendsOpen;
    bool travisRuns;
}

@property (nonatomic, strong) UIStoryboard *storyboard;
@property (nonatomic, strong, readwrite) PKRevealController *revealController;
@property (nonatomic, strong, readwrite) UINavigationController *menuNav;
@property (nonatomic, strong, readwrite) MenuTableViewController *menu;
@property (nonatomic, strong, readwrite) UITabBarController *home;

@end

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // UserConfig
    self.config = [[UserConfig alloc] init];
    
    // Github Client
    self.githubClient = [[AKGitHubClient alloc] initWithClientID:GITHUB_CLIENT_ID
                                                    clientSecret:GITHUB_CLIENT_SECRET
                                                          scopes:@[ AKGitHubScopeUser, AKGitHubScopeRepo ]
                                                            note:@"Test"];

    // Travis
    [self initTravis];

    // Storyboard
    self.storyboard = [UIStoryboard storyboardWithName:kIPhoneStoryboard
                                                bundle: nil];
    // Menu
    self.menuNav = [self.storyboard instantiateViewControllerWithIdentifier:kMenuView];
    self.menu = (MenuTableViewController *)self.menuNav.topViewController;
    
    // Home
    self.home = [self.storyboard instantiateViewControllerWithIdentifier:kHomeView];
    
    // Reveal Controller
    NSDictionary *options = @{
                              PKRevealControllerRecognizesPanningOnFrontViewKey : @NO
                              };
    self.revealController = [PKRevealController revealControllerWithFrontViewController:self.home leftViewController:self.menuNav options:options];
    
    self.revealController.delegate = self;
    self.revealController.animationDuration = 0.25;
    
    // Setup reveal status
    menuOpen = false;
    friendsOpen = false;
    
    // Setup window
    self.window.rootViewController = self.revealController;
    [self.window makeKeyAndVisible];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Travis" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Travis.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Travis
- (BOOL)isUserLoggedIn {
    return [self.config getGithubLogin];
}
- (BOOL)isTravisRunning {
    return travisRuns;
}

- (void)initTravis {
    if ([self.config getGithubLogin]) {
        self.travisOpenSourceClient = [[TKClient alloc] initWithServer:TKOpenSourceServer];
        self.travisPrivateClient = [[TKClient alloc] initWithServer:TKPrivateServer];

        // Login OpenSource Client
        [self.travisOpenSourceClient authenticateWithGitHubToken:[self.config getGithubToken]
                                                         success:^{
                                                             travisRuns = YES;
                                                             NSLog(@"Travis OpenSource is authenticated.");
                                                         }
                                                         failure:^(NSError * error){
                                                             NSLog(@"Travis OpenSource authentication failed");
                                                             NSLog(@"Error: %@", error);
                                                         }];
        // Login Private Client
        if ([self.config getTravisPrivate]) {
            [self.travisPrivateClient authenticateWithGitHubToken:[self.config getGithubToken]
                                                          success:^{
                                                              NSLog(@"Travis Private is authenticated.");
                                                          }
                                                          failure:^(NSError * error){
                                                              NSLog(@"Travis Private authentication failed");
                                                              NSLog(@"Error: %@", error);
                                                          }];
        }
    }
}

- (void)unloadTravis {
    
}

#pragma mark - PKReveal Public Functions
- (void)showFronView {
    [self.revealController showViewController:self.revealController.frontViewController];
    menuOpen = NO;
}
- (void)showMenu {
    if (menuOpen) {
        [self.revealController showViewController:self.revealController.frontViewController];
    } else {
        [self.revealController showViewController:self.revealController.leftViewController];
    }
    
    menuOpen |= menuOpen;
}

- (void)showSettings {
    [self.revealController setFrontViewController:[self.storyboard instantiateViewControllerWithIdentifier:kSettingsView]];
    [self showFronView];
}

- (void)showHome {
    [self.revealController setFrontViewController:[self.storyboard instantiateViewControllerWithIdentifier:kHomeView]];
    [self showFronView];
}


@end
