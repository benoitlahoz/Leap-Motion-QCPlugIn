/**
 *
 *  h[Oz] helpers
 *
 *
 */

#import "LeapObjectiveC.h"






/**
 *  Override the usual LeapObjectiveC methods that use isKindOfClass to recognize
 *  LeapHand and LeapPointable, so we can use different plugins using the Leap library in the same
 *  Quartz Composer install.
 *
 *  NB : the same version of the library must be used.
 *
 */

@interface NSArray (hOzRelativePosition)

- (id)isLeftmost;
- (id)isRightmost;
- (id)isFrontmost;

@end