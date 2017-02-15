//
//  FNCollectionTests.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseStatementTests.h"

@interface FNCollectionTests : XPBaseStatementTests

@end

@implementation FNCollectionTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCount {
    [self eval:@"var v=[0,1,2];var res=map(v, sub(n){return n+1;});"];
    TDEqualObjects(@"[1,2,3]", [self stringForName:@"res"]);


}

@end
