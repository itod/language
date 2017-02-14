#import <PEGKit/PKParser.h>
        
    
#define XP_TOKEN_KIND_BLOCK -2
#define XP_TOKEN_KIND_CALL  -3
#define XP_TOKEN_KIND_APPEND -4
#define XP_TOKEN_KIND_SAVE_SUBSCRIPT -5
#define XP_TOKEN_KIND_LOAD_SUBSCRIPT -6
#define XP_TOKEN_KIND_NEG -7
#define XP_TOKEN_KIND_LOAD -8
#define XP_TOKEN_KIND_FUNC_LITERAL -9
#define XP_TOKEN_KIND_ARRAY_LITERAL -10
#define XP_TOKEN_KIND_DICT_LITERAL -11

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
    XP_TOKEN_KIND_COLON = 26,
    XP_TOKEN_KIND_SEMI_COLON = 27,
    XP_TOKEN_KIND_LT = 28,
    XP_TOKEN_KIND_MOD = 29,
    XP_TOKEN_KIND_EQUALS = 30,
    XP_TOKEN_KIND_GT = 31,
    XP_TOKEN_KIND_OPEN_PAREN = 32,
    XP_TOKEN_KIND_WHILE = 33,
    XP_TOKEN_KIND_VAR = 34,
    XP_TOKEN_KIND_CLOSE_PAREN = 35,
    XP_TOKEN_KIND_TIMES = 36,
    XP_TOKEN_KIND_OR = 37,
    XP_TOKEN_KIND_NOT = 38,
    XP_TOKEN_KIND_PLUS = 39,
    XP_TOKEN_KIND_NULL = 40,
    XP_TOKEN_KIND_OPEN_BRACKET = 41,
    XP_TOKEN_KIND_COMMA = 42,
    XP_TOKEN_KIND_AND = 43,
    XP_TOKEN_KIND_MINUS = 44,
    XP_TOKEN_KIND_IN = 45,
    XP_TOKEN_KIND_CLOSE_BRACKET = 46,
    XP_TOKEN_KIND_DIV = 47,
    XP_TOKEN_KIND_FALSE = 48,
    XP_TOKEN_KIND_SUB = 49,
    XP_TOKEN_KIND_LE = 50,
    XP_TOKEN_KIND_EQ = 51,
};

@interface XPParser : PKParser
        
+ (PKTokenizer *)tokenizer;

@property (nonatomic, retain) id <XPScope>currentScope;
@property (nonatomic, retain) XPGlobalScope *globalScope;
@property (nonatomic, retain) XPMemorySpace *globals;
@property (nonatomic, assign) BOOL foundDefaultParam;

@end

