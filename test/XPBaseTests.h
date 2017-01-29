//
//  XPBaseTests.m
//  XPTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"
#import "XPExpression.h"
#import "XPParser.h"

@class PKTokenizer;

@interface XPBaseTests : XCTestCase
- (NSArray *)tokenize:(NSString *)input;
- (PKTokenizer *)tokenizer;
- (XPParser *)parser;
- (XPExpression *)expressionFromString:(NSString *)str error:(NSError **)outErr;
- (XPExpression *)expressionFromTokens:(NSArray *)toks error:(NSError **)outErr;

@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, retain) PKTokenizer *t;
@end
