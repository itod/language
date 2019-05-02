#import <PEGKit/PKParser.h>
        
    
#define XP_TOKEN_KIND_BLOCK -2
#define XP_TOKEN_KIND_CALL  -3
#define XP_TOKEN_KIND_APPEND -4
#define XP_TOKEN_KIND_SUBSCRIPT_ASSIGN -5
#define XP_TOKEN_KIND_SUBSCRIPT_LOAD -6
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
    XP_TOKEN_KIND_BITOR = 14,
    XP_TOKEN_KIND_NE = 15,
    XP_TOKEN_KIND_OPEN_PAREN = 16,
    XP_TOKEN_KIND_CLOSE_CURLY = 17,
    XP_TOKEN_KIND_CATCH = 18,
    XP_TOKEN_KIND_RETURN = 19,
    XP_TOKEN_KIND_BITNOT = 20,
    XP_TOKEN_KIND_CLOSE_PAREN = 21,
    XP_TOKEN_KIND_TIMES = 22,
    XP_TOKEN_KIND_TIMESEQ = 23,
    XP_TOKEN_KIND_AND = 24,
    XP_TOKEN_KIND_PLUS = 25,
    XP_TOKEN_KIND_COMMA = 26,
    XP_TOKEN_KIND_IF = 27,
    XP_TOKEN_KIND_MINUS = 28,
    XP_TOKEN_KIND_FINALLY = 29,
    XP_TOKEN_KIND_NULL = 30,
    XP_TOKEN_KIND_SHIFTLEFT = 31,
    XP_TOKEN_KIND_FALSE = 32,
    XP_TOKEN_KIND_DIV = 33,
    XP_TOKEN_KIND_PLUSEQ = 34,
    XP_TOKEN_KIND_LE = 35,
    XP_TOKEN_KIND_OPEN_BRACKET = 36,
    XP_TOKEN_KIND_CLOSE_BRACKET = 37,
    XP_TOKEN_KIND_BITXOR = 38,
    XP_TOKEN_KIND_OR = 39,
    XP_TOKEN_KIND_EQ = 40,
    XP_TOKEN_KIND_CONTINUE = 41,
    XP_TOKEN_KIND_BREAK = 42,
    XP_TOKEN_KIND_MINUSEQ = 43,
    XP_TOKEN_KIND_GE = 44,
    XP_TOKEN_KIND_COLON = 45,
    XP_TOKEN_KIND_IN = 46,
    XP_TOKEN_KIND_SEMI_COLON = 47,
    XP_TOKEN_KIND_FOR = 48,
    XP_TOKEN_KIND_SHIFTRIGHT = 49,
    XP_TOKEN_KIND_LT = 50,
    XP_TOKEN_KIND_THROW = 51,
    XP_TOKEN_KIND_EQUALS = 52,
    XP_TOKEN_KIND_TRY = 53,
    XP_TOKEN_KIND_GT = 54,
    XP_TOKEN_KIND_WHILE = 55,
    XP_TOKEN_KIND_IS = 56,
    XP_TOKEN_KIND_ELSE = 57,
    XP_TOKEN_KIND_DEL = 58,
    XP_TOKEN_KIND_DIVEQ = 59,
    XP_TOKEN_KIND_NAN = 60,
    XP_TOKEN_KIND_VAR = 61,
    XP_TOKEN_KIND_NOT = 62,
    XP_TOKEN_KIND_BANG = 63,
    XP_TOKEN_KIND_TRUE = 64,
    XP_TOKEN_KIND__N = 65,
    XP_TOKEN_KIND_SUB = 66,
    XP_TOKEN_KIND_MOD = 67,
    XP_TOKEN_KIND_BITAND = 68,
    XP_TOKEN_KIND_OPEN_CURLY = 69,
};

@interface XPParser : PKParser
        
+ (PKTokenizer *)tokenizer;

@property (nonatomic, retain) id <XPScope>currentScope;
@property (nonatomic, retain) XPGlobalScope *globalScope;
@property (nonatomic, retain) XPMemorySpace *globals;
@property (nonatomic, retain) NSMutableArray *allScopes;
@property (nonatomic, assign) BOOL foundDefaultParam;

@end

