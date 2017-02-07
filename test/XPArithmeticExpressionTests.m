//
//  XPArithmeticExpressionTests.m
//  XPTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "XPBaseStatementTests.h"

@interface XPArithmeticExpressionTests : XPBaseStatementTests
@end

@implementation XPArithmeticExpressionTests

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)test1SpacePlusSpace2 {
    NSString *input = @"var foo=1 + 2;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDEquals(3.0, [[interp.globals objectForName:@"foo"] doubleValue]);
}

- (void)test1Plus2 {
    NSString *input = @"var foo=1+2;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDEquals(3.0, [[interp.globals objectForName:@"foo"] doubleValue]);
}

- (void)test1SpaceMinusSpace1 {
    NSString *input = @"var foo=1 - 1;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDEquals(0.0, [[interp.globals objectForName:@"foo"] doubleValue]);
}

- (void)testTruePlus1 {
    NSString *input = @"var foo=true + 1;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDEquals(2.0, [[interp.globals objectForName:@"foo"] doubleValue]);
}

- (void)testFalsePlus1 {
    NSString *input = @"var foo=false + 1;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDEquals(1.0, [[interp.globals objectForName:@"foo"] doubleValue]);
}

- (void)test2Times2 {
    NSString *input = @"var foo=2*2;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDEquals(4.0, [[interp.globals objectForName:@"foo"] doubleValue]);
}

- (void)test2Div2 {
    NSString *input = @"var foo=2/2;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDEquals(1.0, [[interp.globals objectForName:@"foo"] doubleValue]);
}

- (void)test3Plus2Times2 {
    NSString *input = @"var foo=3+2*2;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDEquals(7.0, [[interp.globals objectForName:@"foo"] doubleValue]);
}

- (void)testOpen3Plus2CloseTimes2 {
    NSString *input = @"var foo=(3+2)*2;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDEquals(10.0, [[interp.globals objectForName:@"foo"] doubleValue]);
}

- (void)testNeg2Mod2 {
    NSString *input = @"var foo=-2%2;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDEquals(-0.0, [[interp.globals objectForName:@"foo"] doubleValue]);
}

- (void)testNeg1Mod2 {
    NSString *input = @"var foo=-1%2;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDEquals(-1.0, [[interp.globals objectForName:@"foo"] doubleValue]);
}

- (void)test0Mod2 {
    NSString *input = @"var foo=0%2;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDEquals(0.0, [[interp.globals objectForName:@"foo"] doubleValue]);
}

- (void)test1Mod2 {
    NSString *input = @"var foo=1%2;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDEquals(1.0, [[interp.globals objectForName:@"foo"] doubleValue]);
}

- (void)test2Mod2 {
    NSString *input = @"var foo=2%2;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDEquals(0.0, [[interp.globals objectForName:@"foo"] doubleValue]);
}

- (void)test3Mod2 {
    NSString *input = @"var foo=3%2;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDEquals(1.0, [[interp.globals objectForName:@"foo"] doubleValue]);
}

- (void)test4Mod2 {
    NSString *input = @"var foo=4%2;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDEquals(0.0, [[interp.globals objectForName:@"foo"] doubleValue]);
}

- (void)testMinus1 {
    NSString *input = @"var foo=-1;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDEquals(-1.0, [[interp.globals objectForName:@"foo"] doubleValue]);
}

- (void)testMinusMinus1 {
    NSString *input = @"var foo=--1;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDEquals(1.0, [[interp.globals objectForName:@"foo"] doubleValue]);
}

- (void)test1PlusMinusMinus1 {
    NSString *input = @"var foo=1 + --1;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDEquals(2.0, [[interp.globals objectForName:@"foo"] doubleValue]);
}

- (void)test1MinusMinusMinus1 {
    NSString *input = @"var foo=1 - --1;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDEquals(0.0, [[interp.globals objectForName:@"foo"] doubleValue]);
}

- (void)testMinusMinus1Plus1 {
    NSString *input = @"var foo=--1 + 1;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDEquals(2.0, [[interp.globals objectForName:@"foo"] doubleValue]);
}

- (void)testMinusMinus1Minus1 {
    NSString *input = @"var foo=--1 - 1;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDEquals(0.0, [[interp.globals objectForName:@"foo"] doubleValue]);
}

- (void)testMinusMinusMinus1 {
    NSString *input = @"var foo=---1;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDEquals(-1.0, [[interp.globals objectForName:@"foo"] doubleValue]);
}

- (void)testMinusMinusMinusMinus4 {
    NSString *input = @"var foo=----4;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDEquals(4.0, [[interp.globals objectForName:@"foo"] doubleValue]);
}

@end
