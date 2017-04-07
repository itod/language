//
//  FNSequenceTests.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseStatementTests.h"

@interface FNSequenceTests : XPBaseStatementTests

@end

@implementation FNSequenceTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCount {
    [self eval:@"var x='321';var c=count(x);"];
    TDEquals(3.0, [self doubleForName:@"c"]);

    [self eval:@"var x='';var c=count(x);"];
    TDEquals(0.0, [self doubleForName:@"c"]);

    [self eval:@"var x=[3,4,5];var c=count(x);"];
    TDEquals(3.0, [self doubleForName:@"c"]);
    
    [self eval:@"var x=[];var c=count(x);"];
    TDEquals(0.0, [self doubleForName:@"c"]);
    
    [self eval:@"var x=[2];var c=count(x);"];
    TDEquals(1.0, [self doubleForName:@"c"]);

    [self eval:@"var x={'a':1,'b':2};var c=count(x);"];
    TDEquals(2.0, [self doubleForName:@"c"]);

    [self eval:@"var x={};var c=count(x);"];
    TDEquals(0.0, [self doubleForName:@"c"]);
}

- (void)testPosition {
    [self eval:@"var x='321';var i=position(x, 1);"];
    TDEquals(3.0, [self doubleForName:@"i"]);
    
    [self eval:@"var x='321';var i=position(x, 0);"];
    TDEquals(0.0, [self doubleForName:@"i"]);
    
    [self eval:@"var x='';var i=position(x, 'a');"];
    TDEquals(0.0, [self doubleForName:@"i"]);
    
    [self eval:@"var x=[3,4,5];var i=position(x, 3);"];
    TDEquals(1.0, [self doubleForName:@"i"]);
    
    [self eval:@"var x=[3,4,5];var i=position(x, 1);"];
    TDEquals(0.0, [self doubleForName:@"i"]);
    
    [self eval:@"var x=[];var i=position(x, 3);"];
    TDEquals(0.0, [self doubleForName:@"i"]);
}

//- (void)testSlice {
//    [self eval:@"var a = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];"];
//    TDEqualObjects(@"");
//}

@end
