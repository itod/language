//
//  XPWhileBlockTests.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseStatementTests.h"
#import "XPNode.h"
#import "XPMemorySpace.h"

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
    [self eval:@"while true {break;}"];
}

- (void)testWhile1 {
    [self eval:@"var i=10;var c=0;while i>0{i=0;c=10;}"];
    TDEquals(10.0, [self doubleForName:@"c"]);
}

- (void)testWhile10 {
    [self eval:@"var i=10;var c=0;while i>0{i=0;c=c+1;}"];
    TDEquals(1.0, [self doubleForName:@"c"]);
}

- (void)testWhile5 {
    [self eval:@"var i=5;var c=0;while i>0{i=i-1;c=c+1;}"];
    TDEquals(5.0, [self doubleForName:@"c"]);
}

@end
