//
//  SimpleHTTPUnitTest.m
//  SimpleHTTPObjCTests
//
//  Created by Aly Yakan on 6/7/17.
//  Copyright © 2017 dreidev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SimpleHTTP.h"

@interface SimpleHTTPUnitTest : XCTestCase
@property (nonatomic, copy) NSString *baseUrl;
@property (nonatomic) NSURL *url;
@property (nonatomic) SimpleHTTPRequest *simpleRequest;
@property (nonatomic) NSMutableDictionary *parameters;
@end

@implementation SimpleHTTPUnitTest

- (void)setUp {
    [super setUp];
    _parameters = [NSMutableDictionary dictionary];
    [[self parameters] setObject:@"paul rudd" forKey:@"name"];
    [[self parameters] setObject:@[@"I love you man"] forKey:@"movies"];
    _baseUrl = @"https://reqres.in/api/";
    _url = [NSURL URLWithString:_baseUrl];
    _simpleRequest = [[SimpleHTTPRequest alloc] initWithURL:_url andMethod:GET andParams:_parameters];
}

- (void)tearDown {
    _parameters = nil;
    _baseUrl = nil;
    _url = nil;
    _simpleRequest = nil;
    [super tearDown];
}

- (void)testImageDownload {
    UIImageView *imageView = [[UIImageView alloc] init];
    NSURL *downloadURL = [NSURL URLWithString:@"http://www.google.com/images/logos/ps_logo2.png"];
    XCTestExpectation *exp = [self expectationWithDescription:@"should execute get request with status code 200"];
    [imageView setImageWithURL:downloadURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        [exp fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testShouldCreateSimpleHTTPRequest {
    if ([self url]) {
        if ([[SimpleHTTPRequest alloc] initWithURL:[self url] andMethod:GET andParams:[self parameters]]) {
            XCTAssert(YES);
        } else {
            XCTAssert(NO);
        }
    }
}

- (void)testShouldEnqueueRequest {
    unsigned long previousCount = [SimpleHTTP queueCount];
    [SimpleHTTP enqueue:[self simpleRequest]];
    XCTAssertEqual([SimpleHTTP queueCount], previousCount + 1);
    [SimpleHTTP emptyQueue];
}

- (void)testShouldExecuteGetRequest {
    NSURL *newUrl = [[NSURL alloc] initWithString:@"users?page=2" relativeToURL:[self url]];
    XCTestExpectation *exp = [self expectationWithDescription:@"should execute get request with status code 200"];
    SimpleHTTPRequest *request = [[SimpleHTTPRequest alloc] initWithURL:newUrl
                                                              andMethod:GET
                                                              andParams:[self parameters]];
    if (request) {
        [SimpleHTTP enqueue:request];
        [SimpleHTTP execute:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 400) {
                [exp fulfill];
            } else {
                XCTFail();
            }
        }];
        
        [self waitForExpectationsWithTimeout:10 handler:nil];
    }
    
}

- (void)testShouldExecutePostRequest {
    NSURL *newUrl = [[NSURL alloc] initWithString:@"users" relativeToURL:[self url]];
    XCTestExpectation *exp = [self expectationWithDescription:@"should execute post request"];
    SimpleHTTPRequest *request = [[SimpleHTTPRequest alloc] initWithURL:newUrl
                                                              andMethod:POST
                                                              andParams:[self parameters]];
    if (request) {
        [SimpleHTTP enqueue:request];
        [SimpleHTTP execute:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 400) {
                [exp fulfill];
            } else {
                XCTFail();
            }
        }];
        
        [self waitForExpectationsWithTimeout:10 handler:nil];
    }
    
}

- (void)testShouldExecutePutRequest {
    
    NSURL *newUrl = [[NSURL alloc] initWithString:@"users/1" relativeToURL:[self url]];
    XCTestExpectation *exp = [self expectationWithDescription:@"should execute post request"];
    SimpleHTTPRequest *request = [[SimpleHTTPRequest alloc] initWithURL:newUrl
                                                              andMethod:PUT
                                                              andParams:[self parameters]];
    if (request) {
        [SimpleHTTP enqueue:request];
        [SimpleHTTP execute:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 400) {
                [exp fulfill];
            } else {
                XCTFail();
            }
        }];
        
        [self waitForExpectationsWithTimeout:10 handler:nil];
    }
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
