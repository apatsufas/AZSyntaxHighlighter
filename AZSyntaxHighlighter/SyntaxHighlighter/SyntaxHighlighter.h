//
//  SyntaxHighlighter.h
//  AZSyntaxHighlighter
//
//  Created by Andreas on 2/5/14.
//  Copyright (c) 2014 Andreas Zimnas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SyntaxHighlighter : NSObject

@property (nonatomic, strong) NSMutableAttributedString* attributedString;
@property (nonatomic, strong) NSString* text;
@property (nonatomic) NSRange range;

-(id)initWithPatterns:(NSArray*)patterns;
-(void)highlight;

@end
