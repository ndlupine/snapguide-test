//
//  NLInstagramPhoto.h
//  SnapguideTest
//
//  Created by Nick Lupinetti on 11/22/12.
//  Copyright (c) 2012 Nick Lupinetti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NLInstagramPhoto : NSObject

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) UIImage *userImage;
@property (nonatomic, retain) NSURL *userImageURL;
@property (nonatomic, retain) NSURL *imageURL;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic) NSInteger likes;

- (id)initWithDictionary:(NSDictionary*)attributes;

@end
