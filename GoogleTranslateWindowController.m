//
//  GoogleTranslateWindowController.m
//  RMH Console
//
//  Created by Randy Robinson on 2/7/14.
//  Copyright (c) 2014 RMH Development. All rights reserved.
//

#import "GoogleTranslateWindowController.h"

@interface GoogleTranslateWindowController ()

@end

@implementation GoogleTranslateWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)defineRecpientsAction:(id)sender {
    defineRecipientsWindowController = [[DefineRecipientsWindowController alloc] initWithWindowNibName:@"DefineRecipientsWindowController"];
    [defineRecipientsWindowController showWindow:self];
}

@end
