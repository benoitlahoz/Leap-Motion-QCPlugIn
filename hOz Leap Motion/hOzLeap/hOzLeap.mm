
#import "hOzLeap.h"


@implementation NSArray (hOzRelativePosition)

- (id)isLeftmost
{
    if ([self count] == 0) {
        return nil;
    }
    float minX = FLT_MAX;
    NSUInteger minPosition = NSUIntegerMax;
    for (NSUInteger i = 0; i < [self count]; i++) {
        id obj = [self objectAtIndex:i];
        
        /**
         * palmPosition = hand
         * tipPosition = pointable
         */
        
        float x = (([obj respondsToSelector:@selector(palmPosition)] == YES) ? [[obj palmPosition] x] : [[obj tipPosition ] x]);
        if (x < minX) {
            minPosition = i;
            minX = x;
        }
    }
    return [self objectAtIndex:minPosition];
}

- (id)isRightmost
{
    if ([self count] == 0) {
        return nil;
    }
    float maxX = -FLT_MAX;
    NSUInteger maxPosition = NSUIntegerMax;
    for (NSUInteger i = 0; i < [self count]; i++) {
        id obj = [self objectAtIndex:i];
        float x = (([obj respondsToSelector:@selector(palmPosition)] == YES) ? [[obj palmPosition] x] : [[obj tipPosition ] x]);
        if (x > maxX) {
            maxPosition = i;
            maxX = x;
        }
    }
    return [self objectAtIndex:maxPosition];
}

- (id)isFrontmost
{
    if ([self count] == 0) {
        return nil;
    }
    float minZ = FLT_MAX;
    NSUInteger minPosition = NSUIntegerMax;
    for (NSUInteger i = 0; i < [self count]; i++) {
        id obj = [self objectAtIndex:i];
        float z = (([obj respondsToSelector:@selector(palmPosition)] == YES) ? [[obj palmPosition] z] : [[obj tipPosition ] z]);
        if (z < minZ) {
            minPosition = i;
            minZ = z;
        }
    }
    return [self objectAtIndex:minPosition];
}

@end
