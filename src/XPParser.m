#import "XPParser.h"
#import <PEGKit/PEGKit.h>
    
#import <Language/XPNode.h>
#import <Language/XPBooleanValue.h>
#import <Language/XPNumericValue.h>
#import <Language/XPStringValue.h>
#import <Language/XPUnaryExpression.h>
#import <Language/XPNegationExpression.h>
#import <Language/XPBooleanExpression.h>
#import <Language/XPRelationalExpression.h>
#import <Language/XPArithmeticExpression.h>
#import <Language/XPCallExpression.h>
#import <Language/XPPathExpression.h>

#import <Language/XPGlobalScope.h>
#import <Language/XPLocalScope.h>
#import <Language/XPFunctionSymbol.h>


@interface XPParser ()
    
@property (nonatomic, retain) PKToken *blockTok;
@property (nonatomic, retain) PKToken *callTok;
@property (nonatomic, retain) PKToken *funcDeclTok;
@property (nonatomic, retain) PKToken *subTok;
@property (nonatomic, retain) PKToken *openParenTok;
@property (nonatomic, retain) PKToken *openCurlyTok;
@property (nonatomic, retain) PKToken *minusTok;
@property (nonatomic, retain) PKToken *colonTok;
@property (nonatomic, retain) PKToken *equalsTok;
@property (nonatomic, assign) BOOL negation;
@property (nonatomic, assign) BOOL negative;

@end

@implementation XPParser { }
    
+ (PKTokenizer *)tokenizer {
    PKTokenizer *t = [PKTokenizer tokenizer];
    [t.symbolState add:@"=="];
    [t.symbolState add:@"!="];
    [t.symbolState add:@"<="];
    [t.symbolState add:@">="];
    [t.symbolState add:@"&&"];
    [t.symbolState add:@"||"];
    
    [t setTokenizerState:t.symbolState from:'-' to:'-'];
	[t.wordState setWordChars:NO from:'\'' to:'\''];
    return t;
}


- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
            
    self.enableVerboseErrorReporting = NO;
    self.tokenizer = [[self class] tokenizer];
    self.blockTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"BLOCK" doubleValue:0.0];
    self.blockTok.tokenKind = XP_TOKEN_KIND_BLOCK;
    self.callTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"CALL" doubleValue:0.0];
    self.callTok.tokenKind = XP_TOKEN_KIND_CALL;
    self.funcDeclTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"FUNC_DECL" doubleValue:0.0];
    self.funcDeclTok.tokenKind = XP_TOKEN_KIND_FUNC_DECL;
    self.subTok = [PKToken tokenWithTokenType:PKTokenTypeWord stringValue:@"sub" doubleValue:0.0];
    self.openParenTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"(" doubleValue:0.0];
    self.openCurlyTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:[NSString stringWithFormat:@"%C", 0x7B] doubleValue:0.0];
    self.minusTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"-" doubleValue:0.0];
    self.colonTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@":" doubleValue:0.0];
    self.equalsTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"=" doubleValue:0.0];

        self.startRuleName = @"program";
        self.tokenKindTab[@"gt"] = @(XP_TOKEN_KIND_GT);
        self.tokenKindTab[@"{"] = @(XP_TOKEN_KIND_OPEN_CURLY);
        self.tokenKindTab[@">="] = @(XP_TOKEN_KIND_GE_SYM);
        self.tokenKindTab[@"&&"] = @(XP_TOKEN_KIND_DOUBLE_AMPERSAND);
        self.tokenKindTab[@"}"] = @(XP_TOKEN_KIND_CLOSE_CURLY);
        self.tokenKindTab[@"true"] = @(XP_TOKEN_KIND_TRUE);
        self.tokenKindTab[@"return"] = @(XP_TOKEN_KIND_RETURN);
        self.tokenKindTab[@"!="] = @(XP_TOKEN_KIND_NOT_EQUAL);
        self.tokenKindTab[@"!"] = @(XP_TOKEN_KIND_BANG);
        self.tokenKindTab[@";"] = @(XP_TOKEN_KIND_SEMI_COLON);
        self.tokenKindTab[@"<"] = @(XP_TOKEN_KIND_LT_SYM);
        self.tokenKindTab[@"%"] = @(XP_TOKEN_KIND_MOD);
        self.tokenKindTab[@"="] = @(XP_TOKEN_KIND_EQUALS);
        self.tokenKindTab[@"le"] = @(XP_TOKEN_KIND_LE);
        self.tokenKindTab[@">"] = @(XP_TOKEN_KIND_GT_SYM);
        self.tokenKindTab[@"lt"] = @(XP_TOKEN_KIND_LT);
        self.tokenKindTab[@"("] = @(XP_TOKEN_KIND_OPEN_PAREN);
        self.tokenKindTab[@"var"] = @(XP_TOKEN_KIND_VAR);
        self.tokenKindTab[@"eq"] = @(XP_TOKEN_KIND_EQ);
        self.tokenKindTab[@")"] = @(XP_TOKEN_KIND_CLOSE_PAREN);
        self.tokenKindTab[@"ne"] = @(XP_TOKEN_KIND_NE);
        self.tokenKindTab[@"or"] = @(XP_TOKEN_KIND_OR);
        self.tokenKindTab[@"not"] = @(XP_TOKEN_KIND_NOT);
        self.tokenKindTab[@"+"] = @(XP_TOKEN_KIND_PLUS);
        self.tokenKindTab[@"*"] = @(XP_TOKEN_KIND_TIMES);
        self.tokenKindTab[@"||"] = @(XP_TOKEN_KIND_DOUBLE_PIPE);
        self.tokenKindTab[@","] = @(XP_TOKEN_KIND_COMMA);
        self.tokenKindTab[@"and"] = @(XP_TOKEN_KIND_AND);
        self.tokenKindTab[@"-"] = @(XP_TOKEN_KIND_MINUS);
        self.tokenKindTab[@"."] = @(XP_TOKEN_KIND_DOT);
        self.tokenKindTab[@"/"] = @(XP_TOKEN_KIND_DIV);
        self.tokenKindTab[@"false"] = @(XP_TOKEN_KIND_FALSE);
        self.tokenKindTab[@"sub"] = @(XP_TOKEN_KIND_SUB);
        self.tokenKindTab[@"<="] = @(XP_TOKEN_KIND_LE_SYM);
        self.tokenKindTab[@"ge"] = @(XP_TOKEN_KIND_GE);
        self.tokenKindTab[@"=="] = @(XP_TOKEN_KIND_DOUBLE_EQUALS);

        self.tokenKindNameTab[XP_TOKEN_KIND_GT] = @"gt";
        self.tokenKindNameTab[XP_TOKEN_KIND_OPEN_CURLY] = @"{";
        self.tokenKindNameTab[XP_TOKEN_KIND_GE_SYM] = @">=";
        self.tokenKindNameTab[XP_TOKEN_KIND_DOUBLE_AMPERSAND] = @"&&";
        self.tokenKindNameTab[XP_TOKEN_KIND_CLOSE_CURLY] = @"}";
        self.tokenKindNameTab[XP_TOKEN_KIND_TRUE] = @"true";
        self.tokenKindNameTab[XP_TOKEN_KIND_RETURN] = @"return";
        self.tokenKindNameTab[XP_TOKEN_KIND_NOT_EQUAL] = @"!=";
        self.tokenKindNameTab[XP_TOKEN_KIND_BANG] = @"!";
        self.tokenKindNameTab[XP_TOKEN_KIND_SEMI_COLON] = @";";
        self.tokenKindNameTab[XP_TOKEN_KIND_LT_SYM] = @"<";
        self.tokenKindNameTab[XP_TOKEN_KIND_MOD] = @"%";
        self.tokenKindNameTab[XP_TOKEN_KIND_EQUALS] = @"=";
        self.tokenKindNameTab[XP_TOKEN_KIND_LE] = @"le";
        self.tokenKindNameTab[XP_TOKEN_KIND_GT_SYM] = @">";
        self.tokenKindNameTab[XP_TOKEN_KIND_LT] = @"lt";
        self.tokenKindNameTab[XP_TOKEN_KIND_OPEN_PAREN] = @"(";
        self.tokenKindNameTab[XP_TOKEN_KIND_VAR] = @"var";
        self.tokenKindNameTab[XP_TOKEN_KIND_EQ] = @"eq";
        self.tokenKindNameTab[XP_TOKEN_KIND_CLOSE_PAREN] = @")";
        self.tokenKindNameTab[XP_TOKEN_KIND_NE] = @"ne";
        self.tokenKindNameTab[XP_TOKEN_KIND_OR] = @"or";
        self.tokenKindNameTab[XP_TOKEN_KIND_NOT] = @"not";
        self.tokenKindNameTab[XP_TOKEN_KIND_PLUS] = @"+";
        self.tokenKindNameTab[XP_TOKEN_KIND_TIMES] = @"*";
        self.tokenKindNameTab[XP_TOKEN_KIND_DOUBLE_PIPE] = @"||";
        self.tokenKindNameTab[XP_TOKEN_KIND_COMMA] = @",";
        self.tokenKindNameTab[XP_TOKEN_KIND_AND] = @"and";
        self.tokenKindNameTab[XP_TOKEN_KIND_MINUS] = @"-";
        self.tokenKindNameTab[XP_TOKEN_KIND_DOT] = @".";
        self.tokenKindNameTab[XP_TOKEN_KIND_DIV] = @"/";
        self.tokenKindNameTab[XP_TOKEN_KIND_FALSE] = @"false";
        self.tokenKindNameTab[XP_TOKEN_KIND_SUB] = @"sub";
        self.tokenKindNameTab[XP_TOKEN_KIND_LE_SYM] = @"<=";
        self.tokenKindNameTab[XP_TOKEN_KIND_GE] = @"ge";
        self.tokenKindNameTab[XP_TOKEN_KIND_DOUBLE_EQUALS] = @"==";

    }
    return self;
}

- (void)dealloc {
        
    self.currentScope = nil;
    self.globalScope = nil;
    self.blockTok = nil;
    self.callTok = nil;
    self.funcDeclTok = nil;
    self.subTok = nil;
    self.openParenTok = nil;
    self.openCurlyTok = nil;
    self.minusTok = nil;
    self.colonTok = nil;
    self.equalsTok = nil;


    [super dealloc];
}

- (void)start {

    [self program_]; 
    [self matchEOF:YES]; 

}

- (void)program_ {
    
    [self execute:^{
    
    self.currentScope = _globalScope;

    }];
    [self globalList_]; 

    [self fireDelegateSelector:@selector(parser:didMatchProgram:)];
}

- (void)globalList_ {
    
    do {
        [self globalItem_]; 
    } while ([self speculate:^{ [self globalItem_]; }]);
    [self execute:^{
    
    NSArray *items = REV(ABOVE(nil));
    XPNode *block = [XPNode nodeWithToken:_blockTok];
    for (id item in items) [block addChild:item];
    PUSH(block);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchGlobalList:)];
}

- (void)globalItem_ {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, XP_TOKEN_KIND_BANG, XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_MINUS, XP_TOKEN_KIND_NOT, XP_TOKEN_KIND_OPEN_PAREN, XP_TOKEN_KIND_TRUE, XP_TOKEN_KIND_VAR, 0]) {
        [self stat_]; 
    } else if ([self predicts:XP_TOKEN_KIND_SUB, 0]) {
        [self funcDecl_]; 
    } else if ([self predicts:XP_TOKEN_KIND_OPEN_CURLY, 0]) {
        [self block_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'globalItem'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchGlobalItem:)];
}

- (void)localList_ {
    
    do {
        [self localItem_]; 
    } while ([self speculate:^{ [self localItem_]; }]);

    [self fireDelegateSelector:@selector(parser:didMatchLocalList:)];
}

- (void)localItem_ {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, XP_TOKEN_KIND_BANG, XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_MINUS, XP_TOKEN_KIND_NOT, XP_TOKEN_KIND_OPEN_PAREN, XP_TOKEN_KIND_TRUE, XP_TOKEN_KIND_VAR, 0]) {
        [self stat_]; 
    } else if ([self predicts:XP_TOKEN_KIND_OPEN_CURLY, 0]) {
        [self block_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'localItem'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchLocalItem:)];
}

- (void)block_ {
    
    [self execute:^{
    
    self.currentScope = [XPLocalScope scopeWithEnclosingScope:_currentScope];

    }];
    [self match:XP_TOKEN_KIND_OPEN_CURLY discard:YES]; 
    if ([self speculate:^{ [self localList_]; }]) {
        [self localList_]; 
    }
    [self match:XP_TOKEN_KIND_CLOSE_CURLY discard:YES]; 
    [self execute:^{
    
    self.currentScope = _currentScope.enclosingScope;

    }];

    [self fireDelegateSelector:@selector(parser:didMatchBlock:)];
}

- (void)stat_ {
    
    if ([self speculate:^{ if ([self speculate:^{ if ([self predicts:XP_TOKEN_KIND_VAR, 0]) {[self varDecl_]; } else if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {[self assign_]; } else {[self raise:@"No viable alternative found in rule 'stat'."];}}]) {if ([self predicts:XP_TOKEN_KIND_VAR, 0]) {[self varDecl_]; } else if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {[self assign_]; } else {[self raise:@"No viable alternative found in rule 'stat'."];}}[self match:XP_TOKEN_KIND_SEMI_COLON discard:YES]; }]) {
        if ([self speculate:^{ if ([self predicts:XP_TOKEN_KIND_VAR, 0]) {[self varDecl_]; } else if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {[self assign_]; } else {[self raise:@"No viable alternative found in rule 'stat'."];}}]) {
            if ([self predicts:XP_TOKEN_KIND_VAR, 0]) {
                [self varDecl_]; 
            } else if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
                [self assign_]; 
            } else {
                [self raise:@"No viable alternative found in rule 'stat'."];
            }
        }
        [self match:XP_TOKEN_KIND_SEMI_COLON discard:YES]; 
    } else if ([self speculate:^{ [self testAndThrow:(id)^{ return _allowNakedExpressions; }]; [self expr_]; }]) {
        [self testAndThrow:(id)^{ return _allowNakedExpressions; }]; 
        [self expr_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'stat'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchStat:)];
}

- (void)varDecl_ {
    
    [self match:XP_TOKEN_KIND_VAR discard:NO]; 
    [self qid_]; 
    [self match:XP_TOKEN_KIND_EQUALS discard:YES]; 
    [self expr_]; 
    [self execute:^{
    
    XPExpression *rhs = POP();
    XPNode *lhs = [XPNode nodeWithToken:POP()];
    PKToken *tok = POP();
    
    XPNode *stat = [XPNode nodeWithToken:tok];
    [stat addChild:lhs]; [stat addChild:rhs];
    PUSH(stat);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchVarDecl:)];
}

- (void)qid_ {
    
    [self matchWord:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchQid:)];
}

- (void)assign_ {
    
    [self qid_]; 
    [self match:XP_TOKEN_KIND_EQUALS discard:NO]; 
    [self expr_]; 
    [self execute:^{
    
    XPExpression *rhs = POP();
    PKToken *tok = POP();
    XPNode *lhs = [XPNode nodeWithToken:POP()];
    
    XPNode *stat = [XPNode nodeWithToken:tok];
    [stat addChild:lhs]; [stat addChild:rhs];
    PUSH(stat);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchAssign:)];
}

- (void)funcList_ {
    
    do {
        [self funcItem_]; 
    } while ([self speculate:^{ [self funcItem_]; }]);

    [self fireDelegateSelector:@selector(parser:didMatchFuncList:)];
}

- (void)funcItem_ {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, XP_TOKEN_KIND_BANG, XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_MINUS, XP_TOKEN_KIND_NOT, XP_TOKEN_KIND_OPEN_PAREN, XP_TOKEN_KIND_TRUE, XP_TOKEN_KIND_VAR, 0]) {
        [self stat_]; 
    } else if ([self predicts:XP_TOKEN_KIND_OPEN_CURLY, 0]) {
        [self block_]; 
    } else if ([self predicts:XP_TOKEN_KIND_RETURN, 0]) {
        [self returnStat_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'funcItem'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchFuncItem:)];
}

- (void)returnStat_ {
    
    [self match:XP_TOKEN_KIND_RETURN discard:NO]; 
    [self expr_]; 
    [self match:XP_TOKEN_KIND_SEMI_COLON discard:YES]; 
    [self execute:^{
    
    XPExpression *expr = POP();
    XPNode *ret = [XPNode nodeWithToken:POP()];
    [ret addChild:expr];
    PUSH(ret);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchReturnStat:)];
}

- (void)funcDecl_ {
    
    [self match:XP_TOKEN_KIND_SUB discard:NO]; 
    [self qid_]; 
    [self execute:^{
        
    // def func
    PKToken *nameTok = POP();
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:nameTok.stringValue enclosingScope:_currentScope];
    [_currentScope defineSymbol:funcSym];
    id sub = POP();
    PUSH(funcSym);
    PUSH(nameTok);
    PUSH(sub);

    // push func scope
    self.currentScope = funcSym;

    }];
    [self match:XP_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self paramList_]; 
    [self match:XP_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
    [self execute:^{
    
    XPFunctionSymbol *funcSym = (id)_currentScope;
    NSDictionary *params = POP();
    [funcSym.members addEntriesFromDictionary:params];

    }];
    [self funcBlock_]; 
    [self execute:^{
    
    // create func node tree
    NSArray *stats = ABOVE(_subTok);
    POP(); // 'sub'
    XPNode *block = [XPNode nodeWithToken:_blockTok];
    for (id stat in stats) [block addChild:stat];

    XPNode *func = [XPNode nodeWithToken:_funcDeclTok];
    [func addChild:[XPNode nodeWithToken:POP()]]; // qid / func name
    [func addChild:block];

    XPFunctionSymbol *funcSym = POP();
    funcSym.blockNode = func;
    PUSH(func);

    // pop scope
    self.currentScope = _currentScope.enclosingScope;

    }];

    [self fireDelegateSelector:@selector(parser:didMatchFuncDecl:)];
}

- (void)paramList_ {
    
    [self execute:^{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    PUSH(params);

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

- (void)param_ {
    
    if ([self speculate:^{ [self dfaultParam_]; }]) {
        [self dfaultParam_]; 
    } else if ([self speculate:^{ [self nakedParam_]; }]) {
        [self nakedParam_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'param'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchParam:)];
}

- (void)dfaultParam_ {
    
    [self qid_]; 
    [self match:XP_TOKEN_KIND_EQUALS discard:YES]; 
    [self expr_]; 
    [self execute:^{
    
    XPExpression *expr = POP();
    NSString *name = POP_STR();
    NSMutableDictionary *params = PEEK();
    [params setObject:expr forKey:name];

    }];

    [self fireDelegateSelector:@selector(parser:didMatchDfaultParam:)];
}

- (void)nakedParam_ {
    
    [self qid_]; 
    [self execute:^{
    
    NSString *name = POP_STR();
    NSMutableDictionary *params = PEEK();
    [params setObject:[NSNull null] forKey:name];

    }];

    [self fireDelegateSelector:@selector(parser:didMatchNakedParam:)];
}

- (void)funcBlock_ {
    
    [self match:XP_TOKEN_KIND_OPEN_CURLY discard:YES]; 
    if ([self speculate:^{ [self funcList_]; }]) {
        [self funcList_]; 
    }
    [self match:XP_TOKEN_KIND_CLOSE_CURLY discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchFuncBlock:)];
}

- (void)funcCall_ {
    
    [self qid_]; 
    [self match:XP_TOKEN_KIND_OPEN_PAREN discard:NO]; 
    if ([self speculate:^{ [self argList_]; }]) {
        [self argList_]; 
    }
    [self match:XP_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
    [self execute:^{
    
    NSArray *args = ABOVE(_openParenTok);
    POP(); // '('
    XPCallExpression *call = [XPCallExpression nodeWithToken:_callTok];
    call.scope = _currentScope;
    [call addChild:[XPNode nodeWithToken:POP()]]; // qid
    for (id arg in args) [call addChild:arg];
    PUSH(call);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchFuncCall:)];
}

- (void)argList_ {
    
    [self arg_]; 
    while ([self speculate:^{ [self match:XP_TOKEN_KIND_COMMA discard:YES]; [self arg_]; }]) {
        [self match:XP_TOKEN_KIND_COMMA discard:YES]; 
        [self arg_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchArgList:)];
}

- (void)arg_ {
    
    [self expr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchArg:)];
}

- (void)expr_ {
    
    [self orExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchExpr:)];
}

- (void)orOp_ {
    
    if ([self predicts:XP_TOKEN_KIND_OR, 0]) {
        [self match:XP_TOKEN_KIND_OR discard:YES]; 
    } else if ([self predicts:XP_TOKEN_KIND_DOUBLE_PIPE, 0]) {
        [self match:XP_TOKEN_KIND_DOUBLE_PIPE discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'orOp'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchOrOp:)];
}

- (void)orExpr_ {
    
    [self andExpr_]; 
    while ([self speculate:^{ [self orOp_]; [self andExpr_]; }]) {
        [self orOp_]; 
        [self andExpr_]; 
        [self execute:^{
        
    XPValue *rhs = POP();
    XPValue *lhs = POP();
    PUSH([XPBooleanExpression booleanExpressionWithOperand:lhs operator:XP_TOKEN_KIND_OR operand:rhs]);

        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchOrExpr:)];
}

- (void)andOp_ {
    
    if ([self predicts:XP_TOKEN_KIND_AND, 0]) {
        [self match:XP_TOKEN_KIND_AND discard:YES]; 
    } else if ([self predicts:XP_TOKEN_KIND_DOUBLE_AMPERSAND, 0]) {
        [self match:XP_TOKEN_KIND_DOUBLE_AMPERSAND discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'andOp'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAndOp:)];
}

- (void)andExpr_ {
    
    [self equalityExpr_]; 
    while ([self speculate:^{ [self andOp_]; [self equalityExpr_]; }]) {
        [self andOp_]; 
        [self equalityExpr_]; 
        [self execute:^{
        
    XPValue *rhs = POP();
    XPValue *lhs = POP();
    PUSH([XPBooleanExpression booleanExpressionWithOperand:lhs operator:XP_TOKEN_KIND_AND operand:rhs]);

        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAndExpr:)];
}

- (void)eqOp_ {
    
    if ([self predicts:XP_TOKEN_KIND_DOUBLE_EQUALS, 0]) {
        [self match:XP_TOKEN_KIND_DOUBLE_EQUALS discard:YES]; 
    } else if ([self predicts:XP_TOKEN_KIND_EQ, 0]) {
        [self match:XP_TOKEN_KIND_EQ discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'eqOp'."];
    }
    [self execute:^{
     PUSH(@(XP_TOKEN_KIND_EQ)); 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchEqOp:)];
}

- (void)neOp_ {
    
    if ([self predicts:XP_TOKEN_KIND_NOT_EQUAL, 0]) {
        [self match:XP_TOKEN_KIND_NOT_EQUAL discard:YES]; 
    } else if ([self predicts:XP_TOKEN_KIND_NE, 0]) {
        [self match:XP_TOKEN_KIND_NE discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'neOp'."];
    }
    [self execute:^{
     PUSH(@(XP_TOKEN_KIND_NE)); 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchNeOp:)];
}

- (void)equalityExpr_ {
    
    [self relationalExpr_]; 
    while ([self speculate:^{ if ([self predicts:XP_TOKEN_KIND_DOUBLE_EQUALS, XP_TOKEN_KIND_EQ, 0]) {[self eqOp_]; } else if ([self predicts:XP_TOKEN_KIND_NE, XP_TOKEN_KIND_NOT_EQUAL, 0]) {[self neOp_]; } else {[self raise:@"No viable alternative found in rule 'equalityExpr'."];}[self relationalExpr_]; }]) {
        if ([self predicts:XP_TOKEN_KIND_DOUBLE_EQUALS, XP_TOKEN_KIND_EQ, 0]) {
            [self eqOp_]; 
        } else if ([self predicts:XP_TOKEN_KIND_NE, XP_TOKEN_KIND_NOT_EQUAL, 0]) {
            [self neOp_]; 
        } else {
            [self raise:@"No viable alternative found in rule 'equalityExpr'."];
        }
        [self relationalExpr_]; 
        [self execute:^{
        
    XPValue *rhs = POP();
    NSInteger op = POP_INT();
    XPValue *lhs = POP();
    PUSH([XPRelationalExpression relationalExpressionWithOperand:lhs operator:op operand:rhs]);

        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchEqualityExpr:)];
}

- (void)ltOp_ {
    
    if ([self predicts:XP_TOKEN_KIND_LT_SYM, 0]) {
        [self match:XP_TOKEN_KIND_LT_SYM discard:YES]; 
    } else if ([self predicts:XP_TOKEN_KIND_LT, 0]) {
        [self match:XP_TOKEN_KIND_LT discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'ltOp'."];
    }
    [self execute:^{
     PUSH(@(XP_TOKEN_KIND_LT)); 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchLtOp:)];
}

- (void)gtOp_ {
    
    if ([self predicts:XP_TOKEN_KIND_GT_SYM, 0]) {
        [self match:XP_TOKEN_KIND_GT_SYM discard:YES]; 
    } else if ([self predicts:XP_TOKEN_KIND_GT, 0]) {
        [self match:XP_TOKEN_KIND_GT discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'gtOp'."];
    }
    [self execute:^{
     PUSH(@(XP_TOKEN_KIND_GT)); 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchGtOp:)];
}

- (void)leOp_ {
    
    if ([self predicts:XP_TOKEN_KIND_LE_SYM, 0]) {
        [self match:XP_TOKEN_KIND_LE_SYM discard:YES]; 
    } else if ([self predicts:XP_TOKEN_KIND_LE, 0]) {
        [self match:XP_TOKEN_KIND_LE discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'leOp'."];
    }
    [self execute:^{
     PUSH(@(XP_TOKEN_KIND_LE)); 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchLeOp:)];
}

- (void)geOp_ {
    
    if ([self predicts:XP_TOKEN_KIND_GE_SYM, 0]) {
        [self match:XP_TOKEN_KIND_GE_SYM discard:YES]; 
    } else if ([self predicts:XP_TOKEN_KIND_GE, 0]) {
        [self match:XP_TOKEN_KIND_GE discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'geOp'."];
    }
    [self execute:^{
     PUSH(@(XP_TOKEN_KIND_GE)); 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchGeOp:)];
}

- (void)relationalExpr_ {
    
    [self additiveExpr_]; 
    while ([self speculate:^{ if ([self predicts:XP_TOKEN_KIND_LT, XP_TOKEN_KIND_LT_SYM, 0]) {[self ltOp_]; } else if ([self predicts:XP_TOKEN_KIND_GT, XP_TOKEN_KIND_GT_SYM, 0]) {[self gtOp_]; } else if ([self predicts:XP_TOKEN_KIND_LE, XP_TOKEN_KIND_LE_SYM, 0]) {[self leOp_]; } else if ([self predicts:XP_TOKEN_KIND_GE, XP_TOKEN_KIND_GE_SYM, 0]) {[self geOp_]; } else {[self raise:@"No viable alternative found in rule 'relationalExpr'."];}[self additiveExpr_]; }]) {
        if ([self predicts:XP_TOKEN_KIND_LT, XP_TOKEN_KIND_LT_SYM, 0]) {
            [self ltOp_]; 
        } else if ([self predicts:XP_TOKEN_KIND_GT, XP_TOKEN_KIND_GT_SYM, 0]) {
            [self gtOp_]; 
        } else if ([self predicts:XP_TOKEN_KIND_LE, XP_TOKEN_KIND_LE_SYM, 0]) {
            [self leOp_]; 
        } else if ([self predicts:XP_TOKEN_KIND_GE, XP_TOKEN_KIND_GE_SYM, 0]) {
            [self geOp_]; 
        } else {
            [self raise:@"No viable alternative found in rule 'relationalExpr'."];
        }
        [self additiveExpr_]; 
        [self execute:^{
        
    XPValue *rhs = POP();
    NSInteger op = POP_INT();
    XPValue *lhs = POP();
    PUSH([XPRelationalExpression relationalExpressionWithOperand:lhs operator:op operand:rhs]);

        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchRelationalExpr:)];
}

- (void)plus_ {
    
    [self match:XP_TOKEN_KIND_PLUS discard:YES]; 
    [self execute:^{
     PUSH(@(XP_TOKEN_KIND_PLUS)); 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchPlus:)];
}

- (void)minus_ {
    
    [self match:XP_TOKEN_KIND_MINUS discard:YES]; 
    [self execute:^{
     PUSH(@(XP_TOKEN_KIND_MINUS)); 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchMinus:)];
}

- (void)additiveExpr_ {
    
    [self multiplicativeExpr_]; 
    while ([self speculate:^{ if ([self predicts:XP_TOKEN_KIND_PLUS, 0]) {[self plus_]; } else if ([self predicts:XP_TOKEN_KIND_MINUS, 0]) {[self minus_]; } else {[self raise:@"No viable alternative found in rule 'additiveExpr'."];}[self multiplicativeExpr_]; }]) {
        if ([self predicts:XP_TOKEN_KIND_PLUS, 0]) {
            [self plus_]; 
        } else if ([self predicts:XP_TOKEN_KIND_MINUS, 0]) {
            [self minus_]; 
        } else {
            [self raise:@"No viable alternative found in rule 'additiveExpr'."];
        }
        [self multiplicativeExpr_]; 
        [self execute:^{
        
    XPValue *rhs = POP();
    NSInteger op = POP_INT();
    XPValue *lhs = POP();
    PUSH([XPArithmeticExpression arithmeticExpressionWithOperand:lhs operator:op operand:rhs]);

        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAdditiveExpr:)];
}

- (void)times_ {
    
    [self match:XP_TOKEN_KIND_TIMES discard:YES]; 
    [self execute:^{
     PUSH(@(XP_TOKEN_KIND_TIMES)); 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchTimes:)];
}

- (void)div_ {
    
    [self match:XP_TOKEN_KIND_DIV discard:YES]; 
    [self execute:^{
     PUSH(@(XP_TOKEN_KIND_DIV)); 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchDiv:)];
}

- (void)mod_ {
    
    [self match:XP_TOKEN_KIND_MOD discard:YES]; 
    [self execute:^{
     PUSH(@(XP_TOKEN_KIND_MOD)); 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchMod:)];
}

- (void)multiplicativeExpr_ {
    
    [self unaryExpr_]; 
    while ([self speculate:^{ if ([self predicts:XP_TOKEN_KIND_TIMES, 0]) {[self times_]; } else if ([self predicts:XP_TOKEN_KIND_DIV, 0]) {[self div_]; } else if ([self predicts:XP_TOKEN_KIND_MOD, 0]) {[self mod_]; } else {[self raise:@"No viable alternative found in rule 'multiplicativeExpr'."];}[self unaryExpr_]; }]) {
        if ([self predicts:XP_TOKEN_KIND_TIMES, 0]) {
            [self times_]; 
        } else if ([self predicts:XP_TOKEN_KIND_DIV, 0]) {
            [self div_]; 
        } else if ([self predicts:XP_TOKEN_KIND_MOD, 0]) {
            [self mod_]; 
        } else {
            [self raise:@"No viable alternative found in rule 'multiplicativeExpr'."];
        }
        [self unaryExpr_]; 
        [self execute:^{
        
    XPValue *rhs = POP();
    NSInteger op = POP_INT();
    XPValue *lhs = POP();
    PUSH([XPArithmeticExpression arithmeticExpressionWithOperand:lhs operator:op operand:rhs]);

        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchMultiplicativeExpr:)];
}

- (void)unaryExpr_ {
    
    if ([self predicts:XP_TOKEN_KIND_BANG, XP_TOKEN_KIND_NOT, 0]) {
        [self negatedUnary_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_MINUS, XP_TOKEN_KIND_OPEN_PAREN, XP_TOKEN_KIND_TRUE, 0]) {
        [self unary_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'unaryExpr'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchUnaryExpr:)];
}

- (void)negatedUnary_ {
    
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
    [self unary_]; 
    [self execute:^{
    

    }];
    [self execute:^{
    
    if (_negation)
		PUSH([XPNegationExpression negationExpressionWithExpression:POP()]);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchNegatedUnary:)];
}

- (void)unary_ {
    
    if ([self predicts:XP_TOKEN_KIND_MINUS, 0]) {
        [self signedPrimaryExpr_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_OPEN_PAREN, XP_TOKEN_KIND_TRUE, 0]) {
        [self primaryExpr_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'unary'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchUnary:)];
}

- (void)signedPrimaryExpr_ {
    
    [self execute:^{
    
    _negative = NO; 

    }];
    do {
        [self match:XP_TOKEN_KIND_MINUS discard:YES]; 
        [self execute:^{
         _negative = !_negative; 
        }];
    } while ([self predicts:XP_TOKEN_KIND_MINUS, 0]);
    [self primaryExpr_]; 
    [self execute:^{
    
    if (_negative)
		PUSH([XPUnaryExpression unaryExpressionWithExpression:POP()]);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchSignedPrimaryExpr:)];
}

- (void)primaryExpr_ {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_TRUE, 0]) {
        [self atom_]; 
    } else if ([self predicts:XP_TOKEN_KIND_OPEN_PAREN, 0]) {
        [self subExpr_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'primaryExpr'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchPrimaryExpr:)];
}

- (void)subExpr_ {
    
    [self match:XP_TOKEN_KIND_OPEN_PAREN discard:NO]; 
    [self expr_]; 
    [self match:XP_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
    [self execute:^{
    
    id objs = ABOVE(_openParenTok);
    POP(); // discard `(`
    PUSH_ALL(REV(objs));

    }];

    [self fireDelegateSelector:@selector(parser:didMatchSubExpr:)];
}

- (void)atom_ {
    
    if ([self speculate:^{ [self literal_]; }]) {
        [self literal_]; 
    } else if ([self speculate:^{ [self funcCall_]; }]) {
        [self funcCall_]; 
    } else if ([self speculate:^{ [self qid_]; }]) {
        [self qid_]; 
    } else if ([self speculate:^{ [self pathExpr_]; }]) {
        [self pathExpr_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'atom'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAtom:)];
}

- (void)pathExpr_ {
    
    [self execute:^{
    
    PUSH(_openParenTok);

    }];
    [self identifier_]; 
    while ([self speculate:^{ [self match:XP_TOKEN_KIND_DOT discard:YES]; [self step_]; }]) {
        [self match:XP_TOKEN_KIND_DOT discard:YES]; 
        [self step_]; 
    }
    [self execute:^{
    
    id toks = REV(ABOVE(_openParenTok));
    POP(); // discard `_openParenTok`
    PUSH([XPPathExpression pathExpressionWithSteps:toks]);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchPathExpr:)];
}

- (void)step_ {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self identifier_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [self num_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'step'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchStep:)];
}

- (void)identifier_ {
    
    [self matchWord:NO]; 
    [self execute:^{
     PUSH(POP_STR()); 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchIdentifier:)];
}

- (void)literal_ {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [self str_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [self num_]; 
    } else if ([self predicts:XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_TRUE, 0]) {
        [self bool_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'literal'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchLiteral:)];
}

- (void)bool_ {
    
    if ([self predicts:XP_TOKEN_KIND_TRUE, 0]) {
        [self true_]; 
        [self execute:^{
         PUSH([XPBooleanValue booleanValueWithBoolean:YES]); 
        }];
    } else if ([self predicts:XP_TOKEN_KIND_FALSE, 0]) {
        [self false_]; 
        [self execute:^{
         PUSH([XPBooleanValue booleanValueWithBoolean:NO]); 
        }];
    } else {
        [self raise:@"No viable alternative found in rule 'bool'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchBool:)];
}

- (void)true_ {
    
    [self match:XP_TOKEN_KIND_TRUE discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchTrue:)];
}

- (void)false_ {
    
    [self match:XP_TOKEN_KIND_FALSE discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchFalse:)];
}

- (void)num_ {
    
    [self matchNumber:NO]; 
    [self execute:^{
    
    PUSH([XPNumericValue nodeWithToken:POP()]);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchNum:)];
}

- (void)str_ {
    
    [self matchQuotedString:NO]; 
    [self execute:^{
    
    PUSH([XPStringValue stringValueWithString:POP_QUOTED_STR()]);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchStr:)];
}

@end
