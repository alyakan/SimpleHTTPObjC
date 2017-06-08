//
//  SimpleHTTP.h
//  ObjCDemo
//
//  Created by Aly Yakan on 5/21/17.
//  Copyright © 2017 dreidev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleHTTPRequest.h"
#import "NSObject+ImageDownload.h"

@interface SimpleHTTP : NSObject
{
    
}

+ (void) enqueue:(SimpleHTTPRequest*_Nonnull) request;
+ (void) execute:(void (^_Nullable)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler;
+ (void) downloadImageWithURL:(NSURL *_Nonnull)url completionHandler:(void (^_Nullable)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler;
+ (unsigned long)queueCount;
+ (void)emptyQueue;

@end

