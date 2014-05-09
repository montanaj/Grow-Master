//
//  StartScene.h
//  Grow1
//
//  Created by Calvin Hildreth on 4/19/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Page.h"

@interface StartScene : SKScene
@property (strong, nonatomic) Page *page;
@property (strong, nonatomic) NSArray *allPagesInStory;
@property (strong, nonatomic) NSMutableArray *allAvailablePages;
@end
