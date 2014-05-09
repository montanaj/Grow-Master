//
//  AnimationViewController.m
//  Grow1
//
//  Created by Claire on 4/26/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import "AnimationViewController.h"
#import "FirstAnimationScene.h"
#import <SpriteKit/SpriteKit.h>

@interface AnimationViewController ()

@property BOOL sceneCreated;

@end

@implementation AnimationViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController.navigationBar setHidden:YES];

        SKView *spriteView = (id)self.view;
        spriteView.showsDrawCount = YES;
        spriteView.showsFPS = YES;
        spriteView.showsNodeCount = YES;

        FirstAnimationScene *firstAniScene = [[FirstAnimationScene alloc] initWithSize:CGSizeMake(640, 1136)];
        [spriteView presentScene:firstAniScene];
        self.sceneCreated = YES;
}


@end
