//
//  StartScene.m
//  Grow1
//
//  Created by Calvin Hildreth on 4/19/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import "StartScene.h"
#import "BackgroundStarsSprite.h"
#import "PlanetSprite.h"
#import "GrowTextSprite.h"
#import "StartButton.h"
#import "ViewController.h"
#import "TreeScene.h"
#import "InitailPlayThroughScnen1.h"
#import "FirstRunObject.h"
#import "Choice.h"

@interface  StartScene()
@property BOOL contentCreated;
@property BOOL isTapped;
@end

@implementation StartScene

-(void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
        [self loadStory];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.view addGestureRecognizer:tapGestureRecognizer];
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

- (void)createSceneContents
{
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFill;
    
    PlanetSprite *planetSprite = [self createPlanetSprite];
    planetSprite.name = @"planetSprite";
    [self addChild:planetSprite];
    GrowTextSprite *growTextSprite = [self createGrowTextSprite];
    [self addChild:growTextSprite];
    BackgroundStarsSprite *backgroundStars = [self createBackgroundStars];
    backgroundStars.position = CGPointMake(0, 0);
    [self addChild:backgroundStars];
    
    SKAction *moveStars = [SKAction moveToY:0 duration:0];
    [backgroundStars runAction:moveStars completion:^{
        SKAction *moveAway = [SKAction moveToY:-1136 duration:60];
        [backgroundStars runAction:moveAway];
        [self moveStars];
    }];
    SKAction *rotate = [SKAction rotateByAngle:M_PI duration:20];
    [planetSprite runAction:[SKAction repeatActionForever:rotate]];

    StartButton *startButton = [self createStartButton];
    startButton.name = @"startButton";
    [self addChild:startButton];
}
#pragma mark SPRITE CREATOR HELPER METHODS

-(StartButton *)createStartButton
{
    StartButton *startButton = [StartButton node];
    startButton = [startButton createStartButtonSceneContents];
    return startButton;
}

-(BackgroundStarsSprite *)createBackgroundStars
{
    BackgroundStarsSprite *backgroundStars = [BackgroundStarsSprite node];
    backgroundStars = [backgroundStars createBackgroundStars];
    return backgroundStars;
}


-(GrowTextSprite *)createGrowTextSprite
{
    GrowTextSprite *growTextSprite = [GrowTextSprite node];
    growTextSprite = [growTextSprite createGrowTextSpriteContents];
    return growTextSprite;
}

-(PlanetSprite *)createPlanetSprite
{
    PlanetSprite *planetSprite = [PlanetSprite node];
    planetSprite = [planetSprite createPlanetSpriteContents];
    return planetSprite;
}

-(void)moveStars
{
    BackgroundStarsSprite *newStars = [self createBackgroundStars];
    newStars.position = CGPointMake(0, 1136);
    SKAction *moveStars = [SKAction moveToY:0 duration:60];
    [self addChild:newStars];
    SKAction *moveAway = [SKAction moveTo:CGPointMake(0, -1136) duration:60];
    SKAction *moveStarsForever = [SKAction performSelector:@selector(moveStars) onTarget:self];
    SKAction *moveForeverGroup = [SKAction group:@[moveAway, moveStarsForever]];
    [newStars runAction:[SKAction sequence:@[moveStars, moveForeverGroup]]];
}
//create an action that performs a selector
//this gets called instantaneously, loading from a sequence of actions 
#pragma mark PLANET SCALING

-(void)scaleIn
{
    PlanetSprite *planetSprite = (id)[self childNodeWithName:@"planetSprite"];
    SKAction *scaleIn = [SKAction scaleBy:1.25 duration:.5];
    [planetSprite runAction:scaleIn];
}

-(void)scaleOut
{
    PlanetSprite *planetSprite = (id)[self childNodeWithName:@"planetSprite"];
    SKAction *scaleOut = [SKAction scaleBy:.80 duration:.5];
    [planetSprite runAction:scaleOut];
}

#pragma mark START BUTTON SCALING ON TAP

-(void)startButtonScaleinOnTap
{
    StartButton *startButton = (id)[self childNodeWithName:@"startButton"];
    SKAction *scaleIn = [SKAction scaleBy:1.25 duration:.5];
    [startButton runAction:[SKAction sequence:@[scaleIn]] completion:^{
        SKTransition *transition = [SKTransition fadeWithDuration:2];

        FirstRunObject *firstRunObject = [self loadIsFirstRun];
        if (firstRunObject.isFirstRun)
        {
            TreeScene *savedTreeScene = [self load];
            TreeScene *treeScene = [[TreeScene alloc] initWithSize:CGSizeMake(640, 1136)];
            treeScene.allPagesInStory = self.allPagesInStory;
            treeScene.allPagesAvailable = self.allAvailablePages;
            treeScene.page = self.page;
            if (savedTreeScene)
            {
                savedTreeScene.savedVersion = YES;
                [self.view presentScene:savedTreeScene transition:transition];
            }
            else
            {
                [self.view presentScene:treeScene transition:transition];
            }
        }
        else
        {
            InitailPlayThroughScnen1 *scene1 = [[InitailPlayThroughScnen1 alloc] initWithSize:CGSizeMake(640, 1136)];
            [self.view presentScene:scene1 transition:transition];
        }
    }];
}

#pragma mark TAP GESTURE

-(void)handleTap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    CGPoint pointTappedInView = [tapGestureRecognizer locationInView:tapGestureRecognizer.view];
    CGPoint pointTappedInSKView = [self convertPointFromView:pointTappedInView];
    SKSpriteNode *touchedNode = (id)[self nodeAtPoint:pointTappedInSKView];


    if ([touchedNode isKindOfClass:[StartButton class]])
    {
        [self startButtonScaleinOnTap];
    }
    else
    {
        if (!self.isTapped)
        {
            [self scaleIn];
            NSLog(@"why am I scaling in?");

            self.isTapped = YES;
        }
        else
        {
            [self scaleOut];
            self.isTapped = NO;
        }
    }
}

-(id)load
{
    NSURL *filePathUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSString* path = [[filePathUrl URLByAppendingPathComponent:@"archive.skscene"] path];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

-(id)loadIsFirstRun
{
    NSURL *filePathUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSString* path = [[filePathUrl URLByAppendingPathComponent:@"firstRunObject.skscene"] path];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

#pragma mark -- Story Helper Methods

-(void)loadStory
{
    if (!self.page)
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"document" ofType:@"json"];
        NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error: NULL];
        NSDictionary *jsonDataPage = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        self.allPagesInStory = [jsonDataPage objectForKey:@"allPagesInStory"];
        self.allAvailablePages = [NSMutableArray new];
        int indexForPage = 0;
        for (NSDictionary *pageData in self.allPagesInStory)
        {
            Page *page = [Page new];
            page.choices = [NSMutableArray new];
            page.pageText = pageData[@"page_text"];
            page.indexOfPage = indexForPage;
            for (NSDictionary *choicesData in pageData[@"choices"])
            {
                Choice *choice = [Choice new];
                choice.buttonText = choicesData[@"buttontext"];
                choice.indexToNextPage = [choicesData[@"indexToNextPage"] intValue];
                if (choicesData[@"isGoodEnding"])
                {
                    page.isGoodEnding = [choicesData[@"isGoodEnding"] boolValue];
                }
                [page.choices addObject:choice];
            }
            [self.allAvailablePages addObject:page];
            indexForPage++;
        }
        self.page = self.allAvailablePages[0];
    }
}
@end
