//
//  LeafSpriteNode.m
//  TreeTests3
//
//  Created by Calvin Hildreth on 4/19/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import "LeafSpriteNode.h"
#import "TreeScene.h"

@implementation LeafSpriteNode

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    NSNumber *rotation = [NSNumber numberWithDouble:self.rotation];
    [aCoder encodeObject:rotation forKey:@"rotation"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        NSNumber *rotation = [aDecoder decodeObjectForKey:@"rotation"];
        self.rotation = rotation.doubleValue;
    }
    
    return self;
}

@end
