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
#import <AFNetworking/AFImageDownloader.h>


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

// Download track data
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

// Download media file
- (void)downloadMediaFileFromRemoteFilePath:(NSString *)remoteFilePath completion:(void(^)(NSString *localFilePath))block
{
    NSURL *URL = [NSURL URLWithString:remoteFilePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDownloadTask *downloadTask = [self.manager downloadTaskWithRequest:request
                                                                          progress:nil
                                                                       destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                                                                           
                                                                           NSString *fileName = [response suggestedFilename];
                                                                           NSFileManager *fileManager = [NSFileManager defaultManager];
                                                                           NSURL *documentsDirectoryURL = [fileManager URLForDirectory:NSDocumentDirectory
                                                                                                                              inDomain:NSUserDomainMask
                                                                                                                     appropriateForURL:nil
                                                                                                                                create:NO
                                                                                                                                 error:nil];
                                                                           return [documentsDirectoryURL URLByAppendingPathComponent:fileName];
                                                                           
                                                                       } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                                                           if (block)
                                                                               block([filePath absoluteString]);
                                                                       }];
    [downloadTask resume];
}

// Download image
- (void)downloadImageFromPath:(NSString *)filePath
                   completion:(void(^)(UIImage *image))block
{
    __weak typeof(self)weakSelf = self;
    AFImageDownloader *imageDownloader = [[AFImageDownloader alloc] init];
    AFHTTPResponseSerializer *serializer = imageDownloader.sessionManager.responseSerializer;
    serializer.acceptableContentTypes = [serializer.acceptableContentTypes setByAddingObject:@"image/pjpeg"];
    serializer.acceptableContentTypes = [serializer.acceptableContentTypes setByAddingObject:@"image/jpeg"];
    [imageDownloader downloadImageForURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:filePath]]
                                        success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull responseObject) {
                                            if (block) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    block(responseObject);
                                                });
                                            }
                                        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                            [weakSelf handleError:error];
                                        }];
}

- (void)handleError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}

@end



















