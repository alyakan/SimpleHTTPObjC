//
//  SimpleHTTP.m
//  ObjCDemo
//
//  Created by Aly Yakan on 5/21/17.
//  Copyright © 2017 dreidev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleHTTP.h"
#import "SimpleHTTPRequest.h"

@implementation SimpleHTTP

static NSOperationQueue* queue;
static NSMutableArray* requestQueue;

+ (void)initialize {
    if (!queue) {
        queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = 2;
    }
    if (!requestQueue) {
        requestQueue = [[NSMutableArray alloc] init];
    }
}

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-init is not a valid initializer for the class SimpleHTTP"
                                 userInfo:nil];
    return nil;
}

+ (void)enqueue:(SimpleHTTPRequest *)request {
    NSLog(@"Operation Count: %lu", (unsigned long)queue.operations.count);
    
    [requestQueue addObject:request];
}

/**
 It asynchronously executes the next request in the queue in a background thread. This is done by dequeing the first request
 from the queue.
 Maximum number of concurrent requests on Mobile Data is 2. On Wifi up to 6 concurrent requests will be handled.
 
 - Parameter completionHandler:
 */
+ (void)execute:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler {
    // If the requestQueue is empty, execute cannot be called.
    if (requestQueue.count == 0) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"-execute cannot be called if the Task Queue is empty. Use -enqueue first."
                                     userInfo:nil];
    }
    
    // Dequeue a request from requestQueue.
    SimpleHTTPRequest* request = (SimpleHTTPRequest*) requestQueue[0];
    [requestQueue removeObjectAtIndex:0];
    
    // Initialize an NSURLSessionDataTask for the request.
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]
                                  dataTaskWithURL:request.url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                      NSLog(@"response status code: %ld", (long)[httpResponse statusCode]);
                                      completionHandler(data, response, error);
                                  }];
    
    // Add the task to the NSOperationQueue called queue.
    [queue addOperationWithBlock:^{
        [task resume];
    }];
}

+ (void)downloadImageWithURL:(NSURL *)url
           completionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler {
    SimpleHTTPRequest *request = [[SimpleHTTPRequest alloc] initWithURL:url
                                                              andMethod:GET
                                                              andParams:nil];
    [self enqueue:request];
    [self execute:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        completionHandler(data, response, error);
    }];
}

+ (unsigned long)queueCount {
    return [requestQueue count];
}

+ (void)emptyQueue {
    [requestQueue removeAllObjects];
}

@end

