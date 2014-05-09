//
//  Planet.m
//  Grow1
//
//  Created by Claire on 4/26/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import "Planet.h"

@implementation Planet


-(Planet *)createPlanetSceneContents
{
    Planet *planetSprite = [[Planet alloc] initWithImageNamed:@"GrowPlanetConcept1copy.png"];
    planetSprite.position = CGPointMake(330, 500);
    planetSprite.size = CGSizeMake(500, 500);
    planetSprite.zPosition = 10;
    return planetSprite;
}

@end