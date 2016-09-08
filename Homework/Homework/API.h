//
//  API.h
//  Homework
//
//  Created by GK on 9/6/16.
//  Copyright © 2016 ME. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EBTrack.h"


typedef void(^CompletionHandler)(EBTrack *stream);

@interface API : NSObject

+ (API *)sharedInstance;

- (void)requestTrackFromEndpoint:(NSString *)endpoint
                      completion:(CompletionHandler)block;

- (void)downloadImageFromPath:(NSString *)filePath
                   completion:(void(^)(UIImage *image))block;

- (void)downloadMediaFileFromRemoteFilePath:(NSString *)remoteFilePath
                                 completion:(void(^)(NSString *localFilePath))block;

@end
