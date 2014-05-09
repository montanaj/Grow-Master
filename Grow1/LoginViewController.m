//
//  LoginViewController.m
//  Grow1
//
//  Created by Calvin Hildreth on 4/19/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//
#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "CustomLogInViewController.h"
#import "CustomSignUpViewController.h"

@interface LoginViewController() <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property BOOL sceneCreated;
//@property (strong, nonatomic) Page *page;
@property (strong, nonatomic) NSArray *allPagesInStory;
@property (strong, nonatomic) NSMutableArray *allAvailablePages;
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [PFUser logOut];//autologout for testing purposes
    [PFFacebookUtils initializeFacebook];
}

-(void)viewWillAppear:(BOOL)animated
{

    //PFUser *currentUser = [PFUser currentUser];

    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        CustomLogInViewController *logInViewController = [[CustomLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate

        [logInViewController setFacebookPermissions:[NSArray arrayWithObjects:@"friends_about_me",@"user_about_me", @"user_relationships", @"user_birthday", @"user_location", nil]];
        [logInViewController setFields:  PFLogInFieldsFacebook | PFLogInFieldsDismissButton | PFLogInFieldsUsernameAndPassword | PFLogInFieldsSignUpButton | PFLogInFieldsPasswordForgotten];

        // Create the sign up view controller
        CustomSignUpViewController *signUpViewController = [[CustomSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        [signUpViewController setFields:PFSignUpFieldsDefault | PFSignUpFieldsEmail];
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];

        // Present the log in view controller
        [self presentViewController:logInViewController animated:NO completion:NULL];
    }


    [super viewWillAppear:animated];

//    if (!self.sceneCreated)
//    {
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
//        //        if (savedTreeScene)
//        //        {
//        //            [spriteView presentScene:savedTreeScene];
//        //        }
//        //        else
//        //        {
//        //            [spriteView presentScene:treeScene.scene];
//        //        }
//        [spriteView presentScene:treeScene];
//
//        self.sceneCreated = YES;
//
//
//    }
//}

#pragma mark PFLOGIN View Controller Helper Methods
}

//// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }

    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}
//// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    [self dismissViewControllerAnimated:YES completion:nil];

}
// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error
{
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark CustomSignUp Helper Methods
// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;

    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }

    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }

    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil]; // Dismiss the PFSignUpViewController
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}


@end
