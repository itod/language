#import <PEGKit/PKParser.h>
        
    
#define XP_TOKEN_KIND_BLOCK -2
#define XP_TOKEN_KIND_CALL  -3
#define XP_TOKEN_KIND_ASSIGN_INDEX -4
#define XP_TOKEN_KIND_ASSIGN_APPEND -5
#define XP_TOKEN_KIND_NEG -6
#define XP_TOKEN_KIND_LOAD -7
#define XP_TOKEN_KIND_LOAD_INDEX -8
#define XP_TOKEN_KIND_FUNC_LITERAL -9

@class PKTokenizer;
@class XPGlobalScope;
@class XPMemorySpace;
@protocol XPScope;

enum {
    XP_TOKEN_KIND_OPEN_CURLY = 14,
    XP_TOKEN_KIND_GE = 15,
    XP_TOKEN_KIND_FOR = 16,
    XP_TOKEN_KIND_BREAK = 17,
    XP_TOKEN_KIND_CLOSE_CURLY = 18,
    XP_TOKEN_KIND_RETURN = 19,
    XP_TOKEN_KIND_TRUE = 20,
    XP_TOKEN_KIND_IF = 21,
    XP_TOKEN_KIND_NE = 22,
    XP_TOKEN_KIND_ELSE = 23,
    XP_TOKEN_KIND_BANG = 24,
    XP_TOKEN_KIND_CONTINUE = 25,
    XP_TOKEN_KIND_SEMI_COLON = 26,
    XP_TOKEN_KIND_LT = 27,
    XP_TOKEN_KIND_MOD = 28,
    XP_TOKEN_KIND_EQUALS = 29,
    XP_TOKEN_KIND_GT = 30,
    XP_TOKEN_KIND_OPEN_PAREN = 31,
    XP_TOKEN_KIND_WHILE = 32,
    XP_TOKEN_KIND_VAR = 33,
    XP_TOKEN_KIND_CLOSE_PAREN = 34,
    XP_TOKEN_KIND_TIMES = 35,
    XP_TOKEN_KIND_OR = 36,
    XP_TOKEN_KIND_NOT = 37,
    XP_TOKEN_KIND_PLUS = 38,
    XP_TOKEN_KIND_NULL = 39,
    XP_TOKEN_KIND_OPEN_BRACKET = 40,
    XP_TOKEN_KIND_COMMA = 41,
    XP_TOKEN_KIND_AND = 42,
    XP_TOKEN_KIND_MINUS = 43,
    XP_TOKEN_KIND_IN = 44,
    XP_TOKEN_KIND_CLOSE_BRACKET = 45,
    XP_TOKEN_KIND_DIV = 46,
    XP_TOKEN_KIND_FALSE = 47,
    XP_TOKEN_KIND_SUB = 48,
    XP_TOKEN_KIND_LE = 49,
    XP_TOKEN_KIND_EQ = 50,
};

@interface XPParser : PKParser
        
+ (PKTokenizer *)tokenizer;

@property (nonatomic, retain) id <XPScope>currentScope;
@property (nonatomic, retain) XPGlobalScope *globalScope;
@property (nonatomic, retain) XPMemorySpace *globals;
@property (nonatomic, assign) BOOL foundDefaultParam;

@end

