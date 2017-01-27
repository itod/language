#import <PEGKit/PKParser.h>
        
@class PKTokenizer;

enum {
    XP_TOKEN_KIND_GE = 14,
    XP_TOKEN_KIND_COMMA = 15,
    XP_TOKEN_KIND_MINUS = 16,
    XP_TOKEN_KIND_GE_SYM = 17,
    XP_TOKEN_KIND_DOUBLE_AMPERSAND = 18,
    XP_TOKEN_KIND_DOT = 19,
    XP_TOKEN_KIND_LT_SYM = 20,
    XP_TOKEN_KIND_NOT_EQUAL = 21,
    XP_TOKEN_KIND_DIV = 22,
    XP_TOKEN_KIND_BANG = 23,
    XP_TOKEN_KIND_TRUE = 24,
    XP_TOKEN_KIND_OR = 25,
    XP_TOKEN_KIND_GT_SYM = 26,
    XP_TOKEN_KIND_NE = 27,
    XP_TOKEN_KIND_LE_SYM = 28,
    XP_TOKEN_KIND_AND = 29,
    XP_TOKEN_KIND_MOD = 30,
    XP_TOKEN_KIND_LT = 31,
    XP_TOKEN_KIND_FALSE = 32,
    XP_TOKEN_KIND_TO = 33,
    XP_TOKEN_KIND_LE = 34,
    XP_TOKEN_KIND_BY = 35,
    XP_TOKEN_KIND_NOT = 36,
    XP_TOKEN_KIND_IN = 37,
    XP_TOKEN_KIND_DOUBLE_EQUALS = 38,
    XP_TOKEN_KIND_EQ = 39,
    XP_TOKEN_KIND_GT = 40,
    XP_TOKEN_KIND_TIMES = 41,
    XP_TOKEN_KIND_OPEN_PAREN = 42,
    XP_TOKEN_KIND_CLOSE_PAREN = 43,
    XP_TOKEN_KIND_PLUS = 44,
    XP_TOKEN_KIND_DOUBLE_PIPE = 45,
};

@interface XPParser : PKParser
        
+ (PKTokenizer *)tokenizer;

@property (nonatomic, assign) BOOL doLoopExpr;

@end

