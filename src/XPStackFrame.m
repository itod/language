//
//  XPStackFrame.m
//  Language
//
//  Created by Todd Ditchendorf on 2/23/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPStackFrame.h"
#import <Language/XPObject.h>

@implementation XPStackFrame

- (void)dealloc {
    self.filePath = nil;
    self.functionName = nil;
    self.sortedLocalNames = nil;
    self.sortedLocalValues = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %@:%ld:%@ %ld>", [self class], [self.filePath lastPathComponent], self.lineNumber, self.functionName, [self.sortedLocalNames count]];
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
        
        [names addObject:name];
        [vals addObject:val];
    }
    
    self.sortedLocalNames = names;
    self.sortedLocalValues = vals;
}


- (NSDictionary *)members {
    NSUInteger c = [_sortedLocalNames count];
    
    NSMutableDictionary *mems = [NSMutableDictionary dictionaryWithCapacity:c];
    NSUInteger i = 0;
    for (NSString *name in _sortedLocalNames) {
        id val = _sortedLocalValues[i++];
        [mems setObject:val forKey:name];
    }
    
    return mems;
}

@end
