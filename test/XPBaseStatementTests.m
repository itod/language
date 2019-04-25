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
    //p.allowNakedExpressions = YES;
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


- (void)exec:(NSString *)input {
    {
        self.stat = nil;
        self.interp = [[[XPInterpreter alloc] init] autorelease];
        self.error = nil;
    }
    
    NSError *err = nil;
    [self.interp interpretString:input filePath:nil error:&err];
    TDNil(err);
    self.error = err;
}


- (void)fail:(NSString *)input {
    {
        self.stat = nil;
        self.interp = [[[XPInterpreter alloc] init] autorelease];
        self.error = nil;
    }
    
    NSError *err = nil;
    [self.interp interpretString:input filePath:nil error:&err];
    TDNotNil(err);
    self.error = err;
}


- (id)eval:(NSString *)input {
    NSError *err = nil;
    id res = [self.interp interpretString:input filePath:nil error:&err];
    TDNil(err);
    self.error = err;
    
    return res;
}


- (NSString *)evalString:(NSString *)input {
    return [[self eval:input] reprValue];
}


- (BOOL)evalBool:(NSString *)input {
    return [[self eval:input] boolValue];
}


- (BOOL)boolForName:(NSString *)name {
    return [[self objectForName:name] boolValue];
}


- (double)doubleForName:(NSString *)name {
    return [[self objectForName:name] doubleValue];
}


- (NSString *)stringForName:(NSString *)name {
    return [[self objectForName:name] stringValue];
}


- (XPObject *)objectForName:(NSString *)name {
    XPObject *obj = [self.interp.globals objectForName:name];
    return obj;
}


- (NSString *)sourceForSelector:(SEL)sel {
    return [self stringFromFileNamed:NSStringFromSelector(sel)];
}


- (NSString *)stringFromFileNamed:(NSString *)filename {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:filename ofType:@"js"];
    //NSString *path = [[NSString stringWithFormat:@"%s/test/scripts/%@.js", getenv("PWD"), filename] stringByExpandingTildeInPath];
    TDNotNil(path);
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    TDNotNil(str);
    return str;
}

@end
