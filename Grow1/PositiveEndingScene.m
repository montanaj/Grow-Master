//
//  PositiveEndingScene.m
//  Grow1
//
//  Created by Claire on 4/27/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import "PositiveEndingScene.h"
#import "BackgroundStarsSprite.h"
#import "PlayAgain.h"
#import "PositiveEndingViewController.h"
#import "TreeViewController.h"

@implementation PositiveEndingScene

-(void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];

    [self createSceneContents];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];

}

-(void)createSceneContents
{
//    self.backgroundColor = [UIColor blackColor];
//    self.scaleMode = SKSceneScaleModeAspectFill;
//    BackgroundStarsSprite *backgroundStars = [self createBackgroundStars];
//    backgroundStars.position = CGPointMake(0, 0);
//    [self addChild:backgroundStars];

//    SKAction *moveStars = [SKAction moveTo:CGPointMake(0, 0) duration:0];
//    SKAction *moveAway = [SKAction moveTo:CGPointMake(0, -1136) duration:60];
//    SKAction *moveStarsForever = [SKAction performSelector:@selector(moveNewStars) onTarget:self];
//    SKAction *moveForeverGroup = [SKAction group:@[moveAway, moveStarsForever]];
//    [backgroundStars runAction:[SKAction sequence:@[moveStars, moveForeverGroup]]];

    SKSpriteNode *transparentBackground = [[SKSpriteNode alloc] initWithImageNamed:@"Transparency.png"];
    transparentBackground.position = CGPointMake(300, 600);
    transparentBackground.zPosition = 10;
    transparentBackground.size = CGSizeMake(500, 600);
    [self addChild:transparentBackground];

    PlayAgain *playAgainButton = [self createPlayAgainButton];
    playAgainButton.name = @"playAgainButton";
    [self addChild:playAgainButton];


    SKLabelNode *finishText = [[SKLabelNode alloc]initWithFontNamed:@"texgyreadventor-regular.otf"];
    finishText.text = @"Ah, sweet success. You've chosen wisely.";
    finishText.color = [UIColor whiteColor];
    finishText.position = CGPointMake(330, 900);
    finishText.fontSize = 25;
    finishText.zPosition = 100;
    [self addChild:finishText];

    SKLabelNode *finishText2 = [[SKLabelNode alloc]initWithFontNamed:@"texgyreadventor-regular.otf"];
    finishText2.text = @"But what possiblities did you miss along the way?";
    finishText2.color = [UIColor whiteColor];
    finishText2.position = CGPointMake(300, 870);
    finishText2.fontSize = 25;
    finishText2.zPosition = 92;
    [self addChild:finishText2];


}

-(PlayAgain *)createPlayAgainButton
{
    PlayAgain *playagainButton = [PlayAgain node];
    return playagainButton;
}

-(void)moveNewStars
{
    BackgroundStarsSprite *newStars = [self createBackgroundStars];
    newStars.position = CGPointMake(0, 1136);
    SKAction *moveStars = [SKAction moveToY:0 duration:60];
    [self addChild:newStars];
    SKAction *moveAway = [SKAction moveTo:CGPointMake(0, -1136) duration:60];
    SKAction *moveStarsForever = [SKAction performSelector:@selector(moveNewStars) onTarget:self];
    SKAction *moveForeverGroup = [SKAction group:@[moveAway, moveStarsForever]];
    [newStars runAction:[SKAction sequence:@[moveStars, moveForeverGroup]]];
}


-(BackgroundStarsSprite *)createBackgroundStars
{
    BackgroundStarsSprite *backgroundStars = [BackgroundStarsSprite node];
    backgroundStars = [backgroundStars createBackgroundStars];
    return backgroundStars;
    
}

-(void)handleTap:(UITapGestureRecognizer *)tapGestureRecognizer
{


    //    UINavigationController *navController = (id)self.view.window.rootViewController;
    //    [navController.viewControllers.firstObject performSegueWithIdentifier:@"EnterGrowSegue" sender:navController.viewControllers.firstObject];

    CGPoint pointTappedInView = [tapGestureRecognizer locationInView:tapGestureRecognizer.view];
    CGPoint pointTappedInSKView = [self convertPointFromView:pointTappedInView];
    SKSpriteNode *touchedNode = (id)[self nodeAtPoint:pointTappedInSKView];


    if ([touchedNode isKindOfClass:[PlayAgain class]])
    {
        UINavigationController *navController = (id)self.view.window.rootViewController;
        for (UIViewController *viewController in navController.viewControllers)
        {
            if ([viewController isKindOfClass:[TreeViewController class]])
            {
                //[self startButtonScaleinOnTap];

                [viewController performSegueWithIdentifier:@"PositiveReturnToTreeView" sender:viewController];
            }
        }
    } else
    {
    }
}

@end