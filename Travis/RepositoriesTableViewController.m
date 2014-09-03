//
//  RepositoriesTableViewController.m
//  Travis
//
//  Created by Nax on 03.09.14.
//  Copyright (c) 2014 Naxmeify. All rights reserved.
//

#import "RepositoriesTableViewController.h"
#import "MBProgressHUD.h"

@interface RepositoriesTableViewController ()

@property(nonatomic, retain) NSArray *repoHolder;
@property(nonatomic, retain) NSArray *repoHolderNames;

- (void)loadData;
@end

@implementation RepositoriesTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self loadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.repoHolder count];;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[self.repoHolder objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.repoHolderNames objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    // Configure the cell...
    NSDictionary *repo = [[self.repoHolder objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSArray *slugs = [repo[@"slug"] componentsSeparatedByString:@"/"];
    NSString *repoName = slugs[1];

    cell.textLabel.text = repoName;

    NSString *formatForDetail = @"Build #%@ - %@";
    NSString *status = @"";

    if (repo[@"last_build_status"] == [NSNull null]) {
        status = @"Error";
    } else {
        if (repo[@"last_build_result"] != [NSNull null]) {
            if ([repo[@"last_build_result"] intValue] == 0) {
                status = @"Success";
            } else {
                status = @"Failed";
            }
        }
    }

    cell.detailTextLabel.text = [NSString stringWithFormat:formatForDetail
            , [repo objectForKey:@"last_build_number"]
            , status];

    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)loadData {
    NSString *baseUrlString = @"https://api.travis-ci.org/repos?member=%@";
    NSString *urlString = [NSString stringWithFormat:baseUrlString, self.username];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSData *jsonData = [[NSData alloc] initWithContentsOfURL:url];
    NSError *error;
    NSArray *json = [NSJSONSerialization
            JSONObjectWithData:jsonData
                       options:kNilOptions
                         error:&error];


    NSMutableDictionary *holder = [[NSMutableDictionary alloc] init];
    for (NSDictionary *repo in json) {
        NSArray *slugs = [repo[@"slug"] componentsSeparatedByString:@"/"];
        NSString *holderName = slugs[0];
        if (holder[holderName] == nil) {
            holder[holderName] = [[NSMutableArray alloc] init];
        }
        [holder[holderName] addObject:repo];
    }

    NSMutableArray *names = [[NSMutableArray alloc] init];
    for (NSString *holderName in holder) {
        [names addObject:holderName];
    }
    [names sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

    NSMutableArray *tmpRepoHolder = [[NSMutableArray alloc] init];
    for (NSString *holderName in names) {
        [tmpRepoHolder addObject:holder[holderName]];
    }
    self.repoHolderNames = [[NSArray alloc] initWithArray:names];
    self.repoHolder = [[NSArray alloc] initWithArray:tmpRepoHolder];
    [self.tableView reloadData];
}

@end
