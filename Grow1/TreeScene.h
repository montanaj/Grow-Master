//
//  TreeScene.h
//  TreeTests3
//
//  Created by Calvin Hildreth on 4/18/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Page.h"

@interface TreeScene : SKScene

@property (strong, nonatomic) Page *page;
@property (strong, nonatomic) NSArray *allPagesInStory;
@property (strong, nonatomic) NSMutableArray *allPagesAvailable;
@property BOOL savedVersion;

-(void)sceneCheck;
-(void)sendPageDownPathInNode:(SKNode *)node;
-(void)createLeavesOnLimb:(SKSpriteNode *)limb;
-(void)scaleShape:(SKShapeNode *)shape inLimb:(SKSpriteNode *)limb;
-(void)createBranchesOnLimb:(id)limb;

@end
