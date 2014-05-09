//
//  TreeScene.m
//  TreeTests3
//
//  Created by Calvin Hildreth on 4/18/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//
#import "TreeViewController.h"
#import "TreeScene.h"
#import "PlanetSpriteNode.h"
#import "TreeSpriteNode.h"
#import "BranchSpriteNode.h"
#import "LeafSpriteNode.h"
#import "BackgroundStarsSprite.h"
#import "Choice.h"
#import "StoryLabelNode.h"
#import "GoodEndingSprite.h"
#import "NegativeEndingSprite.h"
#import "BookMarkSprite.h"
#import "PositiveEndingScene.h"
#import "NegativeEndingScene.h"
#import "ViewController.h"
#import "FirstRunObject.h"
#import "PlayAgain.h"
#import "StartScene.h"
@import GLKit;

@interface TreeScene()<NSCoding>
{
    SKAction *grow;
    SKAction *growIn;
    SKAction *fadeout;
}
@property BOOL isContentCreated;
@property BOOL didSwitchBranches;
@property int endingsReached;
@property int negativeEndingsReached;
@property int sideForMainBranches;
@property (strong, nonatomic) NSMutableArray *paths;
@property (strong, nonatomic) NSMutableArray *path;
@property (strong, nonatomic) BranchSpriteNode *markedBranch;
@property (strong, nonatomic) BranchSpriteNode *previousMarkedBranch;
@property (strong, nonatomic) SKSpriteNode *leftWallSprite;
@property (strong, nonatomic) SKSpriteNode *leftWallThickSprite;
@property (strong, nonatomic) SKSpriteNode *rightWallSprite;
@property (strong, nonatomic) SKSpriteNode *rightWallThickSprite;
@property (strong, nonatomic) SKSpriteNode *topWallSprite;
@property (strong, nonatomic) SKSpriteNode *bottomWallSprite;
@property BOOL isDoneGrowing;
@property BOOL hasEnded;
@property BOOL hasEndedWell;
@property BOOL hasEndedPoorly;
@property (strong, nonatomic) FirstRunObject *firstRunObject;
@end

@implementation TreeScene

-(void)didMoveToView:(SKView *)view
{
    
    [super didMoveToView:view];
    if (!self.isContentCreated)
    {
        [self createSceneContents];
        //come back and fix
        self.isContentCreated = YES;
        self.firstRunObject = [FirstRunObject new];
        self.firstRunObject.isFirstRun = YES;
        [self saveIsFirstRun];
        //
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.view addGestureRecognizer:tapGestureRecognizer];
        UISwipeGestureRecognizer *swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.view addGestureRecognizer:swipeLeftGestureRecognizer];
        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleZoomFrom:)];
        [self.view addGestureRecognizer:pinchGestureRecognizer];
        grow = [SKAction resizeByWidth:0 height:50 duration:3];
        growIn = [SKAction scaleBy:100 duration:3];
        fadeout = [SKAction fadeOutWithDuration:2];
    }
    else if (self.savedVersion)
    {
        self.hasEnded = NO;
        self.hasEndedWell = NO;
        self.hasEndedPoorly = NO;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.view addGestureRecognizer:tapGestureRecognizer];
        UISwipeGestureRecognizer *swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.view addGestureRecognizer:swipeLeftGestureRecognizer];
        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleZoomFrom:)];
        [self.view addGestureRecognizer:pinchGestureRecognizer];
        
        [self enumerateChildNodesWithName:@"stars" usingBlock:^(SKNode *node, BOOL *stop) {
            [node removeFromParent];
        }];
        
        BackgroundStarsSprite *backgroundStars = [self createBackgroundStars];
        backgroundStars.position = CGPointMake(0, 0);
        [self addChild:backgroundStars];
        SKAction *moveStars = [SKAction moveToY:0 duration:0];
        SKAction *moveAway = [SKAction moveToY:-1136 duration:60];
        SKAction *moveStarsForever = [SKAction performSelector:@selector(moveStars) onTarget:self];
        SKAction *moveForeverGroup = [SKAction group:@[moveAway, moveStarsForever]];
        [backgroundStars runAction:[SKAction sequence:@[moveStars, moveForeverGroup]]];
        
        PlanetSpriteNode *planet = (id)[self childNodeWithName:@"planet"];
        TreeSpriteNode *treeSprite = (id)[planet childNodeWithName:@"tree"];
        [self removeAllText];
        [treeSprite enumerateChildNodesWithName:@"branch" usingBlock:^(SKNode *node, BOOL *stop)
        {
            BranchSpriteNode *branch = (id)node;
            [self removeTextFromBranchesWithBranch:branch];
        }];
        [self sendPageDownPathInNode:treeSprite];
        [treeSprite enumerateChildNodesWithName:@"branch" usingBlock:^(SKNode *node, BOOL *stop)
        {
            BranchSpriteNode *branch = (id)node;
            [self moveTextOnBranchesWithBranch:branch];
        }];
    }
}

-(void)didEvaluateActions
{
    [self enumerateChildNodesWithName:@"stars" usingBlock:^(SKNode *node, BOOL *stop)
     {
         if(node.position.y == -1136)
         {
             [node removeFromParent];
         }
     }];
}

-(void)handleSwipe:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    if (!self.hasEnded)
    {
        if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft)
        {
            UINavigationController *navController = (id)self.view.window.rootViewController;
            for (UIViewController *viewController in navController.viewControllers)
            {
                if ([viewController isKindOfClass:[ViewController class]])
                {
                    [viewController performSegueWithIdentifier:@"ShowStorySegue" sender:viewController];
                }
            }
        }
    }
}

-(void)handleTap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    CGPoint pointTappedInView = [tapGestureRecognizer locationInView:tapGestureRecognizer.view];
    CGPoint pointTappedInSKView = [self convertPointFromView:pointTappedInView];
    SKSpriteNode *touchedNode = (id)[self nodeAtPoint:pointTappedInSKView];

    CGPoint pointTappedInSprite = [self convertPoint:pointTappedInSKView toNode:touchedNode];
    NSLog(@"%f %f", pointTappedInSprite.x, pointTappedInSprite.y);
    
    if ([touchedNode isKindOfClass:[PlayAgain class]] && self.hasEnded)
    {
        SKTransition *transition = [SKTransition fadeWithDuration:2];
        StartScene *startScene = [[StartScene alloc] initWithSize:CGSizeMake(640, 1136)];
        [self.view presentScene:startScene transition:transition];
    }
    else if ([touchedNode isKindOfClass:[BookMarkSprite class]])
    {
        if (self.isDoneGrowing && !self.hasEnded)
        {
            [self save];
            NSLog(@"tapped");
            SKLabelNode *savedLabel = [SKLabelNode labelNodeWithFontNamed:@"TexGyreAdventor-Regular"];
            savedLabel.fontSize = 15;
            savedLabel.fontColor = [UIColor whiteColor];
            savedLabel.zPosition = 99;
            savedLabel.text = @"saved!";
            SKAction *fadeIn = [SKAction fadeInWithDuration:1];
            SKAction *fadeOut = [SKAction fadeOutWithDuration:1];
        
            if ([touchedNode.name isEqualToString:@"bookMarkBacker"])
            {
                BookMarkSprite *bookMark = (id)[touchedNode childNodeWithName:@"bookMark"];
                savedLabel.position = CGPointMake(-20, bookMark.size.height/2 - 10);
                [bookMark addChild:savedLabel];
                [savedLabel runAction:[SKAction sequence:@[fadeIn, fadeOut]] completion:^{
                    [savedLabel removeFromParent];
                }];
            }
            else
            {
                savedLabel.position = CGPointMake(-20, touchedNode.size.height/2 - 10);
                [touchedNode addChild:savedLabel];
                [savedLabel runAction:[SKAction sequence:@[fadeIn, fadeOut]] completion:^{
                    [savedLabel removeFromParent];
                }];
            }
        }
    }
//    else if ([touchedNode isKindOfClass:[PlanetSpriteNode class]])
//    {
//        [self endWinningGame];
//
//    }
    else
    {
        if (!self.hasEnded)
        {
            UINavigationController *navController = (id)self.view.window.rootViewController;
            for (UIViewController *viewController in navController.viewControllers)
            {
                if ([viewController isKindOfClass:[ViewController class]])
                {
                    [viewController performSegueWithIdentifier:@"ShowStorySegue" sender:viewController];
                }
            }
        }
    }
}

CGPoint CGPointAdd(CGPoint point1, CGPoint point2) {
    return CGPointMake(point1.x + point2.x, point1.y + point2.y);
}

CGPoint CGPointSubtract(CGPoint point1, CGPoint point2) {
    return CGPointMake(point1.x - point2.x, point1.y - point2.y);
}

GLKVector2 GLKVector2FromCGPoint(CGPoint point) {
    return GLKVector2Make(point.x, point.y);
}

CGPoint CGPointFromGLKVector2(GLKVector2 vector) {
    return CGPointMake(vector.x, vector.y);
}

CGPoint CGPointMultiplyScalar(CGPoint point, CGFloat value) {
    return CGPointFromGLKVector2(GLKVector2MultiplyScalar(GLKVector2FromCGPoint(point), value));
}

- (void)handleZoomFrom:(UIPinchGestureRecognizer *)recognizer
{
    CGPoint touchLocation = [recognizer locationInView:recognizer.view];
    touchLocation = [self convertPointFromView:touchLocation];
    PlanetSpriteNode *planetSprite = (id)[self childNodeWithName:@"planet"];
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {

    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint anchorPoint = CGPointSubtract(touchLocation, planetSprite.position);
        CGPoint mySkNodeShift = CGPointSubtract(anchorPoint, CGPointMultiplyScalar(anchorPoint, recognizer.scale));
        
        [planetSprite runAction:[SKAction group:@[
                                               [SKAction scaleBy:recognizer.scale duration:0.0],
                                               [SKAction moveBy:CGVectorMake(mySkNodeShift.x, mySkNodeShift.y) duration:0.0]
                                               ]]];
        recognizer.scale = 1.0;
        
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded)
    {

    }
}

#pragma mark -- setup 


-(void)createSceneContents
{
    self.hasEnded = NO;
    self.hasEndedWell = NO;
    self.hasEndedPoorly = NO;
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFill;
    self.paths = [NSMutableArray new];
    self.path = [NSMutableArray new];
    self.endingsReached = 0;
    self.sideForMainBranches = 0;
    PlanetSpriteNode *planetSprite = [self createPlanetSprite];
    TreeSpriteNode *treeSprite = [self createTreeSprite];
    [self addChild:planetSprite];
    [planetSprite addChild:treeSprite];
    treeSprite.anchorPoint = CGPointMake(0, 0);
    BackgroundStarsSprite *backgroundStars = [self createBackgroundStars];
    backgroundStars.position = CGPointMake(0, 0);
    [self addChild:backgroundStars];
    
    BookMarkSprite *bookMarkBacker = [[BookMarkSprite alloc] initWithColor:[UIColor clearColor] size:CGSizeMake(100, 100)];
    bookMarkBacker.position = CGPointMake(self.size.width - 50, self.view.frame.size.height + 460);
    bookMarkBacker.anchorPoint = CGPointMake(.5, .5);
    bookMarkBacker.name = @"bookMarkBacker";
    bookMarkBacker.zPosition = 98;
    [self addChild:bookMarkBacker];
    
    SKTexture *bookMarkTexture = [SKTexture textureWithImageNamed:@"BookmarkOutlineMoreGreen.png"];
    BookMarkSprite *bookMarkSprite = [[BookMarkSprite alloc] initWithColor:[UIColor clearColor] size:CGSizeMake(50, 50)];
    bookMarkSprite.texture = bookMarkTexture;
    bookMarkSprite.position = CGPointMake(-10, -10);
    bookMarkSprite.anchorPoint= CGPointMake(0, 0);
    bookMarkSprite.name = @"bookMark";
    bookMarkSprite.xScale = 1.1;
    bookMarkSprite.yScale = 1.1;
    bookMarkSprite.zPosition = 99;
    [bookMarkBacker addChild:bookMarkSprite];
    
    SKAction *moveStars = [SKAction moveToY:0 duration:0];
    SKAction *moveAway = [SKAction moveToY:-1136 duration:60];
    SKAction *moveStarsForever = [SKAction performSelector:@selector(moveStars) onTarget:self];
    SKAction *moveForeverGroup = [SKAction group:@[moveAway, moveStarsForever]];
    [backgroundStars runAction:[SKAction sequence:@[moveStars, moveForeverGroup]]];
    
    [self createLeavesOnLimb:treeSprite];
    [self scaleSceneIn];
    [self sendPageDownPathInNode:treeSprite];
}

#pragma mark -- sprite creation methods

-(PlanetSpriteNode *)createPlanetSprite
{
    PlanetSpriteNode *planetSprite = [PlanetSpriteNode spriteNodeWithImageNamed:@"planet2.png"];
    planetSprite.position = CGPointMake(self.size.width/2,self.size.height/3.5);
    planetSprite.color = [UIColor lightGrayColor];
    planetSprite.anchorPoint = CGPointMake(.5, 1);
    planetSprite.name = @"planet";
    planetSprite.zPosition = 2;
    return planetSprite;
}



-(TreeSpriteNode *)createTreeSprite
{
    TreeSpriteNode *treeSprite = [[TreeSpriteNode alloc] initWithColor:[UIColor clearColor]
                                                                  size:CGSizeMake(1, 50)];
    treeSprite.position = CGPointMake(0, -60);
    treeSprite.zPosition = 20;
    treeSprite.path = [NSMutableArray new];
    [treeSprite.path addObject:self.page];
    treeSprite.name = @"tree";
    treeSprite.previousLength = 0;
    treeSprite.currentLength = treeSprite.size.height;
    treeSprite.indexOfText = 1;
    treeSprite.physicsBody.dynamic = YES;
    treeSprite.colorBlendFactor = 1.0;
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(-0.46, 2.98)];
    [bezierPath addLineToPoint: CGPointMake(-0.5, 46.55)];
    [bezierPath addCurveToPoint: CGPointMake(0.02, 50.5) controlPoint1: CGPointMake(-0.5, 46.55) controlPoint2: CGPointMake(-0.45, 50.5)];
    [bezierPath addCurveToPoint: CGPointMake(0.46, 46.55) controlPoint1: CGPointMake(0.49, 50.5) controlPoint2: CGPointMake(0.46, 46.55)];
    [bezierPath addLineToPoint: CGPointMake(0.5, 2.82)];
    [bezierPath addCurveToPoint: CGPointMake(0.02, 0.45) controlPoint1: CGPointMake(0.5, 2.82) controlPoint2: CGPointMake(0.5, 0.64)];
    [bezierPath addCurveToPoint: CGPointMake(-0.46, 2.98) controlPoint1: CGPointMake(-0.46, 0.27) controlPoint2: CGPointMake(-0.46, 2.98)];
    [bezierPath closePath];
    
    SKShapeNode *treeShape = [SKShapeNode node];
    treeShape.path = [bezierPath CGPath];
    treeShape.strokeColor = [SKColor clearColor];
    treeShape.fillColor = [SKColor brownColor];
    treeShape.name = @"treeShape";
    [treeSprite addChild:treeShape];
    return  treeSprite;
}

-(void)createEndingSprite
{
    Page *page = self.path.lastObject;
    if (page.isGoodEnding)
    {
        GoodEndingSprite *goodSprite = [GoodEndingSprite spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(1, 1)];
        goodSprite.anchorPoint = CGPointMake(0, .5);
        goodSprite.page = page;
        goodSprite.name = @"goodEndingSprite";
        SKShapeNode *goodEndingShape = [SKShapeNode node];
        UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-25, 10, 50, 20)];
        goodEndingShape.path = [ovalPath CGPath];
        goodEndingShape.strokeColor = [UIColor clearColor];
        goodEndingShape.name = @"goodEndingShape";
        [goodSprite addChild:goodEndingShape];
        
        if (self.endingsReached == 0)
        {
            PlanetSpriteNode *planet = (id)[self childNodeWithName:@"planet"];
            TreeSpriteNode *treeSprite = (id)[planet childNodeWithName:@"tree"];
            goodSprite.position = CGPointMake(0, treeSprite.size.height + 2);
            [treeSprite addChild:goodSprite];
        }
        else
        {
            goodSprite.position = CGPointMake(0, self.markedBranch.size.height + 2);
            [self.markedBranch addChild:goodSprite];
        }
        [self sendPageDownPathInNode:goodSprite];
    }
    else
    {
        NegativeEndingSprite *negativeSprite = [NegativeEndingSprite spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(1, 1)];
        negativeSprite.anchorPoint = CGPointMake(0, .5);
        negativeSprite.page = page;
        negativeSprite.name = @"negativeEndingSprite";
        SKShapeNode *negativeEndingShape = [SKShapeNode node];
        UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-25, 10, 50, 20)];
        negativeEndingShape.path = [ovalPath CGPath];
        negativeEndingShape.strokeColor = [UIColor clearColor];
        negativeEndingShape.name = @"negativeEndingShape";
        [negativeSprite addChild:negativeEndingShape];
        
        if (self.endingsReached == 0)
        {
            PlanetSpriteNode *planet = (id)[self childNodeWithName:@"planet"];
            TreeSpriteNode *treeSprite = (id)[planet childNodeWithName:@"tree"];
            negativeSprite.position = CGPointMake(0, treeSprite.size.height + 2);
            [treeSprite addChild:negativeSprite];
        }
        else
        {
            negativeSprite.position = CGPointMake(0, self.markedBranch.size.height + 2);
            [self.markedBranch addChild:negativeSprite];
        }
        [self sendPageDownPathInNode:negativeSprite];
        self.negativeEndingsReached++;
    }
}

-(BackgroundStarsSprite *)createBackgroundStars
{
    BackgroundStarsSprite *backgroundStars = [BackgroundStarsSprite node];
    backgroundStars = [backgroundStars createBackgroundStars];
    return backgroundStars;
}

-(void)moveStars
{
    BackgroundStarsSprite *newStars = [self createBackgroundStars];
    newStars.position = CGPointMake(0, 1136);
    SKAction *moveStars = [SKAction moveToY:0 duration:60];
    [self addChild:newStars];
    SKAction *moveAway = [SKAction moveToY:-1136 duration:60];
    SKAction *moveStarsForever = [SKAction performSelector:@selector(moveStars) onTarget:self];
    SKAction *moveForeverGroup = [SKAction group:@[moveAway, moveStarsForever]];
    [newStars runAction:[SKAction sequence:@[moveStars, moveForeverGroup]]];

}

-(void)scaleShape:(SKShapeNode *)shape inLimb:(SKSpriteNode *)limb
{
    SKAction *scale = [SKAction scaleXBy:(limb.size.height/shape.frame.size.height) y:(limb.size.height/shape.frame.size.height) duration:2];
    SKAction *pingControlType = [SKAction performSelector:@selector(controlTypeInMotion) onTarget:self];
    SKAction *cycleForControlType = [SKAction waitForDuration:.1];
    SKAction *controlSequence = [SKAction sequence:@[pingControlType, cycleForControlType]];
    SKAction *repeatControlSequence = [SKAction repeatAction:controlSequence count:20];
    SKAction *scaleGroup = [SKAction group:@[scale, repeatControlSequence]];
    [shape runAction:scaleGroup];
}

-(SKShapeNode *)createShapeOnSide:(int)side
{
    SKShapeNode *branchShape = [SKShapeNode node];
    branchShape.strokeColor = [UIColor brownColor];
    branchShape.name = @"branchShape";
    branchShape.zPosition = 1;
    if (side == 0)
    {
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint: CGPointMake(0.1, 0)];
        [bezierPath addLineToPoint: CGPointMake(0.1, 307.32)];
        [bezierPath addCurveToPoint: CGPointMake(50, 400) controlPoint1: CGPointMake(0.1, 307.32) controlPoint2: CGPointMake(-4.5, 393.43)];
        branchShape.path = [bezierPath CGPath];
        branchShape.xScale = .1;
        branchShape.yScale = .1;
        branchShape.lineWidth = 10;
    }
    else
    {
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint: CGPointMake(-0.1, 0)];
        [bezierPath addLineToPoint: CGPointMake(-0.1, 307.32)];
        [bezierPath addCurveToPoint: CGPointMake(-50, 400) controlPoint1: CGPointMake(-0.1, 307.32) controlPoint2: CGPointMake(4.5, 393.43)];
        branchShape.path = [bezierPath CGPath];
        branchShape.xScale = .1;
        branchShape.yScale = .1;
        branchShape.lineWidth = 10;
    }
    return branchShape;
}

-(void)createBranchesOnLimb:(id)limb
{
    if ([limb isKindOfClass:[TreeSpriteNode class]])
    {
        TreeSpriteNode *placeholder = limb;
        Page *workingPage = placeholder.path.lastObject;
        int increment = 1;
        for (Choice *choice in workingPage.choices)
        {
            if (choice.indexToNextPage != self.page.indexOfPage)
            {
                float workingLength = (placeholder.currentLength - placeholder.previousLength) / ((workingPage.choices.count - 1) * 2);
                float offsetFromLastGrowth = workingLength * increment;
                float offset = placeholder.previousLength + offsetFromLastGrowth;
                increment += 2;
                
                BranchSpriteNode *newBranch = [[BranchSpriteNode alloc] initWithColor:[SKColor clearColor]
                                                                                 size:CGSizeMake(1, 30)];
                newBranch.path = [NSMutableArray new];
                [newBranch.path addObject:self.allPagesAvailable[choice.indexToNextPage]];
                SKShapeNode *branchShape = [self createShapeOnSide:self.sideForMainBranches];
                if (self.sideForMainBranches == 0)
                {
                    newBranch.zRotation = M_PI / 3;
                    newBranch.side = self.sideForMainBranches;
                    self.sideForMainBranches = 1;
                }
                else
                {
                    newBranch.zRotation = M_PI / -3;
                    newBranch.side = self.sideForMainBranches;
                    self.sideForMainBranches = 0;
                }
                newBranch.zPosition = placeholder.zPosition - 2;
                newBranch.xScale = .01;
                newBranch.yScale = .01;
                newBranch.anchorPoint = CGPointMake(0, 0);
                newBranch.position = CGPointMake(0, offset);
                newBranch.name = @"branch";
                newBranch.physicsBody.dynamic = YES;
                [newBranch addChild:branchShape];
                [limb addChild:newBranch];
                [self sendPageDownPathInNode:newBranch];
                SKAction *scale = [SKAction scaleBy:100 duration:3];
                SKAction *initializeLength = [SKAction performSelector:@selector(initializeBranchLength) onTarget:newBranch];
                SKAction *pingGrowLeaves = [SKAction performSelector:@selector(pingGrowLeaves) onTarget:newBranch];
                SKAction *pingScaleShape = [SKAction performSelector:@selector(pingScaleShape) onTarget:newBranch];
                SKAction *group = [SKAction group:@[initializeLength, pingScaleShape]];
                SKAction *sequence = [SKAction sequence:@[scale, group, pingGrowLeaves]];
                [newBranch runAction:sequence];
            }
        }
    }
    else if ([limb isKindOfClass:[BranchSpriteNode class]])
    {
        BranchSpriteNode *placeholder = (id)limb;
        Page *workingPage = placeholder.path.lastObject;
        int increment = 1;
        for (Choice *choice in workingPage.choices)
        {
            if (choice.indexToNextPage != self.page.indexOfPage)
            {
                float workingLength = (placeholder.currentLength - placeholder.previousLength) / ((workingPage.choices.count - 1) * 2);
                float offsetFromLastGrowth = workingLength * increment;
                float offset = placeholder.previousLength + offsetFromLastGrowth;
                increment += 2;
                
                BranchSpriteNode *newBranch = [[BranchSpriteNode alloc] initWithColor:[SKColor clearColor]
                                                                                 size:CGSizeMake(1, 30)];
                newBranch.path = [NSMutableArray new];
                [newBranch.path addObject:self.allPagesAvailable[choice.indexToNextPage]];
                int side = arc4random() % 2;
                SKShapeNode *branchShape = [self createShapeOnSide:side];
                if (side == 0)
                {
                    newBranch.zRotation = M_PI/3;
                    newBranch.side = side;
                }
                else
                {
                    newBranch.zRotation = M_PI/-3;
                    newBranch.side = side;
                }
                newBranch.zPosition = placeholder.zPosition + 1;
                newBranch.xScale = .01;
                newBranch.yScale = .01;
                newBranch.currentLength = newBranch.size.height;
                newBranch.previousLength = 0;
                newBranch.anchorPoint = CGPointMake(0, 0);
                newBranch.position = CGPointMake(0, offset);
                newBranch.name = @"branch";
                [newBranch addChild:branchShape];
                [limb addChild:newBranch];
                [self sendPageDownPathInNode:newBranch];
                SKAction *scale = [SKAction scaleBy:100 duration:3];
                SKAction *initializeLength = [SKAction performSelector:@selector(initializeBranchLength) onTarget:newBranch];
                SKAction *pingGrowLeaves = [SKAction performSelector:@selector(pingGrowLeaves) onTarget:newBranch];
                SKAction *pingScaleShape = [SKAction performSelector:@selector(pingScaleShape) onTarget:newBranch];
                SKAction *group = [SKAction group:@[initializeLength, pingScaleShape]];
                SKAction *sequence = [SKAction sequence:@[scale, group, pingGrowLeaves]];
                [newBranch runAction:sequence];
            }
        }
    }
}

-(void)createLeavesOnLimb:(SKSpriteNode *)limb
{
    int leafInterval = 1;
    BOOL isFirstOddDone = NO;
    if ([limb isKindOfClass:[TreeSpriteNode class]])
    {
        TreeSpriteNode *placeholder = (id)limb;
        Page *workingPage = placeholder.path.lastObject;
        for (Choice *choice in workingPage.choices)
        {
            UIBezierPath* bezierPath = [UIBezierPath bezierPath];
            [bezierPath moveToPoint: CGPointMake(-0.81, -0.5)];
            [bezierPath addCurveToPoint: CGPointMake(-15.5, 19.1) controlPoint1: CGPointMake(-0.81, -0.5) controlPoint2: CGPointMake(-15.43, 4.37)];
            [bezierPath addCurveToPoint: CGPointMake(-3.13, 40.41) controlPoint1: CGPointMake(-15.57, 33.82) controlPoint2: CGPointMake(-3.1, 38.35)];
            [bezierPath addCurveToPoint: CGPointMake(-2.55, 41.93) controlPoint1: CGPointMake(-3.16, 42.47) controlPoint2: CGPointMake(-2.55, 41.93)];
            [bezierPath addLineToPoint: CGPointMake(-1, 42.5)];
            [bezierPath addLineToPoint: CGPointMake(0.74, 41.93)];
            [bezierPath addLineToPoint: CGPointMake(1.13, 40.03)];
            [bezierPath addCurveToPoint: CGPointMake(13.5, 18.72) controlPoint1: CGPointMake(1.13, 40.03) controlPoint2: CGPointMake(13.54, 30.75)];
            [bezierPath addCurveToPoint: CGPointMake(-0.81, -0.5) controlPoint1: CGPointMake(13.46, 6.68) controlPoint2: CGPointMake(-0.81, -0.5)];
            [bezierPath closePath];
            
            SKShapeNode *leafShape = [SKShapeNode node];
            leafShape.path = [bezierPath CGPath];
            leafShape.strokeColor = [SKColor clearColor];
            leafShape.fillColor = [SKColor colorWithRed:138/255.0f green:206/255.0f blue:86/255.0f alpha:0.4f];
            leafShape.name = @"leafShape";
            leafShape.xScale = .5;
            leafShape.yScale = .5;
            
            LeafSpriteNode *newLeaf = [[LeafSpriteNode alloc] initWithColor:[SKColor clearColor]
                                                                       size:CGSizeMake(1, 5)];
            newLeaf.zPosition = limb.zPosition - 1;
            newLeaf.xScale = .01;
            newLeaf.yScale = .01;
            if (workingPage.choices.count % 2 == 0)
            {
                if (leafInterval > workingPage.choices.count/2)
                {
                    newLeaf.rotation = (M_PI/4)/(leafInterval/2);
                }
                else
                {
                    unsigned long conversion = leafInterval + (workingPage.choices.count / 2);
                    newLeaf.rotation = (M_PI/-4)/(conversion/2);
                }
            }
            else
            {
                if (!isFirstOddDone)
                {
                    newLeaf.rotation = 0;
                    leafInterval--;
                    isFirstOddDone = YES;
                }
                else
                {
                    if (leafInterval > workingPage.choices.count/2)
                    {
                        newLeaf.rotation = (M_PI/4)/(leafInterval/2);
                    }
                    else
                    {
                        newLeaf.rotation = (M_PI/-4)/(leafInterval/2);
                    }
                }
            }
            newLeaf.anchorPoint = CGPointMake(0, 0);
            newLeaf.position = CGPointMake(0, limb.size.height + 1);
            newLeaf.name = @"leaf";
            [newLeaf addChild:leafShape];
            [limb addChild:newLeaf];
            SKAction *scale = [SKAction scaleBy:100 duration:1];
            SKAction *rotate = [SKAction rotateByAngle:newLeaf.rotation duration:.5];
            SKAction *scaleSequence = [SKAction sequence:@[scale, rotate]];
            [newLeaf runAction:scaleSequence];
            leafInterval++;
        }

    }
    else if ([limb isKindOfClass:[BranchSpriteNode class]])
    {
        BranchSpriteNode *placeholder = (id)limb;
        Page *workingPage = placeholder.path.lastObject;
        for (Choice *choice in workingPage.choices)
        {
            UIBezierPath* bezierPath = [UIBezierPath bezierPath];
            [bezierPath moveToPoint: CGPointMake(-0.81, -0.5)];
            [bezierPath addCurveToPoint: CGPointMake(-15.5, 19.1) controlPoint1: CGPointMake(-0.81, -0.5) controlPoint2: CGPointMake(-15.43, 4.37)];
            [bezierPath addCurveToPoint: CGPointMake(-3.13, 40.41) controlPoint1: CGPointMake(-15.57, 33.82) controlPoint2: CGPointMake(-3.1, 38.35)];
            [bezierPath addCurveToPoint: CGPointMake(-2.55, 41.93) controlPoint1: CGPointMake(-3.16, 42.47) controlPoint2: CGPointMake(-2.55, 41.93)];
            [bezierPath addLineToPoint: CGPointMake(-1, 42.5)];
            [bezierPath addLineToPoint: CGPointMake(0.74, 41.93)];
            [bezierPath addLineToPoint: CGPointMake(1.13, 40.03)];
            [bezierPath addCurveToPoint: CGPointMake(13.5, 18.72) controlPoint1: CGPointMake(1.13, 40.03) controlPoint2: CGPointMake(13.54, 30.75)];
            [bezierPath addCurveToPoint: CGPointMake(-0.81, -0.5) controlPoint1: CGPointMake(13.46, 6.68) controlPoint2: CGPointMake(-0.81, -0.5)];
            [bezierPath closePath];
            
            SKShapeNode *leafShape = [SKShapeNode node];
            leafShape.path = [bezierPath CGPath];
            leafShape.strokeColor = [SKColor clearColor];
            leafShape.fillColor = [SKColor colorWithRed:138/255.0f green:206/255.0f blue:86/255.0f alpha:0.4f];
            leafShape.name = @"leafShape";
            leafShape.xScale = .5;
            leafShape.yScale = .5;
            
            LeafSpriteNode *newLeaf = [[LeafSpriteNode alloc] initWithColor:[SKColor clearColor]
                                                                       size:CGSizeMake(1, 5)];
            newLeaf.zPosition = limb.zPosition - 1;
            newLeaf.xScale = .01;
            newLeaf.yScale = .01;
            if (workingPage.choices.count % 2 == 0)
            {
                if (leafInterval > workingPage.choices.count/2)
                {
                    newLeaf.rotation = (M_PI/4)/(leafInterval/2);
                }
                else
                {
                    unsigned long conversion = leafInterval + (workingPage.choices.count / 2);
                    newLeaf.rotation = (M_PI/-4)/(conversion/2);
                }
            }
            else
            {
                if (!isFirstOddDone)
                {
                    newLeaf.rotation = 0;
                    leafInterval--;
                    isFirstOddDone = YES;
                }
                else
                {
                    if (leafInterval > workingPage.choices.count/2)
                    {
                        newLeaf.rotation = (M_PI/4)/(leafInterval/2);
                    }
                    else
                    {
                        newLeaf.rotation = (M_PI/-4)/(leafInterval/2);
                    }
                }
            }
            newLeaf.anchorPoint = CGPointMake(0, 0);
            newLeaf.position = CGPointMake(leafInterval, limb.size.height + 1);
            newLeaf.name = @"leaf";
            [newLeaf addChild:leafShape];
            [limb addChild:newLeaf];
            SKAction *scale = [SKAction scaleBy:100 duration:1];
            SKAction *rotate = [SKAction rotateByAngle:newLeaf.rotation duration:.5];
            SKAction *scaleSequence = [SKAction sequence:@[scale, rotate]];
            [newLeaf runAction:scaleSequence];
            leafInterval++;
        }
    }
}

#pragma mark -- update data

-(void)updatePagesAvailable
{
    //ending bools reading as YES only, no NOs. nonos.
    if ([self.page isEqual:self.allPagesAvailable[0]])
    {
        [self createEndingSprite];
        self.endingsReached++;
        [self checkEndingsReached];
        int closedPathIndex = 0;
        for (Page *page in self.allPagesAvailable)
        {
            if ([page isEqual:self.path[self.path.count - 1]])
            {
                [page.choices removeAllObjects];
            }
            else if ([page isEqual:self.path[self.path.count - 2]])
            {
                closedPathIndex = page.indexOfPage;
                [page.choices removeAllObjects];
            }
        }
        for (Page *page in self.allPagesAvailable)
        {
            if ([page isEqual:self.path[self.path.count - 3]])
            {
                for (Choice *choice in page.choices)
                {
                    if (choice.indexToNextPage == closedPathIndex)
                    {
                        [page.choices removeObjectIdenticalTo:choice];
                        break;
                    }
                }
            }
        }
        [self.paths addObject:self.path];
        [self.path removeAllObjects];
        self.previousMarkedBranch = self.markedBranch;
        self.markedBranch = nil;
    }
    else
    {
        [self.path addObject:self.page];
        [self searchAndGrow];
    }
    [self toggleMovingTextColor];
}

#pragma mark -- update sprites

-(void)searchAndGrow
{
    PlanetSpriteNode *planet = (id)[self childNodeWithName:@"planet"];
    TreeSpriteNode *treeSprite = (id)[planet childNodeWithName:@"tree"];
    BookMarkSprite *bookMark = (id)[self childNodeWithName:@"bookMarkBacker"];
    Page *lastPage = self.markedBranch.path.lastObject;
    Choice *lastChoice = lastPage.choices.lastObject;
    self.isDoneGrowing = NO;
    if (self.endingsReached == 0)
    {
        SKAction *fadeoutBookMark = [SKAction fadeOutWithDuration:.5];
        [bookMark runAction:fadeoutBookMark];
        SKAction *fadeInBookMark = [SKAction fadeInWithDuration:.5];
        [treeSprite enumerateChildNodesWithName:@"leaf" usingBlock:^(SKNode *node, BOOL *stop)
        {
            [node runAction:[SKAction sequence:@[fadeout, [SKAction performSelector:@selector(removeFromParent) onTarget:node]]]];
        }];
        SKAction *updateLength = [SKAction performSelector:@selector(updateTreeLength) onTarget:treeSprite];
        SKAction *pingScaleShape = [SKAction performSelector:@selector(pingScaleShape) onTarget:treeSprite];
        SKAction *pingCreateLeaves = [SKAction performSelector:@selector(pingGrowLeaves) onTarget:treeSprite];
        SKAction *pingCreateBranches = [SKAction performSelector:@selector(pingGrowBranches) onTarget:treeSprite];
        SKAction *scaleCheck = [SKAction performSelector:@selector(sceneScaleCheck) onTarget:self];
        SKAction *addPage = [SKAction performSelector:@selector(addPage) onTarget:treeSprite];
        SKAction *sequence = [SKAction sequence:@[grow,
                                                  updateLength,
                                                  pingScaleShape,
                                                  [SKAction waitForDuration:2.2],
                                                  addPage,
                                                  pingCreateLeaves,
                                                  scaleCheck]];
        [treeSprite runAction:sequence completion:^{
            self.isDoneGrowing = YES;
            [bookMark runAction:fadeInBookMark];
        }];
        [treeSprite runAction:pingCreateBranches];
    }
    else if (self.markedBranch)
    {
        SKAction *fadeoutBookMark = [SKAction fadeOutWithDuration:.5];
        [bookMark runAction:fadeoutBookMark];
        SKAction *fadeInBookMark = [SKAction fadeInWithDuration:.5];
        self.didSwitchBranches = NO;
        [self.markedBranch enumerateChildNodesWithName:@"branch" usingBlock:^(SKNode *node, BOOL *stop) {
            BranchSpriteNode *branch = (id)node;
            if ([branch.path containsObject:self.page])
            {
                self.previousMarkedBranch = self.markedBranch;
                self.markedBranch = branch;
                self.didSwitchBranches = YES;
            }
        }];
        if (!self.didSwitchBranches && lastChoice.indexToNextPage != 0)
        {
            [self.markedBranch enumerateChildNodesWithName:@"leaf" usingBlock:^(SKNode *node, BOOL *stop)
             {
                 [node runAction:[SKAction sequence:@[fadeout, [SKAction performSelector:@selector(removeFromParent) onTarget:node]]]];
             }];
            SKAction *updateLength = [SKAction performSelector:@selector(updateBranchLength) onTarget:self.markedBranch];
            SKAction *pingScaleShape = [SKAction performSelector:@selector(pingScaleShape) onTarget:self.markedBranch];
            SKAction *pingGrowLeaves = [SKAction performSelector:@selector(pingGrowLeaves) onTarget:self.markedBranch];
            SKAction *pingGrowBranches = [SKAction performSelector:@selector(pingGrowBranches) onTarget:self.markedBranch];
            SKAction *addPage = [SKAction performSelector:@selector(addPage) onTarget:self.markedBranch];
            SKAction *sceneScaleCheck = [SKAction performSelector:@selector(sceneScaleCheck) onTarget:self];
            SKAction *sequence = [SKAction sequence:@[grow,
                                                      updateLength,
                                                      pingScaleShape,
                                                      [SKAction waitForDuration:2.2],
                                                      pingGrowLeaves,
                                                      pingGrowBranches,
                                                      addPage,
                                                      sceneScaleCheck]];
            [self.markedBranch runAction:sequence completion:^{
                self.isDoneGrowing = YES;
                [bookMark runAction:fadeInBookMark];
            }];
        }
    }
    else
    {
        [treeSprite enumerateChildNodesWithName:@"branch" usingBlock:^(SKNode *node, BOOL *stop)
        {
            BranchSpriteNode *branch = (id)node;
            if ([branch.path containsObject:self.page])
            {
                self.markedBranch = branch;
            }
        }];
        self.isDoneGrowing = YES;
    }
}

-(void)sceneCheck
{
    [self updatePagesAvailable];
}

-(void)sendPageDownPathInNode:(SKNode *)node
{
    SKShapeNode *shape;
    Page *page;
    SKAction *recurse;
    if ([node isKindOfClass:[TreeSpriteNode class]])
    {
        TreeSpriteNode *treeSprite = (id)node;
        page = treeSprite.path.lastObject;
        shape = (id)[treeSprite childNodeWithName:@"treeShape"];
        recurse = [SKAction performSelector:@selector(pingSceneRecurse) onTarget:treeSprite];
        
        if (treeSprite.indexOfText >= page.pageText.length)
        {
            treeSprite.indexOfText = 0;
        }
        char character = [page.pageText characterAtIndex:treeSprite.indexOfText];
        NSString *charString = [NSString stringWithFormat:@"%c", character];
        SKSpriteNode *charContainer = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(1, 1)];
        charContainer.name = @"charContainer";
        StoryLabelNode *type = [StoryLabelNode labelNodeWithFontNamed:@"TexGyreAdventor-Regular"];
        type.text = charString;
        type.fontSize = 8;
        type.fontColor = [SKColor brownColor];
        if (self.hasEndedWell)
        {
            type.fontColor = [UIColor colorWithRed:1.000 green:0.911 blue:0.000 alpha:0.750];
            type.fontSize = 10;
        }
        else if ([treeSprite.path containsObject:self.page] || self.endingsReached == 0)
        {
            type.fontColor = [SKColor whiteColor];
            type.fontSize = 10;
        }
        type.zRotation = M_PI/2;
        type.zPosition = treeSprite.zPosition + 1;
        type.position = CGPointMake(0, 0);
        type.xScale = 1 / shape.xScale;
        type.yScale = 1 / shape.yScale;
        type.name = @"type";

        [charContainer addChild:type];
        [shape addChild:charContainer];
        SKAction *followPath = [SKAction followPath:shape.path asOffset:NO orientToPath:YES duration:treeSprite.size.height/18];
        SKAction *wait = [SKAction waitForDuration:.2];
        SKAction *increment = [SKAction performSelector:@selector(incrementIndexOfPageText) onTarget:treeSprite];
        SKAction *fadeOutType = [SKAction performSelector:@selector(fadeOutNode) onTarget:type];
        SKAction *removeType = [SKAction performSelector:@selector(removeFromParent) onTarget:type];
        SKAction *removeContainer = [SKAction performSelector:@selector(removeFromParent) onTarget:charContainer];
        SKAction *waitAndIncrementAndRecurse = [SKAction sequence:@[wait, increment, recurse]];
        SKAction *sendGroup = [SKAction group:@[followPath, waitAndIncrementAndRecurse]];
        SKAction *sendSequence = [SKAction sequence:@[sendGroup, fadeOutType, removeType, removeContainer]];
        [charContainer runAction:sendSequence];

    }
    else if ([node isKindOfClass:[BranchSpriteNode class]])
    {
        BranchSpriteNode *branchSprite = (id)node;
        page = branchSprite.path.lastObject;
        shape = (id)[branchSprite childNodeWithName:@"branchShape"];
        recurse = [SKAction performSelector:@selector(pingSceneRecurse) onTarget:branchSprite];
        if (branchSprite.indexOfText >= page.pageText.length)
        {
            branchSprite.indexOfText = 0;
        }
        char character = [page.pageText characterAtIndex:branchSprite.indexOfText];
        NSString *charString = [NSString stringWithFormat:@"%c", character];
        SKSpriteNode *charContainer = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(1, 1)];
        charContainer.name = @"charContainer";
        StoryLabelNode *type = [StoryLabelNode labelNodeWithFontNamed:@"TexGyreAdventor-Regular"];
        type.text = charString;
        type.fontSize = 8;
        type.fontColor = [SKColor brownColor];
        if (self.hasEndedWell)
        {
            type.fontColor = [UIColor colorWithRed:1.000 green:0.911 blue:0.000 alpha:0.750];
        }
        else if ([branchSprite isEqual:self.markedBranch])
        {
            type.fontColor = [SKColor whiteColor];
        }
        if (branchSprite.side == 0)
        {
            type.zRotation = M_PI/-2;
        }
        else
        {
            type.zRotation = M_PI/2;
        }
        type.zPosition = branchSprite.zPosition - 1;
        type.position = CGPointMake(0, 0);
        type.xScale = 1 / shape.xScale;
        type.yScale = 1 / shape.yScale;
        type.name = @"type";
        [charContainer addChild:type];
        [shape addChild:charContainer];
        SKAction *followPath = [SKAction followPath:shape.path asOffset:NO orientToPath:YES duration:branchSprite.size.height/12];
        SKAction *wait = [SKAction waitForDuration:.2];
        SKAction *increment = [SKAction performSelector:@selector(incrementIndexOfPageText) onTarget:branchSprite];
        SKAction *fadeOutType = [SKAction performSelector:@selector(fadeOutNode) onTarget:type];
        SKAction *removeType = [SKAction performSelector:@selector(removeFromParent) onTarget:type];
        SKAction *removeContainer = [SKAction performSelector:@selector(removeFromParent) onTarget:charContainer];
        SKAction *waitAndIncrementAndRecurse = [SKAction sequence:@[wait, increment, recurse]];
        SKAction *sendGroup = [SKAction group:@[followPath, waitAndIncrementAndRecurse]];
        SKAction *sendSequence = [SKAction sequence:@[sendGroup, fadeOutType, removeType, removeContainer]];
        [charContainer runAction:sendSequence];
    }
    else if ([node isKindOfClass:[GoodEndingSprite class]])
    {
        GoodEndingSprite *goodSprite = (id)node;
        page = goodSprite.page;
        shape = (id)[goodSprite childNodeWithName:@"goodEndingShape"];
        recurse = [SKAction performSelector:@selector(pingSceneRecurse) onTarget:goodSprite];
        
        if (goodSprite.indexOfText >= page.pageText.length)
        {
            goodSprite.indexOfText = 0;
        }
        char character = [page.pageText characterAtIndex:goodSprite.indexOfText];
        NSString *charString = [NSString stringWithFormat:@"%c", character];
        SKSpriteNode *charContainer = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(1, 1)];
        charContainer.name = @"charContainer";
        StoryLabelNode *type = [StoryLabelNode labelNodeWithFontNamed:@"TexGyreAdventor-Regular"];
        type.text = charString;
        type.fontSize = 10;
        type.fontColor = [UIColor colorWithRed:1.000 green:0.911 blue:0.000 alpha:0.750];
        if (self.hasEndedPoorly)
        {
            type.fontColor = [UIColor colorWithRed:0.685 green:0.000 blue:0.000 alpha:0.750];
        }
        type.zRotation = M_PI/2;
        type.position = CGPointMake(0, 0);
        type.name = @"type";
        [charContainer addChild:type];
        [shape addChild:charContainer];
        SKAction *followPath = [SKAction followPath:shape.path asOffset:NO orientToPath:YES duration:4];
        SKAction *wait = [SKAction waitForDuration:.2];
        SKAction *increment = [SKAction performSelector:@selector(incrementIndexOfPageText) onTarget:goodSprite];
        SKAction *fadeOutType = [SKAction performSelector:@selector(fadeOutNode) onTarget:type];
        SKAction *removeType = [SKAction performSelector:@selector(removeFromParent) onTarget:type];
        SKAction *removeContainer = [SKAction performSelector:@selector(removeFromParent) onTarget:charContainer];
        SKAction *waitAndIncrementAndRecurse = [SKAction sequence:@[wait, increment, recurse]];
        SKAction *sendGroup = [SKAction group:@[followPath, waitAndIncrementAndRecurse]];
        SKAction *sendSequence = [SKAction sequence:@[sendGroup, fadeOutType, removeType, removeContainer]];
        [charContainer runAction:sendSequence];
    }
    else if ([node isKindOfClass:[NegativeEndingSprite class]])
    {
        NegativeEndingSprite *negativeSprite = (id)node;
        page = negativeSprite.page;
        shape = (id)[negativeSprite childNodeWithName:@"negativeEndingShape"];
        recurse = [SKAction performSelector:@selector(pingSceneRecurse) onTarget:negativeSprite];
        
        if (negativeSprite.indexOfText >= page.pageText.length)
        {
            negativeSprite.indexOfText = 0;
        }
        char character = [page.pageText characterAtIndex:negativeSprite.indexOfText];
        NSString *charString = [NSString stringWithFormat:@"%c", character];
        SKSpriteNode *charContainer = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(1, 1)];
        charContainer.name = @"charContainer";
        StoryLabelNode *type = [StoryLabelNode labelNodeWithFontNamed:@"TexGyreAdventor-Regular"];
        type.text = charString;
        type.fontSize = 10;
        if (!self.hasEndedWell)
        {
            type.fontColor = [UIColor colorWithRed:0.685 green:0.000 blue:0.000 alpha:0.750];
        }
        else
        {
            type.fontColor = [UIColor colorWithRed:1.000 green:0.911 blue:0.000 alpha:0.750];
        }
        type.zRotation = M_PI/2;
        type.position = CGPointMake(0, 0);
        type.name = @"type";
        [charContainer addChild:type];
        [shape addChild:charContainer];
        SKAction *followPath = [SKAction followPath:shape.path asOffset:NO orientToPath:YES duration:4];
        SKAction *wait = [SKAction waitForDuration:.2];
        SKAction *increment = [SKAction performSelector:@selector(incrementIndexOfPageText) onTarget:negativeSprite];
        SKAction *fadeOutType = [SKAction performSelector:@selector(fadeOutNode) onTarget:type];
        SKAction *removeType = [SKAction performSelector:@selector(removeFromParent) onTarget:type];
        SKAction *removeContainer = [SKAction performSelector:@selector(removeFromParent) onTarget:charContainer];
        SKAction *waitAndIncrementAndRecurse = [SKAction sequence:@[wait, increment, recurse]];
        SKAction *sendGroup = [SKAction group:@[followPath, waitAndIncrementAndRecurse]];
        SKAction *sendSequence = [SKAction sequence:@[sendGroup, fadeOutType, removeType, removeContainer]];
        [charContainer runAction:sendSequence];
    }
}

-(void)controlTypeInMotion
{
    if (self.endingsReached == 0)
    {
        PlanetSpriteNode *planet = (id)[self childNodeWithName:@"planet"];
        TreeSpriteNode *treeSprite = (id)[planet childNodeWithName:@"tree"];
        SKShapeNode *treeShape = (id)[treeSprite childNodeWithName:@"treeShape"];
        [treeShape enumerateChildNodesWithName:@"charContainer" usingBlock:^(SKNode *node, BOOL *stop)
        {
            SKLabelNode *type = (id)[node childNodeWithName:@"type"];
            if (type)
            {
                type.xScale = 1 / treeShape.xScale;
                type.yScale = 1 / treeShape.yScale;
            }
        }];
        [treeShape enumerateChildNodesWithName:@"branch" usingBlock:^(SKNode *node, BOOL *stop)
        {
            [node enumerateChildNodesWithName:@"branchShape" usingBlock:^(SKNode *node, BOOL *stop)
            {
                SKShapeNode *branchShape = (id)node;
                [branchShape enumerateChildNodesWithName:@"charContainer" usingBlock:^(SKNode *node, BOOL *stop)
                {
                    SKLabelNode *type = (id)[node childNodeWithName:@"type"];
                    if (type)
                    {
                        type.xScale = 1 / branchShape.xScale;
                        type.yScale = 1 / branchShape.yScale;
                    }
                }];
            }];
        }];
    }
    else
    {
        SKShapeNode *branchShape = (id)[self.markedBranch childNodeWithName:@"branchShape"];
        [branchShape enumerateChildNodesWithName:@"charContainer" usingBlock:^(SKNode *node, BOOL *stop)
        {
            SKLabelNode *type = (id)[node childNodeWithName:@"type"];
            if (type)
            {
                type.xScale = 1 / branchShape.xScale;
                type.yScale = 1 / branchShape.yScale;
            }
        }];
        [self.markedBranch enumerateChildNodesWithName:@"branch" usingBlock:^(SKNode *node, BOOL *stop)
         {
             [node enumerateChildNodesWithName:@"branchShape" usingBlock:^(SKNode *node, BOOL *stop)
              {
                  SKShapeNode *branchShape = (id)node;
                  [branchShape enumerateChildNodesWithName:@"charContainer" usingBlock:^(SKNode *node, BOOL *stop)
                   {
                       SKLabelNode *type = (id)[node childNodeWithName:@"type"];
                       if (type)
                       {
                           type.xScale = 1 / branchShape.xScale;
                           type.yScale = 1 / branchShape.yScale;
                       }
                   }];
              }];
         }];
    }
}

-(void)toggleMovingTextColor
{
    PlanetSpriteNode *planet = (id)[self childNodeWithName:@"planet"];
    TreeSpriteNode *treeSprite = (id)[planet childNodeWithName:@"tree"];
    if ([treeSprite.path containsObject:self.page] || self.endingsReached == 0)
    {
        SKShapeNode *treeShape = (id)[treeSprite childNodeWithName:@"treeShape"];
        [treeShape enumerateChildNodesWithName:@"charContainer" usingBlock:^(SKNode *node, BOOL *stop)
         {
             SKLabelNode *type = (id)[node childNodeWithName:@"type"];
             if (type)
             {
                 type.fontColor = [SKColor whiteColor];
                 type.fontSize = 10;
             }
         }];
        if (self.previousMarkedBranch)
        {
            SKShapeNode *branchShape = (id)[self.previousMarkedBranch childNodeWithName:@"branchShape"];
            [branchShape enumerateChildNodesWithName:@"charContainer" usingBlock:^(SKNode *node, BOOL *stop)
             {
                 SKLabelNode *type = (id)[node childNodeWithName:@"type"];
                 if (type)
                 {
                     type.fontColor = [SKColor brownColor];
                 }
             }];
        }
        
    }
    else if (self.markedBranch)
    {
        SKShapeNode *branchShape = (id)[self.markedBranch childNodeWithName:@"branchShape"];
        [branchShape enumerateChildNodesWithName:@"charContainer" usingBlock:^(SKNode *node, BOOL *stop)
         {
             SKLabelNode *type = (id)[node childNodeWithName:@"type"];
             if (type)
             {
                 type.fontColor = [SKColor whiteColor];
             }
         }];
        SKShapeNode *treeShape = (id)[treeSprite childNodeWithName:@"treeShape"];
        [treeShape enumerateChildNodesWithName:@"charContainer" usingBlock:^(SKNode *node, BOOL *stop)
         {
             SKLabelNode *type = (id)[node childNodeWithName:@"type"];
             if (type)
             {
                 type.fontColor = [SKColor brownColor];
                 type.fontSize = 8;
             }
         }];
        if (self.previousMarkedBranch)
        {
            SKShapeNode *branchShape = (id)[self.previousMarkedBranch childNodeWithName:@"branchShape"];
            [branchShape enumerateChildNodesWithName:@"charContainer" usingBlock:^(SKNode *node, BOOL *stop)
             {
                 SKLabelNode *type = (id)[node childNodeWithName:@"type"];
                 if (type)
                 {
                     type.fontColor = [SKColor brownColor];
                 }
             }];
        }
    }
}

-(void)removeAllText
{
    PlanetSpriteNode *planet = (id)[self childNodeWithName:@"planet"];
    TreeSpriteNode *treeSprite = (id)[planet childNodeWithName:@"tree"];
    SKShapeNode *treeShape = (id)[treeSprite childNodeWithName:@"treeShape"];
    [treeShape enumerateChildNodesWithName:@"charContainer" usingBlock:^(SKNode *node, BOOL *stop)
     {
         SKLabelNode *type = (id)[node childNodeWithName:@"type"];
         if (type)
         {
             [type removeFromParent];
         }
         [node removeFromParent];
     }];
    GoodEndingSprite *goodSprite = (id)[treeSprite childNodeWithName:@"goodEndingSprite"];
    if (goodSprite)
    {
        SKShapeNode *goodShape = (id)[goodSprite childNodeWithName:@"goodEndingShape"];
        [goodShape removeAllChildren];
        [self sendPageDownPathInNode:goodSprite];
    }
    NegativeEndingSprite *negativeSprite = (id)[treeSprite childNodeWithName:@"negativeEndingSprite"];
    if (negativeSprite)
    {
        SKShapeNode *negativeShape = (id)[negativeSprite childNodeWithName:@"negativeEndingShape"];
        [negativeShape removeAllChildren];
        [self sendPageDownPathInNode:negativeSprite];
    }
}

-(void)removeTextFromBranchesWithBranch:(BranchSpriteNode *)branch
{
    [branch enumerateChildNodesWithName:@"branch" usingBlock:^(SKNode *node, BOOL *stop)
    {
        BranchSpriteNode *childBranch = (id)node;
        if (childBranch)
        {
            [self removeTextFromBranchesWithBranch:childBranch];
        }
    }];
    SKShapeNode *branchShape = (id)[branch childNodeWithName:@"branchShape"];
    [branchShape enumerateChildNodesWithName:@"charContainer" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
    GoodEndingSprite *goodSprite = (id)[branch childNodeWithName:@"goodEndingSprite"];
    if (goodSprite)
    {
        SKShapeNode *goodShape = (id)[goodSprite childNodeWithName:@"goodEndingShape"];
        [goodShape removeAllChildren];
        [self sendPageDownPathInNode:goodSprite];
    }
    NegativeEndingSprite *negativeSprite = (id)[branch childNodeWithName:@"negativeEndingSprite"];
    if (negativeSprite)
    {
        SKShapeNode *negativeShape = (id)[negativeSprite childNodeWithName:@"negativeEndingShape"];
        [negativeShape removeAllChildren];
        [self sendPageDownPathInNode:negativeSprite];
    }
}

-(void)moveTextOnBranchesWithBranch:(BranchSpriteNode *)branch
{
    [branch enumerateChildNodesWithName:@"branch" usingBlock:^(SKNode *node, BOOL *stop) {
        if ([node isKindOfClass:[BranchSpriteNode class]])
        {
            BranchSpriteNode *childBranch = (id)node;
            [self moveTextOnBranchesWithBranch:childBranch];
        }
    }];
    
    [self sendPageDownPathInNode:branch];
}

-(void)fadeOutNode:(SKNode *)node
{
    [node runAction:[SKAction fadeOutWithDuration:0.1]];
}

#pragma mark -- scale scene

-(void)throwInWalls
{
    self.leftWallSprite = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(10, 1136)];
    self.leftWallThickSprite = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(1000, 1136)];
    self.rightWallSprite = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(10, 1136)];
    self.rightWallThickSprite = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(1000, 1136)];
    self.topWallSprite = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(640, 1000)];
    self.bottomWallSprite = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(640, 10)];
    self.leftWallSprite.zPosition = 18;
    self.rightWallSprite.zPosition = 18;
    self.topWallSprite.zPosition = 18;
    self.bottomWallSprite.zPosition = 18;
    self.leftWallSprite.position = CGPointMake(50, self.size.height/2);
    self.leftWallThickSprite.position = CGPointMake(-460, self.size.height/2);
    self.rightWallSprite.position = CGPointMake(self.size.width - 50, self.size.height/2);
    self.rightWallThickSprite.position = CGPointMake(self.size.width + 440, self.size.height/2);
    self.topWallSprite.position = CGPointMake(self.size.width/2, self.size.height + 440);
    self.bottomWallSprite.position = CGPointMake(self.size.width/2, 0 + 50);
    [self addChild:self.leftWallSprite];
    [self addChild:self.leftWallThickSprite];
    [self addChild:self.rightWallSprite];
    [self addChild:self.rightWallThickSprite];
    [self addChild:self.topWallSprite];
    [self addChild:self.bottomWallSprite];
}

-(void)sceneScaleCheck
{
    PlanetSpriteNode *planet = (id)[self childNodeWithName:@"planet"];
    TreeSpriteNode *treeSprite = (id)[planet childNodeWithName:@"tree"];
    if ([treeSprite intersectsNode:self.topWallSprite] ||
        [treeSprite intersectsNode:self.bottomWallSprite] ||
        [treeSprite intersectsNode:self.leftWallSprite] ||
        [treeSprite intersectsNode:self.leftWallThickSprite] ||
        [treeSprite intersectsNode:self.rightWallSprite] ||
        [treeSprite intersectsNode:self.rightWallThickSprite])
    {
        [self scaleSceneOut];
    }
    else
    {
        [treeSprite enumerateChildNodesWithName:@"branch" usingBlock:^(SKNode *node, BOOL *stop)
        {
            BranchSpriteNode *placeholder = (id)node;
            if ([placeholder intersectsNode:self.topWallSprite] ||
                [placeholder intersectsNode:self.bottomWallSprite] ||
                [placeholder intersectsNode:self.leftWallSprite] ||
                [placeholder intersectsNode:self.leftWallThickSprite] ||
                [placeholder intersectsNode:self.rightWallSprite] ||
                [placeholder intersectsNode:self.rightWallThickSprite])
            {
                [self scaleSceneOut];
            }
        }];
    }
}

-(void)scaleSceneIn
{
    PlanetSpriteNode *planet = (id)[self childNodeWithName:@"planet"];
    SKAction *scaleIn = [SKAction scaleBy:2.4 duration:5];
    SKAction *throwWallsUp = [SKAction performSelector:@selector(throwInWalls) onTarget:self];
    [planet runAction:[SKAction sequence:@[scaleIn, throwWallsUp]]];
}

-(void)scaleSceneOut
{
    PlanetSpriteNode *planet = (id)[self childNodeWithName:@"planet"];
    [planet runAction:[SKAction scaleBy:.95 duration:.2]];
    [planet runAction:[SKAction performSelector:@selector(sceneScaleCheck) onTarget:self]];
}

#pragma mark -- game management

-(void)checkEndingsReached
{
    if (self.negativeEndingsReached == 3)
    {
        [self endLosingGame];
    }
    else if (self.endingsReached == 6)
    {
        [self endWinningGame];
    }
}

-(void)endWinningGame
{
    self.hasEnded = YES;
    self.hasEndedWell = YES;
    PlanetSpriteNode *planet = (id)[self childNodeWithName:@"planet"];
    TreeSpriteNode *treeSprite = (id)[planet childNodeWithName:@"tree"];
    SKShapeNode *treeShape = (id)[treeSprite childNodeWithName:@"treeShape"];
    BookMarkSprite *bookmark = (id)[self childNodeWithName:@"bookMarkBacker"];
    SKAction *fadeOut = [SKAction fadeOutWithDuration:1];
    [bookmark runAction:fadeOut completion:^{
        [bookmark removeFromParent];
    }];
    Page *page = [Page new];
    page.pageText = @"Thank You ";
    [treeSprite.path addObject:page];
    treeSprite.indexOfText = 0;
    [treeSprite enumerateChildNodesWithName:@"branch" usingBlock:^(SKNode *node, BOOL *stop)
    {
        BranchSpriteNode *branch = (id)node;
        if (branch)
        {
            [self modifyBranchesTextWithBranch:branch];
        }
    }];
    [treeShape enumerateChildNodesWithName:@"charContainer" usingBlock:^(SKNode *node, BOOL *stop)
     {
         char character = [page.pageText characterAtIndex:treeSprite.indexOfText];
         NSString *charString = [NSString stringWithFormat:@"%c", character];
         SKLabelNode *type = (id)[node childNodeWithName:@"type"];
         if (type)
         {
             type.text = charString;
             type.fontColor = [UIColor colorWithRed:1.000 green:0.911 blue:0.000 alpha:0.750];
             [treeSprite incrementIndexOfPageText];
         }
     }];
    GoodEndingSprite *goodSprite = (id)[treeSprite childNodeWithName:@"goodEndingSprite"];
    if (goodSprite)
    {
        goodSprite.page.pageText = @"Thank You ";
        goodSprite.indexOfText = 0;
        SKShapeNode *goodShape = (id)[goodSprite childNodeWithName:@"goodEndingShape"];
        [goodShape enumerateChildNodesWithName:@"charContainer" usingBlock:^(SKNode *node, BOOL *stop) {
            
            char character = [goodSprite.page.pageText characterAtIndex:goodSprite.indexOfText];
            NSString *charString = [NSString stringWithFormat:@"%c", character];
            SKLabelNode *type = (id)[node childNodeWithName:@"type"];
            if (type)
            {
                type.text = charString;
                [goodSprite incrementIndexOfPageText];
            }
        }];
    }
    NegativeEndingSprite *negativeSprite = (id)[treeSprite childNodeWithName:@"negativeEndingSprite"];
    if (negativeSprite)
    {
        negativeSprite.page.pageText = @"Thank You ";
        negativeSprite.indexOfText = 0;
        SKShapeNode *negativeShape = (id)[negativeSprite childNodeWithName:@"negativeEndingShape"];
        [negativeShape enumerateChildNodesWithName:@"charContainer" usingBlock:^(SKNode *node, BOOL *stop) {
            
            char character = [negativeSprite.page.pageText characterAtIndex:negativeSprite.indexOfText];
            NSString *charString = [NSString stringWithFormat:@"%c", character];
            SKLabelNode *type = (id)[node childNodeWithName:@"type"];
            if (type)
            {
                type.text = charString;
                type.fontColor = [UIColor colorWithRed:1.000 green:0.911 blue:0.000 alpha:0.750];
                [negativeSprite incrementIndexOfPageText];
            }
        }];
    }
    
    UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
    [bezier2Path moveToPoint: CGPointMake(200.5, 1132.62)];
    [bezier2Path addCurveToPoint: CGPointMake(466.5, 1032.61) controlPoint1: CGPointMake(200.5, 1132.62) controlPoint2: CGPointMake(445.8, 1150.66)];
    [bezier2Path addCurveToPoint: CGPointMake(252.5, 937.95) controlPoint1: CGPointMake(487.2, 914.56) controlPoint2: CGPointMake(288.99, 900.13)];
    [bezier2Path addCurveToPoint: CGPointMake(366.5, 962.95) controlPoint1: CGPointMake(216.01, 975.78) controlPoint2: CGPointMake(361.7, 987.73)];
    [bezier2Path addCurveToPoint: CGPointMake(353.5, 821.87) controlPoint1: CGPointMake(371.3, 938.18) controlPoint2: CGPointMake(378.82, 906.75)];
    [bezier2Path addCurveToPoint: CGPointMake(314.5, 643.27) controlPoint1: CGPointMake(328.18, 736.99) controlPoint2: CGPointMake(314.5, 643.27)];
    [bezier2Path addCurveToPoint: CGPointMake(272.5, 415.57) controlPoint1: CGPointMake(314.5, 643.27) controlPoint2: CGPointMake(274.21, 523.59)];
    [bezier2Path addCurveToPoint: CGPointMake(305.5, 157.5) controlPoint1: CGPointMake(270.79, 307.55) controlPoint2: CGPointMake(305.5, 157.5)];
    
    SKShapeNode *descentPath = [SKShapeNode node];
    descentPath.path = [bezier2Path CGPath];
    descentPath.strokeColor = [UIColor clearColor];
    descentPath.zPosition = 99;
    [self addChild:descentPath];
    
    SKSpriteNode *newSeed = [[SKSpriteNode alloc] initWithImageNamed:@"newSeed2.png"];
    SKAction *rotate = [SKAction rotateByAngle:M_PI/2 duration:1];
    SKAction *fall = [SKAction followPath:descentPath.path duration:7];
    SKAction *repeatRotate = [SKAction repeatAction:rotate count:7];
    SKAction *fallGroup = [SKAction group:@[fall, repeatRotate]];
    [descentPath addChild:newSeed];
    [newSeed runAction:fallGroup completion:^{
        [newSeed removeFromParent];
        newSeed.position = CGPointMake(-9, -67.21);
        newSeed.xScale = 1/planet.xScale;
        newSeed.yScale = 1/planet.yScale;
        [planet addChild:newSeed];
    }];
    
    SKAction *wait = [SKAction waitForDuration:8];
    [self runAction:wait completion:^{
//        PositiveEndingScene *positiveScene = [[PositiveEndingScene alloc] initWithSize:CGSizeMake(640, 1136)];
//        SKTransition *transition = [SKTransition fadeWithDuration:2];
//        [self.view presentScene:positiveScene transition:transition];
        [self showPlayAgainWithGoodEnding];
    }];
    [self delete];
}

-(void)modifyBranchesTextWithBranch:(BranchSpriteNode *)branch
{
    Page *page = [Page new];
    page.pageText = @"Thank You ";
    [branch.path addObject:page];
    branch.indexOfText = 0;
    [branch enumerateChildNodesWithName:@"branch" usingBlock:^(SKNode *node, BOOL *stop)
     {
         BranchSpriteNode *childBranch = (id)node;
         if (childBranch)
         {
             [self modifyBranchesTextWithBranch:childBranch];
         }
     }];
    SKShapeNode *branchShape = (id)[branch childNodeWithName:@"branchShape"];
    [branchShape enumerateChildNodesWithName:@"charContainer" usingBlock:^(SKNode *node, BOOL *stop)
    {
        char character = [page.pageText characterAtIndex:branch.indexOfText];
        NSString *charString = [NSString stringWithFormat:@"%c", character];
        SKLabelNode *type = (id)[node childNodeWithName:@"type"];
        if (type)
        {
            type.text = charString;
            type.fontColor = [UIColor colorWithRed:1.000 green:0.911 blue:0.000 alpha:0.750];
        }
    }];
    GoodEndingSprite *goodSprite = (id)[branch childNodeWithName:@"goodEndingSprite"];
    if (goodSprite)
    {
        goodSprite.page.pageText = @"Thank You ";
        goodSprite.indexOfText = 0;
        SKShapeNode *goodShape = (id)[goodSprite childNodeWithName:@"goodEndingShape"];
        [goodShape enumerateChildNodesWithName:@"charContainer" usingBlock:^(SKNode *node, BOOL *stop) {
            
            char character = [goodSprite.page.pageText characterAtIndex:goodSprite.indexOfText];
            NSString *charString = [NSString stringWithFormat:@"%c", character];
            SKLabelNode *type = (id)[node childNodeWithName:@"type"];
            if (type)
            {
                type.text = charString;
                [goodSprite incrementIndexOfPageText];
            }
        }];
    }
    NegativeEndingSprite *negativeSprite = (id)[branch childNodeWithName:@"negativeEndingSprite"];
    if (negativeSprite)
    {
        negativeSprite.page.pageText = @"Thank You ";
        negativeSprite.indexOfText = 0;
        SKShapeNode *negativeShape = (id)[negativeSprite childNodeWithName:@"negativeEndingShape"];
        [negativeShape enumerateChildNodesWithName:@"charContainer" usingBlock:^(SKNode *node, BOOL *stop) {
            
            char character = [negativeSprite.page.pageText characterAtIndex:negativeSprite.indexOfText];
            NSString *charString = [NSString stringWithFormat:@"%c", character];
            SKLabelNode *type = (id)[node childNodeWithName:@"type"];
            if (type)
            {
                type.text = charString;
                type.fontColor = [UIColor colorWithRed:1.000 green:0.911 blue:0.000 alpha:0.750];
                [negativeSprite incrementIndexOfPageText];
            }
        }];
    }
}

-(void)modifyEndingTextWithBranch:(BranchSpriteNode *)branch
{
    [branch enumerateChildNodesWithName:@"branch" usingBlock:^(SKNode *node, BOOL *stop)
     {
         BranchSpriteNode *childBranch = (id)node;
         if (childBranch)
         {
             [self modifyBranchesTextWithBranch:childBranch];
         }
     }];
    GoodEndingSprite *goodSprite = (id)[branch childNodeWithName:@"goodEndingSprite"];
    if (goodSprite)
    {
        SKShapeNode *goodShape = (id)[goodSprite childNodeWithName:@"goodEndingShape"];
        [goodShape enumerateChildNodesWithName:@"charContainer" usingBlock:^(SKNode *node, BOOL *stop)
        {
            SKLabelNode *type = (id)[node childNodeWithName:@"type"];
            if (type)
            {
                type.color = [UIColor colorWithRed:0.685 green:0.000 blue:0.000 alpha:0.750];
            }
        }];
    }
}


-(void)endLosingGame
{
    self.hasEnded = YES;
    self.hasEndedPoorly = YES;
    BookMarkSprite *bookmark = (id)[self childNodeWithName:@"bookMarkBacker"];
    SKAction *fadeOut = [SKAction fadeOutWithDuration:1];
    [bookmark runAction:fadeOut completion:^{
        [bookmark removeFromParent];
    }];
    PlanetSpriteNode *planet = (id)[self childNodeWithName:@"planet"];
    TreeSpriteNode *treeSprite = (id)[planet childNodeWithName:@"tree"];
    SKShapeNode *treeShape = (id)[treeSprite childNodeWithName:@"treeShape"];
    [treeShape enumerateChildNodesWithName:@"charContainer" usingBlock:^(SKNode *node, BOOL *stop)
     {
         [node removeAllActions];
         SKAction *wait = [SKAction waitForDuration:(arc4random() % 10)/8];
         float range = ((arc4random() % 300) - 150);
         SKAction *moveDown = [SKAction moveTo:CGPointMake(node.position.x + range, node.position.y - 1000) duration:70];
         SKAction *remove = [SKAction performSelector:@selector(removeFromParent) onTarget:node];
         SKAction *endSequence = [SKAction sequence:@[wait, moveDown, remove]];
         [node runAction:endSequence];
     }];
    [treeSprite enumerateChildNodesWithName:@"branch" usingBlock:^(SKNode *node, BOOL *stop)
    {
        BranchSpriteNode *branch = (id)node;
        [self animateBranchesForLosingEndingWithBranch:branch];
    }];
    [treeSprite enumerateChildNodesWithName:@"branch" usingBlock:^(SKNode *node, BOOL *stop) {
        BranchSpriteNode *branch = (id)node;
        [self modifyEndingTextWithBranch:branch];
    }];
//    SKAction *fadeTree = [SKAction fadeOutWithDuration:10];
    treeSprite.color = [UIColor colorWithRed:0.376 green:0.319 blue:0.279 alpha:1.000];
    [treeSprite enumerateChildNodesWithName:@"leaf" usingBlock:^(SKNode *node, BOOL *stop) {
        SKSpriteNode *leaf = (id)node;
        leaf.color = [UIColor colorWithRed:0.376 green:0.319 blue:0.279 alpha:1.000];
    }];
    SKAction *waitWhilstEnding = [SKAction waitForDuration:6];
    [treeSprite runAction:[SKAction group:@[waitWhilstEnding]] completion:^{
        [self showPlayAgainWithNegativeEnding];
    }];
    [self delete];
}

-(void)animateBranchesForLosingEndingWithBranch:(BranchSpriteNode *)branch
{
    [branch enumerateChildNodesWithName:@"branch" usingBlock:^(SKNode *node, BOOL *stop)
     {
         BranchSpriteNode *childBranch = (id)node;
         if (childBranch)
         {
             [self animateBranchesForLosingEndingWithBranch:childBranch];
         }
     }];
    SKShapeNode *branchShape = (id)[branch childNodeWithName:@"branchShape"];
    [branchShape enumerateChildNodesWithName:@"charContainer" usingBlock:^(SKNode *node, BOOL *stop)
    {
        [node removeAllActions];
        SKAction *wait = [SKAction waitForDuration:(arc4random() % 10)/8];
        float range = ((arc4random() % 300) - 150);
        SKAction *moveDown = [SKAction moveTo:CGPointMake(node.position.x + range, node.position.y - 1000) duration:70];
        SKAction *remove = [SKAction performSelector:@selector(removeFromParent) onTarget:node];
        SKAction *endSequence = [SKAction sequence:@[wait, moveDown, remove]];
        [node runAction:endSequence];
        [node enumerateChildNodesWithName:@"leaf" usingBlock:^(SKNode *node, BOOL *stop) {
            LeafSpriteNode *leaf = (id)node;
            leaf.color = [UIColor colorWithRed:0.376 green:0.319 blue:0.279 alpha:1.000];
        }];
    }];
}

#pragma mark -- save

-(void)save
{
    NSURL *filePathUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSString* path = [[filePathUrl URLByAppendingPathComponent:@"archive.skscene"] path];
    [NSKeyedArchiver archiveRootObject:self toFile:path];
}

-(void)delete
{
    NSURL *filePathUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSString* path = [[filePathUrl URLByAppendingPathComponent:@"archive.skscene"] path];
    [NSKeyedArchiver archiveRootObject:nil toFile:path];
}

-(void)saveIsFirstRun
{
    NSURL *filePathUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSString* path = [[filePathUrl URLByAppendingPathComponent:@"firstRunObject.skscene"] path];
    [NSKeyedArchiver archiveRootObject:self.firstRunObject toFile:path];
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:grow forKey:@"grow"];
    [aCoder encodeObject:growIn forKey:@"growIn"];
    [aCoder encodeObject:fadeout forKey:@"fadeout"];
    NSNumber *isContentCreated = [NSNumber numberWithBool:self.isContentCreated];
    NSNumber *didSwitchBranches = [NSNumber numberWithBool:self.didSwitchBranches];
    NSNumber *endingsReached = [NSNumber numberWithInt:self.endingsReached];
    NSNumber *negativeEndingsReached = [NSNumber numberWithInt:self.negativeEndingsReached];
    NSNumber *sideForMainBranches = [NSNumber numberWithInt:self.sideForMainBranches];
    [aCoder encodeObject:sideForMainBranches forKey:@"sideForMainBranches"];
    [aCoder encodeObject:negativeEndingsReached forKey:@"negativeEndingsReached"];
    [aCoder encodeObject:endingsReached forKey:@"endingsReached"];
    [aCoder encodeObject:didSwitchBranches forKey:@"didSwitchBranches"];
    [aCoder encodeObject:isContentCreated forKey:@"isContentCreated"];
    [aCoder encodeObject:self.paths forKey:@"paths"];
    [aCoder encodeObject:self.path forKey:@"path"];
    [aCoder encodeObject:self.page forKey:@"page"];
    [aCoder encodeObject:self.markedBranch forKey:@"markedBranch"];
    [aCoder encodeObject:self.allPagesAvailable forKey:@"allPagesAvailable"];
    [aCoder encodeObject:self.previousMarkedBranch forKey:@"previousMarkedBranch"];
    [aCoder encodeObject:self.leftWallSprite forKey:@"leftWallSprite"];
    [aCoder encodeObject:self.leftWallThickSprite forKey:@"leftWallThickSprite"];
    [aCoder encodeObject:self.rightWallSprite forKey:@"rightWallSprite"];
    [aCoder encodeObject:self.rightWallThickSprite forKey:@"rightWallThickSprite"];
    [aCoder encodeObject:self.topWallSprite forKey:@"topWallSprite"];
    [aCoder encodeObject:self.bottomWallSprite forKey:@"bottomWallSprite"];
    [aCoder encodeObject:self.view.gestureRecognizers forKey:@"gestureRecognizers"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        grow = [aDecoder decodeObjectForKey:@"grow"];
        growIn = [aDecoder decodeObjectForKey:@"growIn"];
        fadeout = [aDecoder decodeObjectForKey:@"fadeout"];
        NSNumber *isContentCreated = [aDecoder decodeObjectForKey:@"isContentCreated"];
        NSNumber *didSwitchBranches = [aDecoder decodeObjectForKey:@"didSwitchBranches"];
        NSNumber *endingsReached = [aDecoder decodeObjectForKey:@"endingsReached"];
        NSNumber *negativeEndingsReached = [aDecoder decodeObjectForKey:@"negativeEndingsReached"];
        NSNumber *sideForMainBranches = [aDecoder decodeObjectForKey:@"sideForMainBranches"];
        self.sideForMainBranches = sideForMainBranches.intValue;
        self.negativeEndingsReached = negativeEndingsReached.intValue;
        self.endingsReached = endingsReached.intValue;
        self.didSwitchBranches = didSwitchBranches.boolValue;
        self.isContentCreated = isContentCreated.boolValue;
        self.paths = [aDecoder decodeObjectForKey:@"paths"];
        self.path = [aDecoder decodeObjectForKey:@"path"];
        self.page = [aDecoder decodeObjectForKey:@"page"];
        self.markedBranch = [aDecoder decodeObjectForKey:@"markedBranch"];
        self.allPagesAvailable = [aDecoder decodeObjectForKey:@"allPagesAvailable"];
        self.previousMarkedBranch = [aDecoder decodeObjectForKey:@"previousMarkedBranch"];
        self.leftWallSprite = [aDecoder decodeObjectForKey:@"leftWallSprite"];
        self.leftWallThickSprite = [aDecoder decodeObjectForKey:@"leftWallThickSprite"];
        self.rightWallSprite = [aDecoder decodeObjectForKey:@"rightWallSprite"];
        self.rightWallThickSprite = [aDecoder decodeObjectForKey:@"rightWallThickSprite"];
        self.topWallSprite = [aDecoder decodeObjectForKey:@"topWallSprite"];
        self.bottomWallSprite = [aDecoder decodeObjectForKey:@"bottomWallSprite"];
        self.view.gestureRecognizers = [aDecoder decodeObjectForKey:@"gestureRecognizers"];
    }
    return self;
}

#pragma mark -- play again sequence

-(void)showPlayAgainWithGoodEnding
{
    PlanetSpriteNode *planet = (id)[self childNodeWithName:@"planet"];
    SKAction *rotate = [SKAction rotateByAngle:M_PI/-4 duration:1];
    SKAction *scale = [SKAction scaleXTo:.6 y:.6 duration:1];
    SKAction *move = [SKAction moveByX:-100 y:-100 duration:1];
    [planet runAction:[SKAction group:@[rotate, scale, move]]];
    
    PlayAgain *playAgainSprite = [PlayAgain createPlayAgainButtonContents];
    playAgainSprite.name = @"playAgainSprite";
    playAgainSprite.position = CGPointMake(self.size.width - 180, self.view.frame.size.height - 170);
    playAgainSprite.zPosition = 98;
    [self addChild:playAgainSprite];
    
    SKSpriteNode *textContainer = [[SKSpriteNode alloc] initWithColor:[UIColor clearColor] size:CGSizeMake(600, 400)];
    textContainer.position = CGPointMake(self.size.width/2, self.view.frame.size.height + 300);
    textContainer.name = @"textContainer";
    [self addChild:textContainer];
    
    SKSpriteNode *textContainer2 = [[SKSpriteNode alloc] initWithColor:[UIColor clearColor] size:CGSizeMake(300, 300)];
    textContainer2.position = CGPointMake(self.size.width - 170, self.view.frame.size.height/2 - 150);
    textContainer2.zPosition = 1;
    [self addChild:textContainer2];
    NSString *goodEndingString = @"Success, you've reached an end. Many possibilities setout before you. Every Storyis unique as is every tree you nurture and create     through your choices.";
    NSString *plugString = @"If you enjoyed this   story, why not make   your own? write and   sumbit your story at    growtheapp.com";
    float horizontalPadding = 0;
    float verticalPadding = 0;
    for (int index = 0; index < goodEndingString.length; index++)
    {
        char character = [goodEndingString characterAtIndex:index];
        NSString *charString = [NSString stringWithFormat:@"%c", character];
        SKLabelNode *type = [SKLabelNode labelNodeWithFontNamed:@"TexGyreAdventor-Regular"];
        type.text = charString;
        type.fontColor = [UIColor whiteColor];
        type.fontSize = 30;
        type.zPosition = 99;
        type.name = @"type";
        if ((-textContainer.size.width/2 +10) + horizontalPadding >= textContainer.size.width/2)
        {
            verticalPadding += 50;
            horizontalPadding = 0;
        }
        type.position = CGPointMake((-textContainer.size.width/2 + 10) + horizontalPadding, (textContainer.size.height/2 - 30) - verticalPadding);
        //s-kern
        horizontalPadding += 22;
//        [self.typeArray addObject:type];
        [textContainer addChild:type];
    }
    float horizontalPadding2 = 0;
    float verticalPadding2 = 0;
    for (int index = 0; index < plugString.length; index++)
    {
        char character = [plugString characterAtIndex:index];
        NSString *charString = [NSString stringWithFormat:@"%c", character];
        SKLabelNode *type = [SKLabelNode labelNodeWithFontNamed:@"TexGyreAdventor-Regular"];
        type.text = charString;
        type.fontColor = [UIColor whiteColor];
        type.fontSize = 18;
        type.zPosition = 99;
        type.name = @"type";
        if ((-textContainer2.size.width/2) + horizontalPadding2 >= textContainer2.size.width/2)
        {
            verticalPadding2 += 25;
            horizontalPadding2 = 0;
        }
        type.position = CGPointMake((-textContainer2.size.width/2 + 10) + horizontalPadding2, (textContainer2.size.height/2 - 30) - verticalPadding2);
        //s-kern
        horizontalPadding2 += 14;
        //        [self.typeArray addObject:type];
        [textContainer2 addChild:type];
    }
}

-(void)showPlayAgainWithNegativeEnding
{
    PlanetSpriteNode *planet = (id)[self childNodeWithName:@"planet"];
    SKAction *rotate = [SKAction rotateByAngle:M_PI/-4 duration:1];
    SKAction *scale = [SKAction scaleXTo:.6 y:.6 duration:1];
    SKAction *move = [SKAction moveByX:-100 y:-100 duration:1];
    [planet runAction:[SKAction group:@[rotate, scale, move]]];
    
    PlayAgain *playAgainSprite = [PlayAgain createPlayAgainButtonContents];
    playAgainSprite.name = @"playAgainSprite";
    playAgainSprite.position = CGPointMake(self.size.width - 180, self.view.frame.size.height - 170);
    playAgainSprite.zPosition = 98;
    [self addChild:playAgainSprite];
    
    SKSpriteNode *textContainer = [[SKSpriteNode alloc] initWithColor:[UIColor clearColor] size:CGSizeMake(600, 400)];
    textContainer.position = CGPointMake(self.size.width/2, self.view.frame.size.height + 300);
    textContainer.name = @"textContainer";
    [self addChild:textContainer];
    
    SKSpriteNode *textContainer2 = [[SKSpriteNode alloc] initWithColor:[UIColor clearColor] size:CGSizeMake(300, 300)];
    textContainer2.position = CGPointMake(self.size.width - 170, self.view.frame.size.height/2 - 150);
    textContainer2.zPosition = 1;
    [self addChild:textContainer2];
    NSString *goodEndingString = @"Oh no, you're tree seems to have reacted poorly to this telling. Would You like to try again?";
    NSString *plugString = @"If you enjoyed this   story, why not make   your own? write and   sumbit your story at    growtheapp.com";
    float horizontalPadding = 0;
    float verticalPadding = 0;
    for (int index = 0; index < goodEndingString.length; index++)
    {
        char character = [goodEndingString characterAtIndex:index];
        NSString *charString = [NSString stringWithFormat:@"%c", character];
        SKLabelNode *type = [SKLabelNode labelNodeWithFontNamed:@"TexGyreAdventor-Regular"];
        type.text = charString;
        type.fontColor = [UIColor whiteColor];
        type.fontSize = 30;
        type.zPosition = 99;
        type.name = @"type";
        if ((-textContainer.size.width/2 +10) + horizontalPadding >= textContainer.size.width/2)
        {
            verticalPadding += 50;
            horizontalPadding = 0;
        }
        type.position = CGPointMake((-textContainer.size.width/2 + 10) + horizontalPadding, (textContainer.size.height/2 - 30) - verticalPadding);
        //s-kern
        horizontalPadding += 22;
        [textContainer addChild:type];
    }
    float horizontalPadding2 = 0;
    float verticalPadding2 = 0;
    for (int index = 0; index < plugString.length; index++)
    {
        char character = [plugString characterAtIndex:index];
        NSString *charString = [NSString stringWithFormat:@"%c", character];
        SKLabelNode *type = [SKLabelNode labelNodeWithFontNamed:@"TexGyreAdventor-Regular"];
        type.text = charString;
        type.fontColor = [UIColor whiteColor];
        type.fontSize = 18;
        type.zPosition = 99;
        type.name = @"type";
        if ((-textContainer2.size.width/2) + horizontalPadding2 >= textContainer2.size.width/2)
        {
            verticalPadding2 += 25;
            horizontalPadding2 = 0;
        }
        type.position = CGPointMake((-textContainer2.size.width/2 + 10) + horizontalPadding2, (textContainer2.size.height/2 - 30) - verticalPadding2);
        //s-kern
        horizontalPadding2 += 14;
        [textContainer2 addChild:type];
    }
}





@end
