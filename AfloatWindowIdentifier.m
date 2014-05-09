//
//  AfloatWindowIdentifier.m
//  Afloat
//
//  Created by ∞ on 28/08/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AfloatWindowIdentifier.h"

@interface AfloatWindowIdentifier ()

@property(setter=_setCategory:, copy) NSString* category;
@property(setter=_setKey:, copy) NSString* key;
@property(setter=_setCanMatchMultipleWindows:, assign) BOOL canMatchMultipleWindows;

+ (NSArray*) identifierSubclasses;

@end

@interface AfloatWindowIdentifier (AfloatAbstractPrivateMethods)
+ (BOOL) canInitWithWindow:(NSWindow*) w;
- (id) initWithWindow:(NSWindow*) w;
@end

// the class that implements kAfloatByWindowCustomSubclassCategory

@interface _AfloatWindowByClassIdentifier : AfloatWindowIdentifier {}
@end
@implementation _AfloatWindowByClassIdentifier

+ (BOOL) canInitWithWindow:(NSWindow*) w {
	return ![w isKindOfClass:[NSPanel class]] && ![w isMemberOfClass:[NSWindow class]];
}

- (id) initWithWindow:(NSWindow*) w {
	if (self = [super init]) {
		self.category = kAfloatByWindowCustomSubclassCategory;
		self.key = NSStringFromClass([w class]);
		self.canMatchMultipleWindows = YES;
	}
	
	return self;
}

- (BOOL) matchesWindow:(NSWindow*) w {
	return [(NSStringFromClass([w class])) isEqual:self.key];
}

@end

// the class that implements kAfloatByDelegateCustomSubclassCategory

@interface _AfloatWindowByDelegateClassIdentifier : AfloatWindowIdentifier {}
@end
@implementation _AfloatWindowByDelegateClassIdentifier

+ (BOOL) canInitWithWindow:(NSWindow*) w {
	return [w delegate] != nil;
}

- (id) initWithWindow:(NSWindow*) w {
	if (self = [super init]) {
		self.category = kAfloatByDelegateCustomSubclassCategory;
		self.key = NSStringFromClass([[w delegate] class]);
		self.canMatchMultipleWindows = YES;
	}
	
	return self;
}

- (BOOL) matchesWindow:(NSWindow*) w {
	return [w delegate] && [(NSStringFromClass([[w delegate] class])) isEqual:self.key];
}

@end

// the class that implements kAfloatByWindowCustomControllerCategory

@interface _AfloatWindowByControllerClassIdentifier : AfloatWindowIdentifier {}
@end
@implementation _AfloatWindowByControllerClassIdentifier

+ (BOOL) canInitWithWindow:(NSWindow*) w {
	return [w windowController] && ![[w windowController] isMemberOfClass:[NSWindowController class]];
}

- (id) initWithWindow:(NSWindow*) w {
	if (self = [super init]) {
		self.category = kAfloatByWindowCustomControllerCategory;
		self.key = NSStringFromClass([[w windowController] class]);
		self.canMatchMultipleWindows = YES;
	}
	
	return self;
}

- (BOOL) matchesWindow:(NSWindow*) w {
	return [w windowController] && [(NSStringFromClass([[w windowController] class])) isEqual:self.key];
}

@end

// the class that implements kAfloatByWindowAutosaveNameCategory

@interface _AfloatWindowByAutosaveNameIdentifier : AfloatWindowIdentifier {}
@end
@implementation _AfloatWindowByAutosaveNameIdentifier

+ (BOOL) canInitWithWindow:(NSWindow*) w {
	return [w frameAutosaveName] && ![[w frameAutosaveName] isEqual:@""];
}

- (id) initWithWindow:(NSWindow*) w {
	if (self = [super init]) {
		self.category = kAfloatByWindowAutosaveNameCategory;
		self.key = [w frameAutosaveName];
		self.canMatchMultipleWindows = YES;
	}
	
	return self;
}

- (BOOL) matchesWindow:(NSWindow*) w {
	return [w frameAutosaveName] && [[w frameAutosaveName] isEqual:self.key];
}

@end

// - * - - * - - * - - * - - * - - * - - * - 

@implementation AfloatWindowIdentifier

+ (NSArray*) identifierSubclasses {
	static id classes = nil; if (!classes) {
		classes = [[NSArray alloc] initWithObjects:
				   [_AfloatWindowByAutosaveNameIdentifier class],
				   [_AfloatWindowByClassIdentifier class],
				   [_AfloatWindowByDelegateClassIdentifier class],
				   [_AfloatWindowByControllerClassIdentifier class],
				   nil];
	}
	
	return classes;
}

- (void) dealloc {
	self.category = nil;
	self.key = nil;
	
	[super dealloc];
}

@synthesize category = _category, key = _key, canMatchMultipleWindows = _canMatchMultipleWindows;

+ (NSArray*) allIdentifiersForWindow:(NSWindow*) w {
	NSMutableArray* results = [NSMutableArray array];
	
	for (Class c in [self identifierSubclasses]) {
		if ([c canInitWithWindow:w])
			[results addObject:[[[c alloc] initWithWindow:w] autorelease]];
	}
	
	return results;
}

- (BOOL) matchesWindow:(NSWindow*) w {
	return NO;
}

@end
