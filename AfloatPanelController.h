//
//  AfloatPanelController.h
//  AfloatHUD
//
//  Created by ∞ on 04/03/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum {
	kAfloatWindowStateNormal = 0,
	kAfloatWindowStateAfloat = 1,
	kAfloatWindowStatePinnedToDesktop = 2,
} AfloatWindowState;

@interface AfloatPanelController : NSWindowController {
	NSWindow* _parentWindow;
	float lastAlpha;
}

- (id) initAttachedToWindow:(NSWindow*) window;
+ (id) panelControllerForWindow:(NSWindow*) w;

- (IBAction) hideWindow:(id) sender;
- (IBAction) toggleWindow:(id) sender;

- (IBAction) disableAllOverlays:(id) sender;

@property(retain, nonatomic) NSWindow* parentWindow;
@property CGFloat alphaValue;
// @property(getter=isKeptAfloat) BOOL keptAfloat;
@property AfloatWindowState windowState;

@property(getter=isOnAllSpaces) BOOL onAllSpaces;
@property(getter=isOverlay) BOOL overlay;
@property BOOL alphaValueAnimatesOnMouseOver;

@property(readonly) BOOL canSetAlphaValueAnimatesOnMouseOver;

@end
