//
//  XPBaseExpressionTests.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseExpressionTests.h"
#import "XPNode.h"

@implementation XPBaseExpressionTests

- (void)setUp {
    [super setUp];
    
    self.expr = nil;
}

- (void)tearDown {
    self.expr = nil;
    
    [super tearDown];
}


- (XPParser *)parser {
    XPParser *p = [super parser];
    p.allowNakedExpressions = YES;
    return p;
}


- (id)expressionFromString:(NSString *)str error:(NSError **)outErr {
    TDTrue(self.parser);
    PKAssembly *a = [self.parser parseString:str error:outErr];
    
    XPNode *block = [a pop];
    TDTrue([block isKindOfClass:[XPNode class]]);
    
    id expr = [block.children firstObject];
    return expr;
}


- (id)expressionFromTokens:(NSArray *)toks error:(NSError **)outErr {
    TDTrue(self.parser);
    PKAssembly *a = [self.parser parseTokens:toks error:outErr];
    
    XPNode *block = [a pop];
    TDTrue([block isKindOfClass:[XPNode class]]);
    
    id expr = [block.children firstObject];
    return expr;
}

@end
