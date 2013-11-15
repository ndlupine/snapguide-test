//
//  NLInstagramPhoto.m
//  SnapguideTest
//
//  Created by Nick Lupinetti on 11/22/12.
//  Copyright (c) 2012 Nick Lupinetti. All rights reserved.
//

#import "NLInstagramPhoto.h"

static NSString * const kImageKeyPathRetina = @"images.standard_resolution.url";
static NSString * const kImageKeyPathStandard = @"images.low_resolution.url";
static NSString * const kUserImageKeyPath = @"user.profile_picture";
static NSString * const kUserNameKeyPath = @"user.username";
static NSString * const kLikesKeyPath = @"likes.count";

@implementation NLInstagramPhoto

- (id)initWithDictionary:(NSDictionary *)attributes {
    self = [super init];
    
    if (self) {
        self.username = [attributes valueForKeyPath:kUserNameKeyPath];
        self.userImageURL = [NSURL URLWithString:[attributes valueForKeyPath:kUserImageKeyPath]];
        self.likes = [[attributes valueForKeyPath:kLikesKeyPath] integerValue];
        
        if ([[UIScreen mainScreen] scale] == 2.0) {
            self.imageURL = [NSURL URLWithString:[attributes valueForKeyPath:kImageKeyPathRetina]];
        }
        else {
            self.imageURL = [NSURL URLWithString:[attributes valueForKeyPath:kImageKeyPathStandard]];
        }
    }
    
    return self;
}

- (void)dealloc {
    [_image release];
    [_username release];
    [_imageURL release];
    [_userImage release];
    [_userImageURL release];
    [super dealloc];
}

@end
