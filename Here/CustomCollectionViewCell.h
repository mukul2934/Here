//
//  CustomCollectionViewCell.h
//  Here!
//
//  Created by Mukul Surajiwale on 7/2/15.
//  Copyright (c) 2015 Mukul Surajiwale. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *customImageView;
@property (strong, nonatomic) IBOutlet UIVisualEffectView *blurImageView;

@end
