//
//  PageViewController.m
//  Grow1
//
//  Created by Calvin Hildreth on 4/19/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//
#import <Parse/Parse.h>
#import "PageViewController.h"
#import "TreeViewController.h"
#import "Choice.h"

@interface PageViewController ()<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *myButtonView;
@property (strong, nonatomic) NSDictionary *jsondataPage;
@property (strong, nonatomic) IBOutlet UITextView *myTextView;
@property (strong, nonatomic) NSArray *currentChoices;
@property BOOL buttonsShowing;
@end



@implementation PageViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.currentChoices = [NSArray new];
    [self loadCurrentPage];
    self.myTextView.delegate = self;
    self.myTextView.layer.cornerRadius = 3;
    self.myButtonView.hidden = YES;
    [self.myTextView setFont:[UIFont fontWithName:@"TexGyreAdventor-Regular" size:18]];
    
    UISwipeGestureRecognizer *swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                                      action:@selector(handleSwipe:)];
    swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.myTextView addGestureRecognizer:swipeRightGestureRecognizer];
    for (UIView* aView in _myTextView.subviews)
    {
        if ([@"_UITextContainerView" isEqualToString:NSStringFromClass([aView class])])
        {
            if (aView.frame.size.height < self.view.frame.size.height)
            {
                UISwipeGestureRecognizer *swipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                                               action:@selector(handleSwipe:)];
                swipeUpGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
                UISwipeGestureRecognizer *swipeDownGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                                                 action:@selector(handleSwipe:)];
                swipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
                [self.myTextView addGestureRecognizer:swipeUpGestureRecognizer];
                [self.myTextView addGestureRecognizer:swipeDownGestureRecognizer];
            }
            break;
        }
    }
}



-(void)scrollViewDidScroll: (UIScrollView*)scrollView
{
    float scrollViewHeight = scrollView.frame.size.height;
    float scrollContentSizeHeight = scrollView.contentSize.height;
    float scrollOffset = scrollView.contentOffset.y;

    if (scrollOffset + scrollViewHeight == scrollContentSizeHeight)
    {
        [self createButtons];
        self.myButtonView.frame = CGRectMake(0, self.view.frame.size.height + 100, self.view.frame.size.width, 100);
        self.myButtonView.hidden = NO;
        [self showButtons];

    }
    else if (scrollOffset + scrollViewHeight > scrollContentSizeHeight -20 && self.buttonsShowing)
    {
        [self hideButtons];
    }
}

-(void)loadCurrentPage
{
    if (!self.page)
    {
        NSLog(@"the unspeakable has ooccuurreedd");
    }
    self.myTextView.text = self.page.pageText;
    self.myTextView.textColor = [UIColor whiteColor];
    self.currentChoices = self.page.choices;
}

- (IBAction)EitherButtonTappedPopulateNextPage:(UIButton*)button
{
    
    self.page = self.allAvailablePages[button.tag];
    [UIView animateWithDuration:1 animations:^{
        self.myTextView.frame = CGRectMake(20, 0, self.myTextView.frame.size.width, self.myTextView.frame.size.height);
        self.myButtonView.frame = CGRectMake(0, self.view.frame.size.height + 100, self.view.frame.size.width, 100);
    }
    completion:^(BOOL finished)
    {
        self.buttonsShowing = NO;
        [self performSegueWithIdentifier:@"UnwindToTree" sender:self];
    }];

}

-(void)handleSwipe:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (self.buttonsShowing)
    {
        [self hideButtons];
    }
    else
    {
        [self createButtons];
        self.myButtonView.frame = CGRectMake(0, self.view.frame.size.height + 100, self.view.frame.size.width, 100);
        self.myButtonView.hidden = NO;
        [self showButtons];
    }
}

-(void)createButtons
{
    float padding = 20;
    float buttonWidth = ((self.view.frame.size.width - 40 - (self.currentChoices.count * 2))/self.currentChoices.count);
    for (int index = 0; index < self.currentChoices.count; index++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(padding, -20, buttonWidth, 80);
        [button setTitle:[self.currentChoices[index] buttonText] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
        button.titleLabel.numberOfLines = 0;
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.layer.cornerRadius = 3;
        button.titleLabel.font = [UIFont fontWithName:@"TexGyreAdventor-Regular" size:9];
        button.tag = [self.currentChoices[index] indexToNextPage];
        button.backgroundColor = [UIColor colorWithRed:138/255.0f green:206/255.0f blue:86/255.0f alpha:0.4f];
        [button addTarget:self action:@selector(EitherButtonTappedPopulateNextPage:) forControlEvents:UIControlEventTouchUpInside];
        [self.myButtonView addSubview:button];
        padding += button.frame.size.width + 2;
    }
}

-(void)showButtons
{
    [UIView animateWithDuration:1 animations:^{
        self.myTextView.center = CGPointMake(self.view.center.x, self.view.center.y - 100);
        self.myButtonView.frame = CGRectMake(0, self.view.frame.size.height - 80, self.view.frame.size.width, 100);

    }
    completion:^(BOOL finished)
    {
        self.buttonsShowing = YES;
    }];
}

-(void)hideButtons
{
    [UIView animateWithDuration:1 animations:^{
        self.myTextView.frame = CGRectMake(20, 20, self.myTextView.frame.size.width, self.view.frame.size.height);
        self.myButtonView.frame = CGRectMake(0, self.view.frame.size.height + 100, self.view.frame.size.width, 100);
    }
                     completion:^(BOOL finished)
     {
         self.buttonsShowing = NO;
     }];
}
@end
