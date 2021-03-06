//
//  XPIfBlockTests.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseStatementTests.h"

@interface XPIfBlockTests : XPBaseStatementTests

@end

@implementation XPIfBlockTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testIfTrueParse {
    [self exec:@"if true {}"];
}

- (void)testIfTrue {
    [self exec:@"var foo = 0; if true {foo=1;}"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
}

- (void)testIfTrueElse {
    [self exec:@"var foo = 0; if true {} else {foo=1;}"];
    TDEquals(0.0, [self doubleForName:@"foo"]);
}

- (void)testIfFalseElse {
    [self exec:@"var foo = 0; if false {} else {foo=1;}"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
}

- (void)testIfFalseElseIfTrue {
    [self exec:@"var foo = 0; if false {} else if true {foo=1;}"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
}

- (void)testIfFalseElseIfFalseElseIfTrue {
    [self exec:@"var foo = 0; if false {} else if false {} else if true {foo=1;}"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
}

- (void)testIfFalseElseIfFalseElse {
    [self exec:@"var foo = 0; if false {} else if false {} else {foo=1;}"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
}

- (void)testIfFalseElseIfTrueElseIfTrue {
    [self exec:@"var foo = 0; if false {} else if true {foo=10;} else if true {foo=1;}"];
    TDEquals(10.0, [self doubleForName:@"foo"]);
}

- (void)testIfTrueElseIfTrueElseIfTrue {
    [self exec:@"var foo = 0; if true {foo=3;} else if true {foo=10;} else if true {foo=1;}"];
    TDEquals(3.0, [self doubleForName:@"foo"]);
}

- (void)testIfFalseElseIfTrueElse {
    [self exec:@"var foo = 0; if false {} else if true {foo=11;} else {foo=1;}"];
    TDEquals(11.0, [self doubleForName:@"foo"]);
}

- (void)testIfFalseElseIfTrueElseFail {
    [self fail:@"var foo = 0; if false {} else {foo=11;} else {foo=1;}"];
    TDEqualObjects(XPSyntaxError, self.error.localizedDescription);
}

@end
