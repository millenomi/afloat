//
//  AfloatScriptingAppDelegate.m
//  AfloatScripting
//
//  Created by ∞ on 30/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AfloatScriptingAppDelegate.h"


@implementation AfloatScriptingAppDelegate

- (void) applicationDidFinishLaunching:(NSNotification*) n {
	[self rearmDeathTimer];
}

- (void) rearmDeathTimer {
	if (deathTimer) {
		[deathTimer invalidate];
	}
	
	deathTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(deathTimerTicked:) userInfo:nil repeats:NO];
}

- (void) deathTimerTicked:(NSTimer*) t {
	[NSApp terminate:self];
}

- (void) dealloc {
	[deathTimer invalidate];
}

@end
