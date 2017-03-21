//
//  XPFuncLiteralTests.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseStatementTests.h"

@interface XPFuncLiteralTests : XPBaseStatementTests

@end

@implementation XPFuncLiteralTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSub {
    [self eval:@"var foo = sub () {};"];
}

- (void)testSubRet1 {
    [self eval:@"var foo=sub(){return 1;}; var bar=foo();"];
    TDEquals(1.0, [self doubleForName:@"bar"]);
}

- (void)testOverrideFail {
    [self fail:@"var foo=sub(){return 1;};var foo=1;var bar=foo();"];
    TDEqualObjects(XPExceptionTypeMismatch, self.error.localizedDescription);
}

- (void)testFwdFuncValRef {
    [self eval:@"var bar=foo;var baz=bar();sub foo(){return 33;}"];
    TDEquals(33.0, [self doubleForName:@"baz"]);
}

- (void)testFuncDeclRef {
    [self eval:@"sub foo(){return 33;}var bar=foo;var baz=bar();"];
    TDEquals(33.0, [self doubleForName:@"baz"]);
}

- (void)testFuncLiteralCall {
    [self eval:@"var baz=sub(){return 22}()"];
    TDEquals(22.0, [self doubleForName:@"baz"]);
}

- (void)testFuncSubExprCall {
    [self eval:@"var baz=(sub(){return 88})()"];
    TDEquals(88.0, [self doubleForName:@"baz"]);
}

@end
