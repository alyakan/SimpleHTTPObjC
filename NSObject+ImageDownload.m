//
//  NSObject+ImageDownload.m
//  SimpleHTTPObjC
//
//  Created by Aly Yakan on 6/7/17.
//  Copyright © 2017 dreidev. All rights reserved.
//

#import "NSObject+ImageDownload.h"
#import "SimpleHTTP.h"

@implementation UIImageView (ImageDownload)
static NSOperationQueue* queue;

- (instancetype)init {
    self = [super init];
    queue = [[NSOperationQueue alloc] init];
    
    return self;
}

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error {
    if (error) {
        NSLog(@"The session is invalid with error: %@", error.localizedDescription);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSLog(@"Downloading, Total Data Received %@", data);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        NSLog(@"%@ failed: %@", task.originalRequest.URL, error);
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    NSLog(@"Downloading, Total Bytes Written %f", (float)totalBytesWritten / (float)totalBytesExpectedToWrite * 100);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    [self setImageFromLocation:location session:session];
}

- (void)setImageFromLocation:(NSURL *)location session:(NSURLSession *)session {
    NSData *data = [NSData dataWithContentsOfURL:location];
    if (data) {
        NSLog(@"Sucessfully retrieved data");
        UIImage *image = [UIImage imageWithData:data];
        NSLog(@"Extracted image: %@", image.description);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Attemping to set image...");
            [self setImage:image];
            [session invalidateAndCancel];
            NSLog(@"Successfully set the image to: %@", [self image].description);
        });
    }
}

- (void)setImageWithURL:(NSURL *)url background:(BOOL)background {
    if (!queue) {
        queue = [[NSOperationQueue alloc] init];
    }
    
    NSURLSessionConfiguration *config;
    if (background) {
        config = [NSURLSessionConfiguration defaultSessionConfiguration];
    } else {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"background"];
        config.sessionSendsLaunchEvents = YES;
        config.discretionary = YES;
    }
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url];
    
    [self resumeTask:task];
    
}

- (void)setImageWithURL:(NSURL *)url
      completionHandler:(void (^)(NSError * _Nullable))completionHandler {
    __weak UIImageView *weakSelf = self;
    [SimpleHTTP downloadImageWithURL:url
                   completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                       UIImageView *innerSelf = weakSelf;
                       if (data) {
                           UIImage *image = [UIImage imageWithData:data];
                           dispatch_async(dispatch_get_main_queue(), ^{
                               [innerSelf setImage:image];
                               completionHandler(error);
                           });
                       }
    }];
}

- (void)resumeTask:(NSURLSessionTask *)task {
    [queue addOperationWithBlock:^{
        NSLog(@"Resuming Task");
        [task resume];
    }];
}
@end

