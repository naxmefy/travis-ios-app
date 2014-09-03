//
//  AddUserViewController.h
//  Travis
//
//  Created by Nax on 03.09.14.
//  Copyright (c) 2014 Naxmeify. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddUserDelegate <NSObject>
- (void)insertNewUser:(NSString*)username;
@end

@interface AddUserViewController : UITableViewController <UITextFieldDelegate>


@property (weak, nonatomic) id <AddUserDelegate> delegate;

@end
