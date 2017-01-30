//
//  XPBaseTests.m
//  XPTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "XPBaseTests.h"
#import "XPParser.h"
#import <PEGKit/PKAssembly.h>

@implementation XPBaseTests

- (void)setUp {
    [super setUp];
    //
}

- (void)tearDown {
    //
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

@end
