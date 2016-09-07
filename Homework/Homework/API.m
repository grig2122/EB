//
//  API.m
//  Homework
//
//  Created by GK on 9/6/16.
//  Copyright © 2016 ME. All rights reserved.
//

#import "API.h"
#import <AFNetworking/AFNetworking.h>
#import "EBTrack+Network.h"

@interface API ()

@property (nonatomic, strong) AFURLSessionManager *manager;

@end

@implementation API

+ (API *)sharedInstance {
    static dispatch_once_t once;
    static API *instance = nil;
    dispatch_once(&once, ^{
        if (!instance) {
            instance = [[API alloc] init];
            
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
            instance.manager = manager;
        }
    });
    return instance;
}

- (void)requestTrackFromEndpoint:(NSString *)endpoint completion:(CompletionHandler)block
{
    NSURL *URL = [NSURL URLWithString:endpoint];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDataTask *dataTask = [self.manager dataTaskWithRequest:request
                                                     completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                         if (error)
                                                         {
                                                             [self handleError:error];
                                                         }
                                                         else
                                                         {
                                                             EBTrack *track = [EBTrack trackFromJson:responseObject];
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (block)
                                                                     block(track);
                                                             });
                                                         }
                                                     }];
    
    [dataTask resume];
}

- (void)handleError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}

@end



















