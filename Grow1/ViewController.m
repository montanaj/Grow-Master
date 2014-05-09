//
//  ViewController.m
//  Grow1
//
//  Created by Calvin Hildreth on 4/18/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//
#import <SpriteKit/SpriteKit.h>
#import "ViewController.h"
#import "StartScene.h"
#import <Parse/Parse.h>
#import "TreeScene.h"
#import "PageViewController.h"
#import "Choice.h"
#import "NegativeEndingViewController.h"
#import "PositiveEndingViewController.h"

@interface ViewController ()
@property BOOL sceneCreated;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.sceneCreated)
    {
        self.sceneCreated = YES;
        [self loadStory];
        [self.navigationController.navigationBar setHidden:YES];
        SKView *spriteView = (SKView *)self.view;
        StartScene *startScene = [[StartScene alloc] initWithSize:CGSizeMake(640, 1136)];
        [spriteView presentScene:startScene];
    }
}

#pragma mark -- Segue Methods

-(IBAction)unwindToTree:(UIStoryboardSegue *)sender
{
    PageViewController *source = (id)sender.sourceViewController;
    self.page = source.page;
    self.allAvailablePages = source.allAvailablePages;
    SKView *spriteView = (id)self.view;
    TreeScene *treeScene = (id)spriteView.scene;
    treeScene.allPagesAvailable = self.allAvailablePages;
    treeScene.page = self.page;
    [treeScene sceneCheck];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowStorySegue"])
    {
        SKView *spriteView = (id)self.view;
        TreeScene *treeScene = (id)spriteView.scene;
        self.page = treeScene.page;
        self.allAvailablePages = treeScene.allPagesAvailable;
        PageViewController *destination = (id)segue.destinationViewController;
        destination.page = self.page;
        destination.allAvailablePages = self.allAvailablePages;
    }
}

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
//Notes:
//this is to find the actual names of any custom font
//    for (NSString* family in [UIFont familyNames])
//    {
//        NSLog(@"%@", family);
//        for (NSString *name in [UIFont fontNamesForFamilyName: family]) {
//            NSLog(@" %@", name);
//        }
//    }


@end
