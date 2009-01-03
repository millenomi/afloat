#import <Carbon/Carbon.h>

#define kAfloatNagPreferencesIdentifier (CFSTR("net.infinite-labs.Afloat.Donations"))
#define kAfloatDidEndAlertsKey (CFSTR("AfloatDidEndAlerts"))
#define kAfloatFirstAlertShownKey (CFSTR("AfloatFirstAlertShown"))
#define kAfloatInstallationDateKey (CFSTR("AfloatInstallationDate"))

#define kAfloatOneDay (24 * 60 * 60)

enum {
	kAfloatDoNotShowAlerts = 0,
	kAfloatShouldShowFirstAlert = 1,
	kAfloatShouldShowLastAlert = 2
};
typedef NSInteger AfloatNagAction;

static id AfloatNagGetPreferenceForKey(CFStringRef key, Class cl) {
	id obj = (id) CFPreferencesCopyAppValue(key, kAfloatNagPreferencesIdentifier);
	if (cl && obj && ![obj isKindOfClass:cl]) {
		[obj release];
		obj = nil;
	}
	
	return [obj autorelease];
}

static BOOL AfloatNagGetBooleanForKey(CFStringRef key) {
	id obj = AfloatNagGetPreferenceForKey(key, nil);
	return obj && [obj respondsToSelector:@selector(boolValue)] && [obj boolValue];
}

static void AfloatNagSetPreferenceForKey(CFStringRef key, id obj) {
	CFPreferencesSetAppValue(key, (CFPropertyListRef) obj, kAfloatNagPreferencesIdentifier);
	CFPreferencesAppSynchronize(kAfloatNagPreferencesIdentifier);
}

static AfloatNagAction AfloatNagCurrentAction() {
	if (AfloatNagGetBooleanForKey(kAfloatDidEndAlertsKey))
		return kAfloatDoNotShowAlerts;
	
	NSDate* date = AfloatNagGetPreferenceForKey(kAfloatInstallationDateKey, [NSDate class]);
	if (!date)
		return kAfloatDoNotShowAlerts;
	
	NSTimeInterval i = -[date timeIntervalSinceNow];
	
	if (i < kAfloatOneDay)
		return kAfloatDoNotShowAlerts;
	else if (i < 8* kAfloatOneDay)
		return AfloatNagGetBooleanForKey(kAfloatFirstAlertShownKey)? kAfloatDoNotShowAlerts : kAfloatShouldShowFirstAlert;
	else
		return kAfloatShouldShowLastAlert;
}
