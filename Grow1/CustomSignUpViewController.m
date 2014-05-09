//
//  CustomSignUpViewController.m
//  Grow1
//
//  Created by Claire on 4/23/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import "CustomSignUpViewController.h"

@interface CustomSignUpViewController ()

@end

@implementation CustomSignUpViewController

- (void)viewDidLoad
{

    // Change the placeholder text "Additional" to "Phone number"
    //[self.signUpView.additionalField setPlaceholder:@"Phone number"];
    [self.signUpView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"InitialBackground.png"]]];
    [self.signUpView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GrayScaleLogo.png"]]];
    //
    //    // Set buttons appearance

     //   [self.signUpView.dismissButton setImage:[UIImage imageNamed:@"exit.png"] forState:UIControlStateNormal];
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
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    // Move all fields down on smaller screen sizes
    float yOffset = [UIScreen mainScreen].bounds.size.height <= 480.0f ? 30.0f : 0.0f;

    CGRect fieldFrame = self.signUpView.usernameField.frame;

    [self.signUpView.dismissButton setFrame:CGRectMake(1.0f, 10.0f, 30.5f, 45.5f)];
    [self.signUpView.logo setFrame:CGRectMake(66.5f, 70.0f, 187.0f, 90.5f)];
    [self.signUpView.signUpButton setFrame:CGRectMake(35.0f, 385.0f, 250.0f, 40.0f)];
 //   [self.fieldsBackground setFrame:CGRectMake(35.0f, fieldFrame.origin.y + yOffset, 250.0f, 174.0f)];

    [self.signUpView.usernameField setFrame:CGRectMake(fieldFrame.origin.x + 5.0f,
                                                       fieldFrame.origin.y + yOffset,
                                                       fieldFrame.size.width - 10.0f,
                                                       fieldFrame.size.height)];
    yOffset += fieldFrame.size.height;

    [self.signUpView.passwordField setFrame:CGRectMake(fieldFrame.origin.x + 5.0f,
                                                       fieldFrame.origin.y + yOffset,
                                                       fieldFrame.size.width - 10.0f,
                                                       fieldFrame.size.height)];
    yOffset += fieldFrame.size.height;

    [self.signUpView.emailField setFrame:CGRectMake(fieldFrame.origin.x + 5.0f,
                                                    fieldFrame.origin.y + yOffset,
                                                    fieldFrame.size.width - 10.0f,
                                                    fieldFrame.size.height)];
    yOffset += fieldFrame.size.height;

    [self.signUpView.additionalField setFrame:CGRectMake(fieldFrame.origin.x + 5.0f,
                                                         fieldFrame.origin.y + yOffset,
                                                         fieldFrame.size.width - 10.0f,
                                                         fieldFrame.size.height)];
}


@end
