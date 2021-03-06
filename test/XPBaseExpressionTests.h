//
//  XPBaseExpressionTests.h
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseTests.h"

@interface XPBaseExpressionTests : XPBaseTests
- (id)expressionFromString:(NSString *)str error:(NSError **)outErr;
- (id)expressionFromTokens:(NSArray *)toks error:(NSError **)outErr;

@property (nonatomic, retain) id expr;
@end
