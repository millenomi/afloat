//
//  AfloatDisableOverlaysCommand.m
//  AfloatScripting
//
//  Created by ∞ on 31/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AfloatDisableOverlaysCommand.h"
#import "AfloatScriptingWire.h"
#import "AfloatScriptingAppDelegate.h"

@implementation AfloatDisableOverlaysCommand

- (id) performDefaultImplementation {
	[[NSApp delegate] rearmDeathTimer];
	
	[[NSDistributedNotificationCenter defaultCenter]
	 postNotificationName:kAfloatScriptDisableAllOverlaysNotification object:kAfloatScriptWireObject];
	return nil;
}

@end
