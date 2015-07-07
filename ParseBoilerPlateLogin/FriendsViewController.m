//
//  FriendsViewController.m
//  Here!
//
//  Created by Mukul Surajiwale on 7/1/15.
//  Copyright (c) 2015 Mukul Surajiwale. All rights reserved.
//

#import "FriendsViewController.h"
#import "CustomTableViewCell.h"

@interface FriendsViewController ()

// Outlets
@property (strong, nonatomic) IBOutlet UITableView *tableView;

// Properties
@property (strong, nonatomic) NSMutableArray *friends;
@property (strong, nonatomic) UITextField *friendsTextField;

- (IBAction)addFriendButtonPressed:(UIButton *)sender;

@end

@implementation FriendsViewController

-(NSMutableArray *)friends{
    if (!_friends) {
        _friends = [[NSMutableArray alloc]init];
    }
    return _friends;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewDidAppear:(BOOL)animated {
    PFQuery *friendsQuery = [PFQuery queryWithClassName:@"Friends"];
    [friendsQuery whereKey:@"User" equalTo:[PFUser currentUser]];
    [friendsQuery findObjectsInBackgroundWithBlock:^(NSArray *friends, NSError *error) {
        if ([friends count] > 0) {
            [self.friends removeAllObjects];
            for (PFObject *obj in friends) {
                PFObject *friendObj = obj[@"Friend"];
                PFQuery *query = [PFQuery queryWithClassName:@"_User"];
                [query orderByDescending:@"createdAt"];
                [self.friends addObject:[query getObjectWithId:friendObj.objectId]];
            }
            [self.tableView reloadData];
        } else {
            NSLog(@"No friends found");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (IBAction)addFriendButtonPressed:(UIButton *)sender {
    UIAlertView *addFriendAlert = [[UIAlertView alloc] initWithTitle:@"Add Friend" message:@"Enter in friends username." delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
    addFriendAlert.alertViewStyle=UIAlertViewStylePlainTextInput;
    self.friendsTextField = [addFriendAlert textFieldAtIndex:0];
    [addFriendAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *username = [[alertView textFieldAtIndex:0] text];
    
    PFQuery *friendQuery = [PFQuery queryWithClassName:@"_User"];
    [friendQuery whereKey:@"username" equalTo:username];
    [friendQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            PFObject *friend = object;
            PFObject *friendLink = [PFObject objectWithClassName:@"Friends"];
            [friendLink setObject:[PFUser currentUser] forKey:@"User"];
            [friendLink setObject:friend forKey:@"Friend"];
            [friendLink saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Friend Added!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [successAlert show];
                    
                } else {
                    NSLog(@"Failed to add friend");
                }
            }];
        } else {
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"User does not exist." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [errorAlert show];
        }
    }];
    [self.tableView reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSLog(@"%@", self.friends);
    return [self.friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomTableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    customCell.username.text = self.friends[indexPath.row][@"username"];
    PFFile *imageFile = self.friends[indexPath.row][@"ProfileImage"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            customCell.profileImageView.image = [UIImage imageWithData:data];
            customCell.profileImageView.layer.masksToBounds = YES;
            customCell.profileImageView.layer.cornerRadius = 50;
        } else {
            NSLog(@"Failed to retrieve profile image data");
        }
    }];
    
    return customCell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
