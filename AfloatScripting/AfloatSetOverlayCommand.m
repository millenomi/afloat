//
//  AfloatSetOverlayCommand.m
//  AfloatScripting
//
//  Created by ∞ on 31/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AfloatSetOverlayCommand.h"
#import "AfloatScriptingWire.h"
#import "AfloatScriptingAppDelegate.h"

@implementation AfloatSetOverlayCommand

- (id) performDefaultImplementation {
	BOOL showsBadgeAnimation = AfloatBOOLFromObject([[self evaluatedArguments] objectForKey:@"showsBadgeAnimation"], YES);
	BOOL overlay = AfloatBOOLFromObject([self directParameter], NO);
	
	[[NSApp delegate] rearmDeathTimer];
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:kAfloatScriptSetOverlayNotification object:kAfloatScriptWireObject userInfo:
	 [NSDictionary dictionaryWithObjectsAndKeys:
	  [NSNumber numberWithBool:showsBadgeAnimation], @"showsBadgeAnimation",
	  [NSNumber numberWithBool:overlay], @"overlay",
	  nil]
	 ];
	return nil;
}

@end
