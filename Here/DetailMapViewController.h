//
//  DetailMapViewController.h
//  Here!
//
//  Created by Mukul Surajiwale on 7/7/15.
//  Copyright (c) 2015 Mukul Surajiwale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface DetailMapViewController : UIViewController

// Outlets
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;

// Properties
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) PFGeoPoint *geoPoint;
@property (strong, nonatomic) UIImage *profilePic;

@end
