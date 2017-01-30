//
//  XPAssignStatTests.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseStatementTests.h"
#import "XPNode.h"
#import "XPMemorySpace.h"

@interface XPAssignStatTests : XPBaseStatementTests

@end

@implementation XPAssignStatTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFooEq1 {
    NSString *input = @"var foo = 1; foo = 2;";

    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSError *err = nil;
    [interp interpretString:input error:nil];
    TDNil(err);
    
    TDEquals(2.0, [[interp.globals objectForName:@"foo"] doubleValue]);
}

@end
