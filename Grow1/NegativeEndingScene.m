//
//  NegativeEndingScene.m
//  Grow1
//
//  Created by Claire on 4/27/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import "NegativeEndingScene.h"
#import "BackgroundStarsSprite.h"

@implementation NegativeEndingScene


-(void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    [self createSceneContents];
}
//these are the initial contents. Pertaining to the background this means that it is created once. Thereafter, the the initial backgroundStars sprite moves off screen and is destroyed. We need a recursive method to keep recreating a background a move it offscreen/destroy it. So we create moveStars method and have it call itself (recursive).
-(void)createSceneContents
{
    self.backgroundColor = [UIColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFill;
    BackgroundStarsSprite *backgroundStars = [self createBackgroundStars];
    backgroundStars.position = CGPointMake(0, 0);
    [self addChild:backgroundStars];

    SKAction *moveStars = [SKAction moveTo:CGPointMake(0, 0) duration:0];
    SKAction *moveAway = [SKAction moveTo:CGPointMake(0, -1136) duration:60];
    SKAction *moveStarsForever = [SKAction performSelector:@selector(moveStars) onTarget:self];
    SKAction *moveForeverGroup = [SKAction group:@[moveAway, moveStarsForever]];
    [backgroundStars runAction:[SKAction sequence:@[moveStars, moveForeverGroup]]];
}

-(void)moveStars
{
    BackgroundStarsSprite *newStars = [self createBackgroundStars];
    newStars.position = CGPointMake(0, 1136);
    SKAction *moveStars = [SKAction moveToY:0 duration:60];
    [self addChild:newStars];
    SKAction *moveAway = [SKAction moveTo:CGPointMake(-1136, 0) duration:60];
    SKAction *moveStarsForever = [SKAction performSelector:@selector(moveStars) onTarget:self];
    SKAction *moveForeverGroup = [SKAction group:@[moveAway, moveStarsForever]];
    [newStars runAction:[SKAction sequence:@[moveStars, moveForeverGroup]]];
}

-(BackgroundStarsSprite *)createBackgroundStars
{
    BackgroundStarsSprite *backgroundStars = [BackgroundStarsSprite node];
    backgroundStars = [backgroundStars createBackgroundStars];
    return backgroundStars;
}

@end
