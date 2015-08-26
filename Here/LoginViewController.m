//
//  LoginViewController.m
//  Here!
//
//  Created by Mukul Surajiwale on 6/30/15.
//  Copyright (c) 2015 Mukul Surajiwale. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
@interface LoginViewController ()

// Outlets
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

// Actions
- (IBAction)loginButtonPressed:(UIButton *)sender;





@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.loginButton.hidden = YES;
    NSTimer* myTimer = [NSTimer scheduledTimerWithTimeInterval: 0.25 target: self selector: @selector(showLoginButton:) userInfo: nil repeats: YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showLoginButton:(NSTimer *) t {
    if ([self.passwordTextField.text length] >= 5 && [self.usernameTextField.text length] > 1) {
        self.loginButton.hidden = NO;
    } else {
        self.loginButton.hidden = YES;
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"loginToMain"]) {
        MainViewController *mainView = [segue destinationViewController];
    }
}


- (IBAction)loginButtonPressed:(UIButton *)sender {
    // Log User into the App
    if ([self.usernameTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter a username and password." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    } else {
        [PFUser logInWithUsernameInBackground:self.usernameTextField.text password:self.passwordTextField.text block:^(PFUser *user, NSError *error) {
            if (!error) {
                NSLog(@"Login Successful");
                // Login User
                [self performSegueWithIdentifier:@"loginToMain" sender:nil];
            } else {
                UIAlertView *loginAlertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Username/Password is invalid." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [loginAlertView show];
                [self.passwordTextField resignFirstResponder];
            }
        }];
        
        
    }
}
@end
