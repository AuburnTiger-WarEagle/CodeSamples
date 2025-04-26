//
//  GoogleTranslateWindowController2.m
//  RMH Console
//
//  Created by Randy Robinson on 2/7/14.
//  Copyright (c) 2014 RMH Development. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#include <AudioToolbox/AudioToolbox.h>
#import "GoogleTranslateWindowController2.h"
#import "DataAccessLayer.h"


@interface GoogleTranslateWindowController2 ()

@end

@implementation GoogleTranslateWindowController2

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {

    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    // inititialize global arrays
    [self initializeVariables];
    DataAccessLayer *dataAccessLayer = [[DataAccessLayer alloc] init];
    self.sourceLanguagesArray = [dataAccessLayer getLangData];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* apiKey = [defaults objectForKey:@"APIKey"];
    if (apiKey.length > 30)  // we have a key, so hide these fields
    {
        [self.enterGoogleAPIKeyTextField setHidden:YES];
        [self.enterGoogleAPIKeyTextField2 setHidden:NO];
        [self.saveAPIKeyButtonProperty setHidden:YES];
        [self.enterGoogleAPIKeyTextField2 setStringValue: apiKey];
    }
    else
    {
        [self.enterGoogleAPIKeyTextField setHidden:NO];
        [self.enterGoogleAPIKeyTextField2 setHidden:YES];
        [self.saveAPIKeyButtonProperty setHidden:NO];
        [self.enterGoogleAPIKeyTextField2 setStringValue:@"Enter your Google API Key in this field"];
    }
    
    // disable the Define Recipients button until a good message has been created
    //[self.definerecipientsButtonProperty setEnabled:NO];
    
    // set start date to today and end date to tomorrow
    [self.startDate setDateValue:[NSDate date]];
    [self.endDate setDateValue:[[NSDate date] dateByAddingTimeInterval:60*60*24]];
    
    // set the default URL
    [self.messageURL setStringValue:@"http://www.rmhdevelopment.com"];
    
    // get the next message number from the database
    [self.messageNumber setStringValue:[NSString stringWithFormat:@"%d",[dataAccessLayer getNextMsgNumber]]];
    
    // set the message type values
    /*
    messageTypeArray = [NSMutableArray arrayWithObjects:@"PUSH",@"RMH",nil];
    
    for (int i = 0; i < [messageTypeArray count]; ++i)
    {
        [self.messageType addItemWithObjectValue:[messageTypeArray objectAtIndex:i]];
    }
    [self.messageType selectItemAtIndex:0];
     */
    [self.enterGoogleAPIKeyTextField setHidden:YES];
    
    NSColor *color = [NSColor whiteColor];
    NSMutableAttributedString *colorTitle;
    NSRange titleRange;
    
    colorTitle = [[NSMutableAttributedString alloc] initWithAttributedString:[self.goButtonProperties attributedTitle]];
    titleRange = NSMakeRange(0, [colorTitle length]);
    [colorTitle addAttribute:NSForegroundColorAttributeName value:color range:titleRange];
    [self.goButtonProperties setAttributedTitle:colorTitle];
}

- (IBAction)defineRecpientsAction:(id)sender {
    defineRecipientsWindowController = [[DefineRecipientsWindowController alloc] initWithWindowNibName:@"DefineRecipientsWindowController"];
    [defineRecipientsWindowController showWindow:self];
}

- (IBAction)saveAPIKeyAction:(id)sender {
    NSString *apiKey = [self.enterGoogleAPIKeyTextField stringValue];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:apiKey forKey:@"APIKey"];
    [self.enterGoogleAPIKeyTextField setHidden:YES];
    [self.enterGoogleAPIKeyTextField2 setHidden:NO];
    [self.saveAPIKeyButtonProperty setHidden:YES];
    [self.enterGoogleAPIKeyTextField2 setStringValue:apiKey];
    [self initializeVariables];
}




- (IBAction)resetAPIKeyAction:(id)sender {
    [self.enterGoogleAPIKeyTextField setHidden:NO];
    [self.enterGoogleAPIKeyTextField2 setHidden:YES];
    [self.saveAPIKeyButtonProperty setHidden:NO];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"RESET" forKey:@"APIKey"];
}

- (IBAction)goAction:(id)sender {
    NSString *title = [self.enterMessageTitle stringValue];
    NSString *text = [self.enterMessageText stringValue];
    NSString *messageNumber = [self.messageNumber stringValue];
    NSDate *start_Date = [self.startDate dateValue];
    NSDate *end_Date = [self.endDate dateValue];
    NSString *url = [self.messageURL stringValue];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *startDate = [dateFormat stringFromDate:start_Date];
    NSString *endDate = [dateFormat stringFromDate:end_Date];
    
    if (targetLanguages.count == 0)
    {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"OK"];
        [alert setMessageText:NSLocalizedString(@"Please select at least one target language",nil)];
        [alert setAlertStyle:NSInformationalAlertStyle];
        
        if ([alert runModal] == NSAlertFirstButtonReturn) {
            return;
        }
        
    }
    
    //Put the translate files web service on a back ground thread (queue)
    dispatch_async(kBgQueue, ^{
        bool threadErrorCondition = NO;
        [self.processedLabel setHidden:NO];
        [self.progressBar startAnimation:self]; // start the progress bar
        
        int currentLanguage = 0;
        //NSString *messageTypeValue = [self.messageType itemObjectValueAtIndex:[self.messageType indexOfSelectedItem]];

        [self.progressBar setMaxValue:(double)targetLanguages.count];
        [self.progressBar setMinValue:0];
        LanguageDataClass *languageDataClass = [[LanguageDataClass alloc] init];
        for (int x = 0; x < self.targetLanguagesArray.count; x++)
        {
            NSString * errorMessage = @"";

                currentLanguage++;
                languageDataClass = [self.targetLanguagesArray objectAtIndex:x];
                // determine source language
                NSString *sourceLanguage = @"en"; // this will select the appropriate code
                NSString *targetLanguage = languageDataClass.db_google_code;
                NSString *xcodeLanguage = languageDataClass.db_apple_code;
                [self.processingText setStringValue:languageDataClass.db_language];
                
                @try {
                    if (![sourceLanguage isEqualToString:targetLanguage])
                    {
                        // translate the text here
                        NSString *newMessageReceived = [self TranslateText:@"New message received" :targetLanguage :sourceLanguage];
                        NSString *translatedTitle = [self TranslateText: title : targetLanguage : sourceLanguage];
                        NSString *translatedText = [self TranslateText: text : targetLanguage : sourceLanguage];
                        /*
                        int q = (int)translatedText.length;
                        if ((q > 160) && ([messageTypeValue isEqualToString:@"PUSH"]))    // too long for push notification
                        {
                            NSAlert *alert = [[NSAlert alloc] init];
                            [alert addButtonWithTitle:@"OK"];
                            [alert setMessageText:[NSString stringWithFormat:@"Translated text exceeds 160 character limit for push notifications.\n\nTarget language: %@\n%@",targetLanguage,translatedText]];
                            [alert setAlertStyle:NSInformationalAlertStyle];
                            
                            if ([alert runModal] == NSAlertFirstButtonReturn) {
                                return;
                            }
                        }
                        else
                        { */
                            DataAccessLayer *dataAccessLayer = [[DataAccessLayer alloc] init];
                            [dataAccessLayer storeMessage:messageNumber :translatedTitle :translatedText :xcodeLanguage :newMessageReceived :url :startDate :endDate];

                            [self.translatedText setStringValue:translatedText];
                       // }
                    }
                    else  // source = target language aka "English" - no translation needed
                    {
                        DataAccessLayer *dataAccessLayer = [[DataAccessLayer alloc] init];
                        [dataAccessLayer storeMessage:messageNumber : title : text :xcodeLanguage :@"New message received" :url :startDate :endDate];
                        
                        [self.translatedText setStringValue:text];
                    }
                    [self.processedText setStringValue:languageDataClass.db_language];
                }
                @catch (NSException *exception) {
                    errorMessage = [NSString stringWithFormat:@"ERROR: %@", exception];
                    [self.processedText setStringValue:NSLocalizedString(@"ERROR",nil)];
                    [self performSelectorOnMainThread:@selector(fetchedData:) withObject:errorMessage waitUntilDone:YES];
                }
            }
            if (threadErrorCondition == NO)
            {
                [self performSelectorOnMainThread:@selector(fetchedData:) withObject:@"Translations Complete" waitUntilDone:YES];
                [self.progressBar setDoubleValue:currentLanguage];
            }
        
        [self.progressBar stopAnimation:self]; // stop the progress bar
        [self.progressBar setHidden:YES];
        
    [self.translatedText setStringValue:@"Translations Complete - Message records were successfuly stored in the database."];
        // enable the Define Recipients button now that a good message has been created
    [self.definerecipientsButtonProperty setEnabled:YES];

    });

}



//Called when the background thread is finsished with the google web service
- (void)fetchedData:(NSString *)outputFileName {
    if ([[outputFileName substringToIndex:6] isEqualToString:@"ERROR:"])
    {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"OK"];
        [alert setMessageText:[NSString stringWithFormat:@"%@",outputFileName]];
        [alert setAlertStyle:NSCriticalAlertStyle];
        if ([alert runModal] == NSAlertFirstButtonReturn) {
            [self exitProgram:0];
        }
    }
    else
    {
        [languageButtonGlobal setBordered:YES];
        [self.processedText setHidden:NO];
        [self.processedText setStringValue:languageButtonGlobal.title];
    }
}

- (IBAction)exitProgram:(id)sender {
    [[NSApplication sharedApplication] terminate:nil];
}

- (NSString *)TranslateText:(NSString *)inputText :(NSString *)targetLanguage :(NSString *)sourceLanguage{
    if (inputText.length > 9)
    {
        NSString *URLText = [inputText substringToIndex:9];
        
        if ([URLText isEqualToString:@"itms-apps"]) // don't translate URLS!!!!
        {
            return inputText;
        }
    }
    if (inputText.length > 1)
    {
        NSString *URLText = [inputText substringToIndex:2];
        
        if ([URLText isEqualToString:@"//"]) // don't translate Comments!!!!
        {
            return inputText;
        }
    }
    
    inputText = [inputText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // replace spaces in text to be translated with %20
    //inputText = [inputText stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* apiKey = [defaults objectForKey:@"APIKey"];
    NSString* numCharsToTranslate = [defaults objectForKey:@"NUMCHARS"];
    NSInteger iNumCharsToTranslate = numCharsToTranslate.integerValue;
    NSString *googleString = [NSString stringWithFormat:@"%@%@",@"https://www.googleapis.com/language/translate/v2?key=",apiKey];
    googleString = [googleString stringByAppendingString:[NSString stringWithFormat:@"&source=%@&target=",sourceLanguage]];
    googleString = [googleString stringByAppendingString:targetLanguage];
    googleString = [googleString stringByAppendingString:@"&q="];
    googleString = [googleString stringByAppendingString:inputText];
    
    if (GT_DEBUG)
        if (GT_DEBUG) NSLog(@"GoogleString: %@", googleString);
    
    NSString *translatedText;
    NSData *data;
    NSURL *googleTranslateURL;
    
    googleTranslateURL = [[NSURL alloc] initWithString:googleString];
    data = [NSData dataWithContentsOfURL: googleTranslateURL];
    
    @try
    {
        translatedText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        if (GT_DEBUG)
            NSLog(@"(1)translatedText string is: %@", translatedText);
        
        if (translatedText.length < 1)  // bad call, sleep for 2 seconds and try again
        {
            usleep(2000000);
            data = [NSData dataWithContentsOfURL: googleTranslateURL];
            translatedText = nil;
            translatedText = [[NSString alloc] initWithData:data encoding:NSUTF16StringEncoding];
            if (GT_DEBUG)
                NSLog(@"(1b)translatedText string is: %@ (after a re-try)", translatedText);
        }
        
        if (translatedText.length < 1)  // bad call, sleep for 5 seconds and try again
        {
            usleep(5000000);
            data = [NSData dataWithContentsOfURL: googleTranslateURL];
            translatedText = nil;
            translatedText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (GT_DEBUG)
                NSLog(@"(1c)translatedText string is: %@ (after 2 re-tries)", translatedText);
        }
        
        if (translatedText.length < 1)  // bad call, sleep for 10 seconds and try again
        {
            usleep(10000000);
            data = [NSData dataWithContentsOfURL: googleTranslateURL];
            translatedText = nil;
            translatedText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (GT_DEBUG)
                NSLog(@"(1d)translatedText string is: %@ (after 3 re-tries)", translatedText);
        }
        
        if (translatedText.length < 1)  // bad call, sleep for 25 seconds and try again
        {
            usleep(25000000);
            data = [NSData dataWithContentsOfURL: googleTranslateURL];
            translatedText = nil;
            translatedText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (GT_DEBUG)
                NSLog(@"(1e)translatedText string is: %@ (after 4 re-tries)", translatedText);
        }
        
        iNumCharsToTranslate += inputText.length;
        if (iNumCharsToTranslate < 1)
        {
            NSString *errorText = [NSString stringWithFormat:@"%@: %@\n\n%@",NSLocalizedString(@"INPUT TEXT",nil),inputText,NSLocalizedString(@"GOOGLE ERROR6",nil)];
            @throw [NSException exceptionWithName:NSLocalizedString(@"GOOGLE ERROR5",nil)
                                           reason:errorText userInfo:nil];
        }
        
        numCharsToTranslate = [NSString stringWithFormat:@"%d", (int)iNumCharsToTranslate];
        
        [defaults setObject:numCharsToTranslate forKey:@"NUMCHARS"];
        
        
        
        // remove extraneous chars
        
        translatedText = [translatedText stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        translatedText = [translatedText stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        translatedText = [translatedText stringByReplacingOccurrencesOfString:@" =" withString:@""];
        translatedText = [translatedText stringByReplacingOccurrencesOfString:@"= " withString:@""];
        translatedText = [translatedText stringByReplacingOccurrencesOfString:@";" withString:@""];
        translatedText = [translatedText stringByReplacingOccurrencesOfString:@"}" withString:@""];
        translatedText = [translatedText stringByReplacingOccurrencesOfString:@"{" withString:@""];
        translatedText = [translatedText stringByReplacingOccurrencesOfString:@"[" withString:@""];
        translatedText = [translatedText stringByReplacingOccurrencesOfString:@"]" withString:@""];
        translatedText = [translatedText stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
        translatedText = [translatedText stringByReplacingOccurrencesOfString:@"&#39" withString:@"'"];
        translatedText = [translatedText stringByReplacingOccurrencesOfString:@"\\u200b" withString:@""];
        NSString *key = @"translatedText";
        if (GT_DEBUG)
            NSLog(@"(2)translatedText string is: %@", translatedText);
        NSUInteger i = [translatedText rangeOfString:key].location;
        NSInteger j = translatedText.length;
        if ((i > 10000000) || (j <1))
        {
            NSString *errorText = [NSString stringWithFormat:@"%@: %@\n\n%@",NSLocalizedString(@"INPUT TEXT",nil),inputText,NSLocalizedString(@"GOOGLE ERROR6",nil)];
            @throw [NSException exceptionWithName:NSLocalizedString(@"GOOGLE ERROR5",nil)
                                           reason:errorText userInfo:nil];
        }
        
        if (GT_DEBUG)
            NSLog(@"Index Value is: %lu", i);
        translatedText = [translatedText substringFromIndex:i+16];
        translatedText = [translatedText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        // convert substitute chars back to actual value
        translatedText = [translatedText stringByReplacingOccurrencesOfString:@". *." withString:@" .*."];
        translatedText = [translatedText stringByReplacingOccurrencesOfString:@". **." withString:@" .**."];
        if (GT_DEBUG)
            NSLog(@"(3)translatedText string is: %@", translatedText);
    }
    @catch (NSException *exception)
    {
        translatedText = [NSString stringWithFormat:@"%@ %@ - %@", NSLocalizedString(@"GOOGLE ERROR5",nil),targetLanguage, exception];
        NSLog(@"(E) ERROR - ERROR - ERROR: %@", translatedText);
    }
    
    googleTranslateURL = nil;
    data = nil;
    
    return translatedText;
    
}

- (IBAction)defineRecipientsAction:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.messageNumber stringValue] forKey:@"MessageNumber"];
    //[defaults setObject:[self.messageType itemObjectValueAtIndex:[self.messageType indexOfSelectedItem]] forKey:@"MessageType"];
    // this pointer is a (strong) property in the header file
    defineRecipientsWindowController  = [[DefineRecipientsWindowController alloc] initWithWindowNibName:@"DefineRecipientsWindowController"];
    [defineRecipientsWindowController showWindow:self];
}
/*
- (IBAction)messageTypeAction:(id)sender {
    if ([[self.messageType itemObjectValueAtIndex:[self.messageType indexOfSelectedItem]] isEqualToString:@"PUSH"])
    {
        [self.enterMessageTitle setStringValue:@"The title is only used for RMH messages at this time."];
        [self.enterMessageTitle setEnabled:NO];
    }
    else    {
        [self.enterMessageTitle setStringValue:@""];
        [self.enterMessageTitle setEnabled:YES];
    }
}
 */

- (IBAction)sourceLanguage:(id)sender {
    LanguageDataClass *languageDataClass = [[LanguageDataClass alloc] init];
    languageDataClass = [self.sourceLanguagesArray objectAtIndex:[self.sourceLanguageTable selectedRow]];
    [targetLanguageBufferArray addObject:languageDataClass];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"db_language" ascending:YES];
    [targetLanguageBufferArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    self.targetLanguagesArray = targetLanguageBufferArray;
    [sourceLanguageBufferArray removeObjectAtIndex:[self.sourceLanguageTable selectedRow]];
    self.sourceLanguagesArray = sourceLanguageBufferArray;
}

- (IBAction)targetLanguage:(id)sender {
    LanguageDataClass *languageDataClass = [[LanguageDataClass alloc] init];
    languageDataClass = [self.targetLanguagesArray objectAtIndex:[self.targetLanguageTable selectedRow]];
    [sourceLanguageBufferArray addObject:languageDataClass];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"db_language" ascending:YES];
    [sourceLanguageBufferArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    self.sourceLanguagesArray = sourceLanguageBufferArray;
    [targetLanguageBufferArray removeObjectAtIndex:[self.targetLanguageTable selectedRow]];
    self.targetLanguagesArray = targetLanguageBufferArray;
}

- (IBAction)selectAllAction:(id)sender {
    self.targetLanguagesArray = [[NSMutableArray alloc] init];
    self.targetLanguagesArray = masterSourceLanguageArray;
    targetLanguageBufferArray = masterSourceLanguageArray;
    sourceLanguageBufferArray = [[NSMutableArray alloc] init];
    self.sourceLanguagesArray = [[NSMutableArray alloc] init];
}

- (IBAction)deSelectAllAction:(id)sender {
    self.targetLanguagesArray = [[NSMutableArray alloc] init];
    targetLanguageBufferArray = [[NSMutableArray alloc] init];
    sourceLanguageBufferArray = masterSourceLanguageArray;
    self.sourceLanguagesArray = sourceLanguageBufferArray;
}

-(void)initializeVariables{
    DataAccessLayer *dataAccessLayer = [[DataAccessLayer alloc] init];
    xcodeLanguages = [dataAccessLayer getAppleCodes];
    targetLanguages = [dataAccessLayer getGoogleCodes];
    languages = [dataAccessLayer getLanguageList];
    self.sourceLanguagesArray = [dataAccessLayer getLangData];
    sourceLanguageBufferArray = self.sourceLanguagesArray;
    masterSourceLanguageArray = [dataAccessLayer getLangData];
    self.targetLanguagesArray = [[NSMutableArray alloc] init];
    targetLanguageBufferArray = [[NSMutableArray alloc] init];
    sortedLanguages = [languages sortedArrayUsingSelector:@selector(compare:)];
    
}
@end
