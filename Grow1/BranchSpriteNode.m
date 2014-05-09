//
//  BranchSpriteNode.m
//  TreeTests3
//
//  Created by Calvin Hildreth on 4/18/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import "BranchSpriteNode.h"
#import "TreeScene.h"

@implementation BranchSpriteNode

-(void)initializeBranchLength
{
    self.currentLength = self.size.height;
    self.previousLength = 0;
}

-(void)updateBranchLength
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

-(void)pingSceneRecurse
{
    TreeScene *scene = (id)self.scene;
    [scene sendPageDownPathInNode:self];
}

-(void)pingScaleShape
{
    TreeScene *scene = (id)self.scene;
    SKShapeNode *shape = (id)[self childNodeWithName:@"branchShape"];
    [scene scaleShape:shape inLimb:self];
}

-(void)incrementIndexOfPageText
{
    Page *page = self.path.lastObject;
    if (self.side == 1)
    {
        if (self.indexOfText == 0)
        {
            self.indexOfText = (int)page.pageText.length - 1;
        }
        else
        {
            self.indexOfText -= 1;
        }
    }
    else
    {
        if (self.indexOfText >= page.pageText.length - 1)
        {
            self.indexOfText = 0;
        }
        else
        {
            self.indexOfText += 1;
        }
    }

}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    NSNumber *currentLength = [NSNumber numberWithFloat:self.currentLength];
    NSNumber *previousLength = [NSNumber numberWithFloat:self.previousLength];
    NSNumber *indexOfText = [NSNumber numberWithInt:self.indexOfText];
    NSNumber *side = [NSNumber numberWithInt:self.side];
    [aCoder encodeObject:currentLength forKey:@"currentLength"];
    [aCoder encodeObject:previousLength forKey:@"previousLength"];
    [aCoder encodeObject:indexOfText forKey:@"indexOfText"];
    [aCoder encodeObject:side forKey:@"side"];
    [aCoder encodeObject:self.path forKey:@"path"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        NSNumber *currentLength = [aDecoder decodeObjectForKey:@"currentLength"];
        NSNumber *previousLength = [aDecoder decodeObjectForKey:@"previousLength"];
        NSNumber *indexOfText = [aDecoder decodeObjectForKey:@"indexOfText"];
        NSNumber *side = [aDecoder decodeObjectForKey:@"side"];
        self.currentLength = currentLength.floatValue;
        self.previousLength = previousLength.floatValue;
        self.indexOfText = indexOfText.intValue;
        self.side = side.intValue;
        self.path = [aDecoder decodeObjectForKey:@"path"];
    }
    
    return self;
}

@end
