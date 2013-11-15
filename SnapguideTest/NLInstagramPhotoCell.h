//
//  NLInstagramPhotoCell.h
//  SnapguideTest
//
//  Created by Nick Lupinetti on 11/22/12.
//  Copyright (c) 2012 Nick Lupinetti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLInstagramPhoto.h"

@interface NLInstagramPhotoCell : UITableViewCell

@property (nonatomic, getter = isPhotoFocused) BOOL photoFocused;

- (void)setInstagramPhoto:(NLInstagramPhoto *)instagramPhoto;
- (void)setPhotoFocused:(BOOL)photoFocused animated:(BOOL)animated;

@end
