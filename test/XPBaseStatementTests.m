//
//  XPBaseStatementTests.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseStatementTests.h"
#import "XPNode.h"

@implementation XPBaseStatementTests

- (void)setUp {
    [super setUp];
    
    self.stat = nil;
}

- (void)tearDown {
    self.stat = nil;
    
    [super tearDown];
}


- (XPParser *)parser {
    XPParser *p = [super parser];
    p.allowNakedExpressions = YES;
    return p;
}


- (XPNode *)statementFromString:(NSString *)str error:(NSError **)outErr {
    TDTrue(self.parser);
    PKAssembly *a = [self.parser parseString:str error:outErr];
    
    XPNode *stat = [a pop];
    
    //stat = [stat simplify];
    return stat;
}


- (XPNode *)statementFromTokens:(NSArray *)toks error:(NSError **)outErr {
    TDTrue(self.parser);
    PKAssembly *a = [self.parser parseTokens:toks error:outErr];
    
    XPNode *stat = [a pop];
    
    //stat = [stat simplify];
    return stat;
}

@end
