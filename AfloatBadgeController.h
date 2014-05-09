//
//  AfloatBadgeController.h
//  Afloat
//
//  Created by ∞ on 13/03/08.
//  Copyright 2008 Emanuele Vulcano. All rights reserved.
//

#import <Cocoa/Cocoa.h>

enum {
	AfloatBadgeDidBeginKeepingAfloat,
	AfloatBadgeDidEndKeepingAfloat
};
typedef NSUInteger AfloatBadgeType;

@interface AfloatBadgeController : NSWindowController {
	NSWindow* _parentWindow;
	IBOutlet NSImageView* badgeView;
	
	BOOL fadingOut;
	unsigned int enqueuedFades;
}

@property(retain, nonatomic) NSWindow* parentWindow;

- (id) initAttachedToWindow:(NSWindow*) parentWindow;
+ (id) badgeControllerForWindow:(NSWindow*) w;

- (void) animateWithBadgeType:(AfloatBadgeType) type;
+ (NSImage*) didBeginKeepingAfloatBadge;
+ (NSImage*) didEndKeepingAfloatBadge;

@end
