//
//  BackgroundStarsSprite.m
//  Grow1
//
//  Created by Calvin Hildreth on 4/19/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import "BackgroundStarsSprite.h"

@implementation BackgroundStarsSprite

-(BackgroundStarsSprite *)createBackgroundStars
{
   BackgroundStarsSprite *backgroundStars = [[BackgroundStarsSprite alloc] initWithImageNamed:@"InitialBackground.png"];
    backgroundStars.zPosition = 1;
    backgroundStars.size = CGSizeMake(640, 1136);
    backgroundStars.anchorPoint = CGPointMake(0, 0);
    backgroundStars.name = @"stars";
    return backgroundStars;
}

@end
