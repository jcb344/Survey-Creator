//
//  SCMainView.m
//  Survey Creator
//
//  Created by Jacob Balthazor on 3/26/13.
//  Copyright (c) 2013 Jacob Balthazor. All rights reserved.
//

#import "SCMainView.h"

@implementation SCMainView

-(IBAction)addQuestion:(id)sender{
    if (data == Nil) {
        data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Big Prompt",@"DirectionsPromt",@"jcb344@gmail.com",@"ToEmail", nil];
        questions = [[NSMutableArray alloc] init];
    }
    if ([radioButtons selectedColumn] == 0) {
        if ([answerArray count] > 0) {
            NSDictionary *question = [NSDictionary dictionaryWithObjectsAndKeys:[promptField stringValue],@"prompt",[self typeForIndex:[radioButtons selectedColumn]],@"type",[answerArray copy],@"choices", nil];
            [questions addObject:question];
        }
    }
    else{
        NSDictionary *question = [NSDictionary dictionaryWithObjectsAndKeys:[promptField stringValue],@"prompt",[self typeForIndex:[radioButtons selectedColumn]],@"type", nil];
        [questions addObject:question];
    }
    [table reloadData];
}

-(IBAction)deleteQuestion:(id)sender{
    if ([questions count] > 0  && [table selectedRow] >= 0 ) {
        [questions removeObjectAtIndex:[table selectedRow]];
        [table removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:[table selectedRow]] withAnimation:NSTableViewAnimationSlideUp];
    }
}

-(IBAction)fileNew:(id)sender{
    [questions removeAllObjects];
    [surveyID setStringValue:@""];
    [surveyPrompt setStringValue:@""];
    [table reloadData];
    
    
}

-(IBAction)open:(id)sender{
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:YES];
    [openDlg setCanChooseDirectories:NO];
    
    if ( [openDlg runModalForDirectory:nil file:nil] == NSOKButton )
    {
        NSArray* files = [openDlg filenames];
        
        NSString* fileName = [files objectAtIndex:0];
        if ([[fileName pathExtension] isEqualToString:@"plist"]) {
            NSDictionary *file = [NSDictionary dictionaryWithContentsOfFile:fileName];
        
            surveyID = [file objectForKey:@"surveyID"];
            surveyPrompt = [file objectForKey:@"DirectionsPromt"];
            questions = [file objectForKey:@"Questions"];
        }
        [table reloadData];
    }
}

-(IBAction)generatePlist:(id)sender{
    NSSavePanel * savePanel = [NSSavePanel savePanel];
    // Restrict the file type to whatever you like
    [savePanel setAllowedFileTypes:[NSArray arrayWithObject:@"plist"]];
    // Set the starting directory
    //[savePanel setDirectoryURL:someURL];
    // Perform other setup
    // Use a completion handler -- this is a block which takes one argument
    // which corresponds to the button that was clicked
    [savePanel beginSheetModalForWindow:window completionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            
            NSLog(@"Got URL: %@", [[savePanel URL] relativePath]);
            
            if (questions != Nil) {
                data = [[NSDictionary alloc] initWithObjectsAndKeys:[surveyID stringValue],@"surveyID",[surveyPrompt stringValue],@"DirectionsPromt",questions,@"Questions", nil];
                [data writeToFile:[[savePanel URL] relativePath]  atomically:YES];
                NSLog(@"written");
            }
            else{
                NSLog(@"no questions to write");
            }
            
        }
    }];
}

-(IBAction)addAnswer:(id)sender{
    if (answerArray == Nil) {
        answerArray = [[NSMutableArray alloc] init];
    }
    [answerArray addObject:[answerField stringValue]];
    [answerTable reloadData];
}

-(IBAction)deleteAnswer:(id)sender{
    NSLog(@"%ld",[answerTable selectedRow]);
    if ([answerArray count] > 0 && [answerTable selectedRow] >= 0 ) {
        [answerArray removeObjectAtIndex:[answerTable selectedRow]];
        [answerTable removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:[answerTable selectedRow]] withAnimation:NSTableViewAnimationSlideUp];
    }
}

-(IBAction)radioButtonsChanged:(id)sender{
    if ([radioButtons selectedColumn] == 0) {
        [answerField setEnabled:YES];
        [answerPrompt setEnabled:YES];
        [answerTable setEnabled:YES];
        [addAnswerButton setEnabled:YES];
        [deleteAnswerButton setEnabled:YES];
        [answerArray release];
        answerArray = Nil;
        [answerTable reloadData];
    }
    else{
        [answerField setEnabled:NO];
        [answerPrompt setEnabled:NO];
        [answerTable setEnabled:NO];
        [addAnswerButton setEnabled:NO];
        [deleteAnswerButton setEnabled:NO];
    }
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    if (tableView == table) {
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
        if( [tableColumn.identifier isEqualToString:@"prompt"] )
        {
            cellView.textField.stringValue = [[questions objectAtIndex:row] objectForKey:@"prompt"];
        }
        else if ([tableColumn.identifier isEqualToString:@"type"]){
            cellView.textField.stringValue = [[questions objectAtIndex:row] objectForKey:@"type"];
        }
        else if ([tableColumn.identifier isEqualToString:@"count"]){
            cellView.textField.stringValue = [NSString stringWithFormat:@"%ld",row+1];
        }
        return cellView;
    }
    else if (tableView == answerTable){
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
        cellView.textField.stringValue = [answerArray objectAtIndex:row];
        return cellView;
    }
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (tableView == table) {
        return [questions count];
    }
    else if (tableView == answerTable){
        return [answerArray count];
    }
}

/*
-(void)awakeFromNib{
    [super awakeFromNib];
    data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Big Prompt",@"DirectionsPromt",@"jcb344@gmail.com",@"ToEmail", nil];
    questions = [[NSMutableArray alloc] init];
}

-(void)loadView{
    [super loadView];
    
    data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Big Prompt",@"DirectionsPromt",@"jcb344@gmail.com",@"ToEmail", nil];
    questions = [[NSMutableArray alloc] init];
}
 */

-(NSString*)typeForIndex:(NSInteger)i{
    NSString *returnString;
    switch (i) {
        case 0:
            returnString = @"multipleAnswer";
            break;
        case 1:
            returnString = @"numberAnswer";
            break;
        case 2:
            returnString = @"shortAnswer";
            break;
        case 3:
            returnString = @"time";
            break;
            
        default:
            break;
    }
    return returnString;
}


@end
