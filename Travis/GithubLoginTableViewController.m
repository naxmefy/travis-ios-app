//
//  GithubLoginTableViewController.m
//  Travis
//
//  Created by Nax on 10.09.14.
//  Copyright (c) 2014 Naxmeify. All rights reserved.
//

#import "GithubLoginTableViewController.h"
#import "AppDelegate.h"

@interface GithubLoginTableViewController (){
    UserConfig *config;
    AKGitHubClient *githubClient;
}
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (void)guiForLogin:(BOOL)forLogin;
- (IBAction)login:(id)sender;
- (void)logout;
- (void)updateGithubCredentials;
- (void)resignResponder;
@end

@implementation GithubLoginTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignResponder)];
    [self.tableView addGestureRecognizer:gestureRecognizer];

    config = [(AppDelegate *)[[UIApplication sharedApplication] delegate] config];
    githubClient = [(AppDelegate *)[[UIApplication sharedApplication] delegate] githubClient];
    
    if ([config getGithubLogin]) {
        self.usernameField.text = [config getGithubUsername];
        self.passwordField.text = [config getGithubPassword];
        [self guiForLogin:NO];
    } else {
        [self guiForLogin:YES];
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)guiForLogin:(BOOL)forLogin {
    if (forLogin) {
        [self.usernameField setEnabled:YES];
        [self.passwordField setEnabled:YES];
        self.usernameField.textColor = [UIColor blackColor];
        self.passwordField.textColor = [UIColor blackColor];
        [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    } else {
        [self.usernameField setEnabled:NO];
        [self.passwordField setEnabled:NO];
        self.usernameField.textColor = [UIColor grayColor];
        self.passwordField.textColor = [UIColor grayColor];
        [self.loginButton setTitle:@"Logout" forState:UIControlStateNormal];
    }
}

- (IBAction)login:(id)sender {
    [self resignResponder];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [githubClient loginWithUsername:self.usernameField.text
                           password:self.passwordField.text
                            success:^(id loginDetails)
     {
         NSLog(@"SUCCESS! %@", loginDetails);
         
         NSLog(@"TOKEN: %@", githubClient.accessToken);
         [config setGithubToken:githubClient.accessToken];
         [config setGithubLogin:YES];
         [(AppDelegate *)[[UIApplication sharedApplication] delegate] initTravis];
         [self updateGithubCredentials];
         
         [self guiForLogin:NO];
         
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [self.navigationController popToRootViewControllerAnimated:YES];
     }
                                 failure:^(id responseObject, NSError *error)
     {
         NSLog(@"ERROR: %@", error);
         [self logout];
         [self.usernameField becomeFirstResponder];
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Wrong credentials" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         [alert show];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
    
    
}


- (void)logout {
    [self resignResponder];
    [self.usernameField setText:@""];
    [self.passwordField setText:@""];
    [config setGithubToken:@""];
    [config setGithubLogin:NO];
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] unloadTravis];
    [self updateGithubCredentials];
    
    [self guiForLogin:YES];
}

- (void)updateGithubCredentials {
    [config setGithubUsername:self.usernameField.text];
    [config setGithubPassword:self.passwordField.text];
}

- (void)resignResponder {
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.usernameField) {
        [self.passwordField becomeFirstResponder];
    } else if (textField == self.passwordField) {
        [self login:textField];
    }
    return YES;
}
@end
