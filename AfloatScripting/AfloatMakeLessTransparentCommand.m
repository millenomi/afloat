//
//  AfloatMakeLessTransparentCommand.m
//  AfloatScripting
//
//  Created by ∞ on 31/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AfloatMakeLessTransparentCommand.h"
#import "AfloatScriptingWire.h"
#import "AfloatScriptingAppDelegate.h"

@implementation AfloatMakeLessTransparentCommand

- (id) performDefaultImplementation {
    AfloatScriptingAppDelegate *asap = [[[AfloatScriptingAppDelegate alloc] init] autorelease];
    [asap rearmDeathTimer];
	
	[[NSDistributedNotificationCenter defaultCenter]
	 postNotificationName:kAfloatScriptLessTransparentNotification object:kAfloatScriptWireObject];
	return nil;
}

@end

