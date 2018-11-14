//
//  Log4OCTests.m
//  Log4OCTests
//
//  Created by FinderTiwk on 2018/08/08.
//  Copyright © 2018 FinderTiwk. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Log4OC.h"

@interface Log4OCTests : XCTestCase

@end

@implementation Log4OCTests

- (void)setUp {
    setLogMode(2, 2, YES);
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testA{
    dxoLog(@"dddd",@"ccccc",nil);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testLog{
    DEBUGLog(@"张三", @"这是一个测试日志");
    [self measureBlock:^{
        DEBUGLog(@"测试数据1");
        INFOLog(@"测试数据1");
        WARNINGLog(@"测试数据1");
        ERRORLog(@"测试数据1");
    }];


    NSLog(@"============LogLevelDEBUG==============");
    setLogLevel(LogLevelDEBUG);
    DEBUGLog(@"测试数据2");
    INFOLog(@"测试数据2");
    WARNINGLog(@"测试数据2");
    ERRORLog(@"测试数据2");

    NSLog(@"============LogLevelINFO==============");
    setLogLevel(LogLevelINFO);
    DEBUGLog(@"测试数据3");
    INFOLog(@"测试数据3");
    WARNINGLog(@"测试数据3");
    ERRORLog(@"测试数据3");

    NSLog(@"============LogLevelWARNING==============");
    setLogLevel(LogLevelWARNING);
    DEBUGLog(@"测试数据4");
    INFOLog(@"测试数据4");
    WARNINGLog(@"测试数据4");
    ERRORLog(@"测试数据4");

    NSLog(@"============LogLevelERROR==============");
    setLogLevel(LogLevelERROR);
    DEBUGLog(@"测试数据5");
    INFOLog(@"测试数据5");
    WARNINGLog(@"测试数据5");
    ERRORLog(@"测试数据5");
}

@end
