//
//  AfloatBadgeController.m
//  Afloat
//
//  Created by ∞ on 13/03/08.
//  Copyright 2008 Emanuele Vulcano. All rights reserved.
//

#import "AfloatBadgeController.h"
#import "AfloatStorage.h"
#import <QuartzCore/QuartzCore.h>

#define kAfloatBadgeControllerKey @"AfloatBadgeController"

@implementation AfloatBadgeController

+ (id) badgeControllerForWindow:(NSWindow*) w {
	id panel = [AfloatStorage sharedValueForWindow:w key:kAfloatBadgeControllerKey];
	if (panel)
		return panel;
	else
		return [[[self alloc] initAttachedToWindow:w] autorelease];
}

- (id) initAttachedToWindow:(NSWindow*) parentWindow {
	if (self = [self initWithWindowNibName:@"AfloatBadge" owner:self]) {
		self.parentWindow = parentWindow;
	}
	
	return self;
}

- (void) windowDidLoad {
	[[self window] setIgnoresMouseEvents:YES];
	[[self window] setLevel:NSStatusWindowLevel];
	
	CABasicAnimation* ani = [CABasicAnimation animation];
	ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	[[self window] setAnimations:
	 [NSDictionary dictionaryWithObject:ani forKey:@"frameOrigin"]];
	
	L0Log(@"badge view = %@", badgeView);
}

@synthesize parentWindow = _parentWindow;
- (void) setParentWindow:(NSWindow*) newParent {
	if (newParent != _parentWindow) {
		if (_parentWindow) {
			[AfloatStorage removeSharedValueForWindow:_parentWindow key:kAfloatBadgeControllerKey];
			
			[_parentWindow release];
		}
		
		if (newParent) {
			[AfloatStorage setSharedValue:self window:newParent key:kAfloatBadgeControllerKey];
			
			//			[[NSNotificationCenter defaultCenter]
			//			 addObserver:self selector:@selector(parentWindowDidResize:) name:NSWindowDidResizeNotification object:_parentWindow];
			
			
			[newParent retain];
		}
		
		_parentWindow = newParent;
	}
}

- (NSPoint) middleOriginForParentWindow {
	if (!self.parentWindow) return NSZeroPoint;
	
	NSRect parentFrame = [self.parentWindow frame];
	NSRect windowFrame = [[self window] frame];
	NSRect screenFrame = [[self.parentWindow screen] visibleFrame];
	parentFrame = NSIntersectionRect(parentFrame, screenFrame);
	
	NSPoint origin = parentFrame.origin;
	origin.x += parentFrame.size.width / 2;
	origin.x -= windowFrame.size.width / 2;
	origin.y += parentFrame.size.height / 2;
	origin.y -= windowFrame.size.height / 2;
	
	return origin;
}

- (void) animateWithBadgeType:(AfloatBadgeType) type {
	[self window]; // so the window is loaded.
	
	switch (type) {
		case AfloatBadgeDidBeginKeepingAfloat:
			[badgeView setImage:[[self class] didBeginKeepingAfloatBadge]];
			
		{
			NSPoint targetOrigin = [self middleOriginForParentWindow];
			NSPoint startingOrigin = targetOrigin;
			startingOrigin.y -= 20;
			
			NSRect r = [[self window] frame];
			r.origin = startingOrigin;
			[[self window] setFrame:r display:NO];
			[[self window] makeKeyAndOrderFront:self];
			
			[NSAnimationContext beginGrouping];
			{
				[[NSAnimationContext currentContext] setDuration:0.4];
				r.origin = targetOrigin;
				[[[self window] animator] setFrame:r display:YES];
			}
			[NSAnimationContext endGrouping];
			
			enqueuedFades++;
			[self performSelector:@selector(_fadeOut) withObject:nil afterDelay:0.7];
		}
			break;
			
		case AfloatBadgeDidEndKeepingAfloat:
			[badgeView setImage:[[self class] didEndKeepingAfloatBadge]];
			
		{
			NSPoint targetOrigin = [self middleOriginForParentWindow];
			NSPoint startingOrigin = targetOrigin;
			targetOrigin.y -= 30;
			
			NSRect r = [[self window] frame];
			r.origin = startingOrigin;
			[[self window] setFrame:r display:NO];
			[[self window] makeKeyAndOrderFront:self];
			
			[NSAnimationContext beginGrouping];
			{
				[[NSAnimationContext currentContext] setDuration:0.4];
				r.origin = targetOrigin;
				[[[self window] animator] setFrame:r display:YES];
			}
			[NSAnimationContext endGrouping];
			
			enqueuedFades++;
			[self performSelector:@selector(_fadeOut) withObject:nil afterDelay:0.7];
		}
			break;
	}
}

- (void) _fadeOut {
	if (enqueuedFades <= 1)
		enqueuedFades = 0;
	else {
		enqueuedFades--;
		return;
	}
	
	if (fadingOut || ![[self window] isVisible]) return;
	fadingOut = YES;
	
	[[NSAnimationContext currentContext] setDuration:0.2];
	[[[self window] animator] setAlphaValue:0];
	[NSAnimationContext endGrouping];
	
	[AfloatStorage removeSharedValueForWindow:self.parentWindow key:kAfloatBadgeControllerKey];
	
	[self performSelector:@selector(_endAnimation) withObject:nil afterDelay:0.3];
}

- (void) _endAnimation {
	fadingOut = NO;	
	[[self window] orderOut:self];
}

+ (NSImage*) didBeginKeepingAfloatBadge {
	static NSImage* image = nil; if (!image) {
		NSBundle* bundle = [NSBundle bundleForClass:self];
		L0Log(@"loading %@", [bundle pathForImageResource:@"AfloatFloatingBadge"]);
		image = [[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"AfloatFloatingBadge"]];
		L0Log(@"%@", image);
	}
	
	return image;
}

+ (NSImage*) didEndKeepingAfloatBadge {
	static NSImage* image = nil; if (!image) {
		NSBundle* bundle = [NSBundle bundleForClass:self];
		L0Log(@"loading %@", [bundle pathForImageResource:@"AfloatSinkingBadge"]);
		image = [[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"AfloatSinkingBadge"]];
		L0Log(@"%@", image);
	}
	
	return image;
}


- (void) dealloc {
	self.parentWindow = nil;
	[super dealloc];
}

@end
