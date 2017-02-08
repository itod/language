#import <PEGKit/PKParser.h>
        
    
#define XP_TOKEN_KIND_BLOCK -2
#define XP_TOKEN_KIND_CALL  -3
#define XP_TOKEN_KIND_ASSIGN_INDEX -4
#define XP_TOKEN_KIND_ASSIGN_APPEND -5
#define XP_TOKEN_KIND_NEG -6
#define XP_TOKEN_KIND_LOAD -7
#define XP_TOKEN_KIND_LOAD_INDEX -8

@class PKTokenizer;
@class XPGlobalScope;
@protocol XPScope;

enum {
    XP_TOKEN_KIND_OPEN_CURLY = 14,
    XP_TOKEN_KIND_GE = 15,
    XP_TOKEN_KIND_BREAK = 16,
    XP_TOKEN_KIND_CLOSE_CURLY = 17,
    XP_TOKEN_KIND_RETURN = 18,
    XP_TOKEN_KIND_TRUE = 19,
    XP_TOKEN_KIND_IF = 20,
    XP_TOKEN_KIND_NE = 21,
    XP_TOKEN_KIND_BANG = 22,
    XP_TOKEN_KIND_ELSE = 23,
    XP_TOKEN_KIND_CONTINUE = 24,
    XP_TOKEN_KIND_SEMI_COLON = 25,
    XP_TOKEN_KIND_LT = 26,
    XP_TOKEN_KIND_MOD = 27,
    XP_TOKEN_KIND_EQUALS = 28,
    XP_TOKEN_KIND_GT = 29,
    XP_TOKEN_KIND_OPEN_PAREN = 30,
    XP_TOKEN_KIND_WHILE = 31,
    XP_TOKEN_KIND_VAR = 32,
    XP_TOKEN_KIND_CLOSE_PAREN = 33,
    XP_TOKEN_KIND_TIMES = 34,
    XP_TOKEN_KIND_OR = 35,
    XP_TOKEN_KIND_NULL = 36,
    XP_TOKEN_KIND_PLUS = 37,
    XP_TOKEN_KIND_NOT = 38,
    XP_TOKEN_KIND_OPEN_BRACKET = 39,
    XP_TOKEN_KIND_COMMA = 40,
    XP_TOKEN_KIND_AND = 41,
    XP_TOKEN_KIND_MINUS = 42,
    XP_TOKEN_KIND_CLOSE_BRACKET = 43,
    XP_TOKEN_KIND_DIV = 44,
    XP_TOKEN_KIND_FALSE = 45,
    XP_TOKEN_KIND_SUB = 46,
    XP_TOKEN_KIND_LE = 47,
    XP_TOKEN_KIND_EQ = 48,
};

@interface XPParser : PKParser
        
+ (PKTokenizer *)tokenizer;

@property (nonatomic, retain) id <XPScope>currentScope;
@property (nonatomic, retain) XPGlobalScope *globalScope;
@property (nonatomic, assign) BOOL allowNakedExpressions;
@property (nonatomic, assign) BOOL foundDefaultParam;

@end

