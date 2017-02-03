//
//  XPFunctionValue.m
//  Language
//
//  Created by Todd Ditchendorf on 03.02.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPFunctionValue.h"

@implementation XPFunctionValue

- (NSString *)stringValue {
    return @"<ANON>";
}


- (id)objectValue {
    return [self stringValue];
}


- (double)doubleValue {
    return 1.0;
}


- (BOOL)boolValue {
    return YES;
}


- (XPDataType)dataType {
    return XPDataTypeObject; // TODO
}


- (void)display:(NSInteger)level {
    //NSLog(@"%@boolean (%@)", [self indent:level], [self stringValue]);
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<XPFunctionValue %@>", [self stringValue]];
}


- (BOOL)isFunctionValue {
    return YES;
}

@end
