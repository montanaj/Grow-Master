//
//  GrowTextSprite.m
//  Grow1
//
//  Created by Calvin Hildreth on 4/19/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import "GrowTextSprite.h"

@implementation GrowTextSprite

-(GrowTextSprite *)createGrowTextSpriteContents
{
    GrowTextSprite *growTextSprite = [[GrowTextSprite alloc]initWithImageNamed:@"GrowLogo.png"];
    growTextSprite.zPosition = 9;
    growTextSprite.size = CGSizeMake(500, 200);
    growTextSprite.position = CGPointMake(320, 870);
    return growTextSprite;
}

@end
