//
//  AfloatPanel.m
//  AfloatHUD
//
//  Created by ∞ on 04/03/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AfloatPanel.h"
#import <Quartz/Quartz.h>

@interface AfloatPanelBackdropView : NSView {
	NSImage* _image;
}
@end

@implementation AfloatPanelBackdropView

- (id) initWithFrame:(NSRect) frame {
	if (self = [super initWithFrame:frame]) {
		NSString* pathToBackdrop = [[NSBundle bundleForClass:[self class]] pathForImageResource:@"AfloatHUDBackdrop"];
		_image = [[NSImage alloc] initWithContentsOfFile:pathToBackdrop];
	}
	
	return self;
}

- (void) dealloc {
	[_image release];
	[super dealloc];
}

- (void) drawRect:(NSRect) r {
	[[NSColor clearColor] set]; NSRectFill(r);
	
	[_image drawInRect:r fromRect:r operation:NSCompositeSourceOver fraction:1.0];
}

@end



@implementation AfloatPanel

- (id) initWithContentRect:(NSRect) contentRect styleMask:(NSUInteger) aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {
	self = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:bufferingType defer:flag];
	if (!self) return nil;
	
	[self setBackgroundColor:[NSColor clearColor]];
	[self setOpaque:NO];
	[self setHasShadow:YES];
	[self setMovableByWindowBackground:NO];
	return self;
}

- (NSPoint) frameOrigin {
	return [self frame].origin;
}

@dynamic frameOrigin;

@end
