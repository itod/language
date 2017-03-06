//
//  XPStackFrame.m
//  Language
//
//  Created by Todd Ditchendorf on 2/23/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPStackFrame.h"
#import "XPObject.h"

@implementation XPStackFrame

- (void)dealloc {
    self.filePath = nil;
    self.functionName = nil;
    self.sortedLocalNames = nil;
    self.sortedLocalValues = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %@:%@ %ld>", [self class], [self.filePath lastPathComponent], self.functionName, [self.sortedLocalNames count]];
}


- (void)setMembers:(NSDictionary *)members {
    NSUInteger c = [members count];

    NSMutableArray *allNames = [NSMutableArray arrayWithCapacity:c];
    [allNames addObjectsFromArray:[members allKeys]];
    [allNames sortUsingSelector:@selector(caseInsensitiveCompare:)];

    NSMutableArray *names = [NSMutableArray arrayWithCapacity:c];
    NSMutableArray *vals = [NSMutableArray arrayWithCapacity:c];
    for (NSString *name in allNames) {
        XPObject *val = members[name];
        TDAssert(val);
        
        if (!val.isNative) {
            [names addObject:name];
            [vals addObject:val];
        }
    }
    
    self.sortedLocalNames = names;
    self.sortedLocalValues = vals;
}

@end
