//
//  LoginVC.m
//  parsechat
//
//  Created by German Flores on 7/6/20.
//  Copyright © 2020 German Flores. All rights reserved.
//

#import "LoginVC.h"
#import <Parse/Parse.h>

@interface LoginVC ()

// MARK: Outlets
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

// MARK: Properties

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

// MARK: Actions
- (IBAction)onLogin:(id)sender {
    if (![self usernameAndPasswordEmpty]) {
        // text fields not empty
        NSString *username = self.usernameTextField.text;
        NSString *password = self.passwordTextField.text;
        
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
            if (error != nil) {
                NSLog(@"User log in failed: %@", error.localizedDescription);
                [self displayLoginError:error];
            } else {
                NSLog(@"User logged in successfully");
                
                // display view controller that needs to shown after successful login
                [self performSegueWithIdentifier:@"loginSegue" sender:nil];
            }
        }];
    }
}

- (IBAction)onSignUp:(id)sender {
    if (![self usernameAndPasswordEmpty]) {
        // text fields not empty
        // initialize a parse user object
        PFUser *newUser = [PFUser user];
        
        // set user properties
        newUser.username = self.usernameTextField.text;
        newUser.password = self.passwordTextField.text;
        
        // call sign up fn on object
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"Error signing up: %@", error.localizedDescription);
                [self displaySignUpError:error];
            } else {
                NSLog(@"User registered successfully!");
                
                // manually segue to logged in view
                [self performSegueWithIdentifier:@"loginSegue" sender:nil];
            }
        }];
    }
}

// MARK: Helpers

- (BOOL)usernameAndPasswordEmpty {
    // check text field inputs
    if (self.usernameTextField.hasText || self.passwordTextField.hasText) {
        return NO;
    } else {
        [self displayEmptyError];
        return YES;
    }
}

// Text fields are empty alert controller
- (void)displayEmptyError {
    NSString *title = @"Error";
    NSString *message = @"Username or Password fields cannot be empty!";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle: UIAlertControllerStyleAlert];
    
    // create OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // handle response here
    }];
    
    // add the OK action to alert controller
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

// Login error alert controller
- (void)displayLoginError:(NSError *)error {
    NSString *title = @"Login Error";
    NSString *message = error.localizedDescription;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // create OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // handle response here
    }];
    
    // add the OK action to alert controller
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

// Sign up error alert controller
- (void)displaySignUpError:(NSError *)error {
    NSString *title = @"Signup Error";
    NSString *message = error.localizedDescription;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // create OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // handle response here
    }];
    
    // add the OK action to alert controller
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
