//
//  XPScopedSymbol.m
//  Language
//
//  Created by Todd Ditchendorf on 01.02.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPScopedSymbol.h"

@interface XPScopedSymbol ()
@property (nonatomic, retain, readwrite) id <XPScope>enclosingScope;
@end

@implementation XPScopedSymbol

- (instancetype)initWithName:(NSString *)name enclosingScope:(id <XPScope>)scope {
    self = [super initWithName:name];
    if (self) {
        self.enclosingScope = scope;
    }
    return self;
}


- (void)dealloc {
    self.enclosingScope = nil;
    [super dealloc];
}


- (NSMutableDictionary *)members {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (id <XPScope>)parentScope {
    return self.enclosingScope;
}


#pragma mark -
#pragma mark XPScope

- (NSString *)scopeName {
    return self.name;
}


- (void)defineSymbol:(XPSymbol *)sym {
    TDAssertMainThread();
    TDAssert(sym);
    TDAssert(self.members);
    
    [self.members setObject:sym forKey:sym.name];
    sym.scope = self;
}


- (XPSymbol *)resolveSymbolNamed:(NSString *)name {
    TDAssertMainThread();
    TDAssert([name length]);
    TDAssert(self.members);
    
    XPSymbol *sym = [self.members objectForKey:name];
    
    if (!sym) {
        sym = [self.parentScope resolveSymbolNamed:name];
    }
    
    return sym;
}


@end
