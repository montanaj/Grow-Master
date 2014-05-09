//
//  NegativeEndingViewController.m
//  Grow1
//
//  Created by Claire on 4/27/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import "NegativeEndingViewController.h"
#import "NegativeEndingScene.h"

@interface NegativeEndingViewController ()

@end

@implementation NegativeEndingViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

}

-(void)viewDidAppear:(BOOL)animated
{

    SKView *spriteView = (SKView *)self.view;
    spriteView.showsFPS = YES;
    spriteView.showsNodeCount = YES;
    spriteView.showsDrawCount = YES;

    NegativeEndingScene *negativeEndingScene = [[NegativeEndingScene alloc] initWithSize:CGSizeMake(640, 1136)];
    [spriteView presentScene:negativeEndingScene];
}

@end
