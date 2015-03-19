//
//  AfloatScriptingSetKeptOnAllSpacesCommand.m
//  AfloatScripting
//
//  Created by ∞ on 31/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AfloatScriptingSetKeptOnAllSpacesCommand.h"
#import "AfloatScriptingWire.h"
#import "AfloatScriptingAppDelegate.h"

@implementation AfloatScriptingSetKeptOnAllSpacesCommand

- (id) performDefaultImplementation {
	BOOL keptOnAllSpaces = [[self directParameter] boolValue];
	
    AfloatScriptingAppDelegate *asap = [[[AfloatScriptingAppDelegate alloc] init] autorelease];
    [asap rearmDeathTimer];
    
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:kAfloatScriptSetKeptOnAllSpacesNotification object:kAfloatScriptWireObject userInfo:
	 [NSDictionary dictionaryWithObjectsAndKeys:
	  [NSNumber numberWithBool:keptOnAllSpaces], @"keptOnAllSpaces",
	  nil]
	 ];
	return nil;
}

@end
