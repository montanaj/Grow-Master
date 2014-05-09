//
//  InitailPlayThroughScene4.m
//  Grow1
//
//  Created by Calvin Hildreth on 4/30/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import "InitailPlayThroughScene4.h"
#import "ViewController.h"
#import "TreeScene.h"

@interface  InitailPlayThroughScene4()
@property (strong, nonatomic) NSArray *introTextArray;
@property BOOL contentCreated;
@property BOOL isDisplaying;
@property int indexOfIntroText;
@property int indexOfCharacter;
@property (strong, nonatomic) NSMutableArray *typeArray;
@end
@implementation InitailPlayThroughScene4

-(void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.view addGestureRecognizer:tapGestureRecognizer];
    }
}

- (void)createSceneContents
{
    self.typeArray = [NSMutableArray new];
    self.backgroundColor = [SKColor darkGrayColor];
    self.scaleMode = SKSceneScaleModeAspectFill;
    self.indexOfIntroText = 0;
    self.indexOfCharacter = 0;
    self.introTextArray = @[@"as soon as you begin, the seed sprouts up",
                            @"suprised as you are, you have forgotten the ending. clearly,though, the story must        continue"];
    SKSpriteNode *textContainer = [[SKSpriteNode alloc] initWithColor:[UIColor colorWithRed:0.473 green:0.435 blue:0.197 alpha:0.490] size:CGSizeMake(600, 400)];
    textContainer.position = CGPointMake(self.size.width/2, self.view.frame.size.height + 300);
    textContainer.name = @"textContainer";
    SKSpriteNode *backgroundSprite = [SKSpriteNode spriteNodeWithImageNamed:@"intro4All.png"];
    backgroundSprite.zPosition = 20;
    backgroundSprite.position = CGPointMake(self.size.width/2, self.size.height/2);
    [self addChild:backgroundSprite];
    [self addChild:textContainer];
    [self placeTextInTextContainer];
}

-(void)placeTextInTextContainer
{
    SKSpriteNode *textContainer = (id)[self childNodeWithName:@"textContainer"];
    NSString *currentText = self.introTextArray[self.indexOfIntroText];
    int length = currentText.length;
    float horizontalPadding = 0;
    float verticalPadding = 0;
    for (int index = 0; index < length; index++)
    {
        char character = [currentText characterAtIndex:index];
        NSString *charString = [NSString stringWithFormat:@"%c", character];
        SKLabelNode *type = [SKLabelNode labelNodeWithFontNamed:@"TexGyreAdventor-Bold"];
        type.text = charString;
        type.fontColor = [UIColor whiteColor];
        type.fontSize = 30;
        type.alpha = 0;
        type.name = @"type";
        type.zPosition = 99;
        if ((-textContainer.size.width/2 +10) + horizontalPadding >= textContainer.size.width/2)
        {
            verticalPadding += 50;
            horizontalPadding = 0;
        }
        type.position = CGPointMake((-textContainer.size.width/2 + 10) + horizontalPadding, (textContainer.size.height/2 - 30) - verticalPadding);
        horizontalPadding += 20;
        [self.typeArray addObject:type];
        [textContainer addChild:type];
    }
    self.isDisplaying = YES;
    [self displayTextByFadeIn];
}

-(void)displayTextByFadeIn
{
    if (self.indexOfCharacter > self.typeArray.count - 1)
    {
        self.indexOfCharacter = 0;
        self.indexOfIntroText += 1;
        self.isDisplaying = NO;
    }
    else
    {
        SKLabelNode *type = self.typeArray[self.indexOfCharacter];
        self.indexOfCharacter++;
        SKAction *fadeIn = [SKAction fadeInWithDuration:.07];
        if ([type.text isEqualToString:@" "])
        {
            fadeIn = [SKAction fadeInWithDuration:0];
        }
        SKAction *displayNextChar = [SKAction performSelector:@selector(displayTextByFadeIn) onTarget:self];
        [type runAction:[SKAction sequence:@[fadeIn, displayNextChar]]];
    }
}

-(void)handleTap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    CGPoint pointTappedInView = [tapGestureRecognizer locationInView:tapGestureRecognizer.view];
    CGPoint pointTappedInSKView = [self convertPointFromView:pointTappedInView];
    SKSpriteNode *touchedNode = (id)[self nodeAtPoint:pointTappedInSKView];
    SKSpriteNode *textContainer = (id)[self childNodeWithName:@"textContainer"];
    
    if (self.isDisplaying)
    {
        self.indexOfCharacter = self.typeArray.count - 1;
        [textContainer enumerateChildNodesWithName:@"type" usingBlock:^(SKNode *node, BOOL *stop)
         {
             node.alpha = 1;
         }];
    }
    else if (self.indexOfIntroText > self.introTextArray.count - 1)
    {
        SKTransition *transition = [SKTransition fadeWithDuration:2];
        TreeScene *treeScene = [[TreeScene alloc] initWithSize:CGSizeMake(640, 1136)];
        
        UINavigationController *navController = (id)self.view.window.rootViewController;
        for (UIViewController *viewController in navController.viewControllers)
        {
            if ([viewController isKindOfClass:[ViewController class]])
            {
                ViewController *vController = (id)viewController;
                treeScene.allPagesInStory = vController.allPagesInStory;
                treeScene.allPagesAvailable = vController.allAvailablePages;
                treeScene.page = vController.page;
            }
        }
        
        [self.view presentScene:treeScene transition:transition];
    }
    else if (!self.isDisplaying)
    {
        [textContainer removeAllChildren];
        [self.typeArray removeAllObjects];
        [self placeTextInTextContainer];
    }
    
}

@end
