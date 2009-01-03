//
//  AfloatMakeMoreTransparentCommand.m
//  AfloatScripting
//
//  Created by ∞ on 31/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AfloatMakeMoreTransparentCommand.h"
#import "AfloatScriptingWire.h"
#import "AfloatScriptingAppDelegate.h"

@implementation AfloatMakeMoreTransparentCommand

- (id) performDefaultImplementation {
	[[NSApp delegate] rearmDeathTimer];
	
	[[NSDistributedNotificationCenter defaultCenter]
	 postNotificationName:kAfloatScriptMoreTransparentNotification object:kAfloatScriptWireObject];
	return nil;
}

@end
