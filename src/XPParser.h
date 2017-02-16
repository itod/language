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
    XP_TOKEN_KIND_TIMESEQ = 16,
    XP_TOKEN_KIND_IS = 17,
    XP_TOKEN_KIND_BREAK = 18,
    XP_TOKEN_KIND_FOR = 19,
    XP_TOKEN_KIND_RETURN = 20,
    XP_TOKEN_KIND_CLOSE_CURLY = 21,
    XP_TOKEN_KIND_TRUE = 22,
    XP_TOKEN_KIND_PLUSEQ = 23,
    XP_TOKEN_KIND_NE = 24,
    XP_TOKEN_KIND_IF = 25,
    XP_TOKEN_KIND_ELSE = 26,
    XP_TOKEN_KIND_BANG = 27,
    XP_TOKEN_KIND_CONTINUE = 28,
    XP_TOKEN_KIND_COLON = 29,
    XP_TOKEN_KIND_SEMI_COLON = 30,
    XP_TOKEN_KIND_LT = 31,
    XP_TOKEN_KIND_MINUSEQ = 32,
    XP_TOKEN_KIND_MOD = 33,
    XP_TOKEN_KIND_EQUALS = 34,
    XP_TOKEN_KIND_AMP = 35,
    XP_TOKEN_KIND_GT = 36,
    XP_TOKEN_KIND_OPEN_PAREN = 37,
    XP_TOKEN_KIND_WHILE = 38,
    XP_TOKEN_KIND_VAR = 39,
    XP_TOKEN_KIND_CLOSE_PAREN = 40,
    XP_TOKEN_KIND_DIVEQ = 41,
    XP_TOKEN_KIND_TIMES = 42,
    XP_TOKEN_KIND_OR = 43,
    XP_TOKEN_KIND_NOT = 44,
    XP_TOKEN_KIND_PLUS = 45,
    XP_TOKEN_KIND_NULL = 46,
    XP_TOKEN_KIND_OPEN_BRACKET = 47,
    XP_TOKEN_KIND_COMMA = 48,
    XP_TOKEN_KIND_AND = 49,
    XP_TOKEN_KIND_NAN = 50,
    XP_TOKEN_KIND_MINUS = 51,
    XP_TOKEN_KIND_IN = 52,
    XP_TOKEN_KIND_CLOSE_BRACKET = 53,
    XP_TOKEN_KIND_DIV = 54,
    XP_TOKEN_KIND_FALSE = 55,
    XP_TOKEN_KIND_SUB = 56,
    XP_TOKEN_KIND_LE = 57,
    XP_TOKEN_KIND_EQ = 58,
};

@interface XPParser : PKParser
        
+ (PKTokenizer *)tokenizer;

@property (nonatomic, retain) id <XPScope>currentScope;
@property (nonatomic, retain) XPGlobalScope *globalScope;
@property (nonatomic, retain) XPMemorySpace *globals;
@property (nonatomic, assign) BOOL foundDefaultParam;

@end

