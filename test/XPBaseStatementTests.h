//
//  XPBaseStatementTests.h
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseTests.h"
#import "XPNode.h"
#import "XPMemorySpace.h"

@interface XPBaseStatementTests : XPBaseTests
- (XPNode *)statementFromString:(NSString *)str error:(NSError **)outErr;
- (XPNode *)statementFromTokens:(NSArray *)toks error:(NSError **)outErr;

@property (nonatomic, retain) XPNode *stat;
@end
