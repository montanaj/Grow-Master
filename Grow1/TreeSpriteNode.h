//
//  TreeSpriteNode.h
//  TreeTests3
//
//  Created by Calvin Hildreth on 4/18/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TreeSpriteNode : SKSpriteNode <NSCoding>
@property float currentLength;
@property float previousLength;
@property (strong, nonatomic) NSMutableArray *path;
@property (strong, nonatomic) NSMutableArray *leaves;
@property int indexOfText;

-(void)pingSceneRecurse;
-(void)incrementIndexOfPageText;
-(void)updateTreeLength;
-(void)pingGrowLeaves;
-(void)pingScaleShape;
-(void)pingGrowBranches;
-(void)addPage;

@end
