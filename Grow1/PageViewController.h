//
//  PageViewController.h
//  Grow1
//
//  Created by Calvin Hildreth on 4/19/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Page.h"


@interface PageViewController : UIViewController

@property (nonatomic) NSInteger pointInStory;
@property (strong, nonatomic) Page *page;
@property (strong, nonatomic) NSMutableArray *allAvailablePages;

@end
