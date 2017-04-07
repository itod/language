//
//  XPWhileBlockTests.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseStatementTests.h"

@interface XPWhileBlockTests : XPBaseStatementTests

@end

@implementation XPWhileBlockTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testWhileTrueParse {
    [self exec:@"while true {break;}"];
}

- (void)testWhileTrueBreak {
    [self exec:@"var x=0;while true {x=x+1;if x>2 {break;}}"];
    TDEquals(3.0, [self doubleForName:@"x"]);
}

- (void)testWhileTrueContinue {
    [self exec:@"var x=0;while true {x=x+1;if x<=4 {continue;} break;}"];
    TDEquals(5.0, [self doubleForName:@"x"]);
}

- (void)testWhile1 {
    [self exec:@"var i=10;var c=0;while i>0{i=0;c=10;}"];
    TDEquals(10.0, [self doubleForName:@"c"]);
}

- (void)testWhile10 {
    [self exec:@"var i=10;var c=0;while i>0{i=0;c=c+1;}"];
    TDEquals(1.0, [self doubleForName:@"c"]);
}

- (void)testWhile5 {
    [self exec:@"var i=5;var c=0;while i>0{i=i-1;c=c+1;}"];
    TDEquals(5.0, [self doubleForName:@"c"]);
}

@end
