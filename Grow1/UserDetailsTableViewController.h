//
//  UserDetailsTableViewController.h
//  Grow1
//
//  Created by Claire on 4/25/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface UserDetailsTableViewController : UITableViewController


@property (nonatomic, strong) NSArray *rowTitleArray;
@property (nonatomic, strong) NSMutableArray *rowDataArray;
@property (nonatomic, strong) NSMutableData *imageData;


@end
