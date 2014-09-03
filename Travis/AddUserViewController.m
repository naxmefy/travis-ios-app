//
//  AddUserViewController.m
//  Travis
//
//  Created by Nax on 03.09.14.
//  Copyright (c) 2014 Naxmeify. All rights reserved.
//

#import "AddUserViewController.h"

@interface AddUserViewController ()

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;

- (IBAction)save:(id)sender;

@end

@implementation AddUserViewController

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)resignResponder {
    [self.usernameField resignFirstResponder];
}

- (IBAction)save:(id)sender {
    [self resignResponder];
    NSString *username = self.usernameField.text;
    if ([username length] > 0) {
        // Save new entity
        if ([self.delegate respondsToSelector:@selector(insertNewUser:)]) {
            [self.delegate insertNewUser:username];
        }
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.usernameField) {
        [self save:nil];
    }
    return YES;
}

@end
