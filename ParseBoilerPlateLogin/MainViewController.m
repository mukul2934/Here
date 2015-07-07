//
//  MainViewController.m
//  Here!
//
//  Created by Mukul Surajiwale on 7/1/15.
//  Copyright (c) 2015 Mukul Surajiwale. All rights reserved.
//

#import "MainViewController.h"
#import "CustomCollectionViewCell.h"
#import <AudioToolbox/AudioServices.h>

@interface MainViewController ()

// Outlets
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIVisualEffectView *mainView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UITextField *messageTextField;

// Actions
- (IBAction)refreshButtonPressed:(UIButton *)sender;
- (IBAction)hereButtonPressed:(UIButton *)sender;
- (IBAction)sendLocationSwipeRecognized:(UISwipeGestureRecognizer *)sender;


// Properties
@property (strong, nonatomic) MKPointAnnotation *mePoint;
@property (strong, nonatomic) NSMutableArray *friends;
@property (nonatomic) int count;
@property (strong, nonatomic) NSMutableArray *sendLocationTo;
@property (strong, nonatomic) PFGeoPoint *currentLocation;
@property (nonatomic) int successCount;

@end

@implementation MainViewController

-(NSMutableArray *)friends{
    if (!_friends) {
        _friends = [[NSMutableArray alloc]init];
    }
    return _friends;
}

-(NSMutableArray *)sendLocationTo{
    if (!_sendLocationTo) {
        _sendLocationTo = [[NSMutableArray alloc]init];
    }
    return _sendLocationTo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView setAllowsMultipleSelection:YES];
    self.mainView.hidden = YES;
    self.messageTextField.delegate = self;
    self.count = 1;
    self.successCount = 0;
    
    // Get current location
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            // do something with the new geoPoint
            NSLog(@"User is currently at %f, %f", geoPoint.latitude, geoPoint.longitude);
            self.currentLocation = geoPoint;
            [[PFUser currentUser] setObject:geoPoint forKey:@"currentLocation"];
            [[PFUser currentUser] saveInBackground];
            [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude),MKCoordinateSpanMake(0.01, 0.01))];
            self.mePoint = [[MKPointAnnotation alloc] init];
            self.mePoint.title = [PFUser currentUser][@"username"];
            self.mePoint.coordinate = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
            [self.mapView addAnnotation:self.mePoint];
        } else {
            NSLog(@"Failed to get location");
        }
    }];
    
    // Populate Friends array
    PFQuery *query = [PFQuery queryWithClassName:@"Friends"];
    [query whereKey:@"User" equalTo:[PFUser currentUser]];
    [query includeKey:@"Friend"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *obj in objects) {
                PFObject *friend = obj[@"Friend"];
                [self.friends addObject:friend];
            }
            [self.collectionView reloadData];
        } else {
            NSLog(@"Failed to find friends");
        }
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)refreshButtonPressed:(UIButton *)sender {
    [self.mapView removeAnnotation:self.mePoint];
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            // do something with the new geoPoint
            NSLog(@"User is currently at %f, %f", geoPoint.latitude, geoPoint.longitude);
            self.currentLocation = geoPoint;
            [[PFUser currentUser] setObject:geoPoint forKey:@"currentLocation"];
            [[PFUser currentUser] saveInBackground];
            [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude),MKCoordinateSpanMake(0.01, 0.01))];
            self.mePoint.title = [PFUser currentUser][@"username"];
            self.mePoint.coordinate = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
            [self.mapView addAnnotation:self.mePoint];
        } else {
            NSLog(@"Failed to get location");
        }
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)hereButtonPressed:(UIButton *)sender {
    if ((self.count)  % 2 == 1) {
        self.mainView.hidden = NO;
        self.count++;
    } else {
        self.mainView.hidden = YES;
        self.count++;
    }
}

- (IBAction)sendLocationSwipeRecognized:(UISwipeGestureRecognizer *)sender {
    [self.messageTextField resignFirstResponder];
    NSString *message = self.messageTextField.text;
    for (PFUser *user in self.sendLocationTo) {
        PFObject *senderRecieverLink = [PFObject objectWithClassName:@"LocationLinks"];
        [senderRecieverLink setObject:[PFUser currentUser] forKey:@"Sender"];
        [senderRecieverLink setObject:user forKey:@"Receiver"];
        [senderRecieverLink setObject:self.currentLocation forKey:@"Location"];
        [senderRecieverLink setObject:message forKey:@"Message"];
        
        [senderRecieverLink saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
            if (!error) {
                NSLog(@"%@ --> %@, loc: %@, Msg: %@", [PFUser currentUser][@"username"], user[@"username"], self.currentLocation, message);
                self.successCount++;
                if (self.successCount == [self.sendLocationTo count]) {
                    self.successCount = 0;
                    self.messageTextField.text = nil;
                    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
                    // TO-DO: Unhide blurImageView on all cells.
                    
                    UIAlertView *sucessAlert = [[UIAlertView alloc] initWithTitle:@"Sucess!" message:@"Location sent :)" delegate:nil cancelButtonTitle:@"Sweet" otherButtonTitles:nil];
                    [sucessAlert show];
                }
            } else {
                NSLog(@"Failed to send location");
            }
        }];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.friends count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CustomCollectionViewCell *customCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    customCell.blurImageView.hidden = YES;
    customCell.blurImageView.layer.masksToBounds = YES;
    customCell.blurImageView.layer.cornerRadius = 52.5;
    PFFile *imageData = self.friends[indexPath.row][@"ProfileImage"];
    [imageData getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            customCell.customImageView.image = [UIImage imageWithData:data];
            customCell.customImageView.layer.masksToBounds = YES;
            customCell.customImageView.layer.cornerRadius = 57.5;
        } else {
            NSLog(@"Failed to retrive profile image data");
        }
    }];
    
    return customCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCollectionViewCell *customCell = [self.collectionView cellForItemAtIndexPath:indexPath];
    customCell.blurImageView.hidden = NO;
    // Access selected user from friends array
    PFUser *selectedUser = self.friends[indexPath.row];
    
    // Add selected user to sendLocationTo array
    [self.sendLocationTo addObject:selectedUser];
    
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCollectionViewCell *customCell = [self.collectionView cellForItemAtIndexPath:indexPath];
    customCell.blurImageView.hidden = YES;
    // Access the user that needs to be removed from the sendLocationTo array
    PFUser *selectedUser = self.friends[indexPath.row];
    
    // Search through sendLocationTo array and delete the user
    for (int i = 0; i < [self.sendLocationTo count]; i++) {
        if (self.sendLocationTo[i][@"username"] == selectedUser[@"username"]) {
            [self.sendLocationTo removeObjectAtIndex:i];
        } else {
            NSLog(@"User not found");
        }
    }

    
}



@end
