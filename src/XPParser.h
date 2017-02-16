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
    XP_TOKEN_KIND_BITOR = 16,
    XP_TOKEN_KIND_TIMESEQ = 17,
    XP_TOKEN_KIND_IS = 18,
    XP_TOKEN_KIND_BREAK = 19,
    XP_TOKEN_KIND_FOR = 20,
    XP_TOKEN_KIND_RETURN = 21,
    XP_TOKEN_KIND_CLOSE_CURLY = 22,
    XP_TOKEN_KIND_TRUE = 23,
    XP_TOKEN_KIND_PLUSEQ = 24,
    XP_TOKEN_KIND_NE = 25,
    XP_TOKEN_KIND_IF = 26,
    XP_TOKEN_KIND_ELSE = 27,
    XP_TOKEN_KIND_BANG = 28,
    XP_TOKEN_KIND_CONTINUE = 29,
    XP_TOKEN_KIND_COLON = 30,
    XP_TOKEN_KIND_SEMI_COLON = 31,
    XP_TOKEN_KIND_LT = 32,
    XP_TOKEN_KIND_MINUSEQ = 33,
    XP_TOKEN_KIND_MOD = 34,
    XP_TOKEN_KIND_EQUALS = 35,
    XP_TOKEN_KIND_BITAND = 36,
    XP_TOKEN_KIND_GT = 37,
    XP_TOKEN_KIND_OPEN_PAREN = 38,
    XP_TOKEN_KIND_WHILE = 39,
    XP_TOKEN_KIND_VAR = 40,
    XP_TOKEN_KIND_CLOSE_PAREN = 41,
    XP_TOKEN_KIND_DIVEQ = 42,
    XP_TOKEN_KIND_TIMES = 43,
    XP_TOKEN_KIND_OR = 44,
    XP_TOKEN_KIND_CAT = 45,
    XP_TOKEN_KIND_PLUS = 46,
    XP_TOKEN_KIND_NOT = 47,
    XP_TOKEN_KIND_OPEN_BRACKET = 48,
    XP_TOKEN_KIND_COMMA = 49,
    XP_TOKEN_KIND_AND = 50,
    XP_TOKEN_KIND_NULL = 51,
    XP_TOKEN_KIND_MINUS = 52,
    XP_TOKEN_KIND_IN = 53,
    XP_TOKEN_KIND_CLOSE_BRACKET = 54,
    XP_TOKEN_KIND_NAN = 55,
    XP_TOKEN_KIND_BITXOR = 56,
    XP_TOKEN_KIND_DIV = 57,
    XP_TOKEN_KIND_FALSE = 58,
    XP_TOKEN_KIND_SUB = 59,
    XP_TOKEN_KIND_LE = 60,
    XP_TOKEN_KIND_EQ = 61,
};

@interface XPParser : PKParser
        
+ (PKTokenizer *)tokenizer;

@property (nonatomic, retain) id <XPScope>currentScope;
@property (nonatomic, retain) XPGlobalScope *globalScope;
@property (nonatomic, retain) XPMemorySpace *globals;
@property (nonatomic, assign) BOOL foundDefaultParam;

@end

