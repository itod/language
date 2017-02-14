//
//  XPForBlockTests.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseStatementTests.h"

@interface XPForBlockTests : XPBaseStatementTests

@end

@implementation XPForBlockTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLoopArray {
    [self eval:@"var x=[3,2,1];var y=[];for el in x {y[]=el;}var a=y[1];var b=y[2];var c=y[3];"];
    TDEquals(3.0, [self doubleForName:@"a"]);
    TDEquals(2.0, [self doubleForName:@"b"]);
    TDEquals(1.0, [self doubleForName:@"c"]);
}

- (void)testLoopDict {
    [self eval:@"var x={'a':'1','b':'2','c':'3'};var y={};for key,val in x {y[key]=val;}var a=y['a'];var b=y['b'];var c=y['c'];"];
    TDEquals(1.0, [self doubleForName:@"a"]);
    TDEquals(2.0, [self doubleForName:@"b"]);
    TDEquals(3.0, [self doubleForName:@"c"]);
}

@end
