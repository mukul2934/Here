//
//  SignUpViewController.m
//  Here!
//
//  Created by Mukul Surajiwale on 6/30/15.
//  Copyright (c) 2015 Mukul Surajiwale. All rights reserved.
//

#import "SignUpViewController.h"
#import "MainViewController.h"
@interface SignUpViewController ()

// Outlets
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;


// Actions
- (IBAction)loginButtonPressed:(UIButton *)sender;
- (IBAction)selectProfilePictureButtonPressed:(UIButton *)sender;

@end

@implementation SignUpViewController

- (void)showLoginButton:(NSTimer *) t {
    if ([self.passwordTextField.text length] >= 5 && [self.usernameTextField.text length] > 1) {
        self.loginButton.hidden = NO;
    } else {
        self.loginButton.hidden = YES;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginButton.hidden = YES;
    NSTimer* myTimer = [NSTimer scheduledTimerWithTimeInterval: 0.25 target: self selector: @selector(showLoginButton:) userInfo: nil repeats: YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"signupToMain"]) {
        MainViewController *mainView = [segue destinationViewController];
    }
}


- (IBAction)loginButtonPressed:(UIButton *)sender {
    PFUser *user = [PFUser user];
    user.username = self.usernameTextField.text;
    user.password = self.passwordTextField.text;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Link profile image with user
            NSData *imageDate = UIImagePNGRepresentation(self.profileImageView.image);
            PFFile *imageFile = [PFFile fileWithData:imageDate];
            
            [user setObject:imageFile forKey:@"ProfileImage"];
            [user saveInBackground];
            [self performSegueWithIdentifier:@"signupToMain" sender:nil];

//            PFObject *userProfile = [PFObject objectWithClassName:@"User_ProfileImage"];
//            [userProfile setObject:[PFUser currentUser] forKey:@"User"];
//            [userProfile setObject:imageFile forKey:@"ProfileImage"];
//            
//            [userProfile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                if (!error) {
//                    [self performSegueWithIdentifier:@"signupToMain" sender:nil];
//                } else {
//                    NSLog(@"%@", error);
//                }
//            }];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (IBAction)selectProfilePictureButtonPressed:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

// UIIMagePickerController Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.profileImageView.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}@end
