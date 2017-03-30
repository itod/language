//
//  XPNewlineTests.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseStatementTests.h"

@interface XPNewlineTests : XPBaseStatementTests

@end

@implementation XPNewlineTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testVarDecl {
    [self eval:@"var foo =\n 1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
}

//- (void)testFuncCallArgument {
//    [self eval:@"var s=replace('abracadabra',\n'bra', '*');"];
//    TDEqualObjects(@"a*cada*", [self stringForName:@"s"]);
//}

@end
