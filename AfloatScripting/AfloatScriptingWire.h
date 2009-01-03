
#define kAfloatScriptWireObject @"net.infinite-labs.Afloat.Scripting"

// Toggles the "kept afloat" flag for the topmost window.
// userInfo:
// @"showsBadgeAnimation" -- if NO suppresses badge animation; otherwise or YES shows the badge animation.
#define kAfloatScriptToggleKeptAfloatNotification @"net.infinite-labs.Afloat.Scripting.ToggleKeptAfloat"

// Sets the "kept afloat" flag for a window.
// userInfo:
// @"showsBadgeAnimation" -- if NO suppresses badge animation; otherwise or YES shows the badge animation.
// @"keptAfloat" -- YES to keep a window afloat, NO to return it to normal.
// NOTE: keptAfloat = NO may return a pinned-to-desktop window to normal.
#define kAfloatScriptSetKeptAfloatNotification @"net.infinite-labs.Afloat.Scripting.SetKeptAfloat"

// Sets the alpha value for a window.
// userInfo:
// @"alphaValue" -- Real 0.0 to 1.0. It will be clamped to the built-in default range (which may be smaller). 0.0 means fully transparent, 1.0 fully opaque.
#define kAfloatScriptSetAlphaValueNotification @"net.infinite-labs.Afloat.Scripting.SetAlphaValue"

// Sets the "to be kept on the screen on all Spaces" flag for the topmost window.
// userInfo:
// @"keptOnAllSpaces" -- YES to keep on all Spaces, NO to return to normal.
#define kAfloatScriptSetKeptOnAllSpacesNotification @"net.infinite-labs.Afloat.Scripting.SetKeptOnAllSpaces"

// Sets the "pinned to desktop" flag for a window.
// userInfo:
// @"showsBadgeAnimation" -- YES to show a badge animation, NO otherwise.
// @"pinnedToDesktop" -- YES to keep a window pinned, NO to return it to normal.
// NOTE: pinnedToDesktop = NO may return an afloat window to normal.
#define kAfloatScriptSetPinnedToDesktopNotification @"net.infinite-labs.Afloat.Scripting.SetKeptPinnedToDesktop"

// Sets the "overlay" flag for a window.
// userInfo:
// @"showsBadgeAnimation" -- YES to show a badge animation, NO otherwise.
// @"overlay" -- YES to make the window an overlay, NO to return it to normal.
// NOTE: same behavior as the overlay checkbox in Adjust Effects. (Long to describe here.)
#define kAfloatScriptSetOverlayNotification @"net.infinite-labs.Afloat.Scripting.SetOverlay"

// Disables all overlays in the topmost app.
#define kAfloatScriptDisableAllOverlaysNotification @"net.infinite-labs.Afloat.Scripting.DisableAllOverlays"

// Makes one step more transparent.
#define kAfloatScriptMoreTransparentNotification @"net.infinite-labs.Afloat.Scripting.MoreTransparent"

// Makes one step less transparent.
#define kAfloatScriptLessTransparentNotification @"net.infinite-labs.Afloat.Scripting.LessTransparent"

// Shows the topmost window's file in the Finder, if any.
#define kAfloatScriptShowWindowFileInFinderNotification @"net.infinite-labs.Afloat.Scripting.ShowWindowFileInFinder"
