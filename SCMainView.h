//
//  SCMainView.h
//  Survey Creator
//
//  Created by Jacob Balthazor on 3/26/13.
//  Copyright (c) 2013 Jacob Balthazor. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SCMainView : NSViewController <NSTableViewDataSource,NSTableViewDelegate> {
    IBOutlet NSWindow *window;
    
    IBOutlet NSTextField *surveyPrompt;
    IBOutlet NSTextField *surveyID;
    
    IBOutlet NSMatrix *radioButtons;
    IBOutlet NSTextField *promptField;
    IBOutlet NSTextField *answerField;
    IBOutlet NSTableView *table;
    IBOutlet NSTableView *answerTable;
    
    IBOutlet NSButton *addAnswerButton;
    IBOutlet NSButton *deleteAnswerButton;
    IBOutlet NSTextField *answerPrompt;
    
    NSMutableDictionary *data;
    NSMutableArray *questions;
    NSMutableArray *answerArray;
}
-(IBAction)generatePlist:(id)sender;
-(IBAction)addQuestion:(id)sender;
-(IBAction)deleteQuestion:(id)sender;

-(IBAction)addAnswer:(id)sender;
-(IBAction)deleteAnswer:(id)sender;
-(IBAction)radioButtonsChanged:(id)sender;

-(IBAction)open:(id)sender;
-(IBAction)fileNew:(id)sender;


-(NSString*)typeForIndex:(NSInteger)i;


@end
