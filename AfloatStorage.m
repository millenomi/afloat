/*
Copyright (c) 2008, Emanuele Vulcano
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import "AfloatStorage.h"

#define kAfloatNamedWindowsCategoryAutosaveKey @"AfloatNamedWindowsCategoryAutosave"

#define kAfloatShouldSaveWindowKey @"AfloatShouldSaveWindow"

@interface AfloatStorage ()

// Is Afloat able to save this window? (doesn't take setShouldSave:...) into account
- (BOOL) canSaveWindow:(NSWindow*) w category:(NSString**) cat key:(NSString**) key;

// Should Afloat save this window? (setShouldSave:NO ... makes this return NO)
- (BOOL) shouldSaveWindow:(NSWindow*) w category:(NSString**) cat key:(NSString**) key;

@end


@implementation AfloatStorage

- (id) init {
	self = [super init];
	if (self != nil) {
		_backingStorage = [NSMutableDictionary new];
	}
	return self;
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[_backingStorage release];
	[super dealloc];
}

- (id) valueForWindow:(NSWindow*) w key:(NSString*) k {
	return [[_backingStorage objectForKey:[NSValue valueWithNonretainedObject:w]] objectForKey:k];
}

- (void) setValue:(id) v forWindow:(NSWindow*) w key:(NSString*) k {
	NSMutableDictionary* d = [self mutableDictionaryForWindow:w];
    if(v)
        [d setObject:v forKey:k];
    else
        [d removeObjectForKey:k];
	[self saveWindowIfRequired:w];
}

- (NSMutableDictionary*) mutableDictionaryForWindow:(NSWindow*) w {
	NSValue* value = [NSValue valueWithNonretainedObject:w];
	NSMutableDictionary* d = [_backingStorage objectForKey:value];
	if (!d) {
		d = [NSMutableDictionary dictionary];
		[_backingStorage setObject:d forKey:value];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillClose:) name:NSWindowWillCloseNotification object:w];
	}
	
	return d;
}

- (void) windowWillClose:(NSNotification*) n {
	NSValue* v = [NSValue valueWithNonretainedObject:[n object]];
	NSMutableDictionary* d = 
		[_backingStorage objectForKey:v];
	if (d) {
		[self.delegate storage:self willRemoveMutableDictionary:d forWindow:[n object]];
		[_backingStorage removeObjectForKey:v];
	}
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowWillCloseNotification object:[n object]];
}

- (void) removeValueForWindow:(NSWindow*) w key:(NSString*) k {
	[[self mutableDictionaryForWindow:w] removeObjectForKey:k];
	[self saveWindowIfRequired:w];
}

// Takes the current state of the storage (including persistedKeys and
// setShouldSave:...) into account.
- (BOOL) shouldSaveWindow:(NSWindow*) w category:(NSString**) cat key:(NSString**) key {
	if (!self.persistedKeys || [self.persistedKeys count] == 0) return NO;
	
	if (![[self valueForWindow:w key:kAfloatShouldSaveWindowKey] boolValue]) return NO;
	
	return [self canSaveWindow:w category:cat key:key];
}

// YES if Afloat could save the window's state (returns cat/key if YES).
// NO otherwise.
- (BOOL) canSaveWindow:(NSWindow*) w category:(NSString**) cat key:(NSString**) key {
	if ([w frameAutosaveName] && ![[w frameAutosaveName] isEqual:@""]) {
		if (cat) *cat = kAfloatNamedWindowsCategoryAutosaveKey;
		if (key) *key = [w frameAutosaveName];
		return YES;
	}
	return NO;	
}

- (void) setShouldSave:(BOOL) save forWindow:(NSWindow*) w {
	[self setValue:[NSNumber numberWithBool:save] forWindow:w key:kAfloatShouldSaveWindowKey];
	if (save)
		[self saveWindowIfRequired:w];
}

- (void) saveWindowIfRequired:(NSWindow*) w {
	NSString* cat = nil, * key = nil;
	BOOL canSave = [self shouldSaveWindow:w category:&cat key:&key];
	if (!canSave) return;
	
	cat = [NSString stringWithFormat:@"Afloat:%@:%@", cat, key];
	
	NSMutableDictionary* m = [NSMutableDictionary dictionary];
	for (NSString* persistedKey in self.persistedKeys)
		[m setObject:[self valueForWindow:w key:persistedKey] forKey:persistedKey];
	
	[[NSUserDefaults standardUserDefaults] setObject:m forKey:cat];
}

+ (void) removeSavedWindowWithCategory:(NSString*) cat identifier:(NSString*) ident {
	NSString* key = [NSString stringWithFormat:@"Afloat:%@:%@", cat, ident];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:key];	
}

@synthesize persistedKeys = _persistedKeys;

+ (id) sharedStorage {
	static id myself = nil; if (!myself) myself = [self new];
	return myself;
}

+ (NSMutableDictionary*) sharedMutableDictionaryForWindow:(NSWindow*) window {
	return [[self sharedStorage] mutableDictionaryForWindow:window];
}

+ (id) sharedValueForWindow:(NSWindow*) w key:(NSString*) k {
	return [[self sharedStorage] valueForWindow:w key:k];
}

+ (void) removeSharedValueForWindow:(NSWindow*) w key:(NSString*) k {
	[[self sharedStorage] removeValueForWindow:w key:k];
}

+ (void) setSharedValue:(id) v window:(NSWindow*) w key:(NSString*) k {
	[[self sharedStorage] setValue:v forWindow:w key:k];
}

+ (void)_withGlobalStorage:(BOOL (^)(NSMutableDictionary *storage)) block
{
    NSString *bundleIdentifier = [[NSBundle bundleForClass:self] bundleIdentifier];
    NSString *storagePath      = [[NSString stringWithFormat:@"~/Library/Preferences/%@.plist", bundleIdentifier] stringByExpandingTildeInPath];
    NSDistributedLock *lock = [NSDistributedLock lockWithPath:[storagePath stringByAppendingPathExtension:@"lockfile"]];
    
    while(![lock tryLock]) {
        usleep(100);
    }
    
    NSMutableDictionary *storage = [NSMutableDictionary dictionaryWithContentsOfFile:storagePath]
                                   ?: [NSMutableDictionary new];
    if(block(storage))
        [storage writeToFile:storagePath atomically:YES];
    
    [lock unlock];
}

+ (id) globalValueForKey:(NSString *) k {
    __block id value;
    [self _withGlobalStorage:^(NSMutableDictionary *storage) {
        value = [storage objectForKey:k];
        return NO;
    }];
    return value;
}

+ (void) setGlobalValue:(id) v forKey:(NSString *) k {
    [self _withGlobalStorage:^(NSMutableDictionary *storage) {
        if(v)
            [storage setObject:v forKey:k];
        else
            [storage removeObjectForKey:k];
        return YES;
    }];
}

@synthesize delegate = _delegate;

@end
