//
//  GoogleTranslateWindowController2.h
//  RMH Console
//
//  Created by Randy Robinson on 11/23/13.
//  Copyright (c) 2013 RMH Development. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define GT_DEBUG FALSE
#import <Cocoa/Cocoa.h>
#import "DefineRecipientsWindowController.h"

@interface GoogleTranslateWindowController2 : NSWindowController <NSTableViewDataSource, NSTableViewDelegate, NSTextViewDelegate>
{
    DefineRecipientsWindowController *defineRecipientsWindowController;
    NSString *commentString;
    NSString *outputFileNameGlobal;
    NSButton *languageButtonGlobal;
    NSString *notificationURL;
    NSString *newDeviceToken;
    NSString *oldDeviceToken;
    NSArray *languages;
    NSArray *sortedLanguages;
    NSArray *xcodeLanguages;
    NSArray *targetLanguages;
    //NSMutableArray *messageTypeArray;
    NSMutableArray *sourceLanguageBufferArray;
    NSMutableArray *targetLanguageBufferArray;
    NSMutableArray *masterSourceLanguageArray;
}
- (IBAction)defineRecipientsAction:(id)sender;
@property (nonatomic, strong) NSMutableArray *sourceLanguagesArray;
@property (nonatomic, strong) NSMutableArray *targetLanguagesArray;
@property (weak) IBOutlet NSTextField *enterGoogleAPIKeyTextField;
@property (weak) IBOutlet NSTextField *enterGoogleAPIKeyTextField2;
@property (weak) IBOutlet NSButton *saveAPIKeyButtonProperty;
@property (weak) IBOutlet NSTextField *apiKeyTextField;
@property (weak) IBOutlet NSButton *goButtonProperties;
@property (weak) IBOutlet NSButton *selectAllButtonProperties;
@property (weak) IBOutlet NSButton *deselectAllButtonProperties;
@property (weak) IBOutlet NSButton *resetAPIKeyButtonProperties;
@property (weak) IBOutlet NSButton *definerecipientsButtonProperty;
//- (IBAction)messageTypeAction:(id)sender;
- (IBAction)sourceLanguage:(id)sender;
- (IBAction)targetLanguage:(id)sender;
@property (weak) IBOutlet NSTableView *sourceLanguageTable;
@property (weak) IBOutlet NSTableView *targetLanguageTable;

@property (weak) IBOutlet NSTextField *processingLabel;
@property (weak) IBOutlet NSTextField *processingText;
@property (weak) IBOutlet NSTextField *processedLabel;
@property (weak) IBOutlet NSTextField *processedText;
@property (weak) IBOutlet NSTextField *key;
@property (weak) IBOutlet NSTextField *enterMessageTitle;
@property (weak) IBOutlet NSTextField *enterMessageText;
@property (weak) IBOutlet NSDatePicker *endDate;
@property (weak) IBOutlet NSTextField *messageNumber;
//@property (weak) IBOutlet NSComboBox *messageType;

@property (weak) IBOutlet NSTextField *messageURL;
@property (weak) IBOutlet NSDatePicker *startDate;

@property (weak) IBOutlet NSTextField *translatedText;
@property (weak) IBOutlet NSProgressIndicator *progressBar;

@end
