//
//  XPBaseStatementTests.h
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseTests.h"
#import "XPNode.h"
#import "XPValue.h"
#import "XPMemorySpace.h"
#import "XPInterpreter.h"

@interface XPBaseStatementTests : XPBaseTests
- (XPNode *)statementFromString:(NSString *)str error:(NSError **)outErr;
- (XPNode *)statementFromTokens:(NSArray *)toks error:(NSError **)outErr;

- (void)eval:(NSString *)input;
- (void)fail:(NSString *)input;

- (BOOL)boolForName:(NSString *)name;
- (double)doubleForName:(NSString *)name;
- (NSString *)stringForName:(NSString *)name;
- (XPValue *)valueForName:(NSString *)name;

@property (nonatomic, retain) XPNode *stat;
@property (nonatomic, retain) XPInterpreter *interp;
@property (nonatomic, retain) NSError *error;
@end
