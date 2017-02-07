#import <PEGKit/PKParser.h>
        
    
#define XP_TOKEN_KIND_BLOCK -2
#define XP_TOKEN_KIND_CALL  -3
#define XP_TOKEN_KIND_ASSIGN_INDEX -4
#define XP_TOKEN_KIND_ASSIGN_APPEND -5

@class PKTokenizer;
@class XPGlobalScope;
@protocol XPScope;

enum {
    XP_TOKEN_KIND_GT = 14,
    XP_TOKEN_KIND_OPEN_CURLY = 15,
    XP_TOKEN_KIND_GE_SYM = 16,
    XP_TOKEN_KIND_CLOSE_CURLY = 17,
    XP_TOKEN_KIND_TRUE = 18,
    XP_TOKEN_KIND_RETURN = 19,
    XP_TOKEN_KIND_IF = 20,
    XP_TOKEN_KIND_NOT_EQUAL = 21,
    XP_TOKEN_KIND_ELSE = 22,
    XP_TOKEN_KIND_BANG = 23,
    XP_TOKEN_KIND_SEMI_COLON = 24,
    XP_TOKEN_KIND_LT_SYM = 25,
    XP_TOKEN_KIND_MOD = 26,
    XP_TOKEN_KIND_EQUALS = 27,
    XP_TOKEN_KIND_LE = 28,
    XP_TOKEN_KIND_GT_SYM = 29,
    XP_TOKEN_KIND_LT = 30,
    XP_TOKEN_KIND_OPEN_PAREN = 31,
    XP_TOKEN_KIND_WHILE = 32,
    XP_TOKEN_KIND_VAR = 33,
    XP_TOKEN_KIND_CLOSE_PAREN = 34,
    XP_TOKEN_KIND_EQ = 35,
    XP_TOKEN_KIND_TIMES = 36,
    XP_TOKEN_KIND_OROP = 37,
    XP_TOKEN_KIND_NE = 38,
    XP_TOKEN_KIND_PLUS = 39,
    XP_TOKEN_KIND_NOT = 40,
    XP_TOKEN_KIND_OPEN_BRACKET = 41,
    XP_TOKEN_KIND_COMMA = 42,
    XP_TOKEN_KIND_ANDOP = 43,
    XP_TOKEN_KIND_NULL = 44,
    XP_TOKEN_KIND_MINUS = 45,
    XP_TOKEN_KIND_CLOSE_BRACKET = 46,
    XP_TOKEN_KIND_DOT = 47,
    XP_TOKEN_KIND_DIV = 48,
    XP_TOKEN_KIND_FALSE = 49,
    XP_TOKEN_KIND_SUB = 50,
    XP_TOKEN_KIND_LE_SYM = 51,
    XP_TOKEN_KIND_GE = 52,
    XP_TOKEN_KIND_DOUBLE_EQUALS = 53,
};

@interface XPParser : PKParser
        
+ (PKTokenizer *)tokenizer;

@property (nonatomic, retain) id <XPScope>currentScope;
@property (nonatomic, retain) XPGlobalScope *globalScope;
@property (nonatomic, assign) BOOL allowNakedExpressions;
@property (nonatomic, assign) BOOL foundDefaultParam;

@end

