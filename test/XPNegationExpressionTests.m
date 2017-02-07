//
//  XPNegationExpressionTests.m
//  XPTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "XPBaseStatementTests.h"

@interface XPNegationExpressionTests : XPBaseStatementTests
@end

@implementation XPNegationExpressionTests

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)testNot1 {
    NSString *input = @"var foo=not 1;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDFalse([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)testBangSpace1 {
    NSString *input = @"var foo=! 1;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDFalse([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)testBang1 {
    NSString *input = @"var foo=!1;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDFalse([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)testNot0 {
    NSString *input = @"var foo=not 0;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDTrue([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)testBangSpace0 {
    NSString *input = @"var foo=! 0;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDTrue([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)testBang0 {
    NSString *input = @"var foo=!0;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDTrue([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)testNotTrue {
    NSString *input = @"var foo=not true;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDFalse([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)testBangSpaceTrue {
    NSString *input = @"var foo=! true;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDFalse([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)testBangTrue {
    NSString *input = @"var foo=!true;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDFalse([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)testNotFalse {
    NSString *input = @"var foo=not false;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDTrue([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)testBangSpaceFalse {
    NSString *input = @"var foo=! false;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDTrue([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)testBangFalse {
    NSString *input = @"var foo=!false;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDTrue([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)testNotOpenTrueClose {
    NSString *input = @"var foo=not(true);";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDFalse([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)testNotSpaceOpenTrueClose {
    NSString *input = @"var foo=not(true);";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDFalse([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)testBangSpaceOpenTrueClose {
    NSString *input = @"var foo=! (true);";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDFalse([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)testBangOpenTrueClose {
    NSString *input = @"var foo=!(true);";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDFalse([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)testNotOpenFalseClose {
    NSString *input = @"var foo=not(false);";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDTrue([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)testNotSpaceOpenFalseClose {
    NSString *input = @"var foo=not (false);";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDTrue([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)testBangOpenFalseClose {
    NSString *input = @"var foo=!(false);";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDTrue([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)testBangSpaceOpenFalseClose {
    NSString *input = @"var foo=! (false);";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDTrue([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)testNotSpaceSQString {
    NSString *input = @"var foo=not 'hello';";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDFalse([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)testNotSQString {
    NSString *input = @"var foo=not'hello';";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDFalse([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)testBangSpaceSQString {
    NSString *input = @"var foo=! 'hello';";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDFalse([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)testBangSQString {
    NSString *input = @"var foo=!'hello';";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDFalse([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)testNotSpaceEmptySQString {
    NSString *input = @"var foo=not '';";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDTrue([[interp.globals objectForName:@"foo"] boolValue]);
}

- (void)testNotEmptySQString {
    NSString *input = @"var foo=not'';";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDTrue([[interp.globals objectForName:@"foo"] boolValue]);
}

@end
