//
//  NegativeEndingSprite.m
//  Grow1
//
//  Created by Calvin Hildreth on 4/27/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import "NegativeEndingSprite.h"
#import "TreeScene.h"

@implementation NegativeEndingSprite

-(void)pingSceneRecurse
{
    TreeScene *scene = (id)self.scene;
    [scene sendPageDownPathInNode:self];
}

-(void)incrementIndexOfPageText
{
    if (self.indexOfText == 0)
    {
        Page *page = self.page;
        self.indexOfText = (int)page.pageText.length - 1;
    }
    else
    {
        self.indexOfText -= 1;
    }
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    NSNumber *indexOfText = [NSNumber numberWithInt:self.indexOfText];
    [aCoder encodeObject:indexOfText forKey:@"indexOfText"];
    [aCoder encodeObject:self.page forKey:@"page"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        NSNumber *indexOfText = [aDecoder decodeObjectForKey:@"indexOfText"];
        self.indexOfText = indexOfText.intValue;
        self.page = [aDecoder decodeObjectForKey:@"page"];
    }
    
    return self;
}

@end
