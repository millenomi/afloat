//
//  Afloat_AfloatNagging.m
//  Afloat
//
//  Created by ∞ on 29/03/08.
//  Copyright 2008 Emanuele Vulcano. All rights reserved.
//

#import "Afloat_AfloatNagging.h"
#import <Carbon/Carbon.h>
#import "AfloatNagPreferences.h"

@implementation Afloat (AfloatNagging)

- (void) checkForNagOnInstall {
#if kAfloatEnableNag
#warning Nagging is enabled.
	if (!AfloatNagGetPreferenceForKey(kAfloatInstallationDateKey, [NSDate class]))
		AfloatNagSetPreferenceForKey(kAfloatInstallationDateKey, [NSDate date]);
	
	if (AfloatNagCurrentAction() != kAfloatDoNotShowAlerts) {
		NSBundle* b = [NSBundle bundleForClass:[self class]];
		NSString* donateApp = [[[b bundlePath] stringByAppendingPathComponent:@"Contents"] stringByAppendingPathComponent:@"Donate for Afloat.app"];
		[[NSWorkspace sharedWorkspace] openFile:donateApp];
	}
#endif
}

@end
