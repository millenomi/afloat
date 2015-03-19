//
//  AfloatShowWindowFileInFinderCommand.m
//  AfloatScripting
//
//  Created by ∞ on 31/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AfloatShowWindowFileInFinderCommand.h"
#import "AfloatScriptingWire.h"
#import "AfloatScriptingAppDelegate.h"

@implementation AfloatShowWindowFileInFinderCommand

- (id) performDefaultImplementation {
    AfloatScriptingAppDelegate *asap = [[[AfloatScriptingAppDelegate alloc] init] autorelease];
    [asap rearmDeathTimer];
	
	[[NSDistributedNotificationCenter defaultCenter]
	 postNotificationName:kAfloatScriptShowWindowFileInFinderNotification object:kAfloatScriptWireObject];
	return nil;
}

@end
