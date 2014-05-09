//
//  ViewController.h
//  Grow1
//
//  Created by Calvin Hildreth on 4/18/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Page.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) Page *page;
@property (strong, nonatomic) NSArray *allPagesInStory;
@property (strong, nonatomic) NSMutableArray *allAvailablePages;

@end
