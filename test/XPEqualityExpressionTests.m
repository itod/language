//
//  XPEqualityExpressionTests.m
//  XPTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "XPBaseStatementTests.h"

@interface XPEqualityExpressionTests : XPBaseStatementTests
@end

@implementation XPEqualityExpressionTests

- (void)setUp {
    [super setUp];

}

- (void)tearDown {
    
    [super tearDown];
}

- (void)test1Eq1 {
    NSString *input = @"var foo=1 == 1;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDTrue([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)test0EqEqSignNeg0 {
    NSString *input = @"var foo=0 == -0;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDTrue([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)testNeg0EqEqSign0 {
    NSString *input = @"var foo=-0 == 0;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDTrue([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)testNeg0EqEqSignNeg0 {
    NSString *input = @"var foo=-0==-0;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDTrue([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)test1EqEqSign1 {
    NSString *input = @"var foo=1 == 1;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDTrue([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)test1Eq2 {
    NSString *input = @"var foo=1 == 2;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDFalse([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)test1EqEqSign2 {
    NSString *input = @"var foo=1 == 2;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDFalse([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)test1Ne1 {
    NSString *input = @"var foo=1 != 1;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDFalse([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)test1NeSign1 {
    NSString *input = @"var foo=1 != 1;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDFalse([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)test1Ne2 {
    NSString *input = @"var foo=1 != 2;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDTrue([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)test1NeSign2 {
    NSString *input = @"var foo=1 != 2;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDTrue([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)test0EqNeg0 {
    NSString *input = @"var foo=0 == -0;";
    
    TDEquals(0, -0);
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDTrue([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)test0NeNeg0 {
    NSString *input = @"var foo=0 != -0;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDFalse([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)test00EqNeg00 {
    NSString *input = @"var foo=0.0 == -0.0;";
    
    TDEquals(0.0, -0.0);
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDTrue([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)test00NeNeg00 {
    NSString *input = @"var foo=0.0 != -0.0;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDFalse([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)testNotOpen1Eq1Close {
    NSString *input = @"var foo=not(1 == 1);";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDFalse([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)testBangOpen1EqEqSign1Close {
    NSString *input = @"var foo=!(1 == 1);";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDFalse([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)testBang1EqEqSign1 {
    NSString *input = @"var foo=!1 == 1;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDFalse([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)test1EqNot1 {
    NSString *input = @"var foo=1 == not 1;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDFalse([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)test1EqBangSpace1 {
    NSString *input = @"var foo=1 == ! 1;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDFalse([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)test1EqSpace1 {
    NSString *input = @"var foo=1 == !1;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDFalse([[interp.globals objectForName:@"foo"] boolValue]);
}

@end
