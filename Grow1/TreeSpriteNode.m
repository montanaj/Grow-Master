//
//  TreeSpriteNode.m
//  TreeTests3
//
//  Created by Calvin Hildreth on 4/18/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import "TreeSpriteNode.h"
#import "TreeScene.h"

@implementation TreeSpriteNode

-(void)updateTreeLength
{
    self.previousLength = self.currentLength;
    self.currentLength = self.size.height;
}

-(void)addPage
{
    TreeScene *scene = (id)self.scene;
    [self.path addObject:scene.page];
}

-(void)pingGrowLeaves
{
    TreeScene *scene = (id)self.scene;
    [scene createLeavesOnLimb:self];
}

-(void)pingGrowBranches
{
    TreeScene *scene = (id)self.scene;
    [scene createBranchesOnLimb:self];
}

-(void)pingScaleShape
{
    TreeScene *scene = (id)self.scene;
    SKShapeNode *shape = (id)[self childNodeWithName:@"treeShape"];
    [scene scaleShape:shape inLimb:self];
}

-(void)pingSceneRecurse
{
    TreeScene *scene = (id)self.scene;
    [scene sendPageDownPathInNode:self];
}

-(void)incrementIndexOfPageText
{
    if (self.indexOfText == 0)
    {
        Page *page = self.path.lastObject;
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
    NSNumber *currentLength = [NSNumber numberWithFloat:self.currentLength];
    NSNumber *previousLength = [NSNumber numberWithFloat:self.previousLength];
    NSNumber *indexOfText = [NSNumber numberWithInt:self.indexOfText];
    [aCoder encodeObject:currentLength forKey:@"currentLength"];
    [aCoder encodeObject:previousLength forKey:@"previousLength"];
    [aCoder encodeObject:indexOfText forKey:@"indexOfText"];
    [aCoder encodeObject:self.path forKey:@"path"];
    [aCoder encodeObject:self.leaves forKey:@"leaves"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        NSNumber *currentLength = [aDecoder decodeObjectForKey:@"currentLength"];
        NSNumber *previousLength = [aDecoder decodeObjectForKey:@"previousLength"];
        NSNumber *indexOfText = [aDecoder decodeObjectForKey:@"indexOfText"];
        self.currentLength = currentLength.floatValue;
        self.previousLength = previousLength.floatValue;
        self.indexOfText = indexOfText.intValue;
        self.path = [aDecoder decodeObjectForKey:@"path"];
        self.leaves = [aDecoder decodeObjectForKey:@"leaves"];
    }
    
    return self;
}

@end
