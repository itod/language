#import <PEGKit/PKParser.h>
        
@class PKTokenizer;
@class XPGlobalScope;
@protocol XPScope;

enum {
    XP_TOKEN_KIND_GT = 14,
    XP_TOKEN_KIND_OPEN_CURLY = 15,
    XP_TOKEN_KIND_GE_SYM = 16,
    XP_TOKEN_KIND_DOUBLE_AMPERSAND = 17,
    XP_TOKEN_KIND_CLOSE_CURLY = 18,
    XP_TOKEN_KIND_TRUE = 19,
    XP_TOKEN_KIND_NOT_EQUAL = 20,
    XP_TOKEN_KIND_BANG = 21,
    XP_TOKEN_KIND_SEMI_COLON = 22,
    XP_TOKEN_KIND_LT_SYM = 23,
    XP_TOKEN_KIND_MOD = 24,
    XP_TOKEN_KIND_EQUALS = 25,
    XP_TOKEN_KIND_LE = 26,
    XP_TOKEN_KIND_GT_SYM = 27,
    XP_TOKEN_KIND_LT = 28,
    XP_TOKEN_KIND_OPEN_PAREN = 29,
    XP_TOKEN_KIND_VAR = 30,
    XP_TOKEN_KIND_EQ = 31,
    XP_TOKEN_KIND_CLOSE_PAREN = 32,
    XP_TOKEN_KIND_NE = 33,
    XP_TOKEN_KIND_OR = 34,
    XP_TOKEN_KIND_NOT = 35,
    XP_TOKEN_KIND_PLUS = 36,
    XP_TOKEN_KIND_TIMES = 37,
    XP_TOKEN_KIND_DOUBLE_PIPE = 38,
    XP_TOKEN_KIND_COMMA = 39,
    XP_TOKEN_KIND_AND = 40,
    XP_TOKEN_KIND_MINUS = 41,
    XP_TOKEN_KIND_DOT = 42,
    XP_TOKEN_KIND_DIV = 43,
    XP_TOKEN_KIND_FALSE = 44,
    XP_TOKEN_KIND_SUB = 45,
    XP_TOKEN_KIND_LE_SYM = 46,
    XP_TOKEN_KIND_GE = 47,
    XP_TOKEN_KIND_DOUBLE_EQUALS = 48,
};

@interface XPParser : PKParser
        
+ (PKTokenizer *)tokenizer;

@property (nonatomic, retain) id <XPScope>currentScope;
@property (nonatomic, retain) XPGlobalScope *globalScope;
@property (nonatomic, assign) BOOL allowNakedExpressions;

@end

