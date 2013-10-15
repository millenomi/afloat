/*
Copyright (c) 2008, Emanuele Vulcano
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import <Cocoa/Cocoa.h>


@interface Afloat : NSObject {
	IBOutlet NSMenu* _menuWithItems;
	BOOL _settingOverlay;
}

+ (id) sharedInstance;
- (NSBundle*) bundle;

- (IBAction) toggleAlwaysOnTop:(id) sender;
- (void) setKeptAfloat:(BOOL) afloat forWindow:(NSWindow*) c showBadgeAnimation:(BOOL) animated;
- (BOOL) isWindowKeptAfloat:(NSWindow*) w;

- (IBAction) makeTranslucent:(id) sender;
- (IBAction) makeOpaque:(id) sender;
- (IBAction) makeMoreTransparent:(id) sender;
- (IBAction) makeLessTransparent:(id) sender;

- (IBAction) toggleFocusFollowsMouse:(id)sender;

- (IBAction) showAdjustEffectsPanel:(id) sender;

- (CGFloat) currentAlphaValueForWindow:(NSWindow*) w;
- (void) setAlphaValue:(CGFloat) f forWindow:(NSWindow*) window animated:(BOOL) animate;
- (void) setAlphaValueByDelta:(CGFloat) f forWindow:(NSWindow*) window animate:(BOOL) animate;
- (void) setAlphaValueAnimatesOnMouseOver:(BOOL) animates forWindow:(NSWindow*) window;
- (BOOL) alphaValueAnimatesOnMouseOverForWindow:(NSWindow*) window;

- (NSWindow*) currentWindow;

- (void) setOnAllSpaces:(BOOL) afloat forWindow:(NSWindow*) c; // animated:(BOOL) animated;
- (BOOL) isWindowOnAllSpaces:(NSWindow*) w;

- (void) setOverlay:(BOOL) overlay forWindow:(NSWindow*) w animated:(BOOL) animated showBadgeAnimation:(BOOL) badge;
- (BOOL) isWindowOverlay:(NSWindow*) w;
- (IBAction) disableAllOverlays:(id) sender;
- (void) disableAllOverlaysShowingBadgeAnimation:(BOOL) badge;


- (IBAction) showWindowFileInFinder:(id) sender;


- (void) setKeptPinnedToDesktop:(BOOL) pinned forWindow:(NSWindow*) c showBadgeAnimation:(BOOL) animated;
- (BOOL) isWindowKeptPinnedToDesktop:(NSWindow*) w;

- (void) animateFadeInForWindow:(NSWindow*) w;
- (void) animateFadeOutForWindow:(NSWindow*) w;

@end
