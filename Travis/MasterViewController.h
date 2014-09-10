//
//  MasterViewController.h
//  Travis
//
//  Created by Nax on 03.09.14.
//  Copyright (c) 2014 Naxmeify. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "AppDelegate.h"
#import "AddUserViewController.h"

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate, AddUserDelegate, PKRevealing>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
