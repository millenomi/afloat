//
//  AfloatScriptingSetKeptAfloatCommand.m
//  AfloatScripting
//
//  Created by ∞ on 30/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AfloatScriptingSetKeptAfloatCommand.h"
#import "AfloatScriptingWire.h"
#import "AfloatScriptingAppDelegate.h"

@implementation AfloatScriptingSetKeptAfloatCommand

- (id) performDefaultImplementation {
	BOOL showsBadgeAnimation = AfloatBOOLFromObject([[self evaluatedArguments] objectForKey:@"showsBadgeAnimation"], YES);
	BOOL keptAfloat = AfloatBOOLFromObject([self directParameter], NO);
	
	[[NSApp delegate] rearmDeathTimer];
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:kAfloatScriptSetKeptAfloatNotification object:kAfloatScriptWireObject userInfo:
		[NSDictionary dictionaryWithObjectsAndKeys:
		 [NSNumber numberWithBool:showsBadgeAnimation], @"showsBadgeAnimation",
		 [NSNumber numberWithBool:keptAfloat], @"keptAfloat",
		 nil]
	];
	return nil;
}

@end
