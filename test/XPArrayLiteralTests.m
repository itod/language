//
//  XPArrayLiteralTests.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseStatementTests.h"
#import "XPNode.h"
#import "XPMemorySpace.h"

@interface XPArrayLiteralTests : XPBaseStatementTests

@end

@implementation XPArrayLiteralTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFetchIndex {
    NSString *input = @"var foo=['a','b'];var bar=foo[0];var baz=foo[1];";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    
    TDEqualObjects(@"a", [[interp.globals objectForName:@"bar"] stringValue]);
    TDEqualObjects(@"b", [[interp.globals objectForName:@"baz"] stringValue]);
}

- (void)testInsertAtIndex {
    NSString *input = @"var foo=['a','b'];foo[0]='c';foo[1]='d';var bar=foo[0];var baz=foo[1];";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    
    TDEqualObjects(@"c", [[interp.globals objectForName:@"bar"] stringValue]);
    TDEqualObjects(@"d", [[interp.globals objectForName:@"baz"] stringValue]);
}

- (void)testInsertAtIndexOutOfOrder {
    NSString *input = @"var foo=['a','b'];foo[1]='d';foo[0]='c';var bar=foo[0];var baz=foo[1];";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    
    TDEqualObjects(@"c", [[interp.globals objectForName:@"bar"] stringValue]);
    TDEqualObjects(@"d", [[interp.globals objectForName:@"baz"] stringValue]);
}

- (void)testAppend {
    NSString *input = @"var foo=[];foo[]='c';foo[]='d';var bar=foo[0];var baz=foo[1];";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    
    TDEqualObjects(@"c", [[interp.globals objectForName:@"bar"] stringValue]);
    TDEqualObjects(@"d", [[interp.globals objectForName:@"baz"] stringValue]);
}

@end
