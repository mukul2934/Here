//
//  NotificationsTableViewCell.h
//  Here!
//
//  Created by Mukul Surajiwale on 7/5/15.
//  Copyright (c) 2015 Mukul Surajiwale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface NotificationsTableViewCell : UITableViewCell

// Outlets
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) PFGeoPoint *geoPoint;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;

// Acions
- (void)reloadCell;

// Properties
@property (strong, nonatomic) MKPointAnnotation *mePoint;
@property (strong, nonatomic) NSString *message;
@end
