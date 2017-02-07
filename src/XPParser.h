#import <PEGKit/PKParser.h>
        
    
#define XP_TOKEN_KIND_BLOCK -2
#define XP_TOKEN_KIND_CALL  -3
#define XP_TOKEN_KIND_ASSIGN_INDEX -4
#define XP_TOKEN_KIND_ASSIGN_APPEND -5
#define XP_TOKEN_KIND_NEG -6
#define XP_TOKEN_KIND_REF -7
#define XP_TOKEN_KIND_INDEX -8

@class PKTokenizer;
@class XPGlobalScope;
@protocol XPScope;

enum {
    XP_TOKEN_KIND_OPEN_CURLY = 14,
    XP_TOKEN_KIND_GE = 15,
    XP_TOKEN_KIND_CLOSE_CURLY = 16,
    XP_TOKEN_KIND_TRUE = 17,
    XP_TOKEN_KIND_RETURN = 18,
    XP_TOKEN_KIND_IF = 19,
    XP_TOKEN_KIND_NE = 20,
    XP_TOKEN_KIND_BANG = 21,
    XP_TOKEN_KIND_ELSE = 22,
    XP_TOKEN_KIND_SEMI_COLON = 23,
    XP_TOKEN_KIND_LT = 24,
    XP_TOKEN_KIND_MOD = 25,
    XP_TOKEN_KIND_EQUALS = 26,
    XP_TOKEN_KIND_GT = 27,
    XP_TOKEN_KIND_OPEN_PAREN = 28,
    XP_TOKEN_KIND_WHILE = 29,
    XP_TOKEN_KIND_VAR = 30,
    XP_TOKEN_KIND_CLOSE_PAREN = 31,
    XP_TOKEN_KIND_TIMES = 32,
    XP_TOKEN_KIND_OR = 33,
    XP_TOKEN_KIND_NULL = 34,
    XP_TOKEN_KIND_PLUS = 35,
    XP_TOKEN_KIND_NOT = 36,
    XP_TOKEN_KIND_OPEN_BRACKET = 37,
    XP_TOKEN_KIND_COMMA = 38,
    XP_TOKEN_KIND_AND = 39,
    XP_TOKEN_KIND_MINUS = 40,
    XP_TOKEN_KIND_CLOSE_BRACKET = 41,
    XP_TOKEN_KIND_DOT = 42,
    XP_TOKEN_KIND_DIV = 43,
    XP_TOKEN_KIND_FALSE = 44,
    XP_TOKEN_KIND_SUB = 45,
    XP_TOKEN_KIND_LE = 46,
    XP_TOKEN_KIND_EQ = 47,
};

@interface XPParser : PKParser
        
+ (PKTokenizer *)tokenizer;

@property (nonatomic, retain) id <XPScope>currentScope;
@property (nonatomic, retain) XPGlobalScope *globalScope;
@property (nonatomic, assign) BOOL allowNakedExpressions;
@property (nonatomic, assign) BOOL foundDefaultParam;

@end

