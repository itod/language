//
//  XPBaseStatementTests.h
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseTests.h"

@interface XPBaseStatementTests : XPBaseTests
- (XPStatement *)statementFromString:(NSString *)str error:(NSError **)outErr;
- (XPStatement *)statementFromTokens:(NSArray *)toks error:(NSError **)outErr;

@property (nonatomic, retain) XPStatement *stat;
@end