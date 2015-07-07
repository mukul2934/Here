//
//  NotificationsViewController.m
//  Here!
//
//  Created by Mukul Surajiwale on 7/2/15.
//  Copyright (c) 2015 Mukul Surajiwale. All rights reserved.
//

#import "NotificationsViewController.h"
#import "NotificationsTableViewCell.h"
@interface NotificationsViewController ()

// Outlets
@property (strong, nonatomic) IBOutlet UITableView *tableView;


// Properties
@property (strong, nonatomic) NSMutableArray *notifications;

@end

@implementation NotificationsViewController

-(NSMutableArray *)notifications{
    if (!_notifications) {
        _notifications = [[NSMutableArray alloc]init];
    }
    return _notifications;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {

    // Populate the notifications array
    PFQuery *notifQuery = [PFQuery queryWithClassName:@"LocationLinks"];
    [notifQuery whereKey:@"Receiver" equalTo:[PFUser currentUser]];
    [notifQuery includeKey:@"Sender"];
    [notifQuery orderByDescending:@"createdAt"];
    [notifQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] > 0) {
            for (PFObject *obj in objects) {
                [self.notifications addObject:obj];
            }
            [self.tableView reloadData];
        } else {
            NSLog(@"Failed to find any notifications");
        }
    }];
    
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.notifications count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NotificationsTableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    customCell.messageLabel.text = self.notifications[indexPath.row][@"Message"];
    
    PFFile *imageFile = self.notifications[indexPath.row][@"Sender"][@"ProfileImage"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            customCell.profileImageView.layer.masksToBounds = YES;
            customCell.profileImageView.layer.cornerRadius = 25;
            customCell.profileImageView.image = [UIImage imageWithData:data];
        } else {
            NSLog(@"Failed to retrive profile image: NotificationsViewController");
        }
    }];
    
    PFGeoPoint *geoPoint = self.notifications[indexPath.row][@"Location"];
    NSLog(@"%f, %f", geoPoint.latitude, geoPoint.longitude);
    customCell.geoPoint = geoPoint;
    [customCell reloadCell];
    
    return customCell;
}



@end
