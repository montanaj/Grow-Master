//
//  FirstAnimationScene.m
//  Grow1
//
//  Created by Claire on 4/26/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import "FirstAnimationScene.h"
#import "Planet.h"
#import "BackgroundStarsSprite.h"
#import "RocketSprite.h"

@interface FirstAnimationScene ()

@property BOOL contentCreated;
@property BOOL tapped;
@end

@implementation FirstAnimationScene



-(void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];

    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.view addGestureRecognizer:tapGestureRecognizer];
    }
}


- (void)createSceneContents
{
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFill;

    Planet *planetSprite = [self createPlanetScene];
    planetSprite.name = @"planet";
    [self addChild:planetSprite];
    SKAction *rotate = [SKAction rotateByAngle:5 duration:20];
    [planetSprite runAction:[SKAction repeatActionForever:rotate]];
    RocketSprite *rocketSprite = [self createRocketSprite];
    rocketSprite.name = @"rocket";
    [self addChild:rocketSprite];
    [rocketSprite runAction:[SKAction repeatActionForever:rotate]];

    BackgroundStarsSprite *backgroundStarsSprite = [self createBackgroundStarsSprite];
    backgroundStarsSprite.name = @"backgroundStarsSprite";
    [self addChild:backgroundStarsSprite];



}


-(void)scaleSceneIn
{
    //storing the child "planet" and storing it in a variable, planet
    Planet *planet = (id)[self childNodeWithName:@"planet"];
    SKAction *scaleIn = [SKAction scaleBy:1.25 duration:.5];
    [planet runAction:scaleIn];

}

-(void)scaleSceneOut
{
    Planet *planet = (id)[self childNodeWithName:@"planet"];
    SKAction *scaleout = [SKAction scaleBy:.80 duration:.5];
    [planet runAction:scaleout];
}

#pragma mark HELPER METHODS FOR SPRITE CREATION

-(RocketSprite *)createRocketSprite
{
    RocketSprite *rocketSprite = [RocketSprite node];
    rocketSprite = [rocketSprite createRocketSpriteSceneContents];
    return rocketSprite;
}

-(BackgroundStarsSprite *)createBackgroundStarsSprite
{
    BackgroundStarsSprite *backgroundStarsSprite = [BackgroundStarsSprite node];
    backgroundStarsSprite = [backgroundStarsSprite createBackgroundStars];
    return backgroundStarsSprite;
}

-(Planet *)createPlanetScene
{
    Planet *planetScene = [Planet node];
    planetScene = [planetScene createPlanetSceneContents];
    return planetScene;
}

#pragma mark TAP GESTURE

-(void)handleTap:(UITapGestureRecognizer *)tapGestureRecognizer

{
    if (!self.tapped) {
        [self scaleSceneIn];
        self.tapped = YES;
    }
    else
    {
        [self scaleSceneOut];
        self.tapped = NO;

    }
}
@end
