//
//  BranchSpriteNode.h
//  TreeTests3
//
//  Created by Calvin Hildreth on 4/18/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BranchSpriteNode : SKSpriteNode<NSCoding>
@property float currentLength;
@property float previousLength;
@property (strong, nonatomic) NSMutableArray *path;
@property int indexOfText;
@property int side;

-(void)pingSceneRecurse;
-(void)pingGrowLeaves;
-(void)pingScaleShape;
-(void)incrementIndexOfPageText;
-(void)initializeBranchLength;
-(void)updateBranchLength;
-(void)pingGrowBranches;
-(void)addPage;

@end
