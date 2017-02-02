#import <PEGKit/PKParser.h>
        
    
#define XP_TOKEN_KIND_BLOCK -2
#define XP_TOKEN_KIND_CALL  -3
#define XP_TOKEN_KIND_FUNC_DECL -4
#define XP_TOKEN_KIND_VAR_REF -5
    
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
    XP_TOKEN_KIND_RETURN = 20,
    XP_TOKEN_KIND_NOT_EQUAL = 21,
    XP_TOKEN_KIND_BANG = 22,
    XP_TOKEN_KIND_SEMI_COLON = 23,
    XP_TOKEN_KIND_LT_SYM = 24,
    XP_TOKEN_KIND_MOD = 25,
    XP_TOKEN_KIND_EQUALS = 26,
    XP_TOKEN_KIND_LE = 27,
    XP_TOKEN_KIND_GT_SYM = 28,
    XP_TOKEN_KIND_LT = 29,
    XP_TOKEN_KIND_OPEN_PAREN = 30,
    XP_TOKEN_KIND_VAR = 31,
    XP_TOKEN_KIND_EQ = 32,
    XP_TOKEN_KIND_CLOSE_PAREN = 33,
    XP_TOKEN_KIND_NE = 34,
    XP_TOKEN_KIND_OR = 35,
    XP_TOKEN_KIND_NOT = 36,
    XP_TOKEN_KIND_PLUS = 37,
    XP_TOKEN_KIND_TIMES = 38,
    XP_TOKEN_KIND_DOUBLE_PIPE = 39,
    XP_TOKEN_KIND_COMMA = 40,
    XP_TOKEN_KIND_AND = 41,
    XP_TOKEN_KIND_MINUS = 42,
    XP_TOKEN_KIND_DOT = 43,
    XP_TOKEN_KIND_DIV = 44,
    XP_TOKEN_KIND_FALSE = 45,
    XP_TOKEN_KIND_SUB = 46,
    XP_TOKEN_KIND_LE_SYM = 47,
    XP_TOKEN_KIND_GE = 48,
    XP_TOKEN_KIND_DOUBLE_EQUALS = 49,
};

@interface XPParser : PKParser
        
+ (PKTokenizer *)tokenizer;

@property (nonatomic, retain) id <XPScope>currentScope;
@property (nonatomic, retain) XPGlobalScope *globalScope;
@property (nonatomic, assign) BOOL allowNakedExpressions;

@end

