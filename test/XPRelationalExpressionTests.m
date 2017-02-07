//
//  XPRelationalExpressionTests.m
//  XPTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "XPBaseStatementTests.h"

@interface XPRelationalExpressionTests : XPBaseStatementTests

@end

@implementation XPRelationalExpressionTests

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)test1Lt1 {
    NSString *input = @"var foo=1 < 1;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDFalse([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)test1LtEq1 {
    NSString *input = @"var foo=1 <= 1;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDTrue([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)test1Lt2 {
    NSString *input = @"var foo=1 < 2;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDTrue([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)test1LtEq2 {
    NSString *input = @"var foo=1 <= 2;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDTrue([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)test1Gt1 {
    NSString *input = @"var foo=1 > 1;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDFalse([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)test1GtEq1 {
    NSString *input = @"var foo=1 >= 1;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDTrue([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)test1Gt2 {
    NSString *input = @"var foo=1 > 2;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDFalse([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)test1GtEq2 {
    NSString *input = @"var foo=1 >= 2;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDFalse([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)testNeg0Lt0 {
    NSString *input = @"var foo=-0 < 0;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDFalse([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)testNeg0Gt0 {
    NSString *input = @"var foo=-0.0 > 0.0;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDFalse([[interp.globals objectForName:@"foo"] boolValue]);
}

@end
