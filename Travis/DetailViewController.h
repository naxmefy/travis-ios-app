//
//  DetailViewController.h
//  Travis
//
//  Created by Nax on 03.09.14.
//  Copyright (c) 2014 Naxmeify. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
