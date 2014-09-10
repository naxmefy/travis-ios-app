//
//  MenuTableViewController.m
//  Travis
//
//  Created by Nax on 09.09.14.
//  Copyright (c) 2014 Naxmeify. All rights reserved.
//

#import "MenuTableViewController.h"
#import "AppDelegate.h"

@interface MenuTableViewController ()
@property (weak, nonatomic) IBOutlet UITableViewCell *homeCell;
- (IBAction)showSettings:(id)sender;
@end

@implementation MenuTableViewController

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [self.navigationController setToolbarHidden:NO animated:YES];
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [self.navigationController setToolbarHidden:YES animated:YES];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == self.homeCell) {
        [appDelegate showHome];
    }
   
}

- (IBAction)showSettings:(id)sender {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showSettings];
}

@end
