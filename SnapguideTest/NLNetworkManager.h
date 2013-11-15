//
//  NLNetworkManager.h
//  SnapguideTest
//
//  Created by Nick Lupinetti on 11/21/12.
//  Copyright (c) 2012 Nick Lupinetti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NLNetworkManager : NSObject

@property (nonatomic, readonly, getter = isLoading) BOOL loading;

+ (NLNetworkManager*)sharedManager;

- (void)requestURL:(NSURL*)url completion:(void (^)(NSData *data))competionHandler failure:(void (^)(NSError *error))failureHandler;
- (void)requestImageAtURL:(NSURL*)url completion:(void (^)(UIImage* image))completion failure:(void (^)(NSError *error))failureHandler;
- (void)cancelRequests;

@end
