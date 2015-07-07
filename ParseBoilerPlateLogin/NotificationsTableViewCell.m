
//
//  NotificationsTableViewCell.m
//  Here!
//
//  Created by Mukul Surajiwale on 7/5/15.
//  Copyright (c) 2015 Mukul Surajiwale. All rights reserved.
//

#import "NotificationsTableViewCell.h"
@implementation NotificationsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(0.0, 0.0),MKCoordinateSpanMake(0.01, 0.01))];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadCell {
    [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(self.geoPoint.latitude, self.geoPoint.longitude),MKCoordinateSpanMake(0.01, 0.01))];
    self.mePoint = [[MKPointAnnotation alloc] init];
    self.mePoint.coordinate = CLLocationCoordinate2DMake(self.geoPoint.latitude, self.geoPoint.longitude);
    [self.mapView addAnnotation:self.mePoint];
}

@end
