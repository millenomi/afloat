//
//  AfloatScriptingSetAlphaValueCommand.m
//  AfloatScripting
//
//  Created by ∞ on 30/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AfloatScriptingSetAlphaValueCommand.h"
#import "AfloatScriptingWire.h"
#import "AfloatScriptingAppDelegate.h"

@implementation AfloatScriptingSetAlphaValueCommand

- (id) performDefaultImplementation {
	float alphaValue = [[self directParameter] floatValue];
	
	[[NSApp delegate] rearmDeathTimer];
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:kAfloatScriptSetAlphaValueNotification object:kAfloatScriptWireObject userInfo:
	 [NSDictionary dictionaryWithObjectsAndKeys:
	  [NSNumber numberWithFloat:alphaValue], @"alphaValue",
	  nil]
	 ];
	return nil;
}

@end
