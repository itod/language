//
//  XPUnaryExpressionTests.m
//  XPTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "XPBaseStatementTests.h"

@interface XPUnaryExpressionTests : XPBaseStatementTests
@property (nonatomic, retain) NSOutputStream *output;
@end

@implementation XPUnaryExpressionTests

- (void)setUp {
    [super setUp];
    
    self.output = [NSOutputStream outputStreamToMemory];
}

- (void)tearDown {
    self.output = nil;
    
    [super tearDown];
}

- (NSString *)outputString {
    NSString *str = [[[NSString alloc] initWithData:[_output propertyForKey:NSStreamDataWrittenToMemoryStreamKey] encoding:NSUTF8StringEncoding] autorelease];
    return str;
}

- (void)testNeg1 {
    NSString *input = @"var foo=-1;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDEquals(-1, [[interp.globals objectForName:@"foo"] doubleValue]);
}

- (void)testNegNeg1 {
    NSString *input = @"var foo=--1;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDEquals(1, [[interp.globals objectForName:@"foo"] doubleValue]);
}

- (void)testNegNegNeg1 {
    NSString *input = @"var foo=---1;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDEquals(-1, [[interp.globals objectForName:@"foo"] doubleValue]);
}

- (void)testNegNegNegNeg1 {
    NSString *input = @"var foo=----1;";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    TDEquals(1, [[interp.globals objectForName:@"foo"] doubleValue]);
}

@end
