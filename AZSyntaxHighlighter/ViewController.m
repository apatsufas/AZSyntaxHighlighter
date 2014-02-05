//
//  ViewController.m
//  AZSyntaxHighlighter
//
//  Created by Andreas on 2/5/14.
//  Copyright (c) 2014 Andreas Zimnas. All rights reserved.
//

#import "ViewController.h"
#import "AZHighlightingTextStorage.h"

@interface ViewController (){
    // Text storage must be held strongly, only the default storage is retained by the text view.
    AZHighlightingTextStorage *_textStorage;
}

@property (nonatomic) IBOutlet UITextView* textView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Replace text storage
	_textStorage = [AZHighlightingTextStorage new];
	[_textStorage addLayoutManager: self.textView.layoutManager];
    
    NSString* initialText =  @"SELECT * FROM tablename";
    
    NSRange range = NSMakeRange(0, 0);
    
    [_textStorage beginEditing];
    [_textStorage replaceCharactersInRange:range withString:initialText];
    [_textStorage endEditing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
