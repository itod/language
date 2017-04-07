//
//  FNNumberTests.m
//  Language
//
//  Created by Todd Ditchendorf on 5/12/14.
//
//

#import "XPBaseStatementTests.h"

@interface FNNumberTests : XPBaseStatementTests

@end

@implementation FNNumberTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMax1 {
    [self eval:@"var x=max(1);"];
    TDEquals(1.0, [self doubleForName:@"x"]);
}

- (void)testMax2 {
    [self eval:@"var x=max(1,2);"];
    TDEquals(2.0, [self doubleForName:@"x"]);
}

- (void)testMax3 {
    [self eval:@"var x=max(1,-2);"];
    TDEquals(1.0, [self doubleForName:@"x"]);
}

- (void)testMax4 {
    [self eval:@"var x=max(-1,-2);"];
    TDEquals(-1.0, [self doubleForName:@"x"]);
}

- (void)testMax5 {
    [self eval:@"var x=max('0','2');"];
    TDEquals(2.0, [self doubleForName:@"x"]);
}

- (void)testMax6 {
    [self eval:@"var x=max([1,2]);"];
    TDEquals(2.0, [self doubleForName:@"x"]);
}

- (void)testMin1 {
    [self eval:@"var x=min(1);"];
    TDEquals(1.0, [self doubleForName:@"x"]);
}

- (void)testMin2 {
    [self eval:@"var x=min(1,2);"];
    TDEquals(1.0, [self doubleForName:@"x"]);
}

- (void)testMin3 {
    [self eval:@"var x=min(1,-2);"];
    TDEquals(-2.0, [self doubleForName:@"x"]);
}

- (void)testMin4 {
    [self eval:@"var x=min('0','2');"];
    TDEquals(0.0, [self doubleForName:@"x"]);
}

- (void)testMin5 {
    [self eval:@"var x=min([1,2]);"];
    TDEquals(1.0, [self doubleForName:@"x"]);
}

- (void)testRand1 {
    [self eval:@"var x=random(1);"];
    double d = [self doubleForName:@"x"];
    TDTrue(d >= 0.0 && d <= 1.0);
}

- (void)testRand2 {
    [self eval:@"var x=random(10);"];
    double d = [self doubleForName:@"x"];
    TDTrue(d >= 0.0 && d <= 10.0);
}

- (void)testRand3 {
    [self eval:@"var x=random(-10);"];
    double d = [self doubleForName:@"x"];
    TDTrue(d <= 0.0 && d >= -10.0);
}

- (void)testRand4 {
    [self eval:@"var x=random(0,10);"];
    double d = [self doubleForName:@"x"];
    TDTrue(d >= 0.0 && d <= 10.0);
}

- (void)testRand5 {
    [self eval:@"var x=random(0, -10);"];
    double d = [self doubleForName:@"x"];
    TDTrue(d <= 0.0 && d >= -10.0);
}

- (void)testRand6 {
    [self eval:@"var x=random(5,12);"];
    double d = [self doubleForName:@"x"];
    TDTrue(d >= 5.0 && d <= 12.0);
}

@end
