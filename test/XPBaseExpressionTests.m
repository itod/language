//
//  XPBaseExpressionTests.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseExpressionTests.h"
#import "XPNode.h"
#import "XPExpression.h"

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


- (XPExpression *)expressionFromString:(NSString *)str error:(NSError **)outErr {
    TDTrue(self.parser);
    PKAssembly *a = [self.parser parseString:str error:outErr];
    
    XPNode *block = [a pop];
    TDTrue([block isKindOfClass:[XPNode class]]);
    
    XPExpression *expr = [block.children firstObject];
    
    expr = [expr simplify];
    return expr;
}


- (XPExpression *)expressionFromTokens:(NSArray *)toks error:(NSError **)outErr {
    TDTrue(self.parser);
    PKAssembly *a = [self.parser parseTokens:toks error:outErr];
    
    XPNode *block = [a pop];
    TDTrue([block isKindOfClass:[XPNode class]]);
    
    XPExpression *expr = [block.children firstObject];
    
    expr = [expr simplify];
    return expr;
}

@end
