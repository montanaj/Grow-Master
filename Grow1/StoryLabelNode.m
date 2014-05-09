//
//  StoryLabelNode.m
//  Grow1
//
//  Created by Calvin Hildreth on 4/25/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import "StoryLabelNode.h"

@implementation StoryLabelNode

-(void)fadeOutNode
{
    [self runAction:[SKAction fadeOutWithDuration:0.1]];
}

@end
