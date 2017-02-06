//
//  XPArrayValue.m
//  Language
//
//  Created by Todd Ditchendorf on 2/5/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPArrayValue.h"

@interface XPArrayValue ()
//@property (nonatomic, retain) NSMutableArray *value;
@end

@implementation XPArrayValue

- (instancetype)initWithToken:(PKToken *)tok {
    self = [super initWithToken:tok];
    if (self) {
//        self.value = [NSMutableArray array];
    }
    return self;
}


- (void)dealloc {
//    self.value = nil;
    [super dealloc];
}


- (NSString *)stringValue {
    NSMutableString *buf = [NSMutableString stringWithString:@"["];
    
    TDAssert(self.children);
    for (id obj in self.children) {
        [buf appendFormat:@"%@,", [obj stringValue]];
    }
    
    [buf appendString:@"]"];
    
    return buf;
}


- (id)objectValue {
    TDAssert(self.children);
    return self.children;
}


- (double)doubleValue {
    return self.boolValue ? 1.0 : 0.0;
}


- (BOOL)boolValue {
    return [self childCount] > 0;
}


- (XPDataType)dataType {
    return XPDataTypeObject; // TODO
}


- (void)display:(NSInteger)level {
    //NSLog(@"%@boolean (%@)", [self indent:level], [self stringValue]);
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<XPArrayValue %@>", [self stringValue]];
}


- (BOOL)isArrayValue {
    return YES;
}

@end
