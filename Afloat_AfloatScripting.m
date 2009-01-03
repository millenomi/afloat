//
//  Afloat_AfloatScripting.m
//  Afloat
//
//  Created by ∞ on 30/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Afloat_AfloatScripting.h"
#import <Carbon/Carbon.h>

static BOOL AfloatBOOLFromObject(id object, BOOL defaultValue) {
	if (!object) return defaultValue;
	else return [object respondsToSelector:@selector(boolValue)] && [object boolValue];
}

static float AfloatFloatFromObject(id object, float defaultValue) {
	if (!object || ![object respondsToSelector:@selector(floatValue)]) return defaultValue;
	else return [object floatValue];
}


@implementation Afloat (AfloatScripting)

- (void) installScriptingSupport {
	// Toggle kept afloat
	[[NSDistributedNotificationCenter defaultCenter]
	 addObserver:self
		selector:@selector(_scriptShouldToggleKeptAfloat:)
			name:kAfloatScriptToggleKeptAfloatNotification
		object:kAfloatScriptWireObject];
	
	// Set kept afloat
	[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(_scriptShouldSetKeptAfloat:) name:kAfloatScriptSetKeptAfloatNotification object:kAfloatScriptWireObject];
	
	// Set alpha value
	[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(_scriptShouldSetAlphaValue:) name:kAfloatScriptSetAlphaValueNotification object:kAfloatScriptWireObject];
	
	// Set to be kept in all spaces
	[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(_scriptShouldSetKeptOnAllSpaces:) name:kAfloatScriptSetKeptOnAllSpacesNotification object:kAfloatScriptWireObject];
	
	// Set pinned to desktop
	[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(_scriptShouldSetPinnedToDesktop:) name:kAfloatScriptSetPinnedToDesktopNotification object:kAfloatScriptWireObject];

	// Set overlay
	[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(_scriptShouldSetOverlay:) name:kAfloatScriptSetOverlayNotification object:kAfloatScriptWireObject];
	
	// Disable all overlays
	[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(_scriptShouldDisableAllOverlays:) name:kAfloatScriptDisableAllOverlaysNotification object:kAfloatScriptWireObject];
	
	// Make more transparent
	[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(_scriptShouldMakeMoreTransparent:) name:kAfloatScriptMoreTransparentNotification object:kAfloatScriptWireObject];

	// Make less transparent
	[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(_scriptShouldMakeLessTransparent:) name:kAfloatScriptLessTransparentNotification object:kAfloatScriptWireObject];

	// Show window's file in finder
	[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(_scriptShouldShowWindowFileInFinder:) name:kAfloatScriptShowWindowFileInFinderNotification object:kAfloatScriptWireObject];

	NSString* pathToScriptingApp = [[[[NSBundle bundleForClass:[self class]] bundlePath] stringByAppendingPathComponent:@"Contents"] stringByAppendingPathComponent:@"Afloat Scripting.app"];
	LSRegisterURL((CFURLRef) [NSURL fileURLWithPath:pathToScriptingApp], false);
	
	L0LogS(@"Scripting support installed.");
}

- (void) _scriptShouldShowWindowFileInFinder:(NSNotification*) n {
	if (![NSApp isActive]) return;
	
	[self showWindowFileInFinder:self];
	
	L0LogS(@"Script: Tried to show the window's file in the Finder.");
}

- (void) _scriptShouldMakeLessTransparent:(NSNotification*) n {
	if (![NSApp isActive]) return;
	
	[self makeLessTransparent:self];
	
	L0LogS(@"Script: Made less transparent.");
}

- (void) _scriptShouldMakeMoreTransparent:(NSNotification*) n {
	if (![NSApp isActive]) return;
	
	[self makeMoreTransparent:self];
	
	L0LogS(@"Script: Made more transparent.");
}

- (void) _scriptShouldDisableAllOverlays:(NSNotification*) n {
	if (![NSApp isActive]) return;
	
	[self disableAllOverlays:self];
	
	L0LogS(@"Script: Disabled all overlays.");
}

- (void) _scriptShouldSetOverlay:(NSNotification*) n {
	if (![NSApp isActive]) return;
	
	NSWindow* w = [self currentWindow];
	BOOL isOverlay = AfloatBOOLFromObject([[n userInfo] objectForKey:@"overlay"], NO);
	BOOL showsBadgeAnimation = AfloatBOOLFromObject([[n userInfo] objectForKey:@"showsBadgeAnimation"], YES);
	
	[self setOverlay:isOverlay forWindow:w animated:YES showBadgeAnimation:showsBadgeAnimation];
	
	L0Log(@"Script: Set window overlay = %d with badge animation = %d", isOverlay, showsBadgeAnimation);
}

- (void) _scriptShouldSetPinnedToDesktop:(NSNotification*) n {
	if (![NSApp isActive]) return;
	
	L0Log(@"Script: will pin to desktop with notification = %@ userInfo = %@", n, [n userInfo]);
	
	NSWindow* w = [self currentWindow];
	BOOL isPinnedToDesktop = AfloatBOOLFromObject([[n userInfo] objectForKey:@"pinnedToDesktop"], NO);
	BOOL showsBadgeAnimation = AfloatBOOLFromObject([[n userInfo] objectForKey:@"showsBadgeAnimation"], YES);

	[self setKeptPinnedToDesktop:isPinnedToDesktop forWindow:w showBadgeAnimation:showsBadgeAnimation];
	
	L0Log(@"Script: Set window pinned to desktop = %d with badge animation = %d", isPinnedToDesktop, showsBadgeAnimation);
}

- (void) _scriptShouldSetKeptOnAllSpaces:(NSNotification*) n {
	if (![NSApp isActive]) return;

	NSWindow* w = [self currentWindow];
	BOOL isKeptOnAllSpaces = AfloatBOOLFromObject([[n userInfo] objectForKey:@"keptOnAllSpaces"], NO);
	
	[self setOnAllSpaces:isKeptOnAllSpaces forWindow:w];
	
	L0Log(@"Script: Set window on all spaces = %d", isKeptOnAllSpaces);
}

- (void) _scriptShouldToggleKeptAfloat:(NSNotification*) n {
	if (![NSApp isActive]) return;
	
	NSWindow* w = [self currentWindow];
	BOOL isKeptAfloat = [self isWindowKeptAfloat:w];
	BOOL showsBadgeAnimation = AfloatBOOLFromObject([[n userInfo] objectForKey:@"showsBadgeAnimation"], YES);
	
	if (w)
		[self setKeptAfloat:!isKeptAfloat forWindow:w showBadgeAnimation:showsBadgeAnimation];
	
	L0Log(@"Script: Did toggle kept afloat with badge animation = %d", showsBadgeAnimation);
}

- (void) _scriptShouldSetKeptAfloat:(NSNotification*) n {
	if (![NSApp isActive]) return;
	
	NSWindow* w = [self currentWindow];
	BOOL isKeptAfloat = [self isWindowKeptAfloat:w];
	BOOL showsBadgeAnimation = AfloatBOOLFromObject([[n userInfo] objectForKey:@"showsBadgeAnimation"], YES);
	BOOL keepAfloat = AfloatBOOLFromObject([[n userInfo] objectForKey:@"keptAfloat"], NO);
	
	if (keepAfloat == isKeptAfloat) return;
	
	if (w)
		[self setKeptAfloat:keepAfloat forWindow:w showBadgeAnimation:showsBadgeAnimation];
	
	L0Log(@"Script: Did set kept afloat = %d with badge animation = %d", keepAfloat, showsBadgeAnimation);
}

- (void) _scriptShouldSetAlphaValue:(NSNotification*) n {
	if (![NSApp isActive]) return;
	
	NSWindow* w = [self currentWindow];
	float alphaValue = AfloatFloatFromObject([[n userInfo] objectForKey:@"alphaValue"], 1.0);
	
	if (w)
		[self setAlphaValue:alphaValue forWindow:w animated:YES];
	
	L0Log(@"Script: Did set alpha value = %f", alphaValue);
}

@end
