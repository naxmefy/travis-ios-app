//
//  GithubLoginViewController.m
//  Travis
//
//  Created by Nax on 10.09.14.
//  Copyright (c) 2014 Naxmeify. All rights reserved.
//

#import "GithubLoginViewController.h"
#import "AppDelegate.h"

@interface GithubLoginViewController ()
- (void)login;
@end

@implementation GithubLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self login];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)login {
    AKGitHubClient *gitClient = [(AppDelegate *)[[UIApplication sharedApplication] delegate] githubClient];
    [gitClient loginWithUsername:@"Naxmeify" password:@"2welcome" success:^(id loginDetails)
     {
         NSLog(@"SUCCESS! %@", loginDetails);
         
         NSLog(@"TOKEN: %@", gitClient.accessToken);
     }
                                 failure:^(id responseObject, NSError *error)
     {
         NSLog(@"ERROR: %@", error);
     }];
}

@end
