//
//  TreeViewController.m
//  Grow1
//
//  Created by Calvin Hildreth on 4/20/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//
#import <Parse/Parse.h>
#import <SpriteKit/SpriteKit.h>
#import "TreeViewController.h"
#import "TreeScene.h"
#import "PageViewController.h"
#import "Page.h"
#import "Choice.h"
#import "NegativeEndingViewController.h"
#import "PositiveEndingViewController.h"

@interface TreeViewController ()

@property BOOL sceneCreated;
@property (strong, nonatomic) Page *page;
@property (strong, nonatomic) NSArray *allPagesInStory;
@property (strong, nonatomic) NSMutableArray *allAvailablePages;
@end

@implementation TreeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    if (!self.sceneCreated)
    {
//        [self loadStory];
//        SKView *spriteView = (id)self.view;
//        spriteView.showsDrawCount = YES;
//        spriteView.showsFPS = YES;
//        spriteView.showsNodeCount = YES;
//        TreeScene *savedTreeScene = [self load];
//        TreeScene *treeScene = [[TreeScene alloc] initWithSize:CGSizeMake(640, 1136)];
//        treeScene.allPagesInStory = self.allPagesInStory;
//        treeScene.allPagesAvailable = self.allAvailablePages;
//        treeScene.page = self.page;
//        if (savedTreeScene)
//        {
//            savedTreeScene.savedVersion = YES;
//            [spriteView presentScene:savedTreeScene];
//        }
//        else
//        {
//            [spriteView presentScene:treeScene.scene];
//        }
//        [spriteView presentScene:treeScene];

        self.sceneCreated = YES;
        

    }
}

//#pragma mark -- Story Helper Methods
//
//-(void)loadStory
//{
//    if (!self.page)
//    {
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"plotLine" ofType:@"json"];
//        NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error: NULL];
//        NSDictionary *jsonDataPage = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
//        self.allPagesInStory = [jsonDataPage objectForKey:@"allPagesInStory"];
//        self.allAvailablePages = [NSMutableArray new];
//        int indexForPage = 0;
//        for (NSDictionary *pageData in self.allPagesInStory)
//        {
//            Page *page = [Page new];
//            page.choices = [NSMutableArray new];
//            page.pageText = pageData[@"page_text"];
//            page.indexOfPage = indexForPage;
//            for (NSDictionary *choicesData in pageData[@"choices"])
//            {
//                Choice *choice = [Choice new];
//                choice.buttonText = choicesData[@"buttontext"];
//                choice.indexToNextPage = [choicesData[@"indexToNextPage"] intValue];
//                if (choicesData[@"isGoodEnding"])
//                {
//                    page.isGoodEnding = [choicesData[@"isGoodEnding"] boolValue];
//                }
//                [page.choices addObject:choice];
//            }
//            [self.allAvailablePages addObject:page];
//            indexForPage++;
//        }
//        self.page = self.allAvailablePages[0];
//    }
//}
//
//#pragma mark -- Segue Methods
//
//-(IBAction)unwindToTree:(UIStoryboardSegue *)sender
//{
//    PageViewController *source = (id)sender.sourceViewController;
//    self.page = source.page;
//    self.allAvailablePages = source.allAvailablePages;
//    SKView *spriteView = (id)self.view;
//    TreeScene *treeScene = (id)spriteView.scene;
//    treeScene.allPagesAvailable = self.allAvailablePages;
//    treeScene.page = self.page;
//    [treeScene sceneCheck];
//}
//
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([segue.identifier isEqualToString:@"ShowStorySegue"])
//    {
//        SKView *spriteView = (id)self.view;
//        TreeScene *treeScene = (id)spriteView.scene;
//        self.page = treeScene.page;
//        self.allAvailablePages = treeScene.allPagesAvailable;
//        PageViewController *destination = (id)segue.destinationViewController;
//        destination.page = self.page;
//        destination.allAvailablePages = self.allAvailablePages;
//    }
//}

- (IBAction)unwindtoTreeView:(UIStoryboardSegue *)unwindSegue
{
    TreeViewController *source = unwindSegue.sourceViewController;

    if ([source isKindOfClass:[NegativeEndingViewController class]])
    {
        NSLog(@"Negatively coming back to you!");
    }
    if ([source isKindOfClass:[PositiveEndingViewController class]]) {
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"Positively coming back to you");
    }

    else
    {
        
    }
    // [self performSegueWithIdentifier:@"UnwindToRedSegueID" sender:self];
    
}

//-(id)load
//{
//    NSURL *filePathUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
//    NSString* path = [[filePathUrl URLByAppendingPathComponent:@"archive.skscene"] path];
//    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
//}
@end
