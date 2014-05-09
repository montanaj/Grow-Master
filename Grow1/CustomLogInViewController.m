//
//  CustomLogInViewController.m
//  Grow1
//
//  Created by Claire on 4/23/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import "CustomLogInViewController.h"


@interface CustomLogInViewController ()

@end

@implementation CustomLogInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//
  [self.logInView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"InitialBackground.png"]]];
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GrayScaleLogo.png"]]];
//
//    // Set buttons appearance
//    [self.logInView.dismissButton setImage:[UIImage imageNamed:@"exit.png"] forState:UIControlStateNormal];
//    [self.logInView.dismissButton setImage:[UIImage imageNamed:@"exit_down.png"] forState:UIControlStateHighlighted];
//
//    [self.logInView.facebookButton setImage:nil forState:UIControlStateNormal];
//    [self.logInView.facebookButton setImage:nil forState:UIControlStateHighlighted];
//    [self.logInView.facebookButton setBackgroundImage:[UIImage imageNamed:@"facebook_down.png"] forState:UIControlStateHighlighted];
//    [self.logInView.facebookButton setBackgroundImage:[UIImage imageNamed:@"facebook.png"] forState:UIControlStateNormal];
//    [self.logInView.facebookButton setTitle:@"" forState:UIControlStateNormal];
//    [self.logInView.facebookButton setTitle:@"" forState:UIControlStateHighlighted];
//
//    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"signup.png"] forState:UIControlStateNormal];
//    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"signup_down.png"] forState:UIControlStateHighlighted];
//    [self.logInView.signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
//    [self.logInView.signUpButton setTitle:@"Sign Up" forState:UIControlStateHighlighted];
//
//    // Add login field background
//    UIView *fieldsBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stick.png"]];
//    [self.logInView insertSubview:fieldsBackground atIndex:1];
      
//    // Remove text shadow
    CALayer *layer = self.logInView.usernameField.layer;
    layer.shadowOpacity = 0.0;
    layer = self.logInView.passwordField.layer;
    layer.shadowOpacity = 0.0;
    [self.logInView.passwordForgottenButton setBackgroundImage:[UIImage imageNamed:@"Forgot .png"] forState:UIControlStateNormal];
    [self.logInView.passwordForgottenButton setImage:[UIImage imageNamed:@"Forgot.png"] forState:UIControlStateNormal];
    // Set field text color
    [self.logInView.usernameField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.logInView.passwordField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];

}
//
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
//
//    // Set frame for elements
//    [self.logInView.dismissButton setFrame:CGRectMake(10.0f, 10.0f, 87.5f, 45.5f)];
    [self.logInView.logo setFrame:CGRectMake(66.5f, 70.0f, 187.0f, 90.5f)];
//    [self.logInView.facebookButton setFrame:CGRectMake(35.0f, 287.0f, 120.0f, 40.0f)];
//    [self.logInView.twitterButton setFrame:CGRectMake(35.0f+130.0f, 287.0f, 120.0f, 40.0f)];
//    [self.logInView.signUpButton setFrame:CGRectMake(35.0f, 385.0f, 250.0f, 40.0f)];
//    [self.logInView.usernameField setFrame:CGRectMake(35.0f, 145.0f, 250.0f, 50.0f)];
//    [self.logInView.passwordField setFrame:CGRectMake(35.0f, 195.0f, 250.0f, 50.0f)];
//    [self.fieldsBackground setFrame:CGRectMake(35.0f, 145.0f, 250.0f, 100.0f)];
}

@end
