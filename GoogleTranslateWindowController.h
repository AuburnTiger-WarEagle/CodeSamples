//
//  GoogleTranslateWindowController.h
//  RMH Console
//
//  Created by Randy Robinson on 11/23/13.
//  Copyright (c) 2013 RMH Development. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DefineRecipientsWindowController.h"

@interface GoogleTranslateWindowController : NSWindowController
{
    DefineRecipientsWindowController *defineRecipientsWindowController;
}
- (IBAction)defineRecpientsAction:(id)sender;
@property (weak) IBOutlet NSButton *arabicButton;
@property (weak) IBOutlet NSButton *thaiButton;
@property (weak) IBOutlet NSButton *romainianButton;
@property (weak) IBOutlet NSButton *slovakianButton;
@property (weak) IBOutlet NSButton *croatianButton;
@property (weak) IBOutlet NSButton *hindiButton;
@property (weak) IBOutlet NSButton *spanishButton;
@property (weak) IBOutlet NSButton *frenchButton;
@property (weak) IBOutlet NSButton *germanButton;
@property (weak) IBOutlet NSButton *italianButton;
@property (weak) IBOutlet NSButton *dutchButton;
@property (weak) IBOutlet NSButton *russianButton;
@property (weak) IBOutlet NSButton *japaneseButton;
@property (weak) IBOutlet NSButton *swedishButton;
@property (weak) IBOutlet NSButton *portugueseButton;
@property (weak) IBOutlet NSButton *danishButton;
@property (weak) IBOutlet NSButton *norwegianButton;
@property (weak) IBOutlet NSButton *finnishButton;
@property (weak) IBOutlet NSButton *chinese0Button;
@property (weak) IBOutlet NSButton *polishButton;
@property (weak) IBOutlet NSButton *chinese1Button;
@property (weak) IBOutlet NSButton *chinese2Button;
@property (weak) IBOutlet NSButton *koreanButton;
@property (weak) IBOutlet NSButton *latvianButton;
@property (weak) IBOutlet NSButton *czechButton;
@property (weak) IBOutlet NSButton *turkishButton;
@property (weak) IBOutlet NSButton *malaysianButton;
@property (weak) IBOutlet NSButton *greekButton;
@property (weak) IBOutlet NSButton *hebrewButton;
@property (weak) IBOutlet NSButton *hungarianButton;
@property (weak) IBOutlet NSButton *indonesianButton;
@property (weak) IBOutlet NSButton *vietnameseButton;
@property (weak) IBOutlet NSButton *englishButton;
@property (weak) IBOutlet NSTextField *googleAPIKey;

@property (weak) IBOutlet NSTextField *enterGoogleAPIKeyTextField;
@property (weak) IBOutlet NSTextField *enterGoogleAPIKeyTextField2;
@property (weak) IBOutlet NSButton *saveAPIKeyButtonProperty;
@property (weak) IBOutlet NSTextField *apiKeyTextField;
@property (weak) IBOutlet NSButton *goButtonProperties;
@property (weak) IBOutlet NSButton *selectAllButtonProperties;
@property (weak) IBOutlet NSButton *deselectAllButtonProperties;
@property (weak) IBOutlet NSButton *resetAPIKeyButtonProperties;

@property (weak) IBOutlet NSTextField *processingLabel;
@property (weak) IBOutlet NSTextField *processingText;
@property (weak) IBOutlet NSTextField *processedLabel;
@property (weak) IBOutlet NSTextField *processedText;
@property (weak) IBOutlet NSTextField *key;
@property (weak) IBOutlet NSTextField *enterMessageTitle;
@property (weak) IBOutlet NSTextField *enterMessageText;
@property (weak) IBOutlet NSDatePicker *endDate;
@property (weak) IBOutlet NSTextField *messageNumber;
@property (weak) IBOutlet NSComboBox *messageType;

@property (weak) IBOutlet NSTextField *messageURL;
@property (weak) IBOutlet NSDatePicker *startDate;

@property (weak) IBOutlet NSTextField *translatedText;
@property (weak) IBOutlet NSProgressIndicator *progressBar;

@end
