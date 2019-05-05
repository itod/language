//
//  XPNumberExpressionTests.m
//  XPTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "XPBaseStatementTests.h"

@interface XPNumberExpressionTests : XPBaseStatementTests
@end

@implementation XPNumberExpressionTests

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)testHex {
    [self exec:@"var n=#F;"];
    TDEquals(15.0, [self doubleForName:@"n"]);

    [self exec:@"var n=#FF;"];
    TDEquals(255.0, [self doubleForName:@"n"]);
}

- (void)testBin {
    [self exec:@"var n=$10;"];
    TDEquals(2.0, [self doubleForName:@"n"]);
}

- (void)testBitNot {
    [self exec:@"var n=~$1;"];
    TDEquals(-2.0, [self doubleForName:@"n"]);

    [self exec:@"var n=~$10;"];
    TDEquals(-3.0, [self doubleForName:@"n"]);
}

- (void)testBitAnd {
    [self exec:@"var n=$10 & $1;"];
    TDEquals(0.0, [self doubleForName:@"n"]);

    [self exec:@"var x=$10; x &= $1;"];
    TDEquals(0.0, [self doubleForName:@"x"]);
}

- (void)testBitOr {
    [self exec:@"var n=$10 | $1;"];
    TDEquals(3.0, [self doubleForName:@"n"]);

    [self exec:@"var x=$10; x |= $1;"];
    TDEquals(3.0, [self doubleForName:@"x"]);
}

- (void)testBitXOr {
    [self exec:@"var n=$010 ^ $101;"];
    TDEquals(7.0, [self doubleForName:@"n"]);

    [self exec:@"var n=$010; n ^= $101;"];
    TDEquals(7.0, [self doubleForName:@"n"]);
}

- (void)testShiftLeft {
    [self exec:@"var n=$1 << 1;"];
    TDEquals(2.0, [self doubleForName:@"n"]);
    
    [self exec:@"var n=$1 << 2;"];
    TDEquals(4.0, [self doubleForName:@"n"]);
    
    [self exec:@"var n=$10 << 2;"];
    TDEquals(8.0, [self doubleForName:@"n"]);

    
    [self exec:@"var n=$10; n <<= 2;"];
    TDEquals(8.0, [self doubleForName:@"n"]);
}

- (void)testShiftRight {
    [self exec:@"var n=$10 >> 1;"];
    TDEquals(1.0, [self doubleForName:@"n"]);
    
    [self exec:@"var n=$100 >> 2;"];
    TDEquals(1.0, [self doubleForName:@"n"]);

    [self exec:@"var n=$100; n >>= 2;"];
    TDEquals(1.0, [self doubleForName:@"n"]);
}

- (void)testPow {
    [self exec:@"var n=2**2;"];
    TDEquals(4.0, [self doubleForName:@"n"]);

    [self exec:@"var n=2**-2;"];
    TDEquals(0.25, [self doubleForName:@"n"]);
}

@end
