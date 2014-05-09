//
//  PositiveEndingViewController.m
//  Grow1
//
//  Created by Claire on 4/27/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import "PositiveEndingViewController.h"
#import "PositiveEndingScene.h"

@interface PositiveEndingViewController ()

@end

@implementation PositiveEndingViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    SKView *spriteView = (SKView *)self.view;
    spriteView.showsDrawCount = YES;
    spriteView.showsFPS = YES;
    spriteView.showsNodeCount = YES;

    PositiveEndingScene *positiveEndingScene = [[PositiveEndingScene alloc] initWithSize:CGSizeMake(640, 1136)];
    [spriteView presentScene:positiveEndingScene];

}


@end
