//
//  FNReplace.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNReplace.h"
#import "FNMatches.h"
#import "XPObject.h"
#import "XPStringClass.h"
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"
#import "XPException.h"

@implementation FNReplace

+ (NSRegularExpressionOptions)regexOptionsForString:(NSString *)flags {
    NSRegularExpressionOptions opts = 0;
    
    if ([flags length]) {
        if ([flags rangeOfString:@"i"].length) {
            opts |= NSRegularExpressionCaseInsensitive;
        }
        
        if ([flags rangeOfString:@"m"].length) {
            opts |= NSRegularExpressionAnchorsMatchLines;
        }
        
        if ([flags rangeOfString:@"x"].length) {
            opts |= NSRegularExpressionAllowCommentsAndWhitespace;
        }
        
        if ([flags rangeOfString:@"s"].length) {
            opts |= NSRegularExpressionDotMatchesLineSeparators;
        }
        
        if ([flags rangeOfString:@"u"].length) {
            opts |= NSRegularExpressionUseUnicodeWordBoundaries;
        }
    }
    
    return opts;
}


+ (NSString *)name {
    return @"matches";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    
    XPSymbol *input = [XPSymbol symbolWithName:@"input"];
    XPSymbol *pattern = [XPSymbol symbolWithName:@"pattern"];
    XPSymbol *flags = [XPSymbol symbolWithName:@"flags"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:input, pattern, flags, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      input, @"input",
                      pattern, @"pattern",
                      flags, @"flags",
                      nil];
    
    [funcSym setDefaultObject:[XPStringClass instanceWithValue:@""] forParamNamed:@"flags"];
    
    return funcSym;
}


- (XPObject *)callInSpace:(XPMemorySpace *)space {
    TDAssert(space);
    
    BOOL res = NO;
    
    NSString *input = [[space objectForName:@"input"] stringValue];
    
    if ([input length]) {
        
        NSString *pattern = [[space objectForName:@"pattern"] stringValue];
        if ([pattern length]) {
            
            NSString *flags = [[space objectForName:@"flags"] stringValue];
            NSRegularExpressionOptions opts = [FNMatches regexOptionsForString:flags];
            
            //NSString *escapedStr = [NSRegularExpression escapedPatternForString:regexStr];
            
            NSError *err = nil;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:opts error:&err];
            if (!regex) {
                [XPException raise:XPExceptionRuntimeError format:@"could not create Regex from pattern '%@'", pattern];
            }
            
            NSUInteger numMatches = [[regex matchesInString:input options:0 range:NSMakeRange(0, [input length])] count];
            NSAssert(NSNotFound != numMatches, @"this would be surprising");
            
            if (NSNotFound == numMatches || 0 == numMatches) {
                res = NO;
            } else {
                res = YES;
            }
        }
    }
    
    return [XPObject boolean:res];
}

@end
