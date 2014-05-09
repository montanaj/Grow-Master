//
//  SignUpViewController.m
//  Grow1
//
//  Created by Calvin Hildreth on 4/19/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//
#import "SignUpViewController.h"
#import <Parse/Parse.h>

@interface SignUpViewController ()

@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;

@end

@implementation SignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)onSignUpButtonPressed:(id)sender
{
    [self createNewUser];
}

- (IBAction)onCancelButtonPressed:(id)sender
{
    
}

- (IBAction)onEndEditingButtonPressed:(id)sender
{
    [self.usernameTextField endEditing:YES];
    [self.passwordTextField endEditing:YES];
    [self.emailTextField endEditing:YES];
}

- (void)createNewUser
{
    PFUser *user = [PFUser user];
    user.username = self.usernameTextField.text;
    user.password = self.passwordTextField.text;
    user.email = self.emailTextField.text;
    
    [user signUpInBackgroundWithTarget:self selector:@selector(handleSignUp:error:)];
}

- (void)handleSignUp:(NSNumber *)result error:(NSError *)error
{
    if (!error)
    {
        [PFUser logInWithUsernameInBackground:self.usernameTextField.text password:self.passwordTextField.text block:^(PFUser *user, NSError *error)
         {
             if (user)
             {
                 [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                 [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
             }
             else
             {
                 UIAlertView *logInFailAlert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                                                                          message:@"Username or Password is Incorrect"
                                                                         delegate:self
                                                                cancelButtonTitle:@"Ok"
                                                                otherButtonTitles:nil];
                 [logInFailAlert show];
             }
         }];    }
    else
    {
        UIAlertView *signUpErrorAlert = [[UIAlertView alloc] initWithTitle:@"Sign In Failed"
                                                                   message:[NSString stringWithFormat:@"%@",[error userInfo][@"error"]]
                                                                  delegate:nil
                                                         cancelButtonTitle:@"Ok"
                                                         otherButtonTitles:nil];
        [signUpErrorAlert show];
    }
}


@end
