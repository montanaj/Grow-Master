//
//  GoodEndingSprite.h
//  Grow1
//
//  Created by Calvin Hildreth on 4/27/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Page.h"
@interface GoodEndingSprite : SKSpriteNode<NSCoding>
@property (strong, nonatomic) Page *page;
@property int indexOfText;

-(void)pingSceneRecurse;
-(void)incrementIndexOfPageText;

@end
