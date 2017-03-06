//
//  XPBreakpoint.m
//  OkudaKit
//
//  Created by Todd Ditchendorf on 7/14/13.
//
//

#import "XPBreakpoint.h"

@implementation XPBreakpoint

+ (instancetype)breakpointWithType:(NSUInteger)type file:(NSString *)path name:(NSString *)name lineNumber:(NSUInteger)lineNum enabled:(BOOL)enabled {
    XPBreakpoint *bp = [[[XPBreakpoint alloc] initWithType:type file:path name:name lineNumber:lineNum enabled:enabled] autorelease];
    return bp;
}


+ (BOOL)supportsSecureCoding {
    return YES;
}


- (instancetype)initWithType:(NSUInteger)type file:(NSString *)path name:(NSString *)name lineNumber:(NSUInteger)lineNum enabled:(BOOL)enabled {
    self = [super init];
    if (self) {
        self.type = type;
        self.file = path;
        self.name = name ? name : @"";
        self.lineNumber = lineNum;
        self.enabled = enabled;
    }
    return self;
}


- (void)dealloc {
    self.file = nil;
    self.name = nil;
    [super dealloc];
}


+ (instancetype)fromPlist:(NSDictionary *)plist {
    return [[[self alloc] initFromPlist:plist] autorelease];
}


- (instancetype)initFromPlist:(NSDictionary *)plist {
    self = [super init];
    if (self) {
        self.type = [plist[@"type"] integerValue];
        self.file = plist[@"file"];
        self.name = plist[@"name"];
        self.lineNumber = [plist[@"lineNumber"] unsignedIntegerValue];
        self.enabled = [plist[@"enabled"] boolValue];
    }
    return self;
}


- (NSMutableDictionary *)asPlist {
    TDAssert(_file);
    TDAssert(_name);
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            @(_type), @"type",
            _file, @"file",
            _name, @"name",
            @(_lineNumber), @"lineNumber",
            @(_enabled), @"enabled",
            nil];
}


//- (instancetype)initWithCoder:(NSCoder *)coder {
//    self.type = [[coder decodeObjectOfClass:[NSNumber class] forKey:@"type"] unsignedIntegerValue];
//    self.file = [coder decodeObjectOfClass:[NSString class] forKey:@"file"];
//    self.name = [coder decodeObjectOfClass:[NSString class] forKey:@"name"];
//    self.lineNumber = [[coder decodeObjectOfClass:[NSNumber class] forKey:@"lineNumber"] unsignedIntegerValue];
//    self.enabled = [[coder decodeObjectOfClass:[NSNumber class] forKey:@"enabled"] boolValue];
//    return self;
//}
//
//
//- (void)encodeWithCoder:(NSCoder *)coder {
//    [coder encodeObject:[NSNumber numberWithUnsignedInteger:_type] forKey:@"type"];
//    [coder encodeObject:_file forKey:@"file"];
//    [coder encodeObject:_name forKey:@"name"];
//    [coder encodeObject:[NSNumber numberWithUnsignedInteger:_lineNumber] forKey:@"lineNumber"];
//    [coder encodeObject:[NSNumber numberWithBool:_enabled] forKey:@"enabled"];
//}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p %@ %lu %@>", [self class], self, [_file lastPathComponent], _lineNumber, (_enabled ? @"enabled" : @"disabled")];
}


- (id)copyWithZone:(NSZone *)zone {
    XPBreakpoint *bp = [[XPBreakpoint alloc] initWithType:_type file:_file name:_name lineNumber:_lineNumber enabled:_enabled];
    return bp;
}


//- (NSUInteger)hash {
//    return [_file hash] + _lineNumber; // TODO check overflow
//}


- (BOOL)isEqual:(id)obj {
    if (obj == self) {
        return YES;
    }
    
    if (![obj isKindOfClass:[XPBreakpoint class]]) {
        return NO;
    }
    
    XPBreakpoint *bp = (XPBreakpoint *)obj;
    
    if (_type != bp->_type) {
        return NO;
    }
    
    if (_lineNumber != bp->_lineNumber) {
        return NO;
    }
    
    if (![_file isEqualToString:bp->_file]) {
        return NO;
    }
    
    if (![_name isEqualToString:bp->_name]) {
        return NO;
    }
    
    return YES;
}


- (NSComparisonResult)compare:(XPBreakpoint *)bp {
    NSComparisonResult result = [_file compare:bp->_file];

    if (NSOrderedSame == result) {
        if (_lineNumber < bp->_lineNumber) {
            result = NSOrderedAscending;
        } else if (_lineNumber > bp->_lineNumber) {
            result = NSOrderedDescending;
        } else {
            result = NSOrderedSame;
        }
    }
    
    return result;
}


- (NSDictionary *)plist {
    TDAssert(0 == _type); // unused
    TDAssert(_file);
    TDAssert(_name);
    NSDictionary *dict = @{@"type": @(_type), @"file": _file, @"name": _name, @"lineNumber": @(_lineNumber), @"enabled": @(_enabled)};
    return dict;
}


- (NSString *)displayString {
    return [NSString stringWithFormat:NSLocalizedString(@"line %d", @""), _lineNumber];
}

@end
