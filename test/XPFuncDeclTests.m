//
//  XPFuncDeclTests.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseStatementTests.h"
#import "XPNode.h"
#import "XPMemorySpace.h"

@interface XPFuncDeclTests : XPBaseStatementTests

@end

@implementation XPFuncDeclTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSubFoo {
    NSString *input = @"sub foo() {}";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    
    //TDEquals(1.0, [[interp.globals objectForName:@"foo"] doubleValue]);
}

- (void)testSubFooRet1Plus1 {
    NSString *input = @"sub foo() { return 1+1; }";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
}

- (void)testCallSubFooRet1Plus1 {
    NSString *input = @"var bar = foo(); sub foo() { return 1+1; }";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    
    TDEquals(2.0, [[interp.globals objectForName:@"bar"] doubleValue]);
}

- (void)testCallSubFooRetAPlusB {
    NSString *input = @"var bar = foo(); sub foo() { var a = 1; var b = 3; return a + b; }";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    
    TDEquals(4.0, [[interp.globals objectForName:@"bar"] doubleValue]);
}

- (void)testCallSubFooRetAPlusBGlobal {
    NSString *input = @"var b=5;var bar=foo();sub foo(){var a=10;return a+b;}";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    
    TDEquals(15.0, [[interp.globals objectForName:@"bar"] doubleValue]);
}

- (void)testCallSubFooRetAPlusBGlobalFail {
    NSString *input = @"var bar=foo();var b=5;sub foo(){var a=10;return a+b;}";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNotNil(err);
}

- (void)testCallSubArg {
    NSString *input = @"var x=2;var bar=foo(x);sub foo(a){var b=10;return a+b;}";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    
    TDEquals(12.0, [[interp.globals objectForName:@"bar"] doubleValue]);
}

- (void)testCallSubArg2 {
    NSString *input = @"var bar=foo(4,5);sub foo(x,y){return x+y;}";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    
    TDEquals(9.0, [[interp.globals objectForName:@"bar"] doubleValue]);
}

- (void)testCallSubArg2Minus {
    NSString *input = @"var bar=foo(10,1);sub foo(x,y){return x -y;}";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    
    TDEquals(9.0, [[interp.globals objectForName:@"bar"] doubleValue]);
}

- (void)testCallSubArg2MinusNeg {
    NSString *input = @"var bar=foo(1,10);sub foo(x,y){return x-y;}";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    
    TDEquals(-9.0, [[interp.globals objectForName:@"bar"] doubleValue]);
}

- (void)testCallSubArg2MinusNeg2 {
    NSString *input = @"var bar=foo(1,10);sub foo(x,y){return x- y;}";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    
    TDEquals(-9.0, [[interp.globals objectForName:@"bar"] doubleValue]);
}

- (void)testCallSubDefaultVal {
    NSString *input = @"var bar = foo(); sub foo(a=77) { return a+1; }";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    
    TDEquals(78.0, [[interp.globals objectForName:@"bar"] doubleValue]);
}

- (void)testCallSubDefaultValOverride {
    NSString *input = @"var bar = foo(22); sub foo(a=77) { return a+1; }";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    
    TDEquals(23.0, [[interp.globals objectForName:@"bar"] doubleValue]);
}

@end
