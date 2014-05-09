//
//  PlanetSprite.m
//  Grow1
//
//  Created by Calvin Hildreth on 4/19/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import "PlanetSprite.h"

@implementation PlanetSprite

-(PlanetSprite *)createPlanetSpriteContents
{
    PlanetSprite *planetSprite = [PlanetSprite spriteNodeWithImageNamed:@"GrowPlanetConcept1copy.png"];
    planetSprite.zPosition = 10;
    planetSprite.size = CGSizeMake(500, 500);
    planetSprite.position = CGPointMake(320, 555);
    return planetSprite;
}

@end
