//
//  FNPosition.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNPosition.h"
#import <Language/XPObject.h>
#import <Language/XPTreeWalker.h>
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"
#import "XPClass.h"

@implementation FNPosition

+ (NSString *)name {
    return @"position";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    
    XPSymbol *col = [XPSymbol symbolWithName:@"collection"];
    XPSymbol *obj = [XPSymbol symbolWithName:@"object"];
    XPSymbol *identity = [XPSymbol symbolWithName:@"compareIdentity"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:col, obj, identity, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      col, @"collection",
                      obj, @"object",
                      identity, @"compareIdentity",
                      nil];
    
    [funcSym setDefaultObject:[XPObject falseObject] forParamNamed:@"compareIdentity"];
    
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc {
    XPObject *col = [space objectForName:@"collection"];
    TDAssert(col);
    XPObject *obj = [space objectForName:@"object"];
    TDAssert(obj);
    XPObject *identity = [space objectForName:@"compareIdentity"];
    
    if (![col.objectClass selectorForMethodNamed:@"position"]) {
        col = [col asStringObject];
    }
    
    TDAssert([col.objectClass selectorForMethodNamed:@"position"]);
    
    NSUInteger res = [[col callInstanceMethodNamed:@"position" withArgs:@[obj, identity]] unsignedIntegerValue];

    return [XPObject number:res];
}

@end
