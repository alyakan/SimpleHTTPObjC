//
//  SimpleHTTPUnitTest.m
//  SimpleHTTPObjCTests
//
//  Created by Aly Yakan on 6/7/17.
//  Copyright © 2017 dreidev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SimpleHTTP.h"
#import "OHHTTPStubs.h"

@interface SimpleHTTPUObjCTests : XCTestCase
@property (nonatomic, copy) NSString *baseUrl;
@property (nonatomic, copy) NSURL *url;
@property (nonatomic, copy) SimpleHTTPRequest *simpleRequest;
@property (nonatomic, copy) NSMutableDictionary *parameters;
@property (nonatomic, copy) NSURL *stubURL;
@property (nonatomic) BOOL isSetUp;
@end

@implementation SimpleHTTPUObjCTests

- (void)stubsOn {
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest * _Nonnull request) {
        NSLog(@"The request url is %@", request.URL.absoluteString);
        return [request.URL.absoluteString isEqualToString:@"https://www.mywebservice.com"];
    } withStubResponse:^OHHTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request) {
        NSData* stubData = [@"Hello World!" dataUsingEncoding:NSUTF8StringEncoding];
        return [OHHTTPStubsResponse responseWithData:stubData statusCode:200 headers:nil];
    }];
}

- (void)mySetUp {
    _isSetUp = true;
    
    [self stubsOn];
    
    _parameters = [NSMutableDictionary dictionary];
    [[self parameters] setObject:@"paul rudd" forKey:@"name"];
    [[self parameters] setObject:@[@"I love you man"] forKey:@"movies"];
    
    _stubURL = [[NSURL alloc] initWithString:@"https://www.mywebservice.com"];
    _baseUrl = @"https://reqres.in/api/";
    _url = [NSURL URLWithString:_baseUrl];
    _simpleRequest = [[SimpleHTTPRequest alloc] initWithURL:_url andMethod:GET andParams:_parameters];
}

- (void)myTearDown {
    _isSetUp = false;
    _parameters = nil;
    _baseUrl = nil;
    _url = nil;
    _simpleRequest = nil;
    _stubURL = nil;
    [OHHTTPStubs removeAllStubs];
}

- (void)setUp {
    [super setUp];
    [self mySetUp];
}

- (void)tearDown {
    [self myTearDown];
    [super tearDown];
}

- (void)testImageDownload {
    UIImageView *imageView = [[UIImageView alloc] init];
    NSURL *downloadURL = [NSURL URLWithString:@"http://www.google.com/images/logos/ps_logo2.png"];
    XCTestExpectation *exp = [self expectationWithDescription:@"should execute get request with status code 200"];
    [imageView setImageWithURL:downloadURL completionHandler:^(NSError * _Nullable error) {
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
    if (![self isSetUp]) {
        [self mySetUp];
    }
    SimpleHTTPRequest *request = [[SimpleHTTPRequest alloc] initWithURL:[self stubURL]
                                                              andMethod:GET
                                                              andParams:[self parameters]];
    if (request) {
        XCTestExpectation *exp = [self expectationWithDescription:@"should execute get request"];
        [SimpleHTTP enqueue:request];
        [SimpleHTTP execute:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 400) {
                XCTAssert(true);
                [exp fulfill];
                [self myTearDown];
            } else {
                XCTFail();
                [self myTearDown];
            }
        }];
    } else {
        XCTFail();
    }
     [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testShouldExecutePostRequest {
    if (![self isSetUp]) {
        [self mySetUp];
    }
    SimpleHTTPRequest *request = [[SimpleHTTPRequest alloc] initWithURL:[self stubURL]
                                                              andMethod:POST
                                                              andParams:[self parameters]];
    if (request) {
        XCTestExpectation *exp = [self expectationWithDescription:@"should execute post request"];
        [SimpleHTTP enqueue:request];
        [SimpleHTTP execute:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 400) {
                XCTAssert(true);
                [exp fulfill];
                [self myTearDown];
            } else {
                XCTFail();
                [self myTearDown];
            }
        }];
        
        [self waitForExpectationsWithTimeout:10 handler:nil];
    }
    
}

- (void)testShouldExecutePutRequest {
    if (![self isSetUp]) {
        [self mySetUp];
    }
    SimpleHTTPRequest *request = [[SimpleHTTPRequest alloc] initWithURL:[self stubURL]
                                                              andMethod:PUT
                                                              andParams:[self parameters]];
    if (request) {
        XCTestExpectation *exp = [self expectationWithDescription:@"should execute post request"];
        [SimpleHTTP enqueue:request];
        [SimpleHTTP execute:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 400) {
                XCTAssert(true);
                [exp fulfill];
                [self myTearDown];
            } else {
                XCTFail();
                [self myTearDown];
            }
        }];
        [self waitForExpectationsWithTimeout:10 handler:nil];
    }
}

@end

