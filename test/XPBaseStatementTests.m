//
//  XPBaseStatementTests.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseStatementTests.h"

@implementation XPBaseStatementTests

- (void)setUp {
    [super setUp];
    
    self.stat = nil;
    self.interp = [[[XPInterpreter alloc] init] autorelease];
    self.error = nil;
}

- (void)tearDown {
    self.stat = nil;
    self.interp = nil;
    self.error = nil;
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
    return stat;
}

    
- (XPNode *)statementFromTokens:(NSArray *)toks error:(NSError **)outErr {
    TDTrue(self.parser);
    PKAssembly *a = [self.parser parseTokens:toks error:outErr];
    
    XPNode *stat = [a pop];
    return stat;
}


- (void)eval:(NSString *)input {
    NSError *err = nil;
    [self.interp interpretString:input error:&err];
//    TDNil(err);
}


- (void)fail:(NSString *)input {
    NSError *err = nil;
    [self.interp interpretString:input error:&err];
    TDNotNil(err);
    self.error = err;
}


- (BOOL)boolForName:(NSString *)name {
    return [[self valueForName:name] boolValue];
}


- (double)doubleForName:(NSString *)name {
    return [[self valueForName:name] doubleValue];
}


- (NSString *)stringForName:(NSString *)name {
    return [[self valueForName:name] stringValue];
}


- (XPValue *)valueForName:(NSString *)name {
    return [self.interp.globals objectForName:name];
}

@end
