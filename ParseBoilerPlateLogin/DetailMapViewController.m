//
//  DetailMapViewController.m
//  Here!
//
//  Created by Mukul Surajiwale on 7/7/15.
//  Copyright (c) 2015 Mukul Surajiwale. All rights reserved.
//

#import "DetailMapViewController.h"

@interface DetailMapViewController ()

// Properties
@property (strong, nonatomic) MKPointAnnotation *mePoint;

@end

@implementation DetailMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Map Setup
    [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(self.geoPoint.latitude, self.geoPoint.longitude),MKCoordinateSpanMake(0.01, 0.01))];
    self.mePoint = [[MKPointAnnotation alloc] init];
    self.mePoint.title = self.message;
    self.mePoint.coordinate = CLLocationCoordinate2DMake(self.geoPoint.latitude, self.geoPoint.longitude);
    [self.mapView addAnnotation:self.mePoint];
    [self.mapView selectAnnotation:self.mePoint animated:YES];

    
    // Profile Image Setup
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.cornerRadius = 37.5;
    self.profileImageView.image = self.profilePic;
    
    
    
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

@end
