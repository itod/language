//
//  XPBreakpointCollection.m
//  Editor
//
//  Created by Todd Ditchendorf on 8/1/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <Language/XPBreakpointCollection.h>
#import <Language/XPBreakpoint.h>

@interface XPBreakpointCollection ()
@property (retain) NSMutableDictionary *all;
- (NSMutableSet *)mutableBreakpointsForFile:(NSString *)path;
@end

@implementation XPBreakpointCollection

+ (BOOL)supportsSecureCoding {
    return YES;
}


+ (instancetype)fromPlist:(NSDictionary *)plist {
    return [[[self alloc] initFromPlist:plist] autorelease];
}


- (id)init {
    self = [super init];
    if (self) {
        self.all = [NSMutableDictionary dictionary];
    }
    return self;
}


- (void)dealloc {
    self.all = nil;
    [super dealloc];
}


- (instancetype)initFromPlist:(NSDictionary *)plist {
    self = [super init];
    if (self) {
        self.all = [NSMutableDictionary dictionary];

        NSArray *plists = plist[@"all"];
        for (NSDictionary *d in plists) {
            XPBreakpoint *bp = [XPBreakpoint fromPlist:d];
            [self addBreakpoint:bp];
        }
    }
    return self;
}


- (NSDictionary *)asPlist {
    TDAssert(self.all);
    
    NSArray *bps = [self allBreakpoints];

    NSMutableArray *plists = [NSMutableArray arrayWithCapacity:[bps count]];
    for (XPBreakpoint *bp in bps) {
        [plists addObject:[bp asPlist]];
    }
    
    return @{@"all": plists};
}


- (id)copyWithZone:(NSZone *)zone {
    // deep copy
    NSDictionary *plist = [self asPlist];
    XPBreakpointCollection *col = [XPBreakpointCollection fromPlist:plist];
    return [col retain]; // +1
}


- (NSArray *)allBreakpoints {
    TDAssert(self.all);
    
    NSMutableArray *result = [NSMutableArray array];

    for (NSSet *bps in [self.all allValues]) {
        for (XPBreakpoint *bp in bps) {
            [result addObject:bp];
        }
    }
    
    return result;
}


- (NSArray *)allFiles {
    TDAssert(self.all);
    
    return [[self.all allKeys] sortedArrayUsingSelector:@selector(compare:)];
}


- (NSDictionary *)breakpointsDictionaryForFile:(NSString *)path {
    TDAssert(self.all);

    NSMutableDictionary *dict = nil;
    NSMutableSet *bps = [self mutableBreakpointsForFile:path];
    
    if (bps)     {
        dict = [NSMutableDictionary dictionaryWithCapacity:[bps count]];
        for (XPBreakpoint *bp in bps) {
            dict[@(bp.lineNumber)] = bp;
        }
    }
    
    return dict;
}


- (NSSet *)breakpointsForFile:(NSString *)path {
    return [[[self mutableBreakpointsForFile:path] copy] autorelease];
}


- (NSArray *)sortedBreakpointsForFile:(NSString *)path {
    return [[[self mutableBreakpointsForFile:path] allObjects] sortedArrayUsingSelector:@selector(compare:)];
}


- (NSMutableSet *)mutableBreakpointsForFile:(NSString *)path {
    TDAssert(self.all);
    TDAssert([path length]);

    NSMutableSet *result = self.all[path];
    return result;
}


- (void)addBreakpoint:(XPBreakpoint *)bp {
    TDAssert(self.all);
    TDAssert(bp);
    
    NSString *key = [[bp.file copy] autorelease];
    TDAssert([key length]);
    
    NSMutableSet *bps = [self mutableBreakpointsForFile:key];

    if (!bps) {
        bps = [NSMutableSet set];
        self.all[key] = bps;
    }
    
    [bps addObject:bp];
}


- (void)removeBreakpoint:(XPBreakpoint *)bp {
    TDAssert(self.all);

    NSString *key = [[bp.file copy] autorelease];
    TDAssert([key length]);
    
    NSMutableSet *bps = [self mutableBreakpointsForFile:key];
    TDAssert(bps);
    
    TDAssert([bps containsObject:bp]);
    [bps removeObject:bp];
    
    if (![bps count]) {
        [self removeBreakpointsForFile:key];
    }
}


- (void)removeBreakpointsForFile:(NSString *)path {
    TDAssert(self.all);
    TDAssert([path length]);

    [self.all removeObjectForKey:path];
}

@end
