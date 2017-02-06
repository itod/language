#import <PEGKit/PKParser.h>
        
    
#define XP_TOKEN_KIND_BLOCK -2
#define XP_TOKEN_KIND_CALL  -3
#define XP_TOKEN_KIND_ASSIGN_INDEX -4

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
    XP_TOKEN_KIND_IF = 21,
    XP_TOKEN_KIND_NOT_EQUAL = 22,
    XP_TOKEN_KIND_ELSE = 23,
    XP_TOKEN_KIND_BANG = 24,
    XP_TOKEN_KIND_SEMI_COLON = 25,
    XP_TOKEN_KIND_LT_SYM = 26,
    XP_TOKEN_KIND_MOD = 27,
    XP_TOKEN_KIND_EQUALS = 28,
    XP_TOKEN_KIND_LE = 29,
    XP_TOKEN_KIND_GT_SYM = 30,
    XP_TOKEN_KIND_LT = 31,
    XP_TOKEN_KIND_OPEN_PAREN = 32,
    XP_TOKEN_KIND_WHILE = 33,
    XP_TOKEN_KIND_VAR = 34,
    XP_TOKEN_KIND_CLOSE_PAREN = 35,
    XP_TOKEN_KIND_EQ = 36,
    XP_TOKEN_KIND_NE = 37,
    XP_TOKEN_KIND_OR = 38,
    XP_TOKEN_KIND_DOUBLE_PIPE = 39,
    XP_TOKEN_KIND_PLUS = 40,
    XP_TOKEN_KIND_TIMES = 41,
    XP_TOKEN_KIND_OPEN_BRACKET = 42,
    XP_TOKEN_KIND_COMMA = 43,
    XP_TOKEN_KIND_AND = 44,
    XP_TOKEN_KIND_NOT = 45,
    XP_TOKEN_KIND_MINUS = 46,
    XP_TOKEN_KIND_NULL = 47,
    XP_TOKEN_KIND_CLOSE_BRACKET = 48,
    XP_TOKEN_KIND_DOT = 49,
    XP_TOKEN_KIND_DIV = 50,
    XP_TOKEN_KIND_FALSE = 51,
    XP_TOKEN_KIND_SUB = 52,
    XP_TOKEN_KIND_LE_SYM = 53,
    XP_TOKEN_KIND_GE = 54,
    XP_TOKEN_KIND_DOUBLE_EQUALS = 55,
};

@interface XPParser : PKParser
        
+ (PKTokenizer *)tokenizer;

@property (nonatomic, retain) id <XPScope>currentScope;
@property (nonatomic, retain) XPGlobalScope *globalScope;
@property (nonatomic, assign) BOOL allowNakedExpressions;
@property (nonatomic, assign) BOOL foundDefaultParam;

@end

