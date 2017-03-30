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

#pragma mark -
#pragma mark STAT

- (void)testVarDecl {
    [self eval:@"var\nfoo = 1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo\n= 1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo =\n 1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
}

- (void)testAssign {
    [self eval:@"var foo=0;foo\n=1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=0;foo=\n1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
}

- (void)testAssignIndex {
    [self eval:@"var foo=[0];foo\n[1]=1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=[0];foo[\n1]=1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=[0];foo[1\n]=1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=[0];foo[1]\n=1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=[0];foo[1]=\n1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
}

- (void)testAssignAppend {
    [self eval:@"var foo=[];foo\n[]=1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=[];foo[\n]=1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=[];foo[]\n=1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=[];foo[]=\n1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
}

- (void)testThrowStat {
    [self fail:@"throw 'ohai'"];
    TDEqualObjects(XPRuntimeError, self.error.localizedDescription);
    TDEqualObjects(@"ohai", self.error.localizedFailureReason);
    
    [self fail:@"throw\n'ohai'"];
    TDEqualObjects(XPRuntimeError, self.error.localizedDescription);
    TDEqualObjects(@"ohai", self.error.localizedFailureReason);
}

- (void)testReturnStat {
    [self eval:@"var foo=sub(){return 11}()"];
    TDEquals(11.0, [self doubleForName:@"foo"]);

    [self eval:@"var foo=sub(){return\n11}()"];
    TDEquals(11.0, [self doubleForName:@"foo"]);
}

#pragma mark -
#pragma mark BLOCK

- (void)testIfBlock {
    [self eval:@"var foo=0;if 1 {foo=22}"];
    TDEquals(22.0, [self doubleForName:@"foo"]);

    [self eval:@"var foo=0;if\n1 {foo=22}"];
    TDEquals(22.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=0;if 1\n{foo=22}"];
    TDEquals(22.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=0;if 1 {\nfoo=22}"];
    TDEquals(22.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=0;if 1 {foo=22\n}"];
    TDEquals(22.0, [self doubleForName:@"foo"]);
}




//- (void)testFuncCallArgument {
//    [self eval:@"var s=replace('abracadabra',\n'bra', '*');"];
//    TDEqualObjects(@"a*cada*", [self stringForName:@"s"]);
//}

@end
