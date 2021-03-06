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

- (void)testLiteralSubscript {
    [self exec:@"var res=[0,1,2][3];"];
    TDEqualObjects(@"2", [self stringForName:@"res"]);
}

- (void)testSubExprSubscript {
    [self exec:@"var res=([0,1,2])[2];"];
    TDEqualObjects(@"1", [self stringForName:@"res"]);
}

- (void)testSum {
    [self exec:@"var v=[0,1,2,-10];var res=sum(v);"];
    TDEquals(-7.0, [self doubleForName:@"res"]);
}

- (void)testMap {
    [self exec:@"var v=[0,1,2];var res=map(v, sub(n){return n+1});"];
    TDEqualObjects(@"[1, 2, 3]", [self stringForName:@"res"]);
}

- (void)testMap1 {
    [self exec:@"var v=[0,1,2];var res=map(v, sub(n){return n-1});"];
    TDEqualObjects(@"[-1, 0, 1]", [self stringForName:@"res"]);
}

- (void)testFilter {
    [self exec:@"var v=[0,1,2,3,4,5];var res=filter(v, sub(n){return 0==n%2});"];
    TDEqualObjects(@"[0, 2, 4]", [self stringForName:@"res"]);
}

- (void)testFilter2 {
    [self exec:@"var v=[0,1,2,3,4,5];var res=filter(v, sub(n){if 0==n%2 {return true} else {return false}});"];
    TDEqualObjects(@"[0, 2, 4]", [self stringForName:@"res"]);
}

- (void)testLocalsInLocalBlock {
    [self exec:[self sourceForSelector:_cmd]];
    TDEquals(42.0, [self doubleForName:@"x"]);
    TDEquals(47.0, [self doubleForName:@"y"]);
}

- (void)testLocalsInLocalBlockRecursive {
    [self exec:[self sourceForSelector:_cmd]];
    TDEquals(42.0, [self doubleForName:@"x"]);
    TDEquals(47.0, [self doubleForName:@"y"]);
}

- (void)testLocalsInLocalBlockNotRecursive {
    [self exec:[self sourceForSelector:_cmd]];
    TDEquals(42.0, [self doubleForName:@"x"]);
    TDEquals( 0.0, [self doubleForName:@"y"]);
}

- (void)testLocalsInFunctionDecl {
    [self exec:[self sourceForSelector:_cmd]];
    TDEqualObjects(@"argX", [self stringForName:@"a"]);
    TDEqualObjects(@"localY", [self stringForName:@"b"]);
    TDEqualObjects([XPObject nullObject], [self objectForName:@"c"]);
}

- (void)testLocalsInFunctionLiteral {
    [self exec:[self sourceForSelector:_cmd]];
    TDEqualObjects(@"argX", [self stringForName:@"a"]);
    TDEqualObjects(@"localY", [self stringForName:@"b"]);
    TDEqualObjects([XPObject nullObject], [self objectForName:@"c"]);
}

- (void)testGlobals {
    [self exec:[self sourceForSelector:_cmd]];
    TDEquals(42.0, [self doubleForName:@"x"]);
    TDEquals(42.0, [self doubleForName:@"y"]);
}

- (void)testMembership1 {
    [self exec:@"var x={};x[3]=null;var i=(3 in x);"];
    TDEquals(1, [self boolForName:@"i"]);
    
    [self exec:@"var x={3:null};var i=(3 in x);"];
    TDEquals(1, [self boolForName:@"i"]);
    
    [self exec:@"var x={'3':null};var i=(3 in x);"];
    TDEquals(1, [self boolForName:@"i"]);
    
    [self exec:@"var x={'3':null};var i=(3 in x);"];
    TDEquals(1, [self boolForName:@"i"]);
    
    [self exec:@"var x={'3':null};var i=(1 in x);"];
    TDEquals(0, [self boolForName:@"i"]);
}

- (void)testMembership2 {
    [self exec:@"var key='3';var x={key:null};var i=(key in x);"];
    TDEquals(1, [self boolForName:@"i"]);

    [self exec:@"var key='3';var x={key:null};var i=(1 in x);"];
    TDEquals(0, [self boolForName:@"i"]);
}

- (void)testDel1 {
    [self exec:@"var x={'foo':null,'bar':null};var bevor=('foo' in x);del x['foo'];"];
    TDEquals(1, [self boolForName:@"bevor"]);
    TDEqualObjects(@"{'bar': null}", [[self objectForName:@"x"] reprValue]);
}

- (void)testSort {
    [self exec:@"var v=['b','a','c'];sort(v)"];
    TDEqualObjects(@"['a', 'b', 'c']", [[self objectForName:@"v"] reprValue]);
}

- (void)testLexicalSort {
    [self exec:@"var v=['1','2','10'];sort(v)"];
    TDEqualObjects(@"['1', '10', '2']", [[self objectForName:@"v"] reprValue]);
}

- (void)testNumericalSortFunction {
    [self exec:@"var v=['1', '10', '2'];sort(v,sub(a){return Number(a)})"];
    TDEqualObjects(@"['1', '2', '10']", [[self objectForName:@"v"] reprValue]);
}

- (void)testReverseSlice {
    [self exec:@"var v=['a','b','c'];v=v[::-1]"];
    TDEqualObjects(@"['c', 'b', 'a']", [[self objectForName:@"v"] reprValue]);
}

- (void)testZeroSliceStep {
    [self fail:@"var v=['a','b','c'];v=v[::0]"];
    TDEqualObjects(XPValueError, self.error.localizedDescription);
}

#if COLLECTION_FUNCS
- (void)testReverse {
    [self exec:@"var v=['a','b','c'];reverse(v)"];
    TDEqualObjects(@"['c', 'b', 'a']", [[self objectForName:@"v"] reprValue]);
}

- (void)testExtend {
    [self exec:@"var v=['a','b','c'];extend(v, [4,5])"];
    TDEqualObjects(@"['a', 'b', 'c', 4, 5]", [[self objectForName:@"v"] reprValue]);
}

- (void)testAppendScalar {
    [self exec:@"var v=['a','b','c'];append(v, 4)"];
    TDEqualObjects(@"['a', 'b', 'c', 4]", [[self objectForName:@"v"] reprValue]);
}

- (void)testAppendVector {
    [self exec:@"var v=['a','b','c'];append(v, [4,5])"];
    TDEqualObjects(@"['a', 'b', 'c', [4, 5]]", [[self objectForName:@"v"] reprValue]);
}

- (void)testHasKey1 {
    [self exec:@"var x={};x[3]=null;var i=hasKey(x, 3);"];
    TDEquals(1, [self boolForName:@"i"]);
    
    [self exec:@"var x={3:null};var i=hasKey(x, 3);"];
    TDEquals(1, [self boolForName:@"i"]);
    
    [self exec:@"var x={'3':null};var i=hasKey(x, 3);"];
    TDEquals(1, [self boolForName:@"i"]);
    
    [self exec:@"var x={'3':null};var i=hasKey(x, 3);"];
    TDEquals(1, [self boolForName:@"i"]);
    
    [self exec:@"var x={'3':null};var i=hasKey(x, 1);"];
    TDEquals(0, [self boolForName:@"i"]);
}

- (void)testHasKey2 {
    [self exec:@"var key='3';var x={key:null};var i=hasKey(x, key);"];
    TDEquals(1, [self boolForName:@"i"]);
}

- (void)testRemoveKey1 {
    [self exec:@"var x={'foo':null};var bevor=hasKey(x,'foo');var entfernt1=removeKey(x,'foo');var entfernt2=removeKey(x,'bar');var danach=hasKey(x,'foo');"];
    TDEquals(1, [self boolForName:@"bevor"]);
    TDEquals(1, [self boolForName:@"entfernt1"]);
    TDEquals(0, [self boolForName:@"entfernt2"]);
    TDEquals(0, [self boolForName:@"danach"]);
}

- (void)testArrayInsert {
    [self exec:@"var x=['a', 'c'];insert(x, 2, 'b')"];
    TDEqualObjects(@"['a', 'b', 'c']", [[self objectForName:@"x"] reprValue]);
    
    [self exec:@"var x=['a', 'c'];insert(x, 1, 'b')"];
    TDEqualObjects(@"['b', 'a', 'c']", [[self objectForName:@"x"] reprValue]);
    
    [self exec:@"var x=['a', 'c'];insert(x, 1, ['b'])"];
    TDEqualObjects(@"[['b'], 'a', 'c']", [[self objectForName:@"x"] reprValue]);
    
    [self fail:@"var x=['a', 'c'];insert(x, 0, 'b')"];
    TDEqualObjects(XPIndexError, self.error.localizedDescription);
}
#endif

@end
