//
//  XPIfBlockTests.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseStatementTests.h"
#import "XPNode.h"
#import "XPMemorySpace.h"

@interface XPIfBlockTests : XPBaseStatementTests

@end

@implementation XPIfBlockTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testIfTrueParse {
    NSString *input = @"if true {}";
    
    NSError *err = nil;
    XPNode *node = [self statementFromString:input error:&err];
    TDNotNil(node);
    TDNil(err);
}

- (void)testIfTrue {
    NSString *input = @"var foo = 0; if true {foo=1;}";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    
    TDEquals(1.0, [[interp.globals objectForName:@"foo"] doubleValue]);
}

- (void)testIfTrueElse {
    NSString *input = @"var foo = 0; if true {} else {foo=1;}";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    
    TDEquals(0.0, [[interp.globals objectForName:@"foo"] doubleValue]);
}

- (void)testIfFalseElse {
    NSString *input = @"var foo = 0; if false {} else {foo=1;}";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    
    TDEquals(1.0, [[interp.globals objectForName:@"foo"] doubleValue]);
}

- (void)testIfFalseElseIfTrue {
    NSString *input = @"var foo = 0; if false {} else if true {foo=1;}";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    
    TDEquals(1.0, [[interp.globals objectForName:@"foo"] doubleValue]);
}

- (void)testIfFalseElseIfFalseElseIfTrue {
    NSString *input = @"var foo = 0; if false {} else if false {} else if true {foo=1;}";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    
    TDEquals(1.0, [[interp.globals objectForName:@"foo"] doubleValue]);
}

- (void)testIfFalseElseIfFalseElse {
    NSString *input = @"var foo = 0; if false {} else if false {} else {foo=1;}";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    
    TDEquals(1.0, [[interp.globals objectForName:@"foo"] doubleValue]);
}

- (void)testIfFalseElseIfTrueElseIfTrue {
    NSString *input = @"var foo = 0; if false {} else if true {foo=10;} else if true {foo=1;}";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    
    TDEquals(10.0, [[interp.globals objectForName:@"foo"] doubleValue]);
}

- (void)testIfFalseElseIfTrueElse {
    NSString *input = @"var foo = 0; if false {} else if true {foo=11;} else {foo=1;}";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    
    TDEquals(11.0, [[interp.globals objectForName:@"foo"] doubleValue]);
}

@end
