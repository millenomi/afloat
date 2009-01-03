//
//  AfloatWindowIdentifier.h
//  Afloat
//
//  Created by ∞ on 28/08/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// A window identifier is used to identify windows
// even after they are closed. They're used by AfloatStorage
// to persist settings and reapply them correctly.

// PLEASE NOTE: This is an abstract class that should not
// be subclassed by clients. Use the +identifiersForWindow:
// method to return suitable identifiers for a window.

@interface AfloatWindowIdentifier : NSObject {
	NSString* _key;
	NSString* _category;
	
	BOOL _canMatchMultipleWindows;
}

// An identifier is made up of a category and a key;
// a category is one of the constants above, while
// a key identifies a window or class of windows
// for that identifier category.
@property(readonly, copy) NSString* category;
@property(readonly, copy) NSString* key;

// If YES, then the identifier is collective
// (ie it can happen that more than one window
// is selected that corresponds to the above).
@property(readonly, assign) BOOL canMatchMultipleWindows;

// YES if this identifier matches the given window,
// NO otherwise.
- (BOOL) matchesWindow:(NSWindow*) w;

// Returns an array of identifiers that match
// the given window.
// NOTE: A window may have no identifiers, in which
// case the storage won't be able to save settings
// for it!
// NOTE 2: Identifiers are returned in order of
// decreasing specificity. The first identifier
// returned is the one most likely to select the
// fewest windows (possibly an individual identifier,
// eg one with canMatchMultipleWindows = NO).
// Following identifiers are likely to select more
// windows.
+ (NSArray*) allIdentifiersForWindow:(NSWindow*) w;

// 

@end

// This category of identifiers uses autosave name as a key.
// They're always individual (canMatchMultipleWindows = NO).
#define kAfloatByWindowAutosaveNameCategory @"AfloatByWindowAutosaveNameCategory"

// This category of identifiers uses the window's custom subclass's
// name as a key. It only selects instances of subclasses of NSWindow,
// not instances of NSWindow itself. (Note that NSPanel instances are never
// selected.)
#define kAfloatByWindowCustomSubclassCategory @"AfloatByWindowCustomSubclassCategory"

// This category of identifiers uses the window's custom delegate
// class as a key. It only selects windows that have a delegate.
#define kAfloatByDelegateCustomSubclassCategory @"AfloatByDelegateCustomSubclassCategory"

// This category of identifiers uses the window's NSWindowController
// custom subclass as a key. It only selects windows whose controller
// is a subclass of NSWindowController, not NSWindowController itself.
#define kAfloatByWindowCustomControllerCategory @"AfloatByWindowCustomControllerCategory"
