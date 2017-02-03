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

- (void)testIfTrue {
    NSString *input = @"if true {}";
    
    NSError *err = nil;
    XPNode *node = [self statementFromString:input error:&err];
    TDNotNil(node);
    TDNil(err);
    
    //TDEquals(1.0, [[interp.globals objectForName:@"foo"] doubleValue]);
}

//- (void)testIfTrue {
//    NSString *input = @"if true {}";
//    
//    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
//    
//    NSError *err = nil;
//    [interp interpretString:input error:&err];
//    TDNil(err);
//    
//    //TDEquals(1.0, [[interp.globals objectForName:@"foo"] doubleValue]);
//}

@end
