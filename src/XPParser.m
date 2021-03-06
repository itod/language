#import "XPParser.h"
#import <PEGKit/PEGKit.h>
    
#import <Language/XPException.h>
#import <Language/XPNode.h>
#import <Language/XPGlobalScope.h>
#import <Language/XPLocalScope.h>
#import <Language/XPVariableSymbol.h>
#import <Language/XPFunctionSymbol.h>

@interface PKParser ()
- (void)raiseInRange:(NSRange)r lineNumber:(NSUInteger)lineNum name:(NSString *)name format:(NSString *)fmt, ...;
@end


@interface XPParser ()
    
@property (nonatomic, retain) PKToken *blockTok;
@property (nonatomic, retain) PKToken *loadTok;
@property (nonatomic, retain) PKToken *callTok;
@property (nonatomic, retain) PKToken *subscriptLoadTok;
@property (nonatomic, retain) PKToken *subscriptAssignTok;
@property (nonatomic, retain) PKToken *appendTok;
@property (nonatomic, retain) PKToken *anonTok;
@property (nonatomic, retain) PKToken *openParenTok;
@property (nonatomic, retain) PKToken *openCurlyTok;
@property (nonatomic, retain) PKToken *openSquareTok;
@property (nonatomic, retain) PKToken *minusTok;
@property (nonatomic, retain) PKToken *colonTok;
@property (nonatomic, retain) PKToken *equalsTok;
@property (nonatomic, retain) PKToken *delTok;
@property (nonatomic, retain) PKToken *notTok;
@property (nonatomic, retain) PKToken *negTok;
@property (nonatomic, retain) PKToken *unaryTok;
@property (nonatomic, retain) PKToken *commaTok;
@property (nonatomic, retain) PKToken *arrayTok;
@property (nonatomic, retain) PKToken *dictTok;
@property (nonatomic, retain) XPNode *firstNode;
@property (nonatomic, retain) XPNode *lastNode;
@property (nonatomic, assign) BOOL negation;
@property (nonatomic, assign) BOOL negative;
@property (nonatomic, assign) BOOL canBreak;
@property (nonatomic, assign) BOOL valid;

@property (nonatomic, retain) NSMutableDictionary *program_memo;
@property (nonatomic, retain) NSMutableDictionary *globalList_memo;
@property (nonatomic, retain) NSMutableDictionary *item_memo;
@property (nonatomic, retain) NSMutableDictionary *anyBlock_memo;
@property (nonatomic, retain) NSMutableDictionary *localList_memo;
@property (nonatomic, retain) NSMutableDictionary *funcBlock_memo;
@property (nonatomic, retain) NSMutableDictionary *localBlock_memo;
@property (nonatomic, retain) NSMutableDictionary *nl_memo;
@property (nonatomic, retain) NSMutableDictionary *terminator_memo;
@property (nonatomic, retain) NSMutableDictionary *stats_memo;
@property (nonatomic, retain) NSMutableDictionary *stat_memo;
@property (nonatomic, retain) NSMutableDictionary *realStat_memo;
@property (nonatomic, retain) NSMutableDictionary *varDecl_memo;
@property (nonatomic, retain) NSMutableDictionary *qid_memo;
@property (nonatomic, retain) NSMutableDictionary *plusEq_memo;
@property (nonatomic, retain) NSMutableDictionary *minusEq_memo;
@property (nonatomic, retain) NSMutableDictionary *timesEq_memo;
@property (nonatomic, retain) NSMutableDictionary *divEq_memo;
@property (nonatomic, retain) NSMutableDictionary *powEq_memo;
@property (nonatomic, retain) NSMutableDictionary *orEq_memo;
@property (nonatomic, retain) NSMutableDictionary *andEq_memo;
@property (nonatomic, retain) NSMutableDictionary *xorEq_memo;
@property (nonatomic, retain) NSMutableDictionary *leftEq_memo;
@property (nonatomic, retain) NSMutableDictionary *rightEq_memo;
@property (nonatomic, retain) NSMutableDictionary *assign_memo;
@property (nonatomic, retain) NSMutableDictionary *assignSubscript_memo;
@property (nonatomic, retain) NSMutableDictionary *assignSlice_memo;
@property (nonatomic, retain) NSMutableDictionary *assignAppend_memo;
@property (nonatomic, retain) NSMutableDictionary *whileBlock_memo;
@property (nonatomic, retain) NSMutableDictionary *break_memo;
@property (nonatomic, retain) NSMutableDictionary *continue_memo;
@property (nonatomic, retain) NSMutableDictionary *forBlock_memo;
@property (nonatomic, retain) NSMutableDictionary *ifBlock_memo;
@property (nonatomic, retain) NSMutableDictionary *elifBlock_memo;
@property (nonatomic, retain) NSMutableDictionary *elseBlock_memo;
@property (nonatomic, retain) NSMutableDictionary *tryBlock_memo;
@property (nonatomic, retain) NSMutableDictionary *catchBlock_memo;
@property (nonatomic, retain) NSMutableDictionary *finallyBlock_memo;
@property (nonatomic, retain) NSMutableDictionary *throwStat_memo;
@property (nonatomic, retain) NSMutableDictionary *del_memo;
@property (nonatomic, retain) NSMutableDictionary *delStat_memo;
@property (nonatomic, retain) NSMutableDictionary *returnStat_memo;
@property (nonatomic, retain) NSMutableDictionary *funcDecl_memo;
@property (nonatomic, retain) NSMutableDictionary *funcBody_memo;
@property (nonatomic, retain) NSMutableDictionary *paramList_memo;
@property (nonatomic, retain) NSMutableDictionary *param_memo;
@property (nonatomic, retain) NSMutableDictionary *dfaultParam_memo;
@property (nonatomic, retain) NSMutableDictionary *nakedParam_memo;
@property (nonatomic, retain) NSMutableDictionary *funcLiteral_memo;
@property (nonatomic, retain) NSMutableDictionary *funcCall_memo;
@property (nonatomic, retain) NSMutableDictionary *argList_memo;
@property (nonatomic, retain) NSMutableDictionary *arg_memo;
@property (nonatomic, retain) NSMutableDictionary *expr_memo;
@property (nonatomic, retain) NSMutableDictionary *or_memo;
@property (nonatomic, retain) NSMutableDictionary *orExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *and_memo;
@property (nonatomic, retain) NSMutableDictionary *andExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *inOp_memo;
@property (nonatomic, retain) NSMutableDictionary *membershipExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *eq_memo;
@property (nonatomic, retain) NSMutableDictionary *ne_memo;
@property (nonatomic, retain) NSMutableDictionary *is_memo;
@property (nonatomic, retain) NSMutableDictionary *equalityExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *lt_memo;
@property (nonatomic, retain) NSMutableDictionary *gt_memo;
@property (nonatomic, retain) NSMutableDictionary *le_memo;
@property (nonatomic, retain) NSMutableDictionary *ge_memo;
@property (nonatomic, retain) NSMutableDictionary *relationalExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *plus_memo;
@property (nonatomic, retain) NSMutableDictionary *minus_memo;
@property (nonatomic, retain) NSMutableDictionary *additiveExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *times_memo;
@property (nonatomic, retain) NSMutableDictionary *div_memo;
@property (nonatomic, retain) NSMutableDictionary *mod_memo;
@property (nonatomic, retain) NSMutableDictionary *multiplicativeExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *bitAnd_memo;
@property (nonatomic, retain) NSMutableDictionary *bitOr_memo;
@property (nonatomic, retain) NSMutableDictionary *bitXor_memo;
@property (nonatomic, retain) NSMutableDictionary *bitExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *shiftLeft_memo;
@property (nonatomic, retain) NSMutableDictionary *shiftRight_memo;
@property (nonatomic, retain) NSMutableDictionary *shiftExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *pow_memo;
@property (nonatomic, retain) NSMutableDictionary *powExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *unaryExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *negatedUnary_memo;
@property (nonatomic, retain) NSMutableDictionary *bitNot_memo;
@property (nonatomic, retain) NSMutableDictionary *unary_memo;
@property (nonatomic, retain) NSMutableDictionary *signedPrimaryExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *primaryExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *trailer_memo;
@property (nonatomic, retain) NSMutableDictionary *subExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *atom_memo;
@property (nonatomic, retain) NSMutableDictionary *loadSubscript_memo;
@property (nonatomic, retain) NSMutableDictionary *loadSlice_memo;
@property (nonatomic, retain) NSMutableDictionary *sliceop_memo;
@property (nonatomic, retain) NSMutableDictionary *varRef_memo;
@property (nonatomic, retain) NSMutableDictionary *arrayLiteral_memo;
@property (nonatomic, retain) NSMutableDictionary *elemList_memo;
@property (nonatomic, retain) NSMutableDictionary *dictLiteral_memo;
@property (nonatomic, retain) NSMutableDictionary *pairList_memo;
@property (nonatomic, retain) NSMutableDictionary *pair_memo;
@property (nonatomic, retain) NSMutableDictionary *scalar_memo;
@property (nonatomic, retain) NSMutableDictionary *null_memo;
@property (nonatomic, retain) NSMutableDictionary *nan_memo;
@property (nonatomic, retain) NSMutableDictionary *inf_memo;
@property (nonatomic, retain) NSMutableDictionary *bool_memo;
@property (nonatomic, retain) NSMutableDictionary *num_memo;
@property (nonatomic, retain) NSMutableDictionary *str_memo;
@end

@implementation XPParser { }
    
+ (PKTokenizer *)tokenizer {
    PKTokenizer *t = [PKTokenizer tokenizer];
    [t.symbolState add:@"=="];
    [t.symbolState add:@"!="];
    [t.symbolState add:@"<="];
    [t.symbolState add:@">="];

//    [t.symbolState add:@"&&"];
//    [t.symbolState add:@"||"];

    [t.symbolState add:@"<<"];
    [t.symbolState add:@">>"];

    [t.symbolState add:@"**"];

    [t.symbolState add:@"+="];
    [t.symbolState add:@"-="];
    [t.symbolState add:@"*="];
    [t.symbolState add:@"/="];
    [t.symbolState add:@"**="];

    [t.symbolState add:@"|="];
    [t.symbolState add:@"&="];
    [t.symbolState add:@"^="];

    [t.symbolState add:@"<<="];
    [t.symbolState add:@">>="];
    
    [t setTokenizerState:t.symbolState from:'\n' to:'\n'];
    [t.whitespaceState setWhitespaceChars:NO from:'\n' to:'\n'];
    [t setTokenizerState:t.symbolState from:'-' to:'-'];
    [t.wordState setWordChars:NO from:'-' to:'-'];
    [t.wordState setWordChars:NO from:'\'' to:'\''];
    
    t.quoteState.allowsEOFTerminatedQuotes = NO;
    
    // dec numbers
    [t.numberState addGroupingSeparator:'_' forRadix:10];
    // hex numbers
    [t setTokenizerState:t.numberState from:'#' to:'#'];
    [t.numberState addPrefix:@"#" forRadix:16];
    [t.numberState addGroupingSeparator:'_' forRadix:16];
    // bin numbers
    [t setTokenizerState:t.numberState from:'$' to:'$'];
    [t.numberState addPrefix:@"$" forRadix:2];
    [t.numberState addGroupingSeparator:'_' forRadix:2];

    return t;
}

- (void)setCurrentScope:(id<XPScope>)s {
    if (s != _currentScope) {
        [_currentScope autorelease];
        _currentScope = [s retain];
    
        if (s) {
            TDAssert(_allScopes);
            [_allScopes addObject:s];
        }
    }
}
    

- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
            
    self.enableVerboseErrorReporting = NO;
    self.tokenizer = [[self class] tokenizer];
    self.blockTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"BLOCK" doubleValue:0.0];
    self.blockTok.tokenKind = XP_TOKEN_KIND_BLOCK;
    self.loadTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"LOAD" doubleValue:0.0];
    self.loadTok.tokenKind = XP_TOKEN_KIND_LOAD;
    self.callTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"CALL" doubleValue:0.0];
    self.callTok.tokenKind = XP_TOKEN_KIND_CALL;
    self.subscriptLoadTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"SUBSCRIPT_LOAD" doubleValue:0.0];
    self.subscriptLoadTok.tokenKind = XP_TOKEN_KIND_SUBSCRIPT_LOAD;
    self.subscriptAssignTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"SUBSCRIPT_ASSIGN" doubleValue:0.0];
    self.subscriptAssignTok.tokenKind = XP_TOKEN_KIND_SUBSCRIPT_ASSIGN;
    self.appendTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"APPEND" doubleValue:0.0];
    self.appendTok.tokenKind = XP_TOKEN_KIND_APPEND;
    self.anonTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"<ANON>" doubleValue:0.0];
    self.anonTok.tokenKind = XP_TOKEN_KIND_FUNC_LITERAL;
    self.openParenTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"(" doubleValue:0.0];
    self.openCurlyTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:[NSString stringWithFormat:@"%C", 0x7B] doubleValue:0.0];
    self.openSquareTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"[" doubleValue:0.0];
    self.minusTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"-" doubleValue:0.0];
    self.colonTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@":" doubleValue:0.0];
    self.equalsTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"=" doubleValue:0.0];
    self.delTok = [PKToken tokenWithTokenType:PKTokenTypeWord stringValue:@"del" doubleValue:0.0];
    self.delTok.tokenKind = XP_TOKEN_KIND_DEL;
    self.notTok = [PKToken tokenWithTokenType:PKTokenTypeWord stringValue:@"not" doubleValue:0.0];
    self.notTok.tokenKind = XP_TOKEN_KIND_NOT;
    self.negTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"NEG" doubleValue:0.0];
    self.negTok.tokenKind = XP_TOKEN_KIND_NEG;
    self.commaTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"," doubleValue:0.0];
    self.arrayTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"ARRAY" doubleValue:0.0];
    self.arrayTok.tokenKind = XP_TOKEN_KIND_ARRAY_LITERAL;
    self.dictTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"DICT" doubleValue:0.0];
    self.dictTok.tokenKind = XP_TOKEN_KIND_DICT_LITERAL;
    
    self.firstNode = [XPNode nodeWithToken:[PKToken tokenWithTokenType:PKTokenTypeNumber stringValue:@"1" doubleValue:1.0]];
    self.firstNode.token.tokenKind = TOKEN_KIND_BUILTIN_NUMBER;
    self.lastNode = [XPNode nodeWithToken:[PKToken tokenWithTokenType:PKTokenTypeNumber stringValue:@"-1" doubleValue:-1.0]];
    self.lastNode.token.tokenKind = TOKEN_KIND_BUILTIN_NUMBER;

        self.startRuleName = @"program";
        self.tokenKindTab[@"|"] = @(XP_TOKEN_KIND_BITOR);
        self.tokenKindTab[@"!="] = @(XP_TOKEN_KIND_NE);
        self.tokenKindTab[@"("] = @(XP_TOKEN_KIND_OPEN_PAREN);
        self.tokenKindTab[@"}"] = @(XP_TOKEN_KIND_CLOSE_CURLY);
        self.tokenKindTab[@"catch"] = @(XP_TOKEN_KIND_CATCH);
        self.tokenKindTab[@"return"] = @(XP_TOKEN_KIND_RETURN);
        self.tokenKindTab[@")"] = @(XP_TOKEN_KIND_CLOSE_PAREN);
        self.tokenKindTab[@"~"] = @(XP_TOKEN_KIND_BITNOT);
        self.tokenKindTab[@"*"] = @(XP_TOKEN_KIND_TIMES);
        self.tokenKindTab[@"*="] = @(XP_TOKEN_KIND_TIMESEQ);
        self.tokenKindTab[@"and"] = @(XP_TOKEN_KIND_AND);
        self.tokenKindTab[@"+"] = @(XP_TOKEN_KIND_PLUS);
        self.tokenKindTab[@"<<="] = @(XP_TOKEN_KIND_LEFTEQ);
        self.tokenKindTab[@","] = @(XP_TOKEN_KIND_COMMA);
        self.tokenKindTab[@"if"] = @(XP_TOKEN_KIND_IF);
        self.tokenKindTab[@"-"] = @(XP_TOKEN_KIND_MINUS);
        self.tokenKindTab[@"finally"] = @(XP_TOKEN_KIND_FINALLY);
        self.tokenKindTab[@"null"] = @(XP_TOKEN_KIND_NULL);
        self.tokenKindTab[@"<<"] = @(XP_TOKEN_KIND_SHIFTLEFT);
        self.tokenKindTab[@"false"] = @(XP_TOKEN_KIND_FALSE);
        self.tokenKindTab[@"/"] = @(XP_TOKEN_KIND_DIV);
        self.tokenKindTab[@"+="] = @(XP_TOKEN_KIND_PLUSEQ);
        self.tokenKindTab[@"<="] = @(XP_TOKEN_KIND_LE);
        self.tokenKindTab[@"^="] = @(XP_TOKEN_KIND_XOREQ);
        self.tokenKindTab[@"["] = @(XP_TOKEN_KIND_OPEN_BRACKET);
        self.tokenKindTab[@"]"] = @(XP_TOKEN_KIND_CLOSE_BRACKET);
        self.tokenKindTab[@"^"] = @(XP_TOKEN_KIND_BITXOR);
        self.tokenKindTab[@"or"] = @(XP_TOKEN_KIND_OR);
        self.tokenKindTab[@"=="] = @(XP_TOKEN_KIND_EQ);
        self.tokenKindTab[@"**"] = @(XP_TOKEN_KIND_POW);
        self.tokenKindTab[@"continue"] = @(XP_TOKEN_KIND_CONTINUE);
        self.tokenKindTab[@"break"] = @(XP_TOKEN_KIND_BREAK);
        self.tokenKindTab[@"-="] = @(XP_TOKEN_KIND_MINUSEQ);
        self.tokenKindTab[@">="] = @(XP_TOKEN_KIND_GE);
        self.tokenKindTab[@":"] = @(XP_TOKEN_KIND_COLON);
        self.tokenKindTab[@"in"] = @(XP_TOKEN_KIND_IN);
        self.tokenKindTab[@"Infinity"] = @(XP_TOKEN_KIND_INF);
        self.tokenKindTab[@";"] = @(XP_TOKEN_KIND_SEMI_COLON);
        self.tokenKindTab[@"for"] = @(XP_TOKEN_KIND_FOR);
        self.tokenKindTab[@">>"] = @(XP_TOKEN_KIND_SHIFTRIGHT);
        self.tokenKindTab[@"<"] = @(XP_TOKEN_KIND_LT);
        self.tokenKindTab[@"throw"] = @(XP_TOKEN_KIND_THROW);
        self.tokenKindTab[@"="] = @(XP_TOKEN_KIND_EQUALS);
        self.tokenKindTab[@"try"] = @(XP_TOKEN_KIND_TRY);
        self.tokenKindTab[@">"] = @(XP_TOKEN_KIND_GT);
        self.tokenKindTab[@"while"] = @(XP_TOKEN_KIND_WHILE);
        self.tokenKindTab[@"&="] = @(XP_TOKEN_KIND_ANDEQ);
        self.tokenKindTab[@"is"] = @(XP_TOKEN_KIND_IS);
        self.tokenKindTab[@"else"] = @(XP_TOKEN_KIND_ELSE);
        self.tokenKindTab[@"del"] = @(XP_TOKEN_KIND_DEL);
        self.tokenKindTab[@"/="] = @(XP_TOKEN_KIND_DIVEQ);
        self.tokenKindTab[@"NaN"] = @(XP_TOKEN_KIND_NAN);
        self.tokenKindTab[@"var"] = @(XP_TOKEN_KIND_VAR);
        self.tokenKindTab[@"not"] = @(XP_TOKEN_KIND_NOT);
        self.tokenKindTab[@"|="] = @(XP_TOKEN_KIND_OREQ);
        self.tokenKindTab[@"**="] = @(XP_TOKEN_KIND_POWEQ);
        self.tokenKindTab[@">>="] = @(XP_TOKEN_KIND_RIGHTEQ);
        self.tokenKindTab[@"!"] = @(XP_TOKEN_KIND_BANG);
        self.tokenKindTab[@"true"] = @(XP_TOKEN_KIND_TRUE);
        self.tokenKindTab[@"\n"] = @(XP_TOKEN_KIND__N);
        self.tokenKindTab[@"sub"] = @(XP_TOKEN_KIND_SUB);
        self.tokenKindTab[@"%"] = @(XP_TOKEN_KIND_MOD);
        self.tokenKindTab[@"&"] = @(XP_TOKEN_KIND_BITAND);
        self.tokenKindTab[@"{"] = @(XP_TOKEN_KIND_OPEN_CURLY);

        self.tokenKindNameTab[XP_TOKEN_KIND_BITOR] = @"|";
        self.tokenKindNameTab[XP_TOKEN_KIND_NE] = @"!=";
        self.tokenKindNameTab[XP_TOKEN_KIND_OPEN_PAREN] = @"(";
        self.tokenKindNameTab[XP_TOKEN_KIND_CLOSE_CURLY] = @"}";
        self.tokenKindNameTab[XP_TOKEN_KIND_CATCH] = @"catch";
        self.tokenKindNameTab[XP_TOKEN_KIND_RETURN] = @"return";
        self.tokenKindNameTab[XP_TOKEN_KIND_CLOSE_PAREN] = @")";
        self.tokenKindNameTab[XP_TOKEN_KIND_BITNOT] = @"~";
        self.tokenKindNameTab[XP_TOKEN_KIND_TIMES] = @"*";
        self.tokenKindNameTab[XP_TOKEN_KIND_TIMESEQ] = @"*=";
        self.tokenKindNameTab[XP_TOKEN_KIND_AND] = @"and";
        self.tokenKindNameTab[XP_TOKEN_KIND_PLUS] = @"+";
        self.tokenKindNameTab[XP_TOKEN_KIND_LEFTEQ] = @"<<=";
        self.tokenKindNameTab[XP_TOKEN_KIND_COMMA] = @",";
        self.tokenKindNameTab[XP_TOKEN_KIND_IF] = @"if";
        self.tokenKindNameTab[XP_TOKEN_KIND_MINUS] = @"-";
        self.tokenKindNameTab[XP_TOKEN_KIND_FINALLY] = @"finally";
        self.tokenKindNameTab[XP_TOKEN_KIND_NULL] = @"null";
        self.tokenKindNameTab[XP_TOKEN_KIND_SHIFTLEFT] = @"<<";
        self.tokenKindNameTab[XP_TOKEN_KIND_FALSE] = @"false";
        self.tokenKindNameTab[XP_TOKEN_KIND_DIV] = @"/";
        self.tokenKindNameTab[XP_TOKEN_KIND_PLUSEQ] = @"+=";
        self.tokenKindNameTab[XP_TOKEN_KIND_LE] = @"<=";
        self.tokenKindNameTab[XP_TOKEN_KIND_XOREQ] = @"^=";
        self.tokenKindNameTab[XP_TOKEN_KIND_OPEN_BRACKET] = @"[";
        self.tokenKindNameTab[XP_TOKEN_KIND_CLOSE_BRACKET] = @"]";
        self.tokenKindNameTab[XP_TOKEN_KIND_BITXOR] = @"^";
        self.tokenKindNameTab[XP_TOKEN_KIND_OR] = @"or";
        self.tokenKindNameTab[XP_TOKEN_KIND_EQ] = @"==";
        self.tokenKindNameTab[XP_TOKEN_KIND_POW] = @"**";
        self.tokenKindNameTab[XP_TOKEN_KIND_CONTINUE] = @"continue";
        self.tokenKindNameTab[XP_TOKEN_KIND_BREAK] = @"break";
        self.tokenKindNameTab[XP_TOKEN_KIND_MINUSEQ] = @"-=";
        self.tokenKindNameTab[XP_TOKEN_KIND_GE] = @">=";
        self.tokenKindNameTab[XP_TOKEN_KIND_COLON] = @":";
        self.tokenKindNameTab[XP_TOKEN_KIND_IN] = @"in";
        self.tokenKindNameTab[XP_TOKEN_KIND_INF] = @"Infinity";
        self.tokenKindNameTab[XP_TOKEN_KIND_SEMI_COLON] = @";";
        self.tokenKindNameTab[XP_TOKEN_KIND_FOR] = @"for";
        self.tokenKindNameTab[XP_TOKEN_KIND_SHIFTRIGHT] = @">>";
        self.tokenKindNameTab[XP_TOKEN_KIND_LT] = @"<";
        self.tokenKindNameTab[XP_TOKEN_KIND_THROW] = @"throw";
        self.tokenKindNameTab[XP_TOKEN_KIND_EQUALS] = @"=";
        self.tokenKindNameTab[XP_TOKEN_KIND_TRY] = @"try";
        self.tokenKindNameTab[XP_TOKEN_KIND_GT] = @">";
        self.tokenKindNameTab[XP_TOKEN_KIND_WHILE] = @"while";
        self.tokenKindNameTab[XP_TOKEN_KIND_ANDEQ] = @"&=";
        self.tokenKindNameTab[XP_TOKEN_KIND_IS] = @"is";
        self.tokenKindNameTab[XP_TOKEN_KIND_ELSE] = @"else";
        self.tokenKindNameTab[XP_TOKEN_KIND_DEL] = @"del";
        self.tokenKindNameTab[XP_TOKEN_KIND_DIVEQ] = @"/=";
        self.tokenKindNameTab[XP_TOKEN_KIND_NAN] = @"NaN";
        self.tokenKindNameTab[XP_TOKEN_KIND_VAR] = @"var";
        self.tokenKindNameTab[XP_TOKEN_KIND_NOT] = @"not";
        self.tokenKindNameTab[XP_TOKEN_KIND_OREQ] = @"|=";
        self.tokenKindNameTab[XP_TOKEN_KIND_POWEQ] = @"**=";
        self.tokenKindNameTab[XP_TOKEN_KIND_RIGHTEQ] = @">>=";
        self.tokenKindNameTab[XP_TOKEN_KIND_BANG] = @"!";
        self.tokenKindNameTab[XP_TOKEN_KIND_TRUE] = @"true";
        self.tokenKindNameTab[XP_TOKEN_KIND__N] = @"\n";
        self.tokenKindNameTab[XP_TOKEN_KIND_SUB] = @"sub";
        self.tokenKindNameTab[XP_TOKEN_KIND_MOD] = @"%";
        self.tokenKindNameTab[XP_TOKEN_KIND_BITAND] = @"&";
        self.tokenKindNameTab[XP_TOKEN_KIND_OPEN_CURLY] = @"{";

        self.program_memo = [NSMutableDictionary dictionary];
        self.globalList_memo = [NSMutableDictionary dictionary];
        self.item_memo = [NSMutableDictionary dictionary];
        self.anyBlock_memo = [NSMutableDictionary dictionary];
        self.localList_memo = [NSMutableDictionary dictionary];
        self.funcBlock_memo = [NSMutableDictionary dictionary];
        self.localBlock_memo = [NSMutableDictionary dictionary];
        self.nl_memo = [NSMutableDictionary dictionary];
        self.terminator_memo = [NSMutableDictionary dictionary];
        self.stats_memo = [NSMutableDictionary dictionary];
        self.stat_memo = [NSMutableDictionary dictionary];
        self.realStat_memo = [NSMutableDictionary dictionary];
        self.varDecl_memo = [NSMutableDictionary dictionary];
        self.qid_memo = [NSMutableDictionary dictionary];
        self.plusEq_memo = [NSMutableDictionary dictionary];
        self.minusEq_memo = [NSMutableDictionary dictionary];
        self.timesEq_memo = [NSMutableDictionary dictionary];
        self.divEq_memo = [NSMutableDictionary dictionary];
        self.powEq_memo = [NSMutableDictionary dictionary];
        self.orEq_memo = [NSMutableDictionary dictionary];
        self.andEq_memo = [NSMutableDictionary dictionary];
        self.xorEq_memo = [NSMutableDictionary dictionary];
        self.leftEq_memo = [NSMutableDictionary dictionary];
        self.rightEq_memo = [NSMutableDictionary dictionary];
        self.assign_memo = [NSMutableDictionary dictionary];
        self.assignSubscript_memo = [NSMutableDictionary dictionary];
        self.assignSlice_memo = [NSMutableDictionary dictionary];
        self.assignAppend_memo = [NSMutableDictionary dictionary];
        self.whileBlock_memo = [NSMutableDictionary dictionary];
        self.break_memo = [NSMutableDictionary dictionary];
        self.continue_memo = [NSMutableDictionary dictionary];
        self.forBlock_memo = [NSMutableDictionary dictionary];
        self.ifBlock_memo = [NSMutableDictionary dictionary];
        self.elifBlock_memo = [NSMutableDictionary dictionary];
        self.elseBlock_memo = [NSMutableDictionary dictionary];
        self.tryBlock_memo = [NSMutableDictionary dictionary];
        self.catchBlock_memo = [NSMutableDictionary dictionary];
        self.finallyBlock_memo = [NSMutableDictionary dictionary];
        self.throwStat_memo = [NSMutableDictionary dictionary];
        self.del_memo = [NSMutableDictionary dictionary];
        self.delStat_memo = [NSMutableDictionary dictionary];
        self.returnStat_memo = [NSMutableDictionary dictionary];
        self.funcDecl_memo = [NSMutableDictionary dictionary];
        self.funcBody_memo = [NSMutableDictionary dictionary];
        self.paramList_memo = [NSMutableDictionary dictionary];
        self.param_memo = [NSMutableDictionary dictionary];
        self.dfaultParam_memo = [NSMutableDictionary dictionary];
        self.nakedParam_memo = [NSMutableDictionary dictionary];
        self.funcLiteral_memo = [NSMutableDictionary dictionary];
        self.funcCall_memo = [NSMutableDictionary dictionary];
        self.argList_memo = [NSMutableDictionary dictionary];
        self.arg_memo = [NSMutableDictionary dictionary];
        self.expr_memo = [NSMutableDictionary dictionary];
        self.or_memo = [NSMutableDictionary dictionary];
        self.orExpr_memo = [NSMutableDictionary dictionary];
        self.and_memo = [NSMutableDictionary dictionary];
        self.andExpr_memo = [NSMutableDictionary dictionary];
        self.inOp_memo = [NSMutableDictionary dictionary];
        self.membershipExpr_memo = [NSMutableDictionary dictionary];
        self.eq_memo = [NSMutableDictionary dictionary];
        self.ne_memo = [NSMutableDictionary dictionary];
        self.is_memo = [NSMutableDictionary dictionary];
        self.equalityExpr_memo = [NSMutableDictionary dictionary];
        self.lt_memo = [NSMutableDictionary dictionary];
        self.gt_memo = [NSMutableDictionary dictionary];
        self.le_memo = [NSMutableDictionary dictionary];
        self.ge_memo = [NSMutableDictionary dictionary];
        self.relationalExpr_memo = [NSMutableDictionary dictionary];
        self.plus_memo = [NSMutableDictionary dictionary];
        self.minus_memo = [NSMutableDictionary dictionary];
        self.additiveExpr_memo = [NSMutableDictionary dictionary];
        self.times_memo = [NSMutableDictionary dictionary];
        self.div_memo = [NSMutableDictionary dictionary];
        self.mod_memo = [NSMutableDictionary dictionary];
        self.multiplicativeExpr_memo = [NSMutableDictionary dictionary];
        self.bitAnd_memo = [NSMutableDictionary dictionary];
        self.bitOr_memo = [NSMutableDictionary dictionary];
        self.bitXor_memo = [NSMutableDictionary dictionary];
        self.bitExpr_memo = [NSMutableDictionary dictionary];
        self.shiftLeft_memo = [NSMutableDictionary dictionary];
        self.shiftRight_memo = [NSMutableDictionary dictionary];
        self.shiftExpr_memo = [NSMutableDictionary dictionary];
        self.pow_memo = [NSMutableDictionary dictionary];
        self.powExpr_memo = [NSMutableDictionary dictionary];
        self.unaryExpr_memo = [NSMutableDictionary dictionary];
        self.negatedUnary_memo = [NSMutableDictionary dictionary];
        self.bitNot_memo = [NSMutableDictionary dictionary];
        self.unary_memo = [NSMutableDictionary dictionary];
        self.signedPrimaryExpr_memo = [NSMutableDictionary dictionary];
        self.primaryExpr_memo = [NSMutableDictionary dictionary];
        self.trailer_memo = [NSMutableDictionary dictionary];
        self.subExpr_memo = [NSMutableDictionary dictionary];
        self.atom_memo = [NSMutableDictionary dictionary];
        self.loadSubscript_memo = [NSMutableDictionary dictionary];
        self.loadSlice_memo = [NSMutableDictionary dictionary];
        self.sliceop_memo = [NSMutableDictionary dictionary];
        self.varRef_memo = [NSMutableDictionary dictionary];
        self.arrayLiteral_memo = [NSMutableDictionary dictionary];
        self.elemList_memo = [NSMutableDictionary dictionary];
        self.dictLiteral_memo = [NSMutableDictionary dictionary];
        self.pairList_memo = [NSMutableDictionary dictionary];
        self.pair_memo = [NSMutableDictionary dictionary];
        self.scalar_memo = [NSMutableDictionary dictionary];
        self.null_memo = [NSMutableDictionary dictionary];
        self.nan_memo = [NSMutableDictionary dictionary];
        self.inf_memo = [NSMutableDictionary dictionary];
        self.bool_memo = [NSMutableDictionary dictionary];
        self.num_memo = [NSMutableDictionary dictionary];
        self.str_memo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
        
    self.currentScope = nil;
    self.globalScope = nil;
    self.globals = nil;
    self.allScopes = nil;
    self.blockTok = nil;
    self.loadTok = nil;
    self.callTok = nil;
    self.subscriptLoadTok = nil;
    self.subscriptAssignTok = nil;
    self.appendTok = nil;
    self.anonTok = nil;
    self.openParenTok = nil;
    self.openCurlyTok = nil;
    self.openSquareTok = nil;
    self.minusTok = nil;
    self.colonTok = nil;
    self.equalsTok = nil;
    self.notTok = nil;
    self.negTok = nil;
    self.unaryTok = nil;
    self.commaTok = nil;
    self.arrayTok = nil;
    self.dictTok = nil;
    self.firstNode = nil;
    self.lastNode = nil;

    self.program_memo = nil;
    self.globalList_memo = nil;
    self.item_memo = nil;
    self.anyBlock_memo = nil;
    self.localList_memo = nil;
    self.funcBlock_memo = nil;
    self.localBlock_memo = nil;
    self.nl_memo = nil;
    self.terminator_memo = nil;
    self.stats_memo = nil;
    self.stat_memo = nil;
    self.realStat_memo = nil;
    self.varDecl_memo = nil;
    self.qid_memo = nil;
    self.plusEq_memo = nil;
    self.minusEq_memo = nil;
    self.timesEq_memo = nil;
    self.divEq_memo = nil;
    self.powEq_memo = nil;
    self.orEq_memo = nil;
    self.andEq_memo = nil;
    self.xorEq_memo = nil;
    self.leftEq_memo = nil;
    self.rightEq_memo = nil;
    self.assign_memo = nil;
    self.assignSubscript_memo = nil;
    self.assignSlice_memo = nil;
    self.assignAppend_memo = nil;
    self.whileBlock_memo = nil;
    self.break_memo = nil;
    self.continue_memo = nil;
    self.forBlock_memo = nil;
    self.ifBlock_memo = nil;
    self.elifBlock_memo = nil;
    self.elseBlock_memo = nil;
    self.tryBlock_memo = nil;
    self.catchBlock_memo = nil;
    self.finallyBlock_memo = nil;
    self.throwStat_memo = nil;
    self.del_memo = nil;
    self.delStat_memo = nil;
    self.returnStat_memo = nil;
    self.funcDecl_memo = nil;
    self.funcBody_memo = nil;
    self.paramList_memo = nil;
    self.param_memo = nil;
    self.dfaultParam_memo = nil;
    self.nakedParam_memo = nil;
    self.funcLiteral_memo = nil;
    self.funcCall_memo = nil;
    self.argList_memo = nil;
    self.arg_memo = nil;
    self.expr_memo = nil;
    self.or_memo = nil;
    self.orExpr_memo = nil;
    self.and_memo = nil;
    self.andExpr_memo = nil;
    self.inOp_memo = nil;
    self.membershipExpr_memo = nil;
    self.eq_memo = nil;
    self.ne_memo = nil;
    self.is_memo = nil;
    self.equalityExpr_memo = nil;
    self.lt_memo = nil;
    self.gt_memo = nil;
    self.le_memo = nil;
    self.ge_memo = nil;
    self.relationalExpr_memo = nil;
    self.plus_memo = nil;
    self.minus_memo = nil;
    self.additiveExpr_memo = nil;
    self.times_memo = nil;
    self.div_memo = nil;
    self.mod_memo = nil;
    self.multiplicativeExpr_memo = nil;
    self.bitAnd_memo = nil;
    self.bitOr_memo = nil;
    self.bitXor_memo = nil;
    self.bitExpr_memo = nil;
    self.shiftLeft_memo = nil;
    self.shiftRight_memo = nil;
    self.shiftExpr_memo = nil;
    self.pow_memo = nil;
    self.powExpr_memo = nil;
    self.unaryExpr_memo = nil;
    self.negatedUnary_memo = nil;
    self.bitNot_memo = nil;
    self.unary_memo = nil;
    self.signedPrimaryExpr_memo = nil;
    self.primaryExpr_memo = nil;
    self.trailer_memo = nil;
    self.subExpr_memo = nil;
    self.atom_memo = nil;
    self.loadSubscript_memo = nil;
    self.loadSlice_memo = nil;
    self.sliceop_memo = nil;
    self.varRef_memo = nil;
    self.arrayLiteral_memo = nil;
    self.elemList_memo = nil;
    self.dictLiteral_memo = nil;
    self.pairList_memo = nil;
    self.pair_memo = nil;
    self.scalar_memo = nil;
    self.null_memo = nil;
    self.nan_memo = nil;
    self.inf_memo = nil;
    self.bool_memo = nil;
    self.num_memo = nil;
    self.str_memo = nil;

    [super dealloc];
}

- (void)clearMemo {
    [_program_memo removeAllObjects];
    [_globalList_memo removeAllObjects];
    [_item_memo removeAllObjects];
    [_anyBlock_memo removeAllObjects];
    [_localList_memo removeAllObjects];
    [_funcBlock_memo removeAllObjects];
    [_localBlock_memo removeAllObjects];
    [_nl_memo removeAllObjects];
    [_terminator_memo removeAllObjects];
    [_stats_memo removeAllObjects];
    [_stat_memo removeAllObjects];
    [_realStat_memo removeAllObjects];
    [_varDecl_memo removeAllObjects];
    [_qid_memo removeAllObjects];
    [_plusEq_memo removeAllObjects];
    [_minusEq_memo removeAllObjects];
    [_timesEq_memo removeAllObjects];
    [_divEq_memo removeAllObjects];
    [_powEq_memo removeAllObjects];
    [_orEq_memo removeAllObjects];
    [_andEq_memo removeAllObjects];
    [_xorEq_memo removeAllObjects];
    [_leftEq_memo removeAllObjects];
    [_rightEq_memo removeAllObjects];
    [_assign_memo removeAllObjects];
    [_assignSubscript_memo removeAllObjects];
    [_assignSlice_memo removeAllObjects];
    [_assignAppend_memo removeAllObjects];
    [_whileBlock_memo removeAllObjects];
    [_break_memo removeAllObjects];
    [_continue_memo removeAllObjects];
    [_forBlock_memo removeAllObjects];
    [_ifBlock_memo removeAllObjects];
    [_elifBlock_memo removeAllObjects];
    [_elseBlock_memo removeAllObjects];
    [_tryBlock_memo removeAllObjects];
    [_catchBlock_memo removeAllObjects];
    [_finallyBlock_memo removeAllObjects];
    [_throwStat_memo removeAllObjects];
    [_del_memo removeAllObjects];
    [_delStat_memo removeAllObjects];
    [_returnStat_memo removeAllObjects];
    [_funcDecl_memo removeAllObjects];
    [_funcBody_memo removeAllObjects];
    [_paramList_memo removeAllObjects];
    [_param_memo removeAllObjects];
    [_dfaultParam_memo removeAllObjects];
    [_nakedParam_memo removeAllObjects];
    [_funcLiteral_memo removeAllObjects];
    [_funcCall_memo removeAllObjects];
    [_argList_memo removeAllObjects];
    [_arg_memo removeAllObjects];
    [_expr_memo removeAllObjects];
    [_or_memo removeAllObjects];
    [_orExpr_memo removeAllObjects];
    [_and_memo removeAllObjects];
    [_andExpr_memo removeAllObjects];
    [_inOp_memo removeAllObjects];
    [_membershipExpr_memo removeAllObjects];
    [_eq_memo removeAllObjects];
    [_ne_memo removeAllObjects];
    [_is_memo removeAllObjects];
    [_equalityExpr_memo removeAllObjects];
    [_lt_memo removeAllObjects];
    [_gt_memo removeAllObjects];
    [_le_memo removeAllObjects];
    [_ge_memo removeAllObjects];
    [_relationalExpr_memo removeAllObjects];
    [_plus_memo removeAllObjects];
    [_minus_memo removeAllObjects];
    [_additiveExpr_memo removeAllObjects];
    [_times_memo removeAllObjects];
    [_div_memo removeAllObjects];
    [_mod_memo removeAllObjects];
    [_multiplicativeExpr_memo removeAllObjects];
    [_bitAnd_memo removeAllObjects];
    [_bitOr_memo removeAllObjects];
    [_bitXor_memo removeAllObjects];
    [_bitExpr_memo removeAllObjects];
    [_shiftLeft_memo removeAllObjects];
    [_shiftRight_memo removeAllObjects];
    [_shiftExpr_memo removeAllObjects];
    [_pow_memo removeAllObjects];
    [_powExpr_memo removeAllObjects];
    [_unaryExpr_memo removeAllObjects];
    [_negatedUnary_memo removeAllObjects];
    [_bitNot_memo removeAllObjects];
    [_unary_memo removeAllObjects];
    [_signedPrimaryExpr_memo removeAllObjects];
    [_primaryExpr_memo removeAllObjects];
    [_trailer_memo removeAllObjects];
    [_subExpr_memo removeAllObjects];
    [_atom_memo removeAllObjects];
    [_loadSubscript_memo removeAllObjects];
    [_loadSlice_memo removeAllObjects];
    [_sliceop_memo removeAllObjects];
    [_varRef_memo removeAllObjects];
    [_arrayLiteral_memo removeAllObjects];
    [_elemList_memo removeAllObjects];
    [_dictLiteral_memo removeAllObjects];
    [_pairList_memo removeAllObjects];
    [_pair_memo removeAllObjects];
    [_scalar_memo removeAllObjects];
    [_null_memo removeAllObjects];
    [_nan_memo removeAllObjects];
    [_inf_memo removeAllObjects];
    [_bool_memo removeAllObjects];
    [_num_memo removeAllObjects];
    [_str_memo removeAllObjects];
}

- (void)start {

    [self program_]; 
    [self matchEOF:YES]; 

}

- (void)__program {
    
    [self execute:^{
    
    self.valid = YES;
    self.currentScope = _globalScope;

    }];
    [self globalList_]; 

    [self fireDelegateSelector:@selector(parser:didMatchProgram:)];
}

- (void)program_ {
    [self parseRule:@selector(__program) withMemo:_program_memo];
}

- (void)__globalList {
    
    while ([self speculate:^{ [self item_]; }]) {
        [self item_]; 
    }
    [self execute:^{
    
    NSArray *items = REV(ABOVE(nil));
    XPNode *block = [XPNode nodeWithToken:_blockTok];
    [block addChildren:items];
    PUSH(block);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchGlobalList:)];
}

- (void)globalList_ {
    [self parseRule:@selector(__globalList) withMemo:_globalList_memo];
}

- (void)__item {
    
    if ([self speculate:^{ [self anyBlock_]; }]) {
        [self anyBlock_]; 
    } else if ([self speculate:^{ [self stats_]; }]) {
        [self stats_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'item'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchItem:)];
}

- (void)item_ {
    [self parseRule:@selector(__item) withMemo:_item_memo];
}

- (void)__anyBlock {
    
    if ([self predicts:XP_TOKEN_KIND_IF, 0]) {
        [self testAndThrow:(id)^{ return _valid; }]; 
        [self ifBlock_]; 
    } else if ([self predicts:XP_TOKEN_KIND_WHILE, 0]) {
        [self whileBlock_]; 
    } else if ([self predicts:XP_TOKEN_KIND_FOR, 0]) {
        [self forBlock_]; 
    } else if ([self predicts:XP_TOKEN_KIND_TRY, 0]) {
        [self tryBlock_]; 
    } else if ([self predicts:XP_TOKEN_KIND_SUB, 0]) {
        [self funcDecl_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'anyBlock'."];
    }
    [self execute:^{
    self.valid=YES;
    }];

    [self fireDelegateSelector:@selector(parser:didMatchAnyBlock:)];
}

- (void)anyBlock_ {
    [self parseRule:@selector(__anyBlock) withMemo:_anyBlock_memo];
}

- (void)__localList {
    
    while ([self speculate:^{ [self item_]; }]) {
        [self item_]; 
    }
    [self execute:^{
    
    NSArray *items = REV(ABOVE(_openCurlyTok));
    POP(); // 'curly'
    XPNode *block = [XPNode nodeWithToken:_blockTok];
    [block addChildren:items];
    PUSH(block);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchLocalList:)];
}

- (void)localList_ {
    [self parseRule:@selector(__localList) withMemo:_localList_memo];
}

- (void)__funcBlock {
    
    [self match:XP_TOKEN_KIND_OPEN_CURLY discard:NO]; 
    [self localList_]; 
    [self match:XP_TOKEN_KIND_CLOSE_CURLY discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchFuncBlock:)];
}

- (void)funcBlock_ {
    [self parseRule:@selector(__funcBlock) withMemo:_funcBlock_memo];
}

- (void)__localBlock {
    
    [self execute:^{
     self.currentScope = [XPLocalScope scopeWithEnclosingScope:_currentScope]; 
    }];
    [self match:XP_TOKEN_KIND_OPEN_CURLY discard:NO]; 
    [self localList_]; 
    [self match:XP_TOKEN_KIND_CLOSE_CURLY discard:YES]; 
    [self execute:^{
     self.currentScope = _currentScope.enclosingScope; 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchLocalBlock:)];
}

- (void)localBlock_ {
    [self parseRule:@selector(__localBlock) withMemo:_localBlock_memo];
}

- (void)__nl {
    
    while ([self predicts:XP_TOKEN_KIND__N, 0]) {
        [self match:XP_TOKEN_KIND__N discard:YES]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchNl:)];
}

- (void)nl_ {
    [self parseRule:@selector(__nl) withMemo:_nl_memo];
}

- (void)__terminator {
    
    if ([self predicts:XP_TOKEN_KIND__N, 0]) {
        [self nl_]; 
    } else if ([self predicts:XP_TOKEN_KIND_SEMI_COLON, 0]) {
        [self match:XP_TOKEN_KIND_SEMI_COLON discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'terminator'."];
    }
    [self execute:^{
    self.valid=YES;
    }];

    [self fireDelegateSelector:@selector(parser:didMatchTerminator:)];
}

- (void)terminator_ {
    [self parseRule:@selector(__terminator) withMemo:_terminator_memo];
}

- (void)__stats {
    
    [self stat_]; 
    while ([self speculate:^{ [self terminator_]; [self stat_]; }]) {
        [self terminator_]; 
        [self stat_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchStats:)];
}

- (void)stats_ {
    [self parseRule:@selector(__stats) withMemo:_stats_memo];
}

- (void)__stat {
    
    if ([self predicts:XP_TOKEN_KIND_SEMI_COLON, XP_TOKEN_KIND__N, 0]) {
        [self terminator_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, XP_TOKEN_KIND_BANG, XP_TOKEN_KIND_BITNOT, XP_TOKEN_KIND_BREAK, XP_TOKEN_KIND_CONTINUE, XP_TOKEN_KIND_DEL, XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_INF, XP_TOKEN_KIND_MINUS, XP_TOKEN_KIND_NAN, XP_TOKEN_KIND_NOT, XP_TOKEN_KIND_NULL, XP_TOKEN_KIND_OPEN_BRACKET, XP_TOKEN_KIND_OPEN_CURLY, XP_TOKEN_KIND_OPEN_PAREN, XP_TOKEN_KIND_RETURN, XP_TOKEN_KIND_SUB, XP_TOKEN_KIND_THROW, XP_TOKEN_KIND_TRUE, XP_TOKEN_KIND_VAR, 0]) {
        [self testAndThrow:(id)^{ return _valid; }]; 
        [self realStat_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'stat'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchStat:)];
}

- (void)stat_ {
    [self parseRule:@selector(__stat) withMemo:_stat_memo];
}

- (void)__realStat {
    
    if ([self predicts:XP_TOKEN_KIND_VAR, 0]) {
        [self varDecl_];
    } else if ([self predicts:XP_TOKEN_KIND_THROW, 0]) {
        [self throwStat_];
    } else if ([self predicts:XP_TOKEN_KIND_BREAK, 0]) {
        [self break_];
    } else if ([self predicts:XP_TOKEN_KIND_CONTINUE, 0]) {
        [self continue_];
    } else if ([self predicts:XP_TOKEN_KIND_RETURN, 0]) {
        [self returnStat_];
    } else if ([self predicts:XP_TOKEN_KIND_DEL, 0]) {
        [self delStat_];
    } else if ([self speculate:^{ [self assign_]; }]) {
        [self assign_];
    } else if ([self speculate:^{ [self assignSubscript_]; }]) {
        [self assignSubscript_];
    } else if ([self speculate:^{ [self assignAppend_]; }]) {
        [self assignAppend_];
    } else if ([self speculate:^{ [self expr_]; }]) {
        [self expr_];
    } else {
        [self raise:@"No viable alternative found in rule 'realStat'."];
    }
    [self execute:^{
        self.valid=NO;
    }];
    
    [self fireDelegateSelector:@selector(parser:didMatchRealStat:)];
}

- (void)realStat_ {
    [self parseRule:@selector(__realStat) withMemo:_realStat_memo];
}

- (void)__varDecl {
    
    [self match:XP_TOKEN_KIND_VAR discard:NO]; 
    [self nl_]; 
    [self qid_]; 
    [self nl_]; 
    [self match:XP_TOKEN_KIND_EQUALS discard:YES]; 
    [self nl_]; 
    [self expr_]; 
    [self execute:^{
    
    XPNode *rhs = POP();
    XPNode *lhs = [XPNode nodeWithToken:POP()];
    PKToken *tok = POP();
    
    XPNode *stat = [XPNode nodeWithToken:tok];
    [stat addChild:lhs]; [stat addChild:rhs];
    PUSH(stat);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchVarDecl:)];
}

- (void)varDecl_ {
    [self parseRule:@selector(__varDecl) withMemo:_varDecl_memo];
}

- (void)__qid {
    
    [self matchWord:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchQid:)];
}

- (void)qid_ {
    [self parseRule:@selector(__qid) withMemo:_qid_memo];
}

- (void)__plusEq {
    
    [self match:XP_TOKEN_KIND_PLUSEQ discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchPlusEq:)];
}

- (void)plusEq_ {
    [self parseRule:@selector(__plusEq) withMemo:_plusEq_memo];
}

- (void)__minusEq {
    
    [self match:XP_TOKEN_KIND_MINUSEQ discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchMinusEq:)];
}

- (void)minusEq_ {
    [self parseRule:@selector(__minusEq) withMemo:_minusEq_memo];
}

- (void)__timesEq {
    
    [self match:XP_TOKEN_KIND_TIMESEQ discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchTimesEq:)];
}

- (void)timesEq_ {
    [self parseRule:@selector(__timesEq) withMemo:_timesEq_memo];
}

- (void)__divEq {
    
    [self match:XP_TOKEN_KIND_DIVEQ discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchDivEq:)];
}

- (void)divEq_ {
    [self parseRule:@selector(__divEq) withMemo:_divEq_memo];
}

- (void)__powEq {
    
    [self match:XP_TOKEN_KIND_POWEQ discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchPowEq:)];
}

- (void)powEq_ {
    [self parseRule:@selector(__powEq) withMemo:_powEq_memo];
}

- (void)__orEq {
    
    [self match:XP_TOKEN_KIND_OREQ discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchOrEq:)];
}

- (void)orEq_ {
    [self parseRule:@selector(__orEq) withMemo:_orEq_memo];
}

- (void)__andEq {
    
    [self match:XP_TOKEN_KIND_ANDEQ discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchAndEq:)];
}

- (void)andEq_ {
    [self parseRule:@selector(__andEq) withMemo:_andEq_memo];
}

- (void)__xorEq {
    
    [self match:XP_TOKEN_KIND_XOREQ discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchXorEq:)];
}

- (void)xorEq_ {
    [self parseRule:@selector(__xorEq) withMemo:_xorEq_memo];
}

- (void)__leftEq {
    
    [self match:XP_TOKEN_KIND_LEFTEQ discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchLeftEq:)];
}

- (void)leftEq_ {
    [self parseRule:@selector(__leftEq) withMemo:_leftEq_memo];
}

- (void)__rightEq {
    
    [self match:XP_TOKEN_KIND_RIGHTEQ discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchRightEq:)];
}

- (void)rightEq_ {
    [self parseRule:@selector(__rightEq) withMemo:_rightEq_memo];
}

- (void)__assign {
    
    [self qid_]; 
    [self nl_]; 
    if ([self predicts:XP_TOKEN_KIND_EQUALS, 0]) {
        [self match:XP_TOKEN_KIND_EQUALS discard:NO]; 
    } else if ([self predicts:XP_TOKEN_KIND_PLUSEQ, 0]) {
        [self plusEq_]; 
    } else if ([self predicts:XP_TOKEN_KIND_MINUSEQ, 0]) {
        [self minusEq_]; 
    } else if ([self predicts:XP_TOKEN_KIND_TIMESEQ, 0]) {
        [self timesEq_]; 
    } else if ([self predicts:XP_TOKEN_KIND_DIVEQ, 0]) {
        [self divEq_]; 
    } else if ([self predicts:XP_TOKEN_KIND_POWEQ, 0]) {
        [self powEq_]; 
    } else if ([self predicts:XP_TOKEN_KIND_OREQ, 0]) {
        [self orEq_]; 
    } else if ([self predicts:XP_TOKEN_KIND_ANDEQ, 0]) {
        [self andEq_]; 
    } else if ([self predicts:XP_TOKEN_KIND_XOREQ, 0]) {
        [self xorEq_]; 
    } else if ([self predicts:XP_TOKEN_KIND_LEFTEQ, 0]) {
        [self leftEq_]; 
    } else if ([self predicts:XP_TOKEN_KIND_RIGHTEQ, 0]) {
        [self rightEq_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'assign'."];
    }
    [self nl_]; 
    [self expr_]; 
    [self execute:^{
    
    XPNode *rhs = POP();
    PKToken *tok = POP();
    XPNode *lhs = [XPNode nodeWithToken:POP()];
    
    XPNode *stat = [XPNode nodeWithToken:tok];
    [stat addChild:lhs]; [stat addChild:rhs];
    PUSH(stat);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchAssign:)];
}

- (void)assign_ {
    [self parseRule:@selector(__assign) withMemo:_assign_memo];
}

- (void)__assignSubscript {
    
    [self qid_]; 
    [self nl_]; 
    [self match:XP_TOKEN_KIND_OPEN_BRACKET discard:NO]; 
    [self nl_]; 
    [self assignSlice_]; 
    [self nl_]; 
    [self match:XP_TOKEN_KIND_CLOSE_BRACKET discard:YES]; 
    [self nl_]; 
    [self match:XP_TOKEN_KIND_EQUALS discard:YES]; 
    [self nl_]; 
    [self expr_]; 
    [self execute:^{
    
    XPNode *rhs = POP();

    NSArray *nodes = REV(ABOVE(_openSquareTok));
    POP(); // square
    
    XPNode *startNode = startNode=nodes[0];
    XPNode *stopNode = nil;
    switch ([nodes count]) {
        case 1: { } break;
        case 2: { stopNode=nodes[1]; } break;
        default:{ TDAssert(0); } break;
    }

    XPNode *lhs = [XPNode nodeWithToken:POP()];
    XPNode *callNode = [XPNode nodeWithToken:_subscriptAssignTok];
    [callNode addChild:lhs];
    [callNode addChild:rhs];
    [callNode addChild:startNode];
    if (stopNode) [callNode addChild:stopNode];
    PUSH(callNode);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchAssignSubscript:)];
}

- (void)assignSubscript_ {
    [self parseRule:@selector(__assignSubscript) withMemo:_assignSubscript_memo];
}

- (void)__assignSlice {
    
    if ([self speculate:^{ if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, XP_TOKEN_KIND_BANG, XP_TOKEN_KIND_BITNOT, XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_INF, XP_TOKEN_KIND_MINUS, XP_TOKEN_KIND_NAN, XP_TOKEN_KIND_NOT, XP_TOKEN_KIND_NULL, XP_TOKEN_KIND_OPEN_BRACKET, XP_TOKEN_KIND_OPEN_CURLY, XP_TOKEN_KIND_OPEN_PAREN, XP_TOKEN_KIND_SUB, XP_TOKEN_KIND_TRUE, 0]) {[self expr_]; } else {[self matchEmpty:NO]; }[self nl_]; [self match:XP_TOKEN_KIND_COLON discard:YES]; [self nl_]; if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, XP_TOKEN_KIND_BANG, XP_TOKEN_KIND_BITNOT, XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_INF, XP_TOKEN_KIND_MINUS, XP_TOKEN_KIND_NAN, XP_TOKEN_KIND_NOT, XP_TOKEN_KIND_NULL, XP_TOKEN_KIND_OPEN_BRACKET, XP_TOKEN_KIND_OPEN_CURLY, XP_TOKEN_KIND_OPEN_PAREN, XP_TOKEN_KIND_SUB, XP_TOKEN_KIND_TRUE, 0]) {[self expr_]; } else {[self matchEmpty:NO]; }}]) {
        if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, XP_TOKEN_KIND_BANG, XP_TOKEN_KIND_BITNOT, XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_INF, XP_TOKEN_KIND_MINUS, XP_TOKEN_KIND_NAN, XP_TOKEN_KIND_NOT, XP_TOKEN_KIND_NULL, XP_TOKEN_KIND_OPEN_BRACKET, XP_TOKEN_KIND_OPEN_CURLY, XP_TOKEN_KIND_OPEN_PAREN, XP_TOKEN_KIND_SUB, XP_TOKEN_KIND_TRUE, 0]) {
            [self expr_]; 
        } else {
            [self matchEmpty:NO]; 
            [self execute:^{
            PUSH(_firstNode);
            }];
        }
        [self nl_]; 
        [self match:XP_TOKEN_KIND_COLON discard:YES]; 
        [self nl_]; 
        if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, XP_TOKEN_KIND_BANG, XP_TOKEN_KIND_BITNOT, XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_INF, XP_TOKEN_KIND_MINUS, XP_TOKEN_KIND_NAN, XP_TOKEN_KIND_NOT, XP_TOKEN_KIND_NULL, XP_TOKEN_KIND_OPEN_BRACKET, XP_TOKEN_KIND_OPEN_CURLY, XP_TOKEN_KIND_OPEN_PAREN, XP_TOKEN_KIND_SUB, XP_TOKEN_KIND_TRUE, 0]) {
            [self expr_]; 
        } else {
            [self matchEmpty:NO]; 
            [self execute:^{
            PUSH(_lastNode);
            }];
        }
    } else if ([self speculate:^{ [self expr_]; }]) {
        [self expr_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'assignSlice'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAssignSlice:)];
}

- (void)assignSlice_ {
    [self parseRule:@selector(__assignSlice) withMemo:_assignSlice_memo];
}

- (void)__assignAppend {
    
    [self qid_]; 
    [self nl_]; 
    [self match:XP_TOKEN_KIND_OPEN_BRACKET discard:YES]; 
    [self nl_]; 
    [self match:XP_TOKEN_KIND_CLOSE_BRACKET discard:YES]; 
    [self nl_]; 
    [self match:XP_TOKEN_KIND_EQUALS discard:YES]; 
    [self nl_]; 
    [self expr_]; 
    [self execute:^{
    
    XPNode *rhs = POP();
    XPNode *lhs = [XPNode nodeWithToken:POP()];
    
    XPNode *stat = [XPNode nodeWithToken:_appendTok];
    [stat addChild:lhs];
    [stat addChild:rhs];
    PUSH(stat);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchAssignAppend:)];
}

- (void)assignAppend_ {
    [self parseRule:@selector(__assignAppend) withMemo:_assignAppend_memo];
}

- (void)__whileBlock {
    
    [self execute:^{
    self.canBreak = YES;
    }];
    [self match:XP_TOKEN_KIND_WHILE discard:NO]; 
    [self expr_]; 
    [self localBlock_]; 
    [self execute:^{
    
    XPNode *block = POP();
    XPNode *expr = POP();
    XPNode *whileNode = [XPNode nodeWithToken:POP()];
    [whileNode addChild:expr];
    [whileNode addChild:block];
    PUSH(whileNode);

    }];
    [self execute:^{
    self.canBreak = NO;
    }];

    [self fireDelegateSelector:@selector(parser:didMatchWhileBlock:)];
}

- (void)whileBlock_ {
    [self parseRule:@selector(__whileBlock) withMemo:_whileBlock_memo];
}

- (void)__break {
    
    [self match:XP_TOKEN_KIND_BREAK discard:NO]; 
    [self execute:^{
    
    PUSH([XPNode nodeWithToken:POP()]);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchBreak:)];
}

- (void)break_ {
    [self parseRule:@selector(__break) withMemo:_break_memo];
}

- (void)__continue {
    
    [self match:XP_TOKEN_KIND_CONTINUE discard:NO]; 
    [self execute:^{
    
    PUSH([XPNode nodeWithToken:POP()]);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchContinue:)];
}

- (void)continue_ {
    [self parseRule:@selector(__continue) withMemo:_continue_memo];
}

- (void)__forBlock {
    
    [self execute:^{
    self.canBreak = YES;
    }];
    [self match:XP_TOKEN_KIND_FOR discard:NO]; 
    [self qid_]; 
    if ([self speculate:^{ [self match:XP_TOKEN_KIND_COMMA discard:NO]; [self qid_]; }]) {
        [self match:XP_TOKEN_KIND_COMMA discard:NO]; 
        [self qid_]; 
    }
    [self match:XP_TOKEN_KIND_IN discard:YES]; 
    [self expr_]; 
    [self localBlock_]; 
    [self execute:^{
    
    XPNode *block = POP();
    XPNode *collExpr = POP();
    XPNode *valNode = [XPNode nodeWithToken:POP()];
    XPNode *keyNode = nil;
    
    if (EQ(PEEK(), _commaTok)) {
        POP(); // comma
        keyNode = [XPNode nodeWithToken:POP()];
    }
    
    XPNode *forNode = [XPNode nodeWithToken:POP()];
    [forNode addChild:valNode];
    [forNode addChild:collExpr];
    [forNode addChild:block];
    if (keyNode) [forNode addChild:keyNode];
    PUSH(forNode);

    }];
    [self execute:^{
    self.canBreak = NO;
    }];

    [self fireDelegateSelector:@selector(parser:didMatchForBlock:)];
}

- (void)forBlock_ {
    [self parseRule:@selector(__forBlock) withMemo:_forBlock_memo];
}

- (void)__ifBlock {
    
    [self match:XP_TOKEN_KIND_IF discard:NO]; 
    [self nl_]; 
    [self expr_]; 
    [self nl_]; 
    [self localBlock_]; 
    [self execute:^{
    
    XPNode *block = POP();
    XPNode *expr = POP();
    XPNode *ifNode = [XPNode nodeWithToken:POP()];
    [ifNode addChild:expr];
    [ifNode addChild:block];
    PUSH(ifNode);

    }];
    while ([self speculate:^{ [self elifBlock_]; }]) {
        [self elifBlock_]; 
    }
    if ([self speculate:^{ [self elseBlock_]; }]) {
        [self elseBlock_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchIfBlock:)];
}

- (void)ifBlock_ {
    [self parseRule:@selector(__ifBlock) withMemo:_ifBlock_memo];
}

- (void)__elifBlock {
    
    [self execute:^{
    self.valid=YES;
    }];
    [self match:XP_TOKEN_KIND_ELSE discard:YES]; 
    [self match:XP_TOKEN_KIND_IF discard:NO]; 
    [self expr_]; 
    [self localBlock_]; 
    [self execute:^{
    
    XPNode *block = POP();
    XPNode *expr = POP();
    XPNode *elifNode = [XPNode nodeWithToken:POP()];
    [elifNode addChild:expr];
    [elifNode addChild:block];

    XPNode *ifNode = PEEK();
    [ifNode addChild:elifNode];

    }];

    [self fireDelegateSelector:@selector(parser:didMatchElifBlock:)];
}

- (void)elifBlock_ {
    [self parseRule:@selector(__elifBlock) withMemo:_elifBlock_memo];
}

- (void)__elseBlock {
    
    [self execute:^{
    self.valid=YES;
    }];
    [self match:XP_TOKEN_KIND_ELSE discard:NO]; 
    [self localBlock_]; 
    [self execute:^{
    
    XPNode *block = POP();
    XPNode *elseNode = [XPNode nodeWithToken:POP()];
    [elseNode addChild:block];

    XPNode *ifNode = PEEK();
    [ifNode addChild:elseNode];

    }];

    [self fireDelegateSelector:@selector(parser:didMatchElseBlock:)];
}

- (void)elseBlock_ {
    [self parseRule:@selector(__elseBlock) withMemo:_elseBlock_memo];
}

- (void)__tryBlock {
    
    [self match:XP_TOKEN_KIND_TRY discard:NO]; 
    [self localBlock_]; 
    [self execute:^{
    
    XPNode *block = POP();
    XPNode *tryNode = [XPNode nodeWithToken:POP()];
    [tryNode addChild:block];
    PUSH(tryNode);

    }];
    if ([self predicts:XP_TOKEN_KIND_CATCH, 0]) {
        [self catchBlock_]; 
        if ([self speculate:^{ [self finallyBlock_]; }]) {
            [self finallyBlock_]; 
        }
    } else if ([self predicts:XP_TOKEN_KIND_FINALLY, 0]) {
        [self finallyBlock_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchTryBlock:)];
}

- (void)tryBlock_ {
    [self parseRule:@selector(__tryBlock) withMemo:_tryBlock_memo];
}

- (void)__catchBlock {
    
    [self execute:^{
    self.valid=YES;
    }];
    [self match:XP_TOKEN_KIND_CATCH discard:NO]; 
    [self qid_]; 
    [self localBlock_]; 
    [self execute:^{
    
  XPNode *block = POP();
  XPNode *qid = [XPNode nodeWithToken:POP()];
  XPNode *catchNode = [XPNode nodeWithToken:POP()];
  [catchNode addChild:qid];
  [catchNode addChild:block];

  XPNode *tryNode = PEEK();
  [tryNode addChild:catchNode];

    }];

    [self fireDelegateSelector:@selector(parser:didMatchCatchBlock:)];
}

- (void)catchBlock_ {
    [self parseRule:@selector(__catchBlock) withMemo:_catchBlock_memo];
}

- (void)__finallyBlock {
    
    [self execute:^{
    self.valid=YES;
    }];
    [self match:XP_TOKEN_KIND_FINALLY discard:NO]; 
    [self localBlock_]; 
    [self execute:^{
    
    XPNode *block = POP();
    XPNode *finallyNode = [XPNode nodeWithToken:POP()];
    [finallyNode addChild:block];

    XPNode *tryNode = PEEK();
    [tryNode addChild:finallyNode];

    }];

    [self fireDelegateSelector:@selector(parser:didMatchFinallyBlock:)];
}

- (void)finallyBlock_ {
    [self parseRule:@selector(__finallyBlock) withMemo:_finallyBlock_memo];
}

- (void)__throwStat {
    
    [self match:XP_TOKEN_KIND_THROW discard:NO]; 
    [self nl_]; 
    [self expr_]; 
    [self execute:^{
    
    XPNode *expr = POP();
    XPNode *throwNode = [XPNode nodeWithToken:POP()];
    [throwNode addChild:expr];
    PUSH(throwNode);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchThrowStat:)];
}

- (void)throwStat_ {
    [self parseRule:@selector(__throwStat) withMemo:_throwStat_memo];
}

- (void)__del {
    
    [self match:XP_TOKEN_KIND_DEL discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchDel:)];
}

- (void)del_ {
    [self parseRule:@selector(__del) withMemo:_del_memo];
}

- (void)__delStat {
    
    [self del_]; 
    [self nl_]; 
    [self expr_]; 
    [self execute:^{
    
    XPNode *delNode = [XPNode nodeWithToken:_delTok];
    [delNode addChild:POP()];
    PUSH(delNode);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchDelStat:)];
}

- (void)delStat_ {
    [self parseRule:@selector(__delStat) withMemo:_delStat_memo];
}

- (void)__returnStat {
    
    [self match:XP_TOKEN_KIND_RETURN discard:NO]; 
    [self nl_]; 
    [self expr_]; 
    [self execute:^{
    
    XPNode *expr = POP();
    XPNode *ret = [XPNode nodeWithToken:POP()];
    [ret addChild:expr];
    PUSH(ret);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchReturnStat:)];
}

- (void)returnStat_ {
    [self parseRule:@selector(__returnStat) withMemo:_returnStat_memo];
}

- (void)__funcDecl {
    
    [self match:XP_TOKEN_KIND_SUB discard:NO]; 
    [self qid_]; 
    [self execute:^{
        
    // def func
    PKToken *nameTok = POP();
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:nameTok.stringValue enclosingScope:_currentScope];
    [_currentScope defineSymbol:funcSym];
    id subTok = POP();
    XPNode *funcNode = [XPNode nodeWithToken:subTok];
    XPNode *nameNode = [XPNode nodeWithToken:nameTok];
    nameNode.scope = _currentScope;
    [funcNode addChild:nameNode];
    PUSH(funcNode);
    PUSH(subTok); // barrier for later

    // push func scope
    self.currentScope = funcSym;

    }];
    [self funcBody_]; 

    [self fireDelegateSelector:@selector(parser:didMatchFuncDecl:)];
}

- (void)funcDecl_ {
    [self parseRule:@selector(__funcDecl) withMemo:_funcDecl_memo];
}

- (void)__funcBody {
    
    [self match:XP_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self paramList_]; 
    [self match:XP_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
    [self execute:^{
    
    XPFunctionSymbol *funcSym = (id)_currentScope;
    NSMutableDictionary *params = POP();
    [funcSym.params addEntriesFromDictionary:params];

    }];
    [self funcBlock_]; 
    [self execute:^{
    
    XPNode *block = POP();
    POP(); // 'sub'
    XPNode *funcNode = POP();
    [funcNode addChild:block];
    PUSH(funcNode);

    XPFunctionSymbol *funcSym = (id)_currentScope;
    funcSym.blockNode = block;

    // pop scope
    self.currentScope = _currentScope.enclosingScope;

    }];

    [self fireDelegateSelector:@selector(parser:didMatchFuncBody:)];
}

- (void)funcBody_ {
    [self parseRule:@selector(__funcBody) withMemo:_funcBody_memo];
}

- (void)__paramList {
    
    [self execute:^{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    PUSH(params);
    _foundDefaultParam = NO;

    }];
    if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self param_]; 
        while ([self speculate:^{ [self match:XP_TOKEN_KIND_COMMA discard:YES]; [self param_]; }]) {
            [self match:XP_TOKEN_KIND_COMMA discard:YES]; 
            [self param_]; 
        }
    }

    [self fireDelegateSelector:@selector(parser:didMatchParamList:)];
}

- (void)paramList_ {
    [self parseRule:@selector(__paramList) withMemo:_paramList_memo];
}

- (void)__param {
    
    if ([self speculate:^{ [self dfaultParam_]; }]) {
        [self dfaultParam_]; 
    } else if ([self speculate:^{ [self nakedParam_]; }]) {
        [self nakedParam_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'param'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchParam:)];
}

- (void)param_ {
    [self parseRule:@selector(__param) withMemo:_param_memo];
}

- (void)__dfaultParam {
    
    [self qid_]; 
    [self match:XP_TOKEN_KIND_EQUALS discard:YES]; 
    [self expr_]; 
    [self execute:^{
    
    _foundDefaultParam = YES;

    XPNode *exprNode = POP();
    PKToken *nameToken = PEEK();
    NSString *name = POP_STR();

    XPFunctionSymbol *funcSym = (id)_currentScope;

    // set default val
    [funcSym setDefaultExpression:exprNode forParamNamed:name];

    XPVariableSymbol *sym = [XPVariableSymbol symbolWithName:name];
    NSMutableDictionary *params = POP();

    // check for dupe param names
    if ([params objectForKey:name]) [self raiseInRange:NSMakeRange(nameToken.offset, [name length]) lineNumber:nameToken.lineNumber name:XPSyntaxError format:@"more than one param named `%@` in declaration of subroutine `%@`", name, funcSym.name];

    [params setObject:sym forKey:name];
    PUSH(params);
    [funcSym.orderedParams addObject:sym];

    }];

    [self fireDelegateSelector:@selector(parser:didMatchDfaultParam:)];
}

- (void)dfaultParam_ {
    [self parseRule:@selector(__dfaultParam) withMemo:_dfaultParam_memo];
}

- (void)__nakedParam {
    
    [self testAndThrow:(id)^{ return !_foundDefaultParam; }]; 
    [self qid_]; 
    [self execute:^{
    
    PKToken *nameTok = PEEK();
    NSString *name = POP_STR();
    XPVariableSymbol *sym = [XPVariableSymbol symbolWithName:name];
    XPFunctionSymbol *funcSym = (id)_currentScope;
    NSMutableDictionary *params = POP();
        
    // check for dupe param names
    if ([params objectForKey:name]) [self raiseInRange:NSMakeRange(nameTok.offset, [name length]) lineNumber:nameTok.lineNumber name:XPSyntaxError format:@"more than one param named `%@` in declaration of subroutine `%@`", name, funcSym.name];
        
    [params setObject:sym forKey:name];
    PUSH(params);

    [funcSym.orderedParams addObject:sym];

    }];

    [self fireDelegateSelector:@selector(parser:didMatchNakedParam:)];
}

- (void)nakedParam_ {
    [self parseRule:@selector(__nakedParam) withMemo:_nakedParam_memo];
}

- (void)__funcLiteral {
    
    [self match:XP_TOKEN_KIND_SUB discard:NO]; 
    [self execute:^{
    
    // def func
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:_anonTok.stringValue enclosingScope:_currentScope];
    funcSym.scope = _currentScope;
    // don't define fyncSym here
    PKToken *subTok = POP();
    XPNode *funcNode = [XPNode nodeWithToken:_anonTok];
    [funcNode addChild:(id)funcSym];
    PUSH(funcNode);
    PUSH(subTok); // barrier for later

    // push func scope
    self.currentScope = funcSym;

    }];
    [self funcBody_]; 

    [self fireDelegateSelector:@selector(parser:didMatchFuncLiteral:)];
}

- (void)funcLiteral_ {
    [self parseRule:@selector(__funcLiteral) withMemo:_funcLiteral_memo];
}

- (void)__funcCall {
    
    [self match:XP_TOKEN_KIND_OPEN_PAREN discard:NO]; 
    [self nl_]; 
    if ([self speculate:^{ [self argList_]; }]) {
        [self argList_]; 
    }
    [self nl_]; 
    [self match:XP_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
    [self execute:^{
    
    NSArray *args = REV(ABOVE(_openParenTok));
    POP(); // '('
    XPNode *callNode = [XPNode nodeWithToken:_callTok];
    [callNode addChild:POP()]; // call target obj
    [callNode addChildren:args];
    PUSH(callNode);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchFuncCall:)];
}

- (void)funcCall_ {
    [self parseRule:@selector(__funcCall) withMemo:_funcCall_memo];
}

- (void)__argList {
    
    [self arg_]; 
    while ([self speculate:^{ [self nl_]; [self match:XP_TOKEN_KIND_COMMA discard:YES]; [self nl_]; [self arg_]; }]) {
        [self nl_]; 
        [self match:XP_TOKEN_KIND_COMMA discard:YES]; 
        [self nl_]; 
        [self arg_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchArgList:)];
}

- (void)argList_ {
    [self parseRule:@selector(__argList) withMemo:_argList_memo];
}

- (void)__arg {
    
    [self expr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchArg:)];
}

- (void)arg_ {
    [self parseRule:@selector(__arg) withMemo:_arg_memo];
}

- (void)__expr {
    
    [self orExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchExpr:)];
}

- (void)expr_ {
    [self parseRule:@selector(__expr) withMemo:_expr_memo];
}

- (void)__or {
    
    [self match:XP_TOKEN_KIND_OR discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchOr:)];
}

- (void)or_ {
    [self parseRule:@selector(__or) withMemo:_or_memo];
}

- (void)__orExpr {
    
    [self andExpr_]; 
    while ([self speculate:^{ [self nl_]; [self or_]; [self nl_]; [self andExpr_]; }]) {
        [self nl_]; 
        [self or_]; 
        [self nl_]; 
        [self andExpr_]; 
        [self execute:^{
        
    id rhs = POP();
    XPNode *orNode = [XPNode nodeWithToken:POP()];
    id lhs = POP();
    [orNode addChild:lhs];
    [orNode addChild:rhs];
    PUSH(orNode);

        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchOrExpr:)];
}

- (void)orExpr_ {
    [self parseRule:@selector(__orExpr) withMemo:_orExpr_memo];
}

- (void)__and {
    
    [self match:XP_TOKEN_KIND_AND discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchAnd:)];
}

- (void)and_ {
    [self parseRule:@selector(__and) withMemo:_and_memo];
}

- (void)__andExpr {
    
    [self membershipExpr_]; 
    while ([self speculate:^{ [self nl_]; [self and_]; [self nl_]; [self membershipExpr_]; }]) {
        [self nl_]; 
        [self and_]; 
        [self nl_]; 
        [self membershipExpr_]; 
        [self execute:^{
        
    id rhs = POP();
    XPNode *andNode = [XPNode nodeWithToken:POP()];
    id lhs = POP();
    [andNode addChild:lhs];
    [andNode addChild:rhs];
    PUSH(andNode);

        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAndExpr:)];
}

- (void)andExpr_ {
    [self parseRule:@selector(__andExpr) withMemo:_andExpr_memo];
}

- (void)__inOp {
    
    [self match:XP_TOKEN_KIND_IN discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchInOp:)];
}

- (void)inOp_ {
    [self parseRule:@selector(__inOp) withMemo:_inOp_memo];
}

- (void)__membershipExpr {
    
    [self equalityExpr_]; 
    while ([self speculate:^{ [self nl_]; [self inOp_]; [self nl_]; [self equalityExpr_]; }]) {
        [self nl_]; 
        [self inOp_]; 
        [self nl_]; 
        [self equalityExpr_]; 
        [self execute:^{
        
    XPNode *rhs = POP();
    XPNode *eqNode = [XPNode nodeWithToken:POP()];
    XPNode *lhs = POP();
    [eqNode addChild:lhs];
    [eqNode addChild:rhs];
    PUSH(eqNode);

        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchMembershipExpr:)];
}

- (void)membershipExpr_ {
    [self parseRule:@selector(__membershipExpr) withMemo:_membershipExpr_memo];
}

- (void)__eq {
    
    [self match:XP_TOKEN_KIND_EQ discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchEq:)];
}

- (void)eq_ {
    [self parseRule:@selector(__eq) withMemo:_eq_memo];
}

- (void)__ne {
    
    [self match:XP_TOKEN_KIND_NE discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchNe:)];
}

- (void)ne_ {
    [self parseRule:@selector(__ne) withMemo:_ne_memo];
}

- (void)__is {
    
    [self match:XP_TOKEN_KIND_IS discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchIs:)];
}

- (void)is_ {
    [self parseRule:@selector(__is) withMemo:_is_memo];
}

- (void)__equalityExpr {
    
    [self relationalExpr_]; 
    while ([self speculate:^{ [self nl_]; if ([self predicts:XP_TOKEN_KIND_EQ, 0]) {[self eq_]; } else if ([self predicts:XP_TOKEN_KIND_NE, 0]) {[self ne_]; } else if ([self predicts:XP_TOKEN_KIND_IS, 0]) {[self is_]; } else {[self raise:@"No viable alternative found in rule 'equalityExpr'."];}[self nl_]; [self relationalExpr_]; }]) {
        [self nl_]; 
        if ([self predicts:XP_TOKEN_KIND_EQ, 0]) {
            [self eq_]; 
        } else if ([self predicts:XP_TOKEN_KIND_NE, 0]) {
            [self ne_]; 
        } else if ([self predicts:XP_TOKEN_KIND_IS, 0]) {
            [self is_]; 
        } else {
            [self raise:@"No viable alternative found in rule 'equalityExpr'."];
        }
        [self nl_]; 
        [self relationalExpr_]; 
        [self execute:^{
        
    XPNode *rhs = POP();
    XPNode *eqNode = [XPNode nodeWithToken:POP()];
    XPNode *lhs = POP();
    [eqNode addChild:lhs];
    [eqNode addChild:rhs];
    PUSH(eqNode);

        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchEqualityExpr:)];
}

- (void)equalityExpr_ {
    [self parseRule:@selector(__equalityExpr) withMemo:_equalityExpr_memo];
}

- (void)__lt {
    
    [self match:XP_TOKEN_KIND_LT discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchLt:)];
}

- (void)lt_ {
    [self parseRule:@selector(__lt) withMemo:_lt_memo];
}

- (void)__gt {
    
    [self match:XP_TOKEN_KIND_GT discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchGt:)];
}

- (void)gt_ {
    [self parseRule:@selector(__gt) withMemo:_gt_memo];
}

- (void)__le {
    
    [self match:XP_TOKEN_KIND_LE discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchLe:)];
}

- (void)le_ {
    [self parseRule:@selector(__le) withMemo:_le_memo];
}

- (void)__ge {
    
    [self match:XP_TOKEN_KIND_GE discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchGe:)];
}

- (void)ge_ {
    [self parseRule:@selector(__ge) withMemo:_ge_memo];
}

- (void)__relationalExpr {
    
    [self additiveExpr_]; 
    while ([self speculate:^{ [self nl_]; if ([self predicts:XP_TOKEN_KIND_LT, 0]) {[self lt_]; } else if ([self predicts:XP_TOKEN_KIND_GT, 0]) {[self gt_]; } else if ([self predicts:XP_TOKEN_KIND_LE, 0]) {[self le_]; } else if ([self predicts:XP_TOKEN_KIND_GE, 0]) {[self ge_]; } else {[self raise:@"No viable alternative found in rule 'relationalExpr'."];}[self nl_]; [self additiveExpr_]; }]) {
        [self nl_]; 
        if ([self predicts:XP_TOKEN_KIND_LT, 0]) {
            [self lt_]; 
        } else if ([self predicts:XP_TOKEN_KIND_GT, 0]) {
            [self gt_]; 
        } else if ([self predicts:XP_TOKEN_KIND_LE, 0]) {
            [self le_]; 
        } else if ([self predicts:XP_TOKEN_KIND_GE, 0]) {
            [self ge_]; 
        } else {
            [self raise:@"No viable alternative found in rule 'relationalExpr'."];
        }
        [self nl_]; 
        [self additiveExpr_]; 
        [self execute:^{
        
    XPNode *rhs = POP();
    XPNode *relNode = [XPNode nodeWithToken:POP()];
    XPNode *lhs = POP();
    [relNode addChild:lhs];
    [relNode addChild:rhs];
    PUSH(relNode);

        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchRelationalExpr:)];
}

- (void)relationalExpr_ {
    [self parseRule:@selector(__relationalExpr) withMemo:_relationalExpr_memo];
}

- (void)__plus {
    
    [self match:XP_TOKEN_KIND_PLUS discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchPlus:)];
}

- (void)plus_ {
    [self parseRule:@selector(__plus) withMemo:_plus_memo];
}

- (void)__minus {
    
    [self match:XP_TOKEN_KIND_MINUS discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchMinus:)];
}

- (void)minus_ {
    [self parseRule:@selector(__minus) withMemo:_minus_memo];
}

- (void)__additiveExpr {
    
    [self multiplicativeExpr_]; 
    while ([self speculate:^{ [self nl_]; if ([self predicts:XP_TOKEN_KIND_PLUS, 0]) {[self plus_]; } else if ([self predicts:XP_TOKEN_KIND_MINUS, 0]) {[self minus_]; } else {[self raise:@"No viable alternative found in rule 'additiveExpr'."];}[self nl_]; [self multiplicativeExpr_]; }]) {
        [self nl_]; 
        if ([self predicts:XP_TOKEN_KIND_PLUS, 0]) {
            [self plus_]; 
        } else if ([self predicts:XP_TOKEN_KIND_MINUS, 0]) {
            [self minus_]; 
        } else {
            [self raise:@"No viable alternative found in rule 'additiveExpr'."];
        }
        [self nl_]; 
        [self multiplicativeExpr_]; 
        [self execute:^{
        
    XPNode *rhs = POP();
    XPNode *addNode = [XPNode nodeWithToken:POP()];
    XPNode *lhs = POP();
    [addNode addChild:lhs];
    [addNode addChild:rhs];
    PUSH(addNode);

        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAdditiveExpr:)];
}

- (void)additiveExpr_ {
    [self parseRule:@selector(__additiveExpr) withMemo:_additiveExpr_memo];
}

- (void)__times {
    
    [self match:XP_TOKEN_KIND_TIMES discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchTimes:)];
}

- (void)times_ {
    [self parseRule:@selector(__times) withMemo:_times_memo];
}

- (void)__div {
    
    [self match:XP_TOKEN_KIND_DIV discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchDiv:)];
}

- (void)div_ {
    [self parseRule:@selector(__div) withMemo:_div_memo];
}

- (void)__mod {
    
    [self match:XP_TOKEN_KIND_MOD discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchMod:)];
}

- (void)mod_ {
    [self parseRule:@selector(__mod) withMemo:_mod_memo];
}

- (void)__multiplicativeExpr {
    
    [self bitExpr_]; 
    while ([self speculate:^{ [self nl_]; if ([self predicts:XP_TOKEN_KIND_TIMES, 0]) {[self times_]; } else if ([self predicts:XP_TOKEN_KIND_DIV, 0]) {[self div_]; } else if ([self predicts:XP_TOKEN_KIND_MOD, 0]) {[self mod_]; } else {[self raise:@"No viable alternative found in rule 'multiplicativeExpr'."];}[self nl_]; [self bitExpr_]; }]) {
        [self nl_]; 
        if ([self predicts:XP_TOKEN_KIND_TIMES, 0]) {
            [self times_]; 
        } else if ([self predicts:XP_TOKEN_KIND_DIV, 0]) {
            [self div_]; 
        } else if ([self predicts:XP_TOKEN_KIND_MOD, 0]) {
            [self mod_]; 
        } else {
            [self raise:@"No viable alternative found in rule 'multiplicativeExpr'."];
        }
        [self nl_]; 
        [self bitExpr_]; 
        [self execute:^{
        
    XPNode *rhs = POP();
    XPNode *multNode = [XPNode nodeWithToken:POP()];
    XPNode *lhs = POP();
    [multNode addChild:lhs];
    [multNode addChild:rhs];
    PUSH(multNode);

        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchMultiplicativeExpr:)];
}

- (void)multiplicativeExpr_ {
    [self parseRule:@selector(__multiplicativeExpr) withMemo:_multiplicativeExpr_memo];
}

- (void)__bitAnd {
    
    [self match:XP_TOKEN_KIND_BITAND discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchBitAnd:)];
}

- (void)bitAnd_ {
    [self parseRule:@selector(__bitAnd) withMemo:_bitAnd_memo];
}

- (void)__bitOr {
    
    [self match:XP_TOKEN_KIND_BITOR discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchBitOr:)];
}

- (void)bitOr_ {
    [self parseRule:@selector(__bitOr) withMemo:_bitOr_memo];
}

- (void)__bitXor {
    
    [self match:XP_TOKEN_KIND_BITXOR discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchBitXor:)];
}

- (void)bitXor_ {
    [self parseRule:@selector(__bitXor) withMemo:_bitXor_memo];
}

- (void)__bitExpr {
    
    [self shiftExpr_]; 
    while ([self speculate:^{ [self nl_]; if ([self predicts:XP_TOKEN_KIND_BITAND, 0]) {[self bitAnd_]; } else if ([self predicts:XP_TOKEN_KIND_BITOR, 0]) {[self bitOr_]; } else if ([self predicts:XP_TOKEN_KIND_BITXOR, 0]) {[self bitXor_]; } else {[self raise:@"No viable alternative found in rule 'bitExpr'."];}[self nl_]; [self shiftExpr_]; }]) {
        [self nl_]; 
        if ([self predicts:XP_TOKEN_KIND_BITAND, 0]) {
            [self bitAnd_]; 
        } else if ([self predicts:XP_TOKEN_KIND_BITOR, 0]) {
            [self bitOr_]; 
        } else if ([self predicts:XP_TOKEN_KIND_BITXOR, 0]) {
            [self bitXor_]; 
        } else {
            [self raise:@"No viable alternative found in rule 'bitExpr'."];
        }
        [self nl_]; 
        [self shiftExpr_]; 
        [self execute:^{
        
    XPNode *rhs = POP();
    XPNode *bitNode = [XPNode nodeWithToken:POP()];
    XPNode *lhs = POP();
    [bitNode addChild:lhs];
    [bitNode addChild:rhs];
    PUSH(bitNode);

        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchBitExpr:)];
}

- (void)bitExpr_ {
    [self parseRule:@selector(__bitExpr) withMemo:_bitExpr_memo];
}

- (void)__shiftLeft {
    
    [self match:XP_TOKEN_KIND_SHIFTLEFT discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchShiftLeft:)];
}

- (void)shiftLeft_ {
    [self parseRule:@selector(__shiftLeft) withMemo:_shiftLeft_memo];
}

- (void)__shiftRight {
    
    [self match:XP_TOKEN_KIND_SHIFTRIGHT discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchShiftRight:)];
}

- (void)shiftRight_ {
    [self parseRule:@selector(__shiftRight) withMemo:_shiftRight_memo];
}

- (void)__shiftExpr {
    
    [self powExpr_]; 
    while ([self speculate:^{ [self nl_]; if ([self predicts:XP_TOKEN_KIND_SHIFTLEFT, 0]) {[self shiftLeft_]; } else if ([self predicts:XP_TOKEN_KIND_SHIFTRIGHT, 0]) {[self shiftRight_]; } else {[self raise:@"No viable alternative found in rule 'shiftExpr'."];}[self nl_]; [self powExpr_]; }]) {
        [self nl_]; 
        if ([self predicts:XP_TOKEN_KIND_SHIFTLEFT, 0]) {
            [self shiftLeft_]; 
        } else if ([self predicts:XP_TOKEN_KIND_SHIFTRIGHT, 0]) {
            [self shiftRight_]; 
        } else {
            [self raise:@"No viable alternative found in rule 'shiftExpr'."];
        }
        [self nl_]; 
        [self powExpr_]; 
        [self execute:^{
        
    XPNode *rhs = POP();
    XPNode *shiftNode = [XPNode nodeWithToken:POP()];
    XPNode *lhs = POP();
    [shiftNode addChild:lhs];
    [shiftNode addChild:rhs];
    PUSH(shiftNode);

        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchShiftExpr:)];
}

- (void)shiftExpr_ {
    [self parseRule:@selector(__shiftExpr) withMemo:_shiftExpr_memo];
}

- (void)__pow {
    
    [self match:XP_TOKEN_KIND_POW discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchPow:)];
}

- (void)pow_ {
    [self parseRule:@selector(__pow) withMemo:_pow_memo];
}

- (void)__powExpr {
    
    [self unaryExpr_]; 
    while ([self speculate:^{ [self nl_]; [self pow_]; [self nl_]; [self unaryExpr_]; }]) {
        [self nl_]; 
        [self pow_]; 
        [self nl_]; 
        [self unaryExpr_]; 
        [self execute:^{
        
    XPNode *rhs = POP();
    XPNode *shiftNode = [XPNode nodeWithToken:POP()];
    XPNode *lhs = POP();
    [shiftNode addChild:lhs];
    [shiftNode addChild:rhs];
    PUSH(shiftNode);

        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchPowExpr:)];
}

- (void)powExpr_ {
    [self parseRule:@selector(__powExpr) withMemo:_powExpr_memo];
}

- (void)__unaryExpr {
    
    if ([self predicts:XP_TOKEN_KIND_BANG, XP_TOKEN_KIND_NOT, 0]) {
        [self negatedUnary_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, XP_TOKEN_KIND_BITNOT, XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_INF, XP_TOKEN_KIND_MINUS, XP_TOKEN_KIND_NAN, XP_TOKEN_KIND_NULL, XP_TOKEN_KIND_OPEN_BRACKET, XP_TOKEN_KIND_OPEN_CURLY, XP_TOKEN_KIND_OPEN_PAREN, XP_TOKEN_KIND_SUB, XP_TOKEN_KIND_TRUE, 0]) {
        [self unary_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'unaryExpr'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchUnaryExpr:)];
}

- (void)unaryExpr_ {
    [self parseRule:@selector(__unaryExpr) withMemo:_unaryExpr_memo];
}

- (void)__negatedUnary {
    
    [self execute:^{
     _negation = NO; 
    }];
    do {
        if ([self predicts:XP_TOKEN_KIND_NOT, 0]) {
            [self match:XP_TOKEN_KIND_NOT discard:YES]; 
        } else if ([self predicts:XP_TOKEN_KIND_BANG, 0]) {
            [self match:XP_TOKEN_KIND_BANG discard:YES]; 
        } else {
            [self raise:@"No viable alternative found in rule 'negatedUnary'."];
        }
        [self execute:^{
         _negation = !_negation; 
        }];
    } while ([self predicts:XP_TOKEN_KIND_BANG, XP_TOKEN_KIND_NOT, 0]);
    [self nl_]; 
    [self unary_]; 
    [self execute:^{
    

    }];
    [self execute:^{
    
    if (_negation) {
        XPNode *notNode = [XPNode nodeWithToken:_notTok];
        [notNode addChild:POP()];
        PUSH(notNode);
    }

    }];

    [self fireDelegateSelector:@selector(parser:didMatchNegatedUnary:)];
}

- (void)negatedUnary_ {
    [self parseRule:@selector(__negatedUnary) withMemo:_negatedUnary_memo];
}

- (void)__bitNot {
    
    [self match:XP_TOKEN_KIND_BITNOT discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchBitNot:)];
}

- (void)bitNot_ {
    [self parseRule:@selector(__bitNot) withMemo:_bitNot_memo];
}

- (void)__unary {
    
    if ([self predicts:XP_TOKEN_KIND_BITNOT, XP_TOKEN_KIND_MINUS, 0]) {
        [self signedPrimaryExpr_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_INF, XP_TOKEN_KIND_NAN, XP_TOKEN_KIND_NULL, XP_TOKEN_KIND_OPEN_BRACKET, XP_TOKEN_KIND_OPEN_CURLY, XP_TOKEN_KIND_OPEN_PAREN, XP_TOKEN_KIND_SUB, XP_TOKEN_KIND_TRUE, 0]) {
        [self primaryExpr_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'unary'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchUnary:)];
}

- (void)unary_ {
    [self parseRule:@selector(__unary) withMemo:_unary_memo];
}

- (void)__signedPrimaryExpr {
    
    [self execute:^{
    
    _negative = NO; 

    }];
    if ([self predicts:XP_TOKEN_KIND_MINUS, 0]) {
        do {
            [self match:XP_TOKEN_KIND_MINUS discard:YES]; 
            [self execute:^{
             self.unaryTok = _negTok; _negative = !_negative; 
            }];
        } while ([self predicts:XP_TOKEN_KIND_MINUS, 0]);
        [self nl_]; 
        [self primaryExpr_]; 
    } else if ([self predicts:XP_TOKEN_KIND_BITNOT, 0]) {
        do {
            [self bitNot_]; 
            [self execute:^{
             self.unaryTok = POP(); _negative = !_negative; 
            }];
        } while ([self predicts:XP_TOKEN_KIND_BITNOT, 0]);
        [self nl_]; 
        [self primaryExpr_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'signedPrimaryExpr'."];
    }
    [self execute:^{
    
    if (_negative) {
        XPNode *negNode = [XPNode nodeWithToken:_unaryTok];
        [negNode addChild:POP()];
        PUSH(negNode);
    }

    }];

    [self fireDelegateSelector:@selector(parser:didMatchSignedPrimaryExpr:)];
}

- (void)signedPrimaryExpr_ {
    [self parseRule:@selector(__signedPrimaryExpr) withMemo:_signedPrimaryExpr_memo];
}

- (void)__primaryExpr {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_INF, XP_TOKEN_KIND_NAN, XP_TOKEN_KIND_NULL, XP_TOKEN_KIND_OPEN_BRACKET, XP_TOKEN_KIND_OPEN_CURLY, XP_TOKEN_KIND_SUB, XP_TOKEN_KIND_TRUE, 0]) {
        [self atom_]; 
    } else if ([self predicts:XP_TOKEN_KIND_OPEN_PAREN, 0]) {
        [self subExpr_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'primaryExpr'."];
    }
    while ([self speculate:^{ [self trailer_]; }]) {
        [self trailer_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchPrimaryExpr:)];
}

- (void)primaryExpr_ {
    [self parseRule:@selector(__primaryExpr) withMemo:_primaryExpr_memo];
}

- (void)__trailer {
    
    if ([self predicts:XP_TOKEN_KIND_OPEN_PAREN, 0]) {
        [self funcCall_]; 
    } else if ([self predicts:XP_TOKEN_KIND_OPEN_BRACKET, 0]) {
        [self loadSubscript_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'trailer'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchTrailer:)];
}

- (void)trailer_ {
    [self parseRule:@selector(__trailer) withMemo:_trailer_memo];
}

- (void)__subExpr {
    
    [self match:XP_TOKEN_KIND_OPEN_PAREN discard:NO]; 
    [self nl_]; 
    [self expr_]; 
    [self nl_]; 
    [self match:XP_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
    [self execute:^{
    
    id objs = ABOVE(_openParenTok);
    POP(); // discard `(`
    PUSH_ALL(REV(objs));

    }];

    [self fireDelegateSelector:@selector(parser:didMatchSubExpr:)];
}

- (void)subExpr_ {
    [self parseRule:@selector(__subExpr) withMemo:_subExpr_memo];
}

- (void)__atom {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_INF, XP_TOKEN_KIND_NAN, XP_TOKEN_KIND_NULL, XP_TOKEN_KIND_TRUE, 0]) {
        [self scalar_]; 
    } else if ([self predicts:XP_TOKEN_KIND_OPEN_BRACKET, 0]) {
        [self arrayLiteral_]; 
    } else if ([self predicts:XP_TOKEN_KIND_OPEN_CURLY, 0]) {
        [self dictLiteral_]; 
    } else if ([self predicts:XP_TOKEN_KIND_SUB, 0]) {
        [self funcLiteral_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self varRef_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'atom'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAtom:)];
}

- (void)atom_ {
    [self parseRule:@selector(__atom) withMemo:_atom_memo];
}

- (void)__loadSubscript {
    
    [self match:XP_TOKEN_KIND_OPEN_BRACKET discard:NO]; 
    [self nl_]; 
    [self loadSlice_]; 
    [self nl_]; 
    [self match:XP_TOKEN_KIND_CLOSE_BRACKET discard:YES]; 
    [self execute:^{
    
    NSArray *nodes = REV(ABOVE(_openSquareTok));
    POP(); // square
    
    XPNode *startNode = startNode=nodes[0];
    XPNode *stopNode = nil;
    XPNode *stepNode = nil;
    switch ([nodes count]) {
        case 1: { } break;
        case 2: { stopNode=nodes[1]; } break;
        case 3: { stopNode=nodes[1]; stepNode=nodes[2]; } break;
        default:{ TDAssert(0); } break;
    }

    XPNode *targetNode = POP();
    XPNode *callNode = [XPNode nodeWithToken:_subscriptLoadTok];
    [callNode addChild:targetNode];
    [callNode addChild:startNode];
    if (stopNode) [callNode addChild:stopNode];
    if (stepNode) [callNode addChild:stepNode];
    PUSH(callNode);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchLoadSubscript:)];
}

- (void)loadSubscript_ {
    [self parseRule:@selector(__loadSubscript) withMemo:_loadSubscript_memo];
}

- (void)__loadSlice {
    
    if ([self speculate:^{ if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, XP_TOKEN_KIND_BANG, XP_TOKEN_KIND_BITNOT, XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_INF, XP_TOKEN_KIND_MINUS, XP_TOKEN_KIND_NAN, XP_TOKEN_KIND_NOT, XP_TOKEN_KIND_NULL, XP_TOKEN_KIND_OPEN_BRACKET, XP_TOKEN_KIND_OPEN_CURLY, XP_TOKEN_KIND_OPEN_PAREN, XP_TOKEN_KIND_SUB, XP_TOKEN_KIND_TRUE, 0]) {[self expr_]; } else {[self matchEmpty:NO]; }[self nl_]; [self match:XP_TOKEN_KIND_COLON discard:YES]; [self nl_]; if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, XP_TOKEN_KIND_BANG, XP_TOKEN_KIND_BITNOT, XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_INF, XP_TOKEN_KIND_MINUS, XP_TOKEN_KIND_NAN, XP_TOKEN_KIND_NOT, XP_TOKEN_KIND_NULL, XP_TOKEN_KIND_OPEN_BRACKET, XP_TOKEN_KIND_OPEN_CURLY, XP_TOKEN_KIND_OPEN_PAREN, XP_TOKEN_KIND_SUB, XP_TOKEN_KIND_TRUE, 0]) {[self expr_]; } else {[self matchEmpty:NO]; }if ([self speculate:^{ [self sliceop_]; }]) {[self sliceop_]; }}]) {
        if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, XP_TOKEN_KIND_BANG, XP_TOKEN_KIND_BITNOT, XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_INF, XP_TOKEN_KIND_MINUS, XP_TOKEN_KIND_NAN, XP_TOKEN_KIND_NOT, XP_TOKEN_KIND_NULL, XP_TOKEN_KIND_OPEN_BRACKET, XP_TOKEN_KIND_OPEN_CURLY, XP_TOKEN_KIND_OPEN_PAREN, XP_TOKEN_KIND_SUB, XP_TOKEN_KIND_TRUE, 0]) {
            [self expr_]; 
        } else {
            [self matchEmpty:NO]; 
            [self execute:^{
            PUSH(_firstNode);
            }];
        }
        [self nl_]; 
        [self match:XP_TOKEN_KIND_COLON discard:YES]; 
        [self nl_]; 
        if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, XP_TOKEN_KIND_BANG, XP_TOKEN_KIND_BITNOT, XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_INF, XP_TOKEN_KIND_MINUS, XP_TOKEN_KIND_NAN, XP_TOKEN_KIND_NOT, XP_TOKEN_KIND_NULL, XP_TOKEN_KIND_OPEN_BRACKET, XP_TOKEN_KIND_OPEN_CURLY, XP_TOKEN_KIND_OPEN_PAREN, XP_TOKEN_KIND_SUB, XP_TOKEN_KIND_TRUE, 0]) {
            [self expr_]; 
        } else {
            [self matchEmpty:NO]; 
            [self execute:^{
            PUSH(_lastNode);
            }];
        }
        if ([self speculate:^{ [self sliceop_]; }]) {
            [self sliceop_]; 
        }
    } else if ([self speculate:^{ [self expr_]; }]) {
        [self expr_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'loadSlice'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchLoadSlice:)];
}

- (void)loadSlice_ {
    [self parseRule:@selector(__loadSlice) withMemo:_loadSlice_memo];
}

- (void)__sliceop {
    
    [self nl_]; 
    [self match:XP_TOKEN_KIND_COLON discard:YES]; 
    [self nl_]; 
    if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, XP_TOKEN_KIND_BANG, XP_TOKEN_KIND_BITNOT, XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_INF, XP_TOKEN_KIND_MINUS, XP_TOKEN_KIND_NAN, XP_TOKEN_KIND_NOT, XP_TOKEN_KIND_NULL, XP_TOKEN_KIND_OPEN_BRACKET, XP_TOKEN_KIND_OPEN_CURLY, XP_TOKEN_KIND_OPEN_PAREN, XP_TOKEN_KIND_SUB, XP_TOKEN_KIND_TRUE, 0]) {
        [self expr_]; 
    } else {
        [self matchEmpty:NO]; 
        [self execute:^{
        PUSH(_lastNode);
        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchSliceop:)];
}

- (void)sliceop_ {
    [self parseRule:@selector(__sliceop) withMemo:_sliceop_memo];
}

- (void)__varRef {
    
    [self qid_]; 
    [self execute:^{
    
    XPNode *refNode = [XPNode nodeWithToken:_loadTok];
    XPNode *idNode = [XPNode nodeWithToken:POP()];
    idNode.scope = _currentScope;
    [refNode addChild:idNode];
    PUSH(refNode);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchVarRef:)];
}

- (void)varRef_ {
    [self parseRule:@selector(__varRef) withMemo:_varRef_memo];
}

- (void)__arrayLiteral {
    
    [self match:XP_TOKEN_KIND_OPEN_BRACKET discard:NO]; 
    [self nl_]; 
    if ([self speculate:^{ [self elemList_]; }]) {
        [self elemList_]; 
    }
    [self nl_]; 
    [self match:XP_TOKEN_KIND_CLOSE_BRACKET discard:YES]; 
    [self execute:^{
    
    NSArray *els = REV(ABOVE(_openSquareTok));
    POP(); // square
    XPNode *arrNode = [XPNode nodeWithToken:_arrayTok];
    [arrNode addChildren:els];
    PUSH(arrNode);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchArrayLiteral:)];
}

- (void)arrayLiteral_ {
    [self parseRule:@selector(__arrayLiteral) withMemo:_arrayLiteral_memo];
}

- (void)__elemList {
    
    [self expr_]; 
    while ([self speculate:^{ [self nl_]; [self match:XP_TOKEN_KIND_COMMA discard:YES]; [self nl_]; [self expr_]; }]) {
        [self nl_]; 
        [self match:XP_TOKEN_KIND_COMMA discard:YES]; 
        [self nl_]; 
        [self expr_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchElemList:)];
}

- (void)elemList_ {
    [self parseRule:@selector(__elemList) withMemo:_elemList_memo];
}

- (void)__dictLiteral {
    
    [self match:XP_TOKEN_KIND_OPEN_CURLY discard:NO]; 
    [self nl_]; 
    if ([self speculate:^{ [self pairList_]; }]) {
        [self pairList_]; 
    }
    [self nl_]; 
    [self match:XP_TOKEN_KIND_CLOSE_CURLY discard:YES]; 
    [self execute:^{
    
    NSArray *pairs = ABOVE(_openCurlyTok);
    POP(); // culry
    XPNode *dictNode = [XPNode nodeWithToken:_dictTok];
    [dictNode addChildren:pairs];
    PUSH(dictNode);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchDictLiteral:)];
}

- (void)dictLiteral_ {
    [self parseRule:@selector(__dictLiteral) withMemo:_dictLiteral_memo];
}

- (void)__pairList {
    
    [self pair_]; 
    while ([self speculate:^{ [self nl_]; [self match:XP_TOKEN_KIND_COMMA discard:YES]; [self nl_]; [self pair_]; }]) {
        [self nl_]; 
        [self match:XP_TOKEN_KIND_COMMA discard:YES]; 
        [self nl_]; 
        [self pair_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchPairList:)];
}

- (void)pairList_ {
    [self parseRule:@selector(__pairList) withMemo:_pairList_memo];
}

- (void)__pair {
    
    [self expr_]; 
    [self nl_]; 
    [self match:XP_TOKEN_KIND_COLON discard:NO]; 
    [self nl_]; 
    [self expr_]; 
    [self execute:^{
    
    XPNode *valExpr = POP();
    PKToken *colonTok = POP();
    XPNode *keyExpr = POP();
    XPNode *pairNode = [XPNode nodeWithToken:colonTok];
    [pairNode addChild:keyExpr];
    [pairNode addChild:valExpr];
    PUSH(pairNode);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchPair:)];
}

- (void)pair_ {
    [self parseRule:@selector(__pair) withMemo:_pair_memo];
}

- (void)__scalar {
    
    if ([self predicts:XP_TOKEN_KIND_NULL, 0]) {
        [self null_]; 
    } else if ([self predicts:XP_TOKEN_KIND_INF, 0]) {
        [self inf_]; 
    } else if ([self predicts:XP_TOKEN_KIND_NAN, 0]) {
        [self nan_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [self str_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [self num_]; 
    } else if ([self predicts:XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_TRUE, 0]) {
        [self bool_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'scalar'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchScalar:)];
}

- (void)scalar_ {
    [self parseRule:@selector(__scalar) withMemo:_scalar_memo];
}

- (void)__null {
    
    [self match:XP_TOKEN_KIND_NULL discard:NO]; 
    [self execute:^{
    
    PUSH([XPNode nodeWithToken:POP()]);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchNull:)];
}

- (void)null_ {
    [self parseRule:@selector(__null) withMemo:_null_memo];
}

- (void)__nan {
    
    [self match:XP_TOKEN_KIND_NAN discard:NO]; 
    [self execute:^{
    
    PUSH([XPNode nodeWithToken:POP()]);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchNan:)];
}

- (void)nan_ {
    [self parseRule:@selector(__nan) withMemo:_nan_memo];
}

- (void)__inf {
    
    [self match:XP_TOKEN_KIND_INF discard:NO]; 
    [self execute:^{
    
    PUSH([XPNode nodeWithToken:POP()]);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchInf:)];
}

- (void)inf_ {
    [self parseRule:@selector(__inf) withMemo:_inf_memo];
}

- (void)__bool {
    
    if ([self predicts:XP_TOKEN_KIND_TRUE, 0]) {
        [self match:XP_TOKEN_KIND_TRUE discard:NO]; 
    } else if ([self predicts:XP_TOKEN_KIND_FALSE, 0]) {
        [self match:XP_TOKEN_KIND_FALSE discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'bool'."];
    }
    [self execute:^{
    
    PUSH([XPNode nodeWithToken:POP()]);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchBool:)];
}

- (void)bool_ {
    [self parseRule:@selector(__bool) withMemo:_bool_memo];
}

- (void)__num {
    
    [self matchNumber:NO]; 
    [self execute:^{
    
    PUSH([XPNode nodeWithToken:POP()]);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchNum:)];
}

- (void)num_ {
    [self parseRule:@selector(__num) withMemo:_num_memo];
}

- (void)__str {
    
    [self matchQuotedString:NO]; 
    [self execute:^{
    
    //PKToken *oldTok = PEEK();
    NSString *s = POP_QUOTED_STR();
    PKToken *tok = [PKToken tokenWithTokenType:PKTokenTypeWord stringValue:s doubleValue:0.0];
    tok.tokenKind = TOKEN_KIND_BUILTIN_WORD;
    PUSH([XPNode nodeWithToken:tok]);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchStr:)];
}

- (void)str_ {
    [self parseRule:@selector(__str) withMemo:_str_memo];
}

@end
