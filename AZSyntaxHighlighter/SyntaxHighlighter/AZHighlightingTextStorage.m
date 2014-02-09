//
//  TKDHighlightingTextStorage.m
//  TextKitDemo
//
//  Created by Max Seelemann on 29.09.13.
//  Copyright (c) 2013 Max Seelemann. All rights reserved.
//

#import "AZHighlightingTextStorage.h"
#import "SyntaxHighlighter.h"
#import "Pattern.h"

@interface AZHighlightingTextStorage ()

@property (nonatomic, strong) SyntaxHighlighter* highlighter;

@end

@implementation AZHighlightingTextStorage
{
	NSMutableAttributedString *_imp;
}

- (id)init
{
	self = [super init];
	
	if (self) {
		_imp = [NSMutableAttributedString new];
        
        _highlighter = [[SyntaxHighlighter alloc] initWithPatterns:@[[[Pattern alloc] initWithPattern:@"\\bselect\\b|\\binsert\\b|\\bupdate\\b|\\bdelete\\b|\\balter\\b|\\bcreate\\b|\\badd\\b|\\bdrop\\b|\\bdistinct\\b|\\border\\b|\\bunion\\b|\\bjoin\\b|\\band\\b|\\bor\\b|\\bas\\b|\\blike\\b|\\bwhere\\b|\\blimit\\b|\\bbetween\\b|\\bprimary\\b|\\bforeign\\b|\\bin\\b|\\bkey\\b|\\btable\\b|\\bview\\b|\\btrigger\\b|\\bindex\\b|\\bbegin\\b|\\banalyze\\b|\\battach\\b|\\bend\\b|\\bcommit\\b|\\brollback\\b|\\bvirtual\\b|\\bdetach\\b|\\bby\\b|\\bexplain\\b|\\bindexed\\b|\\babort\\b|\\baction\\b|\\bafter\\b|\\ball\\b|\\basc\\b|\\bautoincrement\\b|\\bbefore\\b|\\bcascade\\b|\\bcase\\b|\\bcast\\b|\\bcheck\\b|\\bcollate\\b|\\bcolumn\\b|\\bconflict\\b|\\bconstraint\\b|\\bcross\\b|\\bcurrent_date\\b|\\bcurrent_time\\b|\\bcurrent_timestamp\\b|\\bdatabase\\b|\\bdefault\\b|\\bdeferrable\\b|\\bdeferred\\b|\\bdesc\\b|\\beach\\b|\\belse\\b|\\bescape\\b|\\bexcept\\b|\\bexclusive\\b|\\bexists\\b|\\bfail\\b|\\bfor\\b|\\bfull\\b|\\bglob\\b|\\bgroup\\b|\\bhaving\\b|\\bif\\b|\\bignore\\b|\\bimmediate\\b|\\binitially\\b|\\binner\\b|\\bintersect\\b|\\binstead\\b|\\binto\\b|\\bis\\b|\\bisnull\\b|\\bleft\\b|\\bmatch\\b|\\bnatural\\b|\\bno\\b|\\bnot\\b|\\bnotnull\\b|\\bnull\\b|\\bof\\b|\\boffset\\b|\\bon\\b|\\bouter\\b|\\bplan\\b|\\bpragma\\b|\\bquery\\b|\\braise\\b|\\breferences\\b|\\bregexp\\b|\\breindex\\b|\\brelease\\b|\\brename\\b|\\breplace\\b|\\brestrict\\b|\\bright\\b|\\brow\\b|\\bsavepoint\\b|\\bset\\b|\\btemp\\b|\\btemporary\\b|\\bthen\\b|\\bto\\b|\\btransaction\\b|\\bunique\\b|\\busing\\b|\\bvacuum\\b|\\b\\bvalues\\b|\\bwhen\\b|\\bfrom\\b" patternColor:[UIColor colorWithRed:24.0/255.0 green:100.0/255.0 blue:208.0/255.0 alpha:1]],[[Pattern alloc] initWithPattern:@"\\bdate\\b|\\bjulianday\\b|\\bstrftime\\b|\\babs\\b|\\bchanges\\b|\\bcoalesce\\b|\\bifnull\\b|\\bhex\\b|\\blast_insert_rowid\\b|\\blength\\b|\\bload_extension\\b|\\blower\\b|\\bltrim\\b|\\bltrim\\b|\\bmax\\b|\\bmin\\b|\\bnullif\\b|\\bquote\\b|\\brandom\\b|\\brandomblob\\b|\\bround\\b|\\brtrim\\b|\\bsoundex\\b|\\bsqlite_compileoption_get\\b|\\bsqlite_compileoption_used\\b|\\bsqlite_source_id\\b|\\bsqlite_version\\b|\\bsubstr\\b|\\btotal_changes\\b|\\btrim\\b|\\btypeof\\b|\\bupper\\b|\\bzeroblob\\b|\\bavg\\b|\\bcount\\b|\\bgroup_concat\\b|\\bsum\\b|\\btotal\\b" patternColor:[UIColor colorWithRed:52.0/255.0 green:102.0/255.0 blue:128.0/255.0 alpha:1]],[[Pattern alloc] initWithPattern:@"\\binteger\\b|\\bint\\b|\\bdouble\\b|\\bfloat\\b|\\breal\\b|\\btext\\b|\\bchar\\b|\\bvarchar\\b|\\bblob\\b|\\bnull\\b|\\bnumeric\\b|\\bdatetime\\b|\\btime\\b|\\bbool\\b|\\bboolean\\b" patternColor:[[UIColor alloc] initWithRed:.922f green:.596f blue:.173f alpha:1]],[[Pattern alloc] initWithPattern:@"\"(.|\\s|\\n|[^\"])*\"|'(.|\\s|\\n|[^'])*'" patternColor:[[UIColor alloc] initWithRed:.64f green:.08f blue:.08f alpha:1]],[[Pattern alloc] initWithPattern:@"(/\\*([^*]|[\\r\\n]|(\\*+([^*/]|[\\r\\n])))*\\*+/)|(//.*)|--.*|--.*?--" patternColor:[[UIColor alloc] initWithRed:0 green:.5f blue:0 alpha:1]]]];
	}
	
	return self;
}


#pragma mark - Reading Text

- (NSString *)string
{
	return _imp.string;
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range
{
	return [_imp attributesAtIndex:location effectiveRange:range];
}


#pragma mark - Text Editing

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
	[_imp replaceCharactersInRange:range withString:str];
	[self edited:NSTextStorageEditedCharacters range:range changeInLength:(NSInteger)str.length - (NSInteger)range.length];
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range
{
	[_imp setAttributes:attrs range:range];
	[self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
}


#pragma mark - Syntax highlighting

- (void)processEditing
{
    NSRange paragaphRange = [self.string paragraphRangeForRange: self.editedRange];
    
	self.highlighter.attributedString = _imp;
    self.highlighter.range = paragaphRange;
    self.highlighter.text = self.string;
    
    [self.highlighter highlight];
    
    // Call super *after* changing the attrbutes, as it finalizes the attributes and calls the delegate methods.
    [super processEditing];
}

@end
