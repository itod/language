//
//  XPVariableStatementTests.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseStatementTests.h"
#import "XPVariableStatement.h"

@interface XPVariableStatementTests : XPBaseStatementTests

@end

@implementation XPVariableStatementTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFooEq1 {
    NSString *input = @"var foo = 1;";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPStatement *stat = [self statementFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(stat);

    
}

@end
