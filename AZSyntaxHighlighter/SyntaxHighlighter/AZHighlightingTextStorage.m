//
//  TKDHighlightingTextStorage.m
//  TextKitDemo
//
//  Created by Max Seelemann on 29.09.13.
//  Copyright (c) 2013 Max Seelemann. All rights reserved.
//

#import "AZHighlightingTextStorage.h"


@implementation AZHighlightingTextStorage
{
	NSMutableAttributedString *_imp;
}

- (id)init
{
	self = [super init];
	
	if (self) {
		_imp = [NSMutableAttributedString new];
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
	// Regular expression matching all SQL Keywords
	static NSRegularExpression *keywordsExpression;
	keywordsExpression = keywordsExpression ?: [NSRegularExpression regularExpressionWithPattern:@"\\bselect\\b|\\binsert\\b|\\bupdate\\b|\\bdelete\\b|\\balter\\b|\\bcreate\\b|\\badd\\b|\\bdrop\\b|\\bdistinct\\b|\\border\\b|\\bunion\\b|\\bjoin\\b|\\band\\b|\\bor\\b|\\bas\\b|\\blike\\b|\\bwhere\\b|\\blimit\\b|\\bbetween\\b|\\bprimary\\b|\\bforeign\\b|\\bin\\b|\\bkey\\b|\\btable\\b|\\bview\\b|\\btrigger\\b|\\bindex\\b|\\bbegin\\b|\\banalyze\\b|\\battach\\b|\\bend\\b|\\bcommit\\b|\\brollback\\b|\\bvirtual\\b|\\bdetach\\b|\\bby\\b|\\bexplain\\b|\\bindexed\\b|\\babort\\b|\\baction\\b|\\bafter\\b|\\ball\\b|\\basc\\b|\\bautoincrement\\b|\\bbefore\\b|\\bcascade\\b|\\bcase\\b|\\bcast\\b|\\bcheck\\b|\\bcollate\\b|\\bcolumn\\b|\\bconflict\\b|\\bconstraint\\b|\\bcross\\b|\\bcurrent_date\\b|\\bcurrent_time\\b|\\bcurrent_timestamp\\b|\\bdatabase\\b|\\bdefault\\b|\\bdeferrable\\b|\\bdeferred\\b|\\bdesc\\b|\\beach\\b|\\belse\\b|\\bescape\\b|\\bexcept\\b|\\bexclusive\\b|\\bexists\\b|\\bfail\\b|\\bfor\\b|\\bfull\\b|\\bglob\\b|\\bgroup\\b|\\bhaving\\b|\\bif\\b|\\bignore\\b|\\bimmediate\\b|\\binitially\\b|\\binner\\b|\\bintersect\\b|\\binstead\\b|\\binto\\b|\\bis\\b|\\bisnull\\b|\\bleft\\b|\\bmatch\\b|\\bnatural\\b|\\bno\\b|\\bnot\\b|\\bnotnull\\b|\\bnull\\b|\\bof\\b|\\boffset\\b|\\bon\\b|\\bouter\\b|\\bplan\\b|\\bpragma\\b|\\bquery\\b|\\braise\\b|\\breferences\\b|\\bregexp\\b|\\breindex\\b|\\brelease\\b|\\brename\\b|\\breplace\\b|\\brestrict\\b|\\bright\\b|\\brow\\b|\\bsavepoint\\b|\\bset\\b|\\btemp\\b|\\btemporary\\b|\\bthen\\b|\\bto\\b|\\btransaction\\b|\\bunique\\b|\\busing\\b|\\bvacuum\\b|\\b\\bvalues\\b|\\bwhen\\b|\\bfrom\\b" options:NSRegularExpressionCaseInsensitive error:NULL];
	
	// Regular expression matching all SQL Functions
    static NSRegularExpression *functionsExpression;
    functionsExpression = functionsExpression ?: [NSRegularExpression regularExpressionWithPattern:@"\\bdate\\b|\\bjulianday\\b|\\bstrftime\\b|\\babs\\b|\\bchanges\\b|\\bcoalesce\\b|\\bifnull\\b|\\bhex\\b|\\blast_insert_rowid\\b|\\blength\\b|\\bload_extension\\b|\\blower\\b|\\bltrim\\b|\\bltrim\\b|\\bmax\\b|\\bmin\\b|\\bnullif\\b|\\bquote\\b|\\brandom\\b|\\brandomblob\\b|\\bround\\b|\\brtrim\\b|\\bsoundex\\b|\\bsqlite_compileoption_get\\b|\\bsqlite_compileoption_used\\b|\\bsqlite_source_id\\b|\\bsqlite_version\\b|\\bsubstr\\b|\\btotal_changes\\b|\\btrim\\b|\\btypeof\\b|\\bupper\\b|\\bzeroblob\\b|\\bavg\\b|\\bcount\\b|\\bgroup_concat\\b|\\bsum\\b|\\btotal\\b" options:NSRegularExpressionCaseInsensitive error:NULL];
    
    // Regular expression matching all SQL Types
    static NSRegularExpression *typesExpression;
    typesExpression = typesExpression ?: [NSRegularExpression regularExpressionWithPattern:@"\\binteger\\b|\\bint\\b|\\bdouble\\b|\\bfloat\\b|\\breal\\b|\\btext\\b|\\bchar\\b|\\bvarchar\\b|\\bblob\\b|\\bnull\\b|\\bnumeric\\b|\\bdatetime\\b|\\btime\\b|\\bbool\\b|\\bboolean\\b" options:NSRegularExpressionCaseInsensitive error:NULL];
    
    
    static NSRegularExpression *commentsExpression;
    commentsExpression = commentsExpression ?: [NSRegularExpression regularExpressionWithPattern:@"(/\\*([^*]|[\\r\\n]|(\\*+([^*/]|[\\r\\n])))*\\*+/)|(//.*)|--.*|--.*?--" options:NSRegularExpressionCaseInsensitive error:NULL];
    
    static NSRegularExpression *stringsExpression;
    stringsExpression = stringsExpression ?: [NSRegularExpression regularExpressionWithPattern:@"\"(.|\\s|\\n|[^\"])*\"|'(.|\\s|\\n|[^'])*'" options:NSRegularExpressionCaseInsensitive error:NULL];
    
	// Clear text color of edited range
	NSRange paragaphRange = [self.string paragraphRangeForRange: self.editedRange];
	[self removeAttribute:NSForegroundColorAttributeName range:paragaphRange];
    
	// Find all Keywords in range
	[keywordsExpression enumerateMatchesInString:self.string options:0 range:paragaphRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
		// Add red highlight color
        UIColor* keyWordColor = RGB(24, 100, 208);
		[self addAttribute:NSForegroundColorAttributeName value:keyWordColor range:result.range];
	}];
    
    // Find all Keywords in range
	[functionsExpression enumerateMatchesInString:self.string options:0 range:paragaphRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
		// Add red highlight color
        UIColor* functionColor = RGB(52, 102, 128);
		[self addAttribute:NSForegroundColorAttributeName value:functionColor range:result.range];
	}];
    
    // Find all Keywords in range
	[typesExpression enumerateMatchesInString:self.string options:0 range:paragaphRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
		// Add red highlight color
        UIColor* typesColor = [[UIColor alloc] initWithRed:0.922f green:0.596f blue:0.173f alpha:1];
		[self addAttribute:NSForegroundColorAttributeName value:typesColor range:result.range];
	}];
    
    // Find all Strings in range
	[stringsExpression enumerateMatchesInString:self.string options:0 range:paragaphRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
		// Add red highlight color
        UIColor* stringsColor = [[UIColor alloc] initWithRed:.64f green:.08f blue:.08f alpha:1];
		[self addAttribute:NSForegroundColorAttributeName value:stringsColor range:result.range];
	}];
    
    // Find all Comments in range
	[commentsExpression enumerateMatchesInString:self.string options:0 range:paragaphRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
		// Add red highlight color
        UIColor* commentsColor = [[UIColor alloc] initWithRed:0 green:.5f blue:0 alpha:1];
		[self addAttribute:NSForegroundColorAttributeName value:commentsColor range:result.range];
	}];
    
    
    // Call super *after* changing the attrbutes, as it finalizes the attributes and calls the delegate methods.
    [super processEditing];
}

@end
