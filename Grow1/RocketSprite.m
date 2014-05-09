//
//  RocketSprite.m
//  Grow1
//
//  Created by Claire on 4/27/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import "RocketSprite.h"

@implementation RocketSprite

-(RocketSprite *)createRocketSpriteSceneContents
{
    RocketSprite *rocketSprite = [[RocketSprite alloc]initWithImageNamed:@"RocketSprite.png"];
    rocketSprite.position = CGPointMake(100, 900);
    rocketSprite.zPosition = 10;
    rocketSprite.size = CGSizeMake(100, 100);
    return rocketSprite;
}
@end