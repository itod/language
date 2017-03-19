//
//  FNReplace.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNReplace.h"
#import "FNMatches.h"
#import <Language/XPObject.h>
#import "XPStringClass.h"
#import "XPFunctionSymbol.h"
#import <Language/XPTreeWalker.h>
#import "XPMemorySpace.h"
#import "XPException.h"

@implementation FNReplace

+ (NSString *)name {
    return @"replace";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    
    XPSymbol *input = [XPSymbol symbolWithName:@"input"];
    XPSymbol *pattern = [XPSymbol symbolWithName:@"pattern"];
    XPSymbol *replacement = [XPSymbol symbolWithName:@"replacement"];
    XPSymbol *flags = [XPSymbol symbolWithName:@"flags"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:input, pattern, replacement, flags, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      input, @"input",
                      pattern, @"pattern",
                      replacement, @"replacement",
                      flags, @"flags",
                      nil];
    
    [funcSym setDefaultObject:[XPObject string:@""] forParamNamed:@"flags"];
    
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker {
    XPMemorySpace *space = walker.currentSpace;
    TDAssert(space);

    NSString *res = @"";
    
    NSString *input = [[space objectForName:@"input"] stringValue];
    if ([input length]) {
        
        NSString *pattern = [[space objectForName:@"pattern"] stringValue];
        if ([pattern length]) {
            
            NSString *replacement = [[space objectForName:@"replacement"] stringValue];
            
            NSString *flags = [[space objectForName:@"flags"] stringValue];
            
            NSRegularExpressionOptions opts = [FNMatches regexOptionsForString:flags];
            
            //NSString *escapedStr = [NSRegularExpression escapedPatternForString:regexStr];
            
            NSError *err = nil;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:opts error:&err];
            if (!regex) {
                [XPException raise:XPExceptionRegexError format:@"could not create Regex from pattern '%@'", pattern];
            }
            
            res = [regex stringByReplacingMatchesInString:input options:NSMatchingReportCompletion range:NSMakeRange(0, [input length]) withTemplate:replacement];
        }
    }
    
    return [XPObject string:res];
}

@end
