//
//  AfloatSetPinnedToDesktopCommand.m
//  AfloatScripting
//
//  Created by ∞ on 31/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AfloatSetPinnedToDesktopCommand.h"
#import "AfloatScriptingWire.h"
#import "AfloatScriptingAppDelegate.h"

@implementation AfloatSetPinnedToDesktopCommand

- (id) performDefaultImplementation {
	BOOL pinnedToDesktop = AfloatBOOLFromObject([self directParameter], NO);
	NSLog(@"Will pin to desktop = %@ (%d)", [self directParameter], pinnedToDesktop);
	BOOL showsBadgeAnimation = AfloatBOOLFromObject([[self evaluatedArguments] objectForKey:@"showsBadgeAnimation"], YES);
	
	[[NSApp delegate] rearmDeathTimer];
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:kAfloatScriptSetPinnedToDesktopNotification object:kAfloatScriptWireObject userInfo:
	 [NSDictionary dictionaryWithObjectsAndKeys:
	  [NSNumber numberWithBool:pinnedToDesktop], @"pinnedToDesktop",
	  [NSNumber numberWithBool:showsBadgeAnimation], @"showsBadgeAnimation",
	  nil]
	 ];
	return nil;
}

@end
