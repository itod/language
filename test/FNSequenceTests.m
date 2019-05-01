//
//  FNSequenceTests.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseStatementTests.h"

@interface FNSequenceTests : XPBaseStatementTests

@end

@implementation FNSequenceTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCount1 {
    [self exec:@"var x='321';var c=count(x);"];
    TDEquals(3.0, [self doubleForName:@"c"]);
}

- (void)testCount2 {
    [self exec:@"var x='';var c=count(x);"];
    TDEquals(0.0, [self doubleForName:@"c"]);
}

- (void)testCount3 {
    [self exec:@"var x=[3,4,5];var c=count(x);"];
    TDEquals(3.0, [self doubleForName:@"c"]);
}

- (void)testCount4 {
    [self exec:@"var x=[];var c=count(x);"];
    TDEquals(0.0, [self doubleForName:@"c"]);
}

- (void)testCount5 {
    [self exec:@"var x=[2];var c=count(x);"];
    TDEquals(1.0, [self doubleForName:@"c"]);
}

- (void)testCount6 {
    [self exec:@"var x={'a':1,'b':2};var c=count(x);"];
    TDEquals(2.0, [self doubleForName:@"c"]);
}

- (void)testCount7 {
    [self exec:@"var x={};var c=count(x);"];
    TDEquals(0.0, [self doubleForName:@"c"]);
}

- (void)testLoadSlice {
    [self eval:@"var a = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];"];
    TDEqualObjects(@"'a'"                                       , [self evalString:@"a[1]"]);
    TDEqualObjects(@"'h'"                                       , [self evalString:@"a[-1]"]);
    TDEqualObjects(@"['a', 'b', 'c', 'd']"                      , [self evalString:@"a[1:4]"]);
    TDEqualObjects(@"['a', 'b', 'c', 'd']"                      , [self evalString:@"a[:4]"]);
    TDEqualObjects(@"['e', 'f', 'g', 'h']"                      , [self evalString:@"a[-4:-1]"]);
    TDEqualObjects(@"['e', 'f', 'g', 'h']"                      , [self evalString:@"a[-4:]"]);
    TDEqualObjects(@"['d', 'e']"                                , [self evalString:@"a[4:-4]"]);

    TDEqualObjects(@"['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']"  , [self evalString:@"a[:]"]);
    TDEqualObjects(@"['a', 'b', 'c', 'd', 'e']"                 , [self evalString:@"a[:5]"]);
    TDEqualObjects(@"['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']"  , [self evalString:@"a[:-1]"]);
    TDEqualObjects(@"['d', 'e', 'f', 'g', 'h']"                 , [self evalString:@"a[4:]"]);
    TDEqualObjects(@"['f', 'g', 'h']"                           , [self evalString:@"a[-3:]"]);
    TDEqualObjects(@"['b', 'c', 'd', 'e']"                      , [self evalString:@"a[2:5]"]);
    TDEqualObjects(@"['b', 'c', 'd', 'e', 'f', 'g', 'h']"       , [self evalString:@"a[2:-1]"]);
    TDEqualObjects(@"['f', 'g', 'h']"                           , [self evalString:@"a[-3:-1]"]);

    // PYTHON:
    //    a[:]      # ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
    //    a[:5]     # ['a', 'b', 'c', 'd', 'e']
    //    a[:-1]    # ['a', 'b', 'c', 'd', 'e', 'f', 'g']
    //
    //
    //    a[4:]     # ['e', 'f', 'g', 'h']
    //    a[-3:]    # ['f', 'g', 'h']
    //    a[2:5]    # ['c', 'd', 'e']
    //    a[2:-1]   # ['c', 'd', 'e', 'f', 'g']
    //    a[-3:-1]  # ['f', 'g']
    
    [self eval:@"var b = a[4:]"];
    TDEqualObjects(@"['d', 'e', 'f', 'g', 'h']"                 , [self evalString:@"b"]);
    [self eval:@"b[2]=99"];
    TDEqualObjects(@"['d', 99, 'f', 'g', 'h']"                  , [self evalString:@"b"]);
    TDEqualObjects(@"['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']"  , [self evalString:@"a"]);

    // PYTHON:
    //    b = a[4:]
    //    print('Before:   ', b)
    //    b[1] = 99
    //    print('After:    ', b)
    //    print('No change:', a)
    //
    //
    //    Before:    ['e', 'f', 'g', 'h']
    //    After:     ['e', 99, 'g', 'h']
    //    No change: ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']

    [self eval:@"var c = a[:]"]; // copy
    TDFalse([self evalBool:@"c is a or a is c"]);
    TDEqualObjects(@"['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']"  , [self evalString:@"c"]);
    [self eval:@"c[-1]=47"];
    TDEqualObjects(@"['a', 'b', 'c', 'd', 'e', 'f', 'g', 47]"   , [self evalString:@"c"]);
    TDEqualObjects(@"['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']"  , [self evalString:@"a"]);
    
    [self eval:@"var d = a"]; // ref
    TDEqualObjects(@"['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']"  , [self evalString:@"d"]);
    [self eval:@"d[1]=42"];
    TDEqualObjects(@"[42, 'b', 'c', 'd', 'e', 'f', 'g', 'h']"   , [self evalString:@"d"]);
    TDEqualObjects(@"[42, 'b', 'c', 'd', 'e', 'f', 'g', 'h']"   , [self evalString:@"a"]);
}

- (void)testAssignSlice {
    [self eval:@"var a = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];"];

    [self eval:@"a[2:7]=[99, 22, 14]"];
    TDEqualObjects(@"['a', 99, 22, 14, 'h']"   , [self evalString:@"a"]);
    
//    print('Before ', a)
//    a[2:7] = [99, 22, 14]
//    print('After  ', a)
//    >>>
//    Before  ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
//    After   ['a', 'b', 99, 22, 14, 'h']
}

- (void)testAssignSlice2 {
    [self eval:@"var a = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']"];

    [self eval:@"var b=a; a[:]=[101, 102, 103]"];
    TDTrue([self evalBool:@"a is b and b is a"]);
    TDEqualObjects(@"[101, 102, 103]"   , [self evalString:@"a"]);
}

- (void)testSliceIdentity {
    [self eval:@"var a=[];var c = a[:]"]; // copy
    TDFalse([self evalBool:@"c is a or a is c"]);

    [self eval:@"var x = [][:]"]; // copy
    TDFalse([self evalBool:@"x"]);
    
    [self eval:@"var b=[];var d=b"]; // copy
    TDTrue([self evalBool:@"b is d and d is b"]);
}

- (void)testPositionStr1 {
    [self exec:@"var x='321';var i=position(x, '1');"];
    TDEquals(3.0, [self doubleForName:@"i"]);
    
    [self exec:@"var x='321';var i=position(x, '1', false);"];
    TDEquals(3.0, [self doubleForName:@"i"]);
    
    [self exec:@"var x='321';var i=position(x, '1', 0);"];
    TDEquals(3.0, [self doubleForName:@"i"]);
    
    [self exec:@"var x='321';var i=position(x, '1', true);"];
    TDEquals(3.0, [self doubleForName:@"i"]);
    
    [self exec:@"var x='321';var i=position(x, '1', 1);"];
    TDEquals(3.0, [self doubleForName:@"i"]);
    
    [self exec:@"var x='321';var i=position(x, 1);"];
    TDEquals(3.0, [self doubleForName:@"i"]);
    
    [self exec:@"var x='321';var i=position(x, 1, false);"];
    TDEquals(3.0, [self doubleForName:@"i"]);
    
    [self exec:@"var x='321';var i=position(x, 1, 0);"];
    TDEquals(3.0, [self doubleForName:@"i"]);
    
    [self exec:@"var x='321';var i=position(x, 1, true);"];
    TDEquals(0.0, [self doubleForName:@"i"]);
    
    [self exec:@"var x='321';var i=position(x, 1, 1);"];
    TDEquals(0.0, [self doubleForName:@"i"]);
}

- (void)testPositionStr2 {
    [self exec:@"var x='321';var i=position(x, 0);"];
    TDEquals(0.0, [self doubleForName:@"i"]);
    
    [self exec:@"var x='321';var i=position(x, 0, true);"];
    TDEquals(0.0, [self doubleForName:@"i"]);
    
    [self exec:@"var x='321';var i=position(x, 0, false);"];
    TDEquals(0.0, [self doubleForName:@"i"]);
    
    [self exec:@"var x='321';var i=position(x, '0');"];
    TDEquals(0.0, [self doubleForName:@"i"]);
    
    [self exec:@"var x='321';var i=position(x, '0', true);"];
    TDEquals(0.0, [self doubleForName:@"i"]);
    
    [self exec:@"var x='321';var i=position(x, '0', false);"];
    TDEquals(0.0, [self doubleForName:@"i"]);
}

- (void)testPositionStr3 {
    [self exec:@"var x='';var i=position(x, 'a');"];
    TDEquals(0.0, [self doubleForName:@"i"]);
}

- (void)testPositionArr1 {
    [self exec:@"var x=[3,4,5];var i=position(x, 3);"];
    TDEquals(1.0, [self doubleForName:@"i"]);
    
    [self exec:@"var x=[3,4,5];var i=position(x, 3, false);"];
    TDEquals(1.0, [self doubleForName:@"i"]);
    
    [self exec:@"var x=[3,4,5];var i=position(x, 3, true);"];
    TDEquals(1.0, [self doubleForName:@"i"]);
    
    [self exec:@"var x=[3,4,5];var i=position(x, '3');"];
    TDEquals(1.0, [self doubleForName:@"i"]);
    
    [self exec:@"var x=[3,4,5];var i=position(x, '3', false);"];
    TDEquals(1.0, [self doubleForName:@"i"]);
    
    [self exec:@"var x=[3,4,5];var i=position(x, '3', true);"];
    TDEquals(0.0, [self doubleForName:@"i"]);
}

- (void)testPositionArr2 {
    [self exec:@"var x=[3,4,5];var i=position(x, 1);"];
    TDEquals(0.0, [self doubleForName:@"i"]);
}

- (void)testPositionArr3 {
    [self exec:@"var x=[];var i=position(x, 3);"];
    TDEquals(0.0, [self doubleForName:@"i"]);
}

//- (void)testReversedString {
//    [self exec:@"var s='abc';var t=reversed(s);"];
//    TDEqualObjects(@"abc", [self stringForName:@"s"]);
//    TDEqualObjects(@"cba", [self stringForName:@"t"]);
//}
//
//- (void)testReversedArray {
//    [self exec:@"var s=[4,5,6];var t=reversed(s);"];
//    TDEqualObjects(@"[4, 5, 6]", [[self objectForName:@"s"] reprValue]);
//    TDEqualObjects(@"[6, 5, 4]", [[self objectForName:@"t"] reprValue]);
//}

- (void)testArrayLoadOutOfBounds0 {
    [self fail:@"var x=['a'];var y=x[0]"];
    TDEqualObjects(XPIndexError, self.error.localizedDescription);
}

- (void)testArrayAssignOutOfBounds0 {
    [self fail:@"var x=['a'];x[0]='b'"];
    TDEqualObjects(XPIndexError, self.error.localizedDescription);
}

- (void)testStringLoadOutOfBounds0 {
    [self fail:@"var x='a';var y=x[0]"];
    TDEqualObjects(XPIndexError, self.error.localizedDescription);
}

- (void)testStringAssignOutOfBounds0 {
    [self fail:@"var x='a';x[0]='b'"];
    TDEqualObjects(XPIndexError, self.error.localizedDescription);
}

@end
