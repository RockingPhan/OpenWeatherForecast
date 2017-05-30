//
//  OpenWeatherTests.m
//  OpenWeatherTests
//
//  Created by Phanindra Kumar on 28/05/17.
//  Copyright © 2017 Phanindra Kumar. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RootViewController.h"



@interface OpenWeatherTests : XCTestCase


@property (nonatomic )RootViewController *rootVCToTest;

@end

@implementation OpenWeatherTests

- (void)setUp {
    [super setUp];
    
    self.rootVCToTest = [[RootViewController alloc] init];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}


- (void)testAsynchronousDownloadMethod {
    
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Long Async Method"];
    
    self.rootVCToTest downloadWeatherData:openWeatherAppJsonUrlString completionBlock:^(BOOL succeeded, NSData *data, NSError *error) {
        
        
        
        
    }
    
    
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
