//
//  NLNetworkManager.m
//  SnapguideTest
//
//  Created by Nick Lupinetti on 11/21/12.
//  Copyright (c) 2012 Nick Lupinetti. All rights reserved.
//

#import "NLNetworkManager.h"

static NLNetworkManager *sharedManager;


@interface NLNetworkManager ()

@property (nonatomic, readonly) NSOperationQueue *networkQueue;
@property (nonatomic, readwrite, getter = isLoading) BOOL loading;

@end


@implementation NLNetworkManager

@synthesize networkQueue = _networkQueue;

+ (NLNetworkManager*)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[NLNetworkManager alloc] init];
    });
    
    return sharedManager;
}

- (NSOperationQueue*)networkQueue {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _networkQueue = [[NSOperationQueue alloc] init];
        _networkQueue.maxConcurrentOperationCount = 1;
        [_networkQueue setName:@"com.nicklupinetti.networkmanager.networkqueue"];
    });
    
    return _networkQueue;
}

- (void)dealloc {
    [_networkQueue cancelAllOperations];
    [_networkQueue release];
    [super dealloc];
}

- (void)cancelRequests {
    self.loading = NO;
    [self.networkQueue cancelAllOperations];
}

- (void)requestImageAtURL:(NSURL*)url completion:(void (^)(UIImage* image))completion failure:(void (^)(NSError *))failureHandler {
    [self requestURL:url completion:^(NSData *data) {
        UIImage *image = [UIImage imageWithData:data scale:[[UIScreen mainScreen] scale]];
        completion(image);
        
    } failure:^(NSError *error) {
        failureHandler(error);
    }];
}

- (void)requestURL:(NSURL*)url completion:(void (^)(NSData *))competionHandler failure:(void (^)(NSError *))failureHandler {
    NSOperationQueue *originalQueue = [NSOperationQueue currentQueue];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.loading = YES;
    
    [NSURLConnection sendAsynchronousRequest:request queue:self.networkQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (data) {
            [originalQueue addOperationWithBlock:^{
                if (self.networkQueue.operationCount == 0) {
                    self.loading = NO;
                }
                
                competionHandler(data);
            }];
        }
        else if (error) {
            [originalQueue addOperationWithBlock:^{
                if (self.networkQueue.operationCount == 0) {
                    self.loading = NO;
                }
                
                failureHandler(error);
            }];
        }
    }];
}

- (void)setLoading:(BOOL)loading {
    _loading = loading;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:loading];
}


@end
