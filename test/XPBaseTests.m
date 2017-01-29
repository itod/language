//
//  XPBaseTests.m
//  XPTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "XPBaseTests.h"
#import "XPParser.h"
#import "XPExpression.h"
#import <PEGKit/PKAssembly.h>

@implementation XPBaseTests

- (void)setUp {
    [super setUp];
    
    self.expr = nil;
}

- (void)tearDown {
    self.expr = nil;
    
    [super tearDown];
}


- (NSArray *)tokenize:(NSString *)input {
    PKTokenizer *t = [self tokenizer];
    t.string = input;
    
    PKToken *tok = nil;
    PKToken *eof = [PKToken EOFToken];
    
    NSMutableArray *toks = [NSMutableArray array];
    
    while (eof != (tok = [t nextToken])) {
        [toks addObject:tok];
    }
    return toks;
}


- (PKTokenizer *)tokenizer {
    return [XPParser tokenizer];
}


- (XPParser *)parser {
    XPParser *p = [[[XPParser alloc] initWithDelegate:nil] autorelease];
    return p;
}


- (XPExpression *)expressionFromString:(NSString *)str error:(NSError **)outErr {
    TDTrue(self.parser);
    PKAssembly *a = [self.parser parseString:str error:outErr];
    
    XPExpression *expr = [a pop];
    
    expr = [expr simplify];
    return expr;
}


- (XPExpression *)expressionFromTokens:(NSArray *)toks error:(NSError **)outErr {
    TDTrue(self.parser);
    PKAssembly *a = [self.parser parseTokens:toks error:outErr];
    
    XPExpression *expr = [a pop];
    
    expr = [expr simplify];
    return expr;
}

@end
