//
//  AfloatScriptingToggleKeptAfloatCommand.m
//  AfloatScripting
//
//  Created by ∞ on 30/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AfloatScriptingToggleKeptAfloatCommand.h"
#import "AfloatScriptingWire.h"
#import "AfloatScriptingAppDelegate.h"

@implementation AfloatScriptingToggleKeptAfloatCommand

- (id) performDefaultImplementation {
	BOOL showsBadgeAnimation = AfloatBOOLFromObject([[self evaluatedArguments] objectForKey:@"showsBadgeAnimation"], YES);	
	[[NSApp delegate] rearmDeathTimer];
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:kAfloatScriptToggleKeptAfloatNotification object:kAfloatScriptWireObject userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:showsBadgeAnimation] forKey:@"showsBadgeAnimation"]];
	return nil;
}

@end
