//
//  XPBooleanExpressionTests.m
//  XPTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "XPBaseStatementTests.h"

@interface XPBooleanExpressionTests : XPBaseStatementTests
@end

@implementation XPBooleanExpressionTests

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)test1 {
    NSString *input = @"var foo=1;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDTrue([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)test0 {
    NSString *input = @"var foo=0;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDFalse([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)testTrue {
    NSString *input = @"var foo=true;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDTrue([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)testFalse {
    NSString *input = @"var foo=false;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDFalse([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)testOpenTrueClose {
    NSString *input = @"var foo=(true);";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDTrue([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)testOpenFalseClose {
    NSString *input = @"var foo=(false);";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDFalse([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)testSQString {
    NSString *input = @"var foo='hello';";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDTrue([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)testEmptySQString {
    NSString *input = @"var foo='';";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDFalse([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)test1And0 {
    NSString *input = @"var foo=1 and 0;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDFalse([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)test0And1 {
    NSString *input = @"var foo=0 and 1;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDFalse([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)test1And1 {
    NSString *input = @"var foo=1 and 1;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDTrue([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)test1Or0 {
    NSString *input = @"var foo=1 or 0;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDTrue([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)test1PipePipe0 {
    NSString *input = @"var foo=1 or 0;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDTrue([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)test0Or1 {
    NSString *input = @"var foo=0 or 1;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDTrue([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)test1Or1 {
    NSString *input = @"var foo=1 or 1;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDTrue([[interp.globals objectForName:@"foo"] boolValue]);
}

@end
