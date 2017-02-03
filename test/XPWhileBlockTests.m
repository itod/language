//
//  XPWhileBlockTests.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseStatementTests.h"
#import "XPNode.h"
#import "XPMemorySpace.h"

@interface XPWhileBlockTests : XPBaseStatementTests

@end

@implementation XPWhileBlockTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testIfTrueParse {
    NSString *input = @"while true {}";
    
    NSError *err = nil;
    XPNode *node = [self statementFromString:input error:&err];
    TDNotNil(node);
    TDNil(err);
}

- (void)testWhile1 {
    NSString *input = @"var i=10;var c=0;while i>0{i=0;c=10;}";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    
    TDEquals(10.0, [[interp.globals objectForName:@"c"] doubleValue]);
}

- (void)testWhile10 {
    NSString *input = @"var i=10;var c=0;while i>0{i=0;c=c+1;}";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    
    TDEquals(1.0, [[interp.globals objectForName:@"c"] doubleValue]);
}

- (void)testWhile5 {
    NSString *input = @"var i=5;var c=0;while i>0{i=i-1;c=c+1;}";
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:&err];
    TDNil(err);
    
    TDEquals(5.0, [[interp.globals objectForName:@"c"] doubleValue]);
}

@end
