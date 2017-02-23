//
//  XPStackFrame.m
//  Language
//
//  Created by Todd Ditchendorf on 2/23/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPStackFrame.h"

@implementation XPStackFrame

- (void)dealloc {
    self.filename = nil;
    self.functionName = nil;
    self.sortedLocalNames = nil;
    self.sortedLocalValues = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %@:%@ %ld>", [self class], self.filename, self.functionName, [self.sortedLocalNames count]];
}


- (void)setMembers:(NSDictionary *)members {
    NSUInteger c = [members count];

    NSMutableArray *names = [NSMutableArray arrayWithCapacity:c];
    [names addObjectsFromArray:[members allKeys]];
    [names sortUsingSelector:@selector(caseInsensitiveCompare:)];
    
    NSMutableArray *vals = [NSMutableArray arrayWithCapacity:c];
    for (NSString *name in names) {
        id val = members[name];
        TDAssert(val);
        [vals addObject:val];
    }
    
    self.sortedLocalNames = names;
    self.sortedLocalValues = vals;
}

@end
