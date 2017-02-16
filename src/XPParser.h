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
    XP_TOKEN_KIND_IS = 16,
    XP_TOKEN_KIND_BREAK = 17,
    XP_TOKEN_KIND_FOR = 18,
    XP_TOKEN_KIND_RETURN = 19,
    XP_TOKEN_KIND_CLOSE_CURLY = 20,
    XP_TOKEN_KIND_TRUE = 21,
    XP_TOKEN_KIND_IF = 22,
    XP_TOKEN_KIND_NE = 23,
    XP_TOKEN_KIND_ELSE = 24,
    XP_TOKEN_KIND_BANG = 25,
    XP_TOKEN_KIND_CONTINUE = 26,
    XP_TOKEN_KIND_COLON = 27,
    XP_TOKEN_KIND_SEMI_COLON = 28,
    XP_TOKEN_KIND_LT = 29,
    XP_TOKEN_KIND_MOD = 30,
    XP_TOKEN_KIND_EQUALS = 31,
    XP_TOKEN_KIND_AMP = 32,
    XP_TOKEN_KIND_GT = 33,
    XP_TOKEN_KIND_OPEN_PAREN = 34,
    XP_TOKEN_KIND_WHILE = 35,
    XP_TOKEN_KIND_VAR = 36,
    XP_TOKEN_KIND_CLOSE_PAREN = 37,
    XP_TOKEN_KIND_TIMES = 38,
    XP_TOKEN_KIND_OR = 39,
    XP_TOKEN_KIND_NOT = 40,
    XP_TOKEN_KIND_PLUS = 41,
    XP_TOKEN_KIND_NULL = 42,
    XP_TOKEN_KIND_OPEN_BRACKET = 43,
    XP_TOKEN_KIND_COMMA = 44,
    XP_TOKEN_KIND_AND = 45,
    XP_TOKEN_KIND_NAN = 46,
    XP_TOKEN_KIND_MINUS = 47,
    XP_TOKEN_KIND_IN = 48,
    XP_TOKEN_KIND_CLOSE_BRACKET = 49,
    XP_TOKEN_KIND_DIV = 50,
    XP_TOKEN_KIND_FALSE = 51,
    XP_TOKEN_KIND_SUB = 52,
    XP_TOKEN_KIND_LE = 53,
    XP_TOKEN_KIND_EQ = 54,
};

@interface XPParser : PKParser
        
+ (PKTokenizer *)tokenizer;

@property (nonatomic, retain) id <XPScope>currentScope;
@property (nonatomic, retain) XPGlobalScope *globalScope;
@property (nonatomic, retain) XPMemorySpace *globals;
@property (nonatomic, assign) BOOL foundDefaultParam;

@end

