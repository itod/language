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

- (void)testMax {
    [self eval:@"var x=max(1);"];
    TDEquals(1.0, [self doubleForName:@"x"]);
    
    [self eval:@"var x=max(1,2);"];
    TDEquals(2.0, [self doubleForName:@"x"]);
    
    [self eval:@"var x=max(1,-2);"];
    TDEquals(1.0, [self doubleForName:@"x"]);
    
    [self eval:@"var x=max(-1,-2);"];
    TDEquals(-1.0, [self doubleForName:@"x"]);
    
    [self eval:@"var x=max('0','2');"];
    TDEquals(2.0, [self doubleForName:@"x"]);
    
    [self eval:@"var x=max([1,2]);"];
    TDEquals(2.0, [self doubleForName:@"x"]);
}

- (void)testMin {
    [self eval:@"var x=min(1);"];
    TDEquals(1.0, [self doubleForName:@"x"]);
    
    [self eval:@"var x=min(1,2);"];
    TDEquals(1.0, [self doubleForName:@"x"]);
    
    [self eval:@"var x=min(1,-2);"];
    TDEquals(-2.0, [self doubleForName:@"x"]);
    
    [self eval:@"var x=min('0','2');"];
    TDEquals(0.0, [self doubleForName:@"x"]);
    
    [self eval:@"var x=min([1,2]);"];
    TDEquals(1.0, [self doubleForName:@"x"]);
}

@end
