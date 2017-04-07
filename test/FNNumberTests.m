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
    [self exec:@"var x=max(1);"];
    TDEquals(1.0, [self doubleForName:@"x"]);
}

- (void)testMax2 {
    [self exec:@"var x=max(1,2);"];
    TDEquals(2.0, [self doubleForName:@"x"]);
}

- (void)testMax3 {
    [self exec:@"var x=max(1,-2);"];
    TDEquals(1.0, [self doubleForName:@"x"]);
}

- (void)testMax4 {
    [self exec:@"var x=max(-1,-2);"];
    TDEquals(-1.0, [self doubleForName:@"x"]);
}

- (void)testMax5 {
    [self exec:@"var x=max('0','2');"];
    TDEquals(2.0, [self doubleForName:@"x"]);
}

- (void)testMax6 {
    [self exec:@"var x=max([1,2]);"];
    TDEquals(2.0, [self doubleForName:@"x"]);
}

- (void)testMin1 {
    [self exec:@"var x=min(1);"];
    TDEquals(1.0, [self doubleForName:@"x"]);
}

- (void)testMin2 {
    [self exec:@"var x=min(1,2);"];
    TDEquals(1.0, [self doubleForName:@"x"]);
}

- (void)testMin3 {
    [self exec:@"var x=min(1,-2);"];
    TDEquals(-2.0, [self doubleForName:@"x"]);
}

- (void)testMin4 {
    [self exec:@"var x=min('0','2');"];
    TDEquals(0.0, [self doubleForName:@"x"]);
}

- (void)testMin5 {
    [self exec:@"var x=min([1,2]);"];
    TDEquals(1.0, [self doubleForName:@"x"]);
}

- (void)testRand1 {
    [self exec:@"var x=random(1);"];
    double d = [self doubleForName:@"x"];
    TDTrue(d >= 0.0 && d <= 1.0);
}

- (void)testRand2 {
    [self exec:@"var x=random(10);"];
    double d = [self doubleForName:@"x"];
    TDTrue(d >= 0.0 && d <= 10.0);
}

- (void)testRand3 {
    [self exec:@"var x=random(-10);"];
    double d = [self doubleForName:@"x"];
    TDTrue(d <= 0.0 && d >= -10.0);
}

- (void)testRand4 {
    [self exec:@"var x=random(0,10);"];
    double d = [self doubleForName:@"x"];
    TDTrue(d >= 0.0 && d <= 10.0);
}

- (void)testRand5 {
    [self exec:@"var x=random(0, -10);"];
    double d = [self doubleForName:@"x"];
    TDTrue(d <= 0.0 && d >= -10.0);
}

- (void)testRand6 {
    [self exec:@"var x=random(5,12);"];
    double d = [self doubleForName:@"x"];
    TDTrue(d >= 5.0 && d <= 12.0);
}

@end
