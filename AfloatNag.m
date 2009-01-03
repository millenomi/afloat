//
//  AfloatNag.m
//  Afloat
//
//  Created by ∞ on 29/03/08.
//  Copyright 2008 Emanuele Vulcano. All rights reserved.
//

#import "AfloatNag.h"
#import <Carbon/Carbon.h>
#import "NSAlert+L0Alert.h"
#import "AfloatNagPreferences.h"

@implementation AfloatNag

- (void) applicationDidFinishLaunching:(NSNotification*) n {
	NSAlert* a = nil; NSInteger donateButton;
	
	switch (AfloatNagCurrentAction()) {
		case kAfloatDoNotShowAlerts:
			break;
			
		case kAfloatShouldShowFirstAlert:
			AfloatNagSetPreferenceForKey(kAfloatFirstAlertShownKey, [NSNumber numberWithBool:YES]);
			a = [NSAlert alertNamed:@"AfloatDonateFirstAlert"];
			donateButton = NSAlertSecondButtonReturn;
			break;
			
		case kAfloatShouldShowLastAlert:
			AfloatNagSetPreferenceForKey(kAfloatDidEndAlertsKey, [NSNumber numberWithBool:YES]);
			a = [NSAlert alertNamed:@"AfloatDonateLastAlert"];
			donateButton = NSAlertFirstButtonReturn;
			break;
	}
	
	if (a) {
		[NSApp activateIgnoringOtherApps:YES];
		NSInteger result = [a runModal];
		if (result == donateButton) {
			AfloatNagSetPreferenceForKey(kAfloatDidEndAlertsKey, [NSNumber numberWithBool:YES]);
			NSURL* url = [NSURL URLWithString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"AfloatDonationsURL"]];
			[[NSWorkspace sharedWorkspace] openURL:url];
		}
	}
	
	[NSApp terminate:self];
}

@end
