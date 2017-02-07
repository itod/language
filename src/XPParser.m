#import "XPParser.h"
#import <PEGKit/PEGKit.h>
    
#import <Language/XPException.h>
#import <Language/XPNode.h>
#import <Language/XPBooleanValue.h>
#import <Language/XPNumericValue.h>
#import <Language/XPStringValue.h>
#import <Language/XPFunctionValue.h>
#import <Language/XPArrayValue.h>

#import <Language/XPGlobalScope.h>
#import <Language/XPLocalScope.h>
#import <Language/XPVariableSymbol.h>
#import <Language/XPFunctionSymbol.h>

@interface PKParser ()
- (void)raiseInRange:(NSRange)r lineNumber:(NSUInteger)lineNum name:(NSString *)name format:(NSString *)fmt, ...;
@end


@interface XPParser ()
    
@property (nonatomic, retain) PKToken *blockTok;
@property (nonatomic, retain) PKToken *refTok;
@property (nonatomic, retain) PKToken *callTok;
@property (nonatomic, retain) PKToken *indexTok;
@property (nonatomic, retain) PKToken *assignIndexTok;
@property (nonatomic, retain) PKToken *assignAppendTok;
@property (nonatomic, retain) PKToken *subTok;
@property (nonatomic, retain) PKToken *anonTok;
@property (nonatomic, retain) PKToken *openParenTok;
@property (nonatomic, retain) PKToken *openCurlyTok;
@property (nonatomic, retain) PKToken *openSquareTok;
@property (nonatomic, retain) PKToken *minusTok;
@property (nonatomic, retain) PKToken *colonTok;
@property (nonatomic, retain) PKToken *equalsTok;
@property (nonatomic, retain) PKToken *notTok;
@property (nonatomic, retain) PKToken *negTok;
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
    [t.wordState setWordChars:NO from:'-' to:'-'];
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
    self.refTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"REF" doubleValue:0.0];
    self.refTok.tokenKind = XP_TOKEN_KIND_REF;
    self.callTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"CALL" doubleValue:0.0];
    self.callTok.tokenKind = XP_TOKEN_KIND_CALL;
    self.indexTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"INDEX" doubleValue:0.0];
    self.indexTok.tokenKind = XP_TOKEN_KIND_INDEX;
    self.assignIndexTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"INDEX ASSIGN" doubleValue:0.0];
    self.assignIndexTok.tokenKind = XP_TOKEN_KIND_ASSIGN_INDEX;
    self.assignAppendTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"APPEND ASSIGN" doubleValue:0.0];
    self.assignAppendTok.tokenKind = XP_TOKEN_KIND_ASSIGN_APPEND;
    self.subTok = [PKToken tokenWithTokenType:PKTokenTypeWord stringValue:@"sub" doubleValue:0.0];
    self.anonTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"<ANON>" doubleValue:0.0];
    self.openParenTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"(" doubleValue:0.0];
    self.openCurlyTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:[NSString stringWithFormat:@"%C", 0x7B] doubleValue:0.0];
    self.openSquareTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"[" doubleValue:0.0];
    self.minusTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"-" doubleValue:0.0];
    self.colonTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@":" doubleValue:0.0];
    self.equalsTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"=" doubleValue:0.0];
    self.notTok = [PKToken tokenWithTokenType:PKTokenTypeWord stringValue:@"not" doubleValue:0.0];
    self.notTok.tokenKind = XP_TOKEN_KIND_NOT;
    self.negTok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"NEG" doubleValue:0.0];
    self.negTok.tokenKind = XP_TOKEN_KIND_NEG;

        self.startRuleName = @"program";
        self.tokenKindTab[@"{"] = @(XP_TOKEN_KIND_OPEN_CURLY);
        self.tokenKindTab[@">="] = @(XP_TOKEN_KIND_GE);
        self.tokenKindTab[@"}"] = @(XP_TOKEN_KIND_CLOSE_CURLY);
        self.tokenKindTab[@"true"] = @(XP_TOKEN_KIND_TRUE);
        self.tokenKindTab[@"return"] = @(XP_TOKEN_KIND_RETURN);
        self.tokenKindTab[@"if"] = @(XP_TOKEN_KIND_IF);
        self.tokenKindTab[@"!="] = @(XP_TOKEN_KIND_NE);
        self.tokenKindTab[@"!"] = @(XP_TOKEN_KIND_BANG);
        self.tokenKindTab[@"else"] = @(XP_TOKEN_KIND_ELSE);
        self.tokenKindTab[@";"] = @(XP_TOKEN_KIND_SEMI_COLON);
        self.tokenKindTab[@"<"] = @(XP_TOKEN_KIND_LT);
        self.tokenKindTab[@"%"] = @(XP_TOKEN_KIND_MOD);
        self.tokenKindTab[@"="] = @(XP_TOKEN_KIND_EQUALS);
        self.tokenKindTab[@">"] = @(XP_TOKEN_KIND_GT);
        self.tokenKindTab[@"("] = @(XP_TOKEN_KIND_OPEN_PAREN);
        self.tokenKindTab[@"while"] = @(XP_TOKEN_KIND_WHILE);
        self.tokenKindTab[@"var"] = @(XP_TOKEN_KIND_VAR);
        self.tokenKindTab[@")"] = @(XP_TOKEN_KIND_CLOSE_PAREN);
        self.tokenKindTab[@"*"] = @(XP_TOKEN_KIND_TIMES);
        self.tokenKindTab[@"or"] = @(XP_TOKEN_KIND_OR);
        self.tokenKindTab[@"null"] = @(XP_TOKEN_KIND_NULL);
        self.tokenKindTab[@"+"] = @(XP_TOKEN_KIND_PLUS);
        self.tokenKindTab[@"not"] = @(XP_TOKEN_KIND_NOT);
        self.tokenKindTab[@"["] = @(XP_TOKEN_KIND_OPEN_BRACKET);
        self.tokenKindTab[@","] = @(XP_TOKEN_KIND_COMMA);
        self.tokenKindTab[@"and"] = @(XP_TOKEN_KIND_AND);
        self.tokenKindTab[@"-"] = @(XP_TOKEN_KIND_MINUS);
        self.tokenKindTab[@"]"] = @(XP_TOKEN_KIND_CLOSE_BRACKET);
        self.tokenKindTab[@"/"] = @(XP_TOKEN_KIND_DIV);
        self.tokenKindTab[@"false"] = @(XP_TOKEN_KIND_FALSE);
        self.tokenKindTab[@"sub"] = @(XP_TOKEN_KIND_SUB);
        self.tokenKindTab[@"<="] = @(XP_TOKEN_KIND_LE);
        self.tokenKindTab[@"=="] = @(XP_TOKEN_KIND_EQ);

        self.tokenKindNameTab[XP_TOKEN_KIND_OPEN_CURLY] = @"{";
        self.tokenKindNameTab[XP_TOKEN_KIND_GE] = @">=";
        self.tokenKindNameTab[XP_TOKEN_KIND_CLOSE_CURLY] = @"}";
        self.tokenKindNameTab[XP_TOKEN_KIND_TRUE] = @"true";
        self.tokenKindNameTab[XP_TOKEN_KIND_RETURN] = @"return";
        self.tokenKindNameTab[XP_TOKEN_KIND_IF] = @"if";
        self.tokenKindNameTab[XP_TOKEN_KIND_NE] = @"!=";
        self.tokenKindNameTab[XP_TOKEN_KIND_BANG] = @"!";
        self.tokenKindNameTab[XP_TOKEN_KIND_ELSE] = @"else";
        self.tokenKindNameTab[XP_TOKEN_KIND_SEMI_COLON] = @";";
        self.tokenKindNameTab[XP_TOKEN_KIND_LT] = @"<";
        self.tokenKindNameTab[XP_TOKEN_KIND_MOD] = @"%";
        self.tokenKindNameTab[XP_TOKEN_KIND_EQUALS] = @"=";
        self.tokenKindNameTab[XP_TOKEN_KIND_GT] = @">";
        self.tokenKindNameTab[XP_TOKEN_KIND_OPEN_PAREN] = @"(";
        self.tokenKindNameTab[XP_TOKEN_KIND_WHILE] = @"while";
        self.tokenKindNameTab[XP_TOKEN_KIND_VAR] = @"var";
        self.tokenKindNameTab[XP_TOKEN_KIND_CLOSE_PAREN] = @")";
        self.tokenKindNameTab[XP_TOKEN_KIND_TIMES] = @"*";
        self.tokenKindNameTab[XP_TOKEN_KIND_OR] = @"or";
        self.tokenKindNameTab[XP_TOKEN_KIND_NULL] = @"null";
        self.tokenKindNameTab[XP_TOKEN_KIND_PLUS] = @"+";
        self.tokenKindNameTab[XP_TOKEN_KIND_NOT] = @"not";
        self.tokenKindNameTab[XP_TOKEN_KIND_OPEN_BRACKET] = @"[";
        self.tokenKindNameTab[XP_TOKEN_KIND_COMMA] = @",";
        self.tokenKindNameTab[XP_TOKEN_KIND_AND] = @"and";
        self.tokenKindNameTab[XP_TOKEN_KIND_MINUS] = @"-";
        self.tokenKindNameTab[XP_TOKEN_KIND_CLOSE_BRACKET] = @"]";
        self.tokenKindNameTab[XP_TOKEN_KIND_DIV] = @"/";
        self.tokenKindNameTab[XP_TOKEN_KIND_FALSE] = @"false";
        self.tokenKindNameTab[XP_TOKEN_KIND_SUB] = @"sub";
        self.tokenKindNameTab[XP_TOKEN_KIND_LE] = @"<=";
        self.tokenKindNameTab[XP_TOKEN_KIND_EQ] = @"==";

    }
    return self;
}

- (void)dealloc {
        
    self.currentScope = nil;
    self.globalScope = nil;
    self.blockTok = nil;
    self.refTok = nil;
    self.callTok = nil;
    self.indexTok = nil;
    self.assignIndexTok = nil;
    self.assignAppendTok = nil;
    self.subTok = nil;
    self.anonTok = nil;
    self.openParenTok = nil;
    self.openCurlyTok = nil;
    self.openSquareTok = nil;
    self.minusTok = nil;
    self.colonTok = nil;
    self.equalsTok = nil;
    self.notTok = nil;
    self.negTok = nil;


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
    
    if ([self speculate:^{ [self stat_]; }]) {
        [self stat_]; 
    } else if ([self speculate:^{ [self ifBlock_]; }]) {
        [self ifBlock_]; 
    } else if ([self speculate:^{ [self whileBlock_]; }]) {
        [self whileBlock_]; 
    } else if ([self speculate:^{ [self funcDecl_]; }]) {
        [self funcDecl_]; 
    } else if ([self speculate:^{ [self block_]; }]) {
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
    
    if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, XP_TOKEN_KIND_BANG, XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_MINUS, XP_TOKEN_KIND_NOT, XP_TOKEN_KIND_NULL, XP_TOKEN_KIND_OPEN_BRACKET, XP_TOKEN_KIND_OPEN_PAREN, XP_TOKEN_KIND_SUB, XP_TOKEN_KIND_TRUE, XP_TOKEN_KIND_VAR, 0]) {
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
    [self match:XP_TOKEN_KIND_OPEN_CURLY discard:NO]; 
    if ([self speculate:^{ [self localList_]; }]) {
        [self localList_]; 
    }
    [self match:XP_TOKEN_KIND_CLOSE_CURLY discard:YES]; 
    [self execute:^{
    
    self.currentScope = _currentScope.enclosingScope;
    
    NSArray *stats = REV(ABOVE(_openCurlyTok));
    XPNode *block = [XPNode nodeWithToken:POP()];
    [block addChildren:stats];
    PUSH(block);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchBlock:)];
}

- (void)stat_ {
    
    if ([self speculate:^{ if ([self speculate:^{ if ([self speculate:^{ [self varDecl_]; }]) {[self varDecl_]; } else if ([self speculate:^{ [self assign_]; }]) {[self assign_]; } else if ([self speculate:^{ [self assignIndex_]; }]) {[self assignIndex_]; } else if ([self speculate:^{ [self assignAppend_]; }]) {[self assignAppend_]; } else if ([self speculate:^{ [self expr_]; }]) {[self expr_]; } else {[self raise:@"No viable alternative found in rule 'stat'."];}}]) {if ([self speculate:^{ [self varDecl_]; }]) {[self varDecl_]; } else if ([self speculate:^{ [self assign_]; }]) {[self assign_]; } else if ([self speculate:^{ [self assignIndex_]; }]) {[self assignIndex_]; } else if ([self speculate:^{ [self assignAppend_]; }]) {[self assignAppend_]; } else if ([self speculate:^{ [self expr_]; }]) {[self expr_]; } else {[self raise:@"No viable alternative found in rule 'stat'."];}}[self match:XP_TOKEN_KIND_SEMI_COLON discard:YES]; }]) {
        if ([self speculate:^{ if ([self speculate:^{ [self varDecl_]; }]) {[self varDecl_]; } else if ([self speculate:^{ [self assign_]; }]) {[self assign_]; } else if ([self speculate:^{ [self assignIndex_]; }]) {[self assignIndex_]; } else if ([self speculate:^{ [self assignAppend_]; }]) {[self assignAppend_]; } else if ([self speculate:^{ [self expr_]; }]) {[self expr_]; } else {[self raise:@"No viable alternative found in rule 'stat'."];}}]) {
            if ([self speculate:^{ [self varDecl_]; }]) {
                [self varDecl_]; 
            } else if ([self speculate:^{ [self assign_]; }]) {
                [self assign_]; 
            } else if ([self speculate:^{ [self assignIndex_]; }]) {
                [self assignIndex_]; 
            } else if ([self speculate:^{ [self assignAppend_]; }]) {
                [self assignAppend_]; 
            } else if ([self speculate:^{ [self expr_]; }]) {
                [self expr_]; 
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
    
    XPNode *rhs = POP();
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
    
    XPNode *rhs = POP();
    PKToken *tok = POP();
    XPNode *lhs = [XPNode nodeWithToken:POP()];
    
    XPNode *stat = [XPNode nodeWithToken:tok];
    [stat addChild:lhs]; [stat addChild:rhs];
    PUSH(stat);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchAssign:)];
}

- (void)assignIndex_ {
    
    [self qid_]; 
    [self match:XP_TOKEN_KIND_OPEN_BRACKET discard:YES]; 
    [self expr_]; 
    [self match:XP_TOKEN_KIND_CLOSE_BRACKET discard:YES]; 
    [self match:XP_TOKEN_KIND_EQUALS discard:YES]; 
    [self expr_]; 
    [self execute:^{
    
    XPNode *rhs = POP();
    XPNode *idx = POP();
    XPNode *lhs = [XPNode nodeWithToken:POP()];
    
    XPNode *stat = [XPNode nodeWithToken:_assignIndexTok];
    [stat addChild:lhs];
    [stat addChild:idx];
    [stat addChild:rhs];
    PUSH(stat);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchAssignIndex:)];
}

- (void)assignAppend_ {
    
    [self qid_]; 
    [self match:XP_TOKEN_KIND_OPEN_BRACKET discard:YES]; 
    [self match:XP_TOKEN_KIND_CLOSE_BRACKET discard:YES]; 
    [self match:XP_TOKEN_KIND_EQUALS discard:YES]; 
    [self expr_]; 
    [self execute:^{
    
    XPNode *rhs = POP();
    XPNode *lhs = [XPNode nodeWithToken:POP()];
    
    XPNode *stat = [XPNode nodeWithToken:_assignAppendTok];
    [stat addChild:lhs];
    [stat addChild:rhs];
    PUSH(stat);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchAssignAppend:)];
}

- (void)whileBlock_ {
    
    [self match:XP_TOKEN_KIND_WHILE discard:NO]; 
    [self expr_]; 
    [self block_]; 
    [self execute:^{
    
    XPNode *block = POP();
    XPNode *expr = POP();
    XPNode *whileNode = [XPNode nodeWithToken:POP()];
    [whileNode addChild:expr];
    [whileNode addChild:block];
    PUSH(whileNode);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchWhileBlock:)];
}

- (void)ifBlock_ {
    
    [self match:XP_TOKEN_KIND_IF discard:NO]; 
    [self expr_]; 
    [self block_]; 
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

- (void)elifBlock_ {
    
    [self match:XP_TOKEN_KIND_ELSE discard:YES]; 
    [self match:XP_TOKEN_KIND_IF discard:NO]; 
    [self expr_]; 
    [self block_]; 
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

- (void)elseBlock_ {
    
    [self match:XP_TOKEN_KIND_ELSE discard:NO]; 
    [self block_]; 
    [self execute:^{
    
    XPNode *block = POP();
    XPNode *elseNode = [XPNode nodeWithToken:POP()];
    [elseNode addChild:block];

    XPNode *ifNode = PEEK();
    [ifNode addChild:elseNode];

    }];

    [self fireDelegateSelector:@selector(parser:didMatchElseBlock:)];
}

- (void)funcList_ {
    
    do {
        [self funcItem_]; 
    } while ([self speculate:^{ [self funcItem_]; }]);

    [self fireDelegateSelector:@selector(parser:didMatchFuncList:)];
}

- (void)funcItem_ {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, XP_TOKEN_KIND_BANG, XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_MINUS, XP_TOKEN_KIND_NOT, XP_TOKEN_KIND_NULL, XP_TOKEN_KIND_OPEN_BRACKET, XP_TOKEN_KIND_OPEN_PAREN, XP_TOKEN_KIND_SUB, XP_TOKEN_KIND_TRUE, XP_TOKEN_KIND_VAR, 0]) {
        [self stat_]; 
    } else if ([self predicts:XP_TOKEN_KIND_IF, 0]) {
        [self ifBlock_]; 
    } else if ([self predicts:XP_TOKEN_KIND_WHILE, 0]) {
        [self whileBlock_]; 
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
    
    XPNode *expr = POP();
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
    id subTok = POP();
    XPNode *func = [XPNode nodeWithToken:subTok];
    [func addChild:[XPNode nodeWithToken:nameTok]]; // qid / func name
    PUSH(func);
    PUSH(subTok); // barrier for later

    // push func scope
    self.currentScope = funcSym;

    }];
    [self funcBody_]; 
    [self execute:^{
    
    POP(); // pop func node for non literls

    }];

    [self fireDelegateSelector:@selector(parser:didMatchFuncDecl:)];
}

- (void)funcBody_ {
    
    [self match:XP_TOKEN_KIND_OPEN_PAREN discard:YES]; 
    [self paramList_]; 
    [self match:XP_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
    [self execute:^{
    
    XPFunctionSymbol *funcSym = (id)_currentScope;
    NSMutableDictionary *params = POP();
    [funcSym.members addEntriesFromDictionary:params];

    }];
    [self funcBlock_]; 
    [self execute:^{
    
    // create func node tree
    NSArray *stats = REV(ABOVE(_subTok));
    XPNode *block = [XPNode nodeWithToken:_blockTok];
    [block addChildren:stats];

    POP(); // 'sub'
    XPNode *func = POP();
    [func addChild:block];
    PUSH(func); // for literals

    XPFunctionSymbol *funcSym = (id)_currentScope;
    funcSym.blockNode = block;

    // pop scope
    self.currentScope = _currentScope.enclosingScope;

    }];

    [self fireDelegateSelector:@selector(parser:didMatchFuncBody:)];
}

- (void)paramList_ {
    
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
    
    _foundDefaultParam = YES;

    XPNode *expr = POP();
    NSString *name = POP_STR();

    // set default val
    XPFunctionSymbol *funcSym = (id)_currentScope;
    [funcSym setDefaultValue:expr forParamNamed:name];

    XPVariableSymbol *sym = [XPVariableSymbol symbolWithName:name];
    NSMutableDictionary *params = POP();
    [params setObject:sym forKey:name];
    PUSH(params);
    [funcSym.orderedParams addObject:sym];

    }];

    [self fireDelegateSelector:@selector(parser:didMatchDfaultParam:)];
}

- (void)nakedParam_ {
    
    [self testAndThrow:(id)^{ return !_foundDefaultParam; }]; 
    [self qid_]; 
    [self execute:^{
    
    PKToken *qidTok = POP();
    NSString *name = qidTok.stringValue;
    XPVariableSymbol *sym = [XPVariableSymbol symbolWithName:name];
    NSMutableDictionary *params = POP();
    [params setObject:sym forKey:name];
    PUSH(params);

    XPFunctionSymbol *funcSym = (id)_currentScope;
    [funcSym.orderedParams addObject:sym];

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

- (void)funcLiteral_ {
    
    [self match:XP_TOKEN_KIND_SUB discard:NO]; 
    [self execute:^{
    
    // def func
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:_anonTok.stringValue enclosingScope:_currentScope];
    // don't define fyncSym here
    id subTok = POP();
    XPNode *func = [XPFunctionValue nodeWithToken:_anonTok];
    [func addChild:(id)funcSym];
    PUSH(func);
    PUSH(subTok); // barrier for later

    // push func scope
    self.currentScope = funcSym;

    }];
    [self funcBody_]; 

    [self fireDelegateSelector:@selector(parser:didMatchFuncLiteral:)];
}

- (void)funcCall_ {
    
    [self qid_]; 
    [self match:XP_TOKEN_KIND_OPEN_PAREN discard:NO]; 
    if ([self speculate:^{ [self argList_]; }]) {
        [self argList_]; 
    }
    [self match:XP_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
    [self execute:^{
    
    NSArray *args = REV(ABOVE(_openParenTok));
    POP(); // '('
    XPNode *callNode = [XPNode nodeWithToken:_callTok];
    callNode.scope = _currentScope;
    [callNode addChild:[XPNode nodeWithToken:POP()]]; // qid
    [callNode addChildren:args];
    PUSH(callNode);

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

- (void)or_ {
    
    [self match:XP_TOKEN_KIND_OR discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchOr:)];
}

- (void)orExpr_ {
    
    [self andExpr_]; 
    while ([self speculate:^{ [self or_]; [self andExpr_]; }]) {
        [self or_]; 
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

- (void)and_ {
    
    [self match:XP_TOKEN_KIND_AND discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchAnd:)];
}

- (void)andExpr_ {
    
    [self equalityExpr_]; 
    while ([self speculate:^{ [self and_]; [self equalityExpr_]; }]) {
        [self and_]; 
        [self equalityExpr_]; 
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

- (void)eq_ {
    
    [self match:XP_TOKEN_KIND_EQ discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchEq:)];
}

- (void)ne_ {
    
    [self match:XP_TOKEN_KIND_NE discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchNe:)];
}

- (void)equalityExpr_ {
    
    [self relationalExpr_]; 
    while ([self speculate:^{ if ([self predicts:XP_TOKEN_KIND_EQ, 0]) {[self eq_]; } else if ([self predicts:XP_TOKEN_KIND_NE, 0]) {[self ne_]; } else {[self raise:@"No viable alternative found in rule 'equalityExpr'."];}[self relationalExpr_]; }]) {
        if ([self predicts:XP_TOKEN_KIND_EQ, 0]) {
            [self eq_]; 
        } else if ([self predicts:XP_TOKEN_KIND_NE, 0]) {
            [self ne_]; 
        } else {
            [self raise:@"No viable alternative found in rule 'equalityExpr'."];
        }
        [self relationalExpr_]; 
        [self execute:^{
        
    XPValue *rhs = POP();
    XPNode *eqNode = [XPNode nodeWithToken:POP()];
    XPValue *lhs = POP();
    [eqNode addChild:lhs];
    [eqNode addChild:rhs];
    PUSH(eqNode);

        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchEqualityExpr:)];
}

- (void)lt_ {
    
    [self match:XP_TOKEN_KIND_LT discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchLt:)];
}

- (void)gt_ {
    
    [self match:XP_TOKEN_KIND_GT discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchGt:)];
}

- (void)le_ {
    
    [self match:XP_TOKEN_KIND_LE discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchLe:)];
}

- (void)ge_ {
    
    [self match:XP_TOKEN_KIND_GE discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchGe:)];
}

- (void)relationalExpr_ {
    
    [self additiveExpr_]; 
    while ([self speculate:^{ if ([self predicts:XP_TOKEN_KIND_LT, 0]) {[self lt_]; } else if ([self predicts:XP_TOKEN_KIND_GT, 0]) {[self gt_]; } else if ([self predicts:XP_TOKEN_KIND_LE, 0]) {[self le_]; } else if ([self predicts:XP_TOKEN_KIND_GE, 0]) {[self ge_]; } else {[self raise:@"No viable alternative found in rule 'relationalExpr'."];}[self additiveExpr_]; }]) {
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
        [self additiveExpr_]; 
        [self execute:^{
        
    XPValue *rhs = POP();
    XPNode *relNode = [XPNode nodeWithToken:POP()];
    XPValue *lhs = POP();
    [relNode addChild:lhs];
    [relNode addChild:rhs];
    PUSH(relNode);

        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchRelationalExpr:)];
}

- (void)plus_ {
    
    [self match:XP_TOKEN_KIND_PLUS discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchPlus:)];
}

- (void)minus_ {
    
    [self match:XP_TOKEN_KIND_MINUS discard:NO]; 

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
    XPNode *addNode = [XPNode nodeWithToken:POP()];
    XPValue *lhs = POP();
    [addNode addChild:lhs];
    [addNode addChild:rhs];
    PUSH(addNode);

        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAdditiveExpr:)];
}

- (void)times_ {
    
    [self match:XP_TOKEN_KIND_TIMES discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchTimes:)];
}

- (void)div_ {
    
    [self match:XP_TOKEN_KIND_DIV discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchDiv:)];
}

- (void)mod_ {
    
    [self match:XP_TOKEN_KIND_MOD discard:NO]; 

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
    XPNode *multNode = [XPNode nodeWithToken:POP()];
    XPValue *lhs = POP();
    [multNode addChild:lhs];
    [multNode addChild:rhs];
    PUSH(multNode);

        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchMultiplicativeExpr:)];
}

- (void)unaryExpr_ {
    
    if ([self predicts:XP_TOKEN_KIND_BANG, XP_TOKEN_KIND_NOT, 0]) {
        [self negatedUnary_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_MINUS, XP_TOKEN_KIND_NULL, XP_TOKEN_KIND_OPEN_BRACKET, XP_TOKEN_KIND_OPEN_PAREN, XP_TOKEN_KIND_SUB, XP_TOKEN_KIND_TRUE, 0]) {
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
    
    if (_negation) {
        XPNode *notNode = [XPNode nodeWithToken:_notTok];
        [notNode addChild:POP()];
		PUSH(notNode);
    }

    }];

    [self fireDelegateSelector:@selector(parser:didMatchNegatedUnary:)];
}

- (void)unary_ {
    
    if ([self predicts:XP_TOKEN_KIND_MINUS, 0]) {
        [self signedPrimaryExpr_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_NULL, XP_TOKEN_KIND_OPEN_BRACKET, XP_TOKEN_KIND_OPEN_PAREN, XP_TOKEN_KIND_SUB, XP_TOKEN_KIND_TRUE, 0]) {
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
    
    if (_negative) {
        XPNode *negNode = [XPNode nodeWithToken:_negTok];
        [negNode addChild:POP()];
		PUSH(negNode);
    }

    }];

    [self fireDelegateSelector:@selector(parser:didMatchSignedPrimaryExpr:)];
}

- (void)primaryExpr_ {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_NULL, XP_TOKEN_KIND_OPEN_BRACKET, XP_TOKEN_KIND_SUB, XP_TOKEN_KIND_TRUE, 0]) {
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
    
    if ([self speculate:^{ [self scalar_]; }]) {
        [self scalar_]; 
    } else if ([self speculate:^{ [self arrayLiteral_]; }]) {
        [self arrayLiteral_]; 
    } else if ([self speculate:^{ [self funcLiteral_]; }]) {
        [self funcLiteral_]; 
    } else if ([self speculate:^{ [self funcCall_]; }]) {
        [self funcCall_]; 
    } else if ([self speculate:^{ [self indexCall_]; }]) {
        [self indexCall_]; 
    } else if ([self speculate:^{ [self varRef_]; }]) {
        [self varRef_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'atom'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAtom:)];
}

- (void)indexCall_ {
    
    [self qid_]; 
    [self match:XP_TOKEN_KIND_OPEN_BRACKET discard:YES]; 
    [self expr_]; 
    [self match:XP_TOKEN_KIND_CLOSE_BRACKET discard:YES]; 
    [self execute:^{
    
    XPNode *exprNode = POP();

    XPNode *refNode = [XPNode nodeWithToken:_refTok];
    XPNode *idNode = [XPNode nodeWithToken:POP()];
    [refNode addChild:idNode];

    XPNode *callNode = [XPNode nodeWithToken:_indexTok];
    [callNode addChild:refNode];
    [callNode addChild:exprNode];
    PUSH(callNode);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchIndexCall:)];
}

- (void)varRef_ {
    
    [self qid_]; 
    [self execute:^{
    
    XPNode *refNode = [XPNode nodeWithToken:_refTok];
    XPNode *idNode = [XPNode nodeWithToken:POP()];
    [refNode addChild:idNode];
    PUSH(refNode);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchVarRef:)];
}

- (void)arrayLiteral_ {
    
    [self match:XP_TOKEN_KIND_OPEN_BRACKET discard:NO]; 
    if ([self speculate:^{ [self elemList_]; }]) {
        [self elemList_]; 
    }
    [self match:XP_TOKEN_KIND_CLOSE_BRACKET discard:YES]; 
    [self execute:^{
    
    NSArray *els = REV(ABOVE(_openSquareTok));
    XPArrayValue *val = [XPArrayValue nodeWithToken:POP()];
    [val addChildren:els];
    PUSH(val);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchArrayLiteral:)];
}

- (void)elemList_ {
    
    [self expr_]; 
    while ([self speculate:^{ [self match:XP_TOKEN_KIND_COMMA discard:YES]; [self expr_]; }]) {
        [self match:XP_TOKEN_KIND_COMMA discard:YES]; 
        [self expr_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchElemList:)];
}

- (void)scalar_ {
    
    if ([self predicts:XP_TOKEN_KIND_NULL, 0]) {
        [self null_]; 
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

- (void)null_ {
    
    [self match:XP_TOKEN_KIND_NULL discard:YES]; 
    [self execute:^{
    
    PUSH([XPValue nullValue]);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchNull:)];
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