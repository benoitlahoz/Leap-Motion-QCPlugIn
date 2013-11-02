#import <OpenGL/CGLMacro.h>

#import "hOzLeapDevicePlugIn.h"
#import "LeapObjectiveC.h"



#define	kQCPlugIn_Name				@"h[Oz].leap Device"
#define	kQCPlugIn_Description		@"h[Oz] Leap Motion v.0.03\n\nRead the data from the connected Leap Motion device and outputs Keyed Structures organized by Hands, Pointables and Gestures.\nMin Z & Max Z let the user choose the depth and position of the interaction box, defined in width/height by the composition size.\n\nCopyright 2013 - h[Oz]\nBenoît Lahoz www.benoitlahoz.net\nfor L'ange Carasuelo | Mélange Karburant 3\nhttp://www.carasuelo.org | http://www.melangekarburant3.org\n\nCreative Commons Share Alike Attribution 3.0 (Commercial)\nhttp://www.creativecommons.org\n\nThe 0.3 version bugs correction and new outputs were commissioned by Jonathan Hammond (Just Add Music Media, www.justaddmusicmedia.com)"

@implementation hOzLeapDevicePlugIn

@dynamic inputMinZ;
@dynamic inputMaxZ;
@dynamic inputScreen;

@dynamic outputHands;
@dynamic outputFingers;
@dynamic outputFrame;
@dynamic outputConnected;
@dynamic outputGesture;
@dynamic outputScreen;

+ (NSDictionary *)attributes
{
	// Return a dictionary of attributes describing the plug-in (QCPlugInAttributeNameKey, QCPlugInAttributeDescriptionKey...).
    return @{QCPlugInAttributeNameKey:kQCPlugIn_Name, QCPlugInAttributeDescriptionKey:kQCPlugIn_Description};
}

+ (NSDictionary *)attributesForPropertyPortWithKey:(NSString *)key
{
	
    if([key isEqualToString:@"inputMinZ"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Min Z", QCPortAttributeNameKey,
                [NSNumber numberWithDouble:-1.], QCPortAttributeDefaultValueKey, nil];
    
    if([key isEqualToString:@"inputMaxZ"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Max Z", QCPortAttributeNameKey,
                [NSNumber numberWithDouble:1.], QCPortAttributeDefaultValueKey, nil];
    
    if([key isEqualToString:@"inputScreen"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Screen", QCPortAttributeNameKey, nil];
    
    if([key isEqualToString:@"outputGesture"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Gesture", QCPortAttributeNameKey, nil];
    
    if([key isEqualToString:@"outputHands"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Hands", QCPortAttributeNameKey, nil];
    
    if([key isEqualToString:@"outputFingers"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Pointables", QCPortAttributeNameKey, nil];
    
    if([key isEqualToString:@"outputFrame"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Frame", QCPortAttributeNameKey, nil];
    
    if([key isEqualToString:@"outputInteractionBox"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Interaction Box", QCPortAttributeNameKey, nil];
    
    if([key isEqualToString:@"outputConnected"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Is Connected", QCPortAttributeNameKey, nil];
    
    if([key isEqualToString:@"outputGesture"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Gesture", QCPortAttributeNameKey, nil];
    
    if([key isEqualToString:@"outputScreen"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Interaction Box", QCPortAttributeNameKey, nil];
    
    
    
	return nil;
}

+ (QCPlugInExecutionMode)executionMode
{
	// Return the execution mode of the plug-in: kQCPlugInExecutionModeProvider, kQCPlugInExecutionModeProcessor, or kQCPlugInExecutionModeConsumer.
	return kQCPlugInExecutionModeProvider;
}

+ (QCPlugInTimeMode)timeMode
{
	// Return the time dependency mode of the plug-in: kQCPlugInTimeModeNone, kQCPlugInTimeModeIdle or kQCPlugInTimeModeTimeBase.
	return kQCPlugInTimeModeTimeBase;
}

- (id)init
{
	self = [super init];
	if (self) {
		// Allocate any permanent resource required by the plug-in.
	}
	
	return self;
}


@end

@implementation hOzLeapDevicePlugIn (Execution)

- (BOOL)startExecution:(id <QCPlugInContext>)context
{
	
	
	return YES;
}

- (void)enableExecution:(id <QCPlugInContext>)context
{
	aLeapController = [[LeapController alloc] init];
    
    [aLeapController enableGesture:LEAP_GESTURE_TYPE_CIRCLE enable:YES];
    [aLeapController enableGesture:LEAP_GESTURE_TYPE_KEY_TAP enable:YES];
    [aLeapController enableGesture:LEAP_GESTURE_TYPE_SCREEN_TAP enable:YES];
    [aLeapController enableGesture:LEAP_GESTURE_TYPE_SWIPE enable:YES];
    
    gestures = [[NSMutableDictionary alloc] init];
    
    screenCoordinates = [[NSDictionary alloc] init];
    initialized = NO;
    
    depth = 0.;

}

- (BOOL)execute:(id <QCPlugInContext>)context atTime:(NSTimeInterval)time withArguments:(NSDictionary *)arguments
{
    
    self.outputConnected = [aLeapController isConnected];
    
    if ([aLeapController isConnected]) {
        NSMutableDictionary *handsOut = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *fingersOut = [[NSMutableDictionary alloc] init];
        

        frame = [aLeapController frame:0];
        
        iBox = [frame interactionBox];
        
        
        
        // ---- TODO : revoir le "didValueForInputKey"
        //      Parfois la valeur se met à jour puis surement lors d'une saute de frame, elle passe à "inf"
        //
        
        if ([self didValueForInputKeyChange:@"inputScreen"] || [self didValueForInputKeyChange:@"inputMinZ"] || [self didValueForInputKeyChange:@"inputMaxZ"] || initialized == NO) {
            if ([[aLeapController locatedScreens] count] > self.inputScreen) {
                
                if (screenCoordinates) {
                    [screenCoordinates release];
                }
                
                depth = self.inputMaxZ - self.inputMinZ;
                
                NSDictionary *bLeft = [self dictionaryWithLeapVector:[[[aLeapController locatedScreens] objectAtIndex:self.inputScreen] bottomLeftCorner] inContext:context];
                
                
                NSDictionary *screenBottomRight = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [NSNumber numberWithDouble:([[bLeft objectForKey:@"x"] doubleValue] + context.bounds.size.width)], @"x",
                                                   [bLeft objectForKey:@"y"], @"y",
                                                   [bLeft objectForKey:@"z"], @"z", nil];
                
                
                NSDictionary *screenTopLeft = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [bLeft objectForKey:@"x"], @"x",
                                               [NSNumber numberWithDouble:([[bLeft objectForKey:@"y"] doubleValue] + context.bounds.size.height)], @"y",
                                               [bLeft objectForKey:@"z"], @"z", nil];
                
                NSDictionary *screenTopRight = [NSDictionary dictionaryWithObjectsAndKeys:
                                                [NSNumber numberWithDouble:([[bLeft objectForKey:@"x"] doubleValue] + context.bounds.size.width)], @"x",
                                                [NSNumber numberWithDouble:([[bLeft objectForKey:@"y"] doubleValue] + context.bounds.size.height)], @"y",
                                                [bLeft objectForKey:@"z"], @"z", nil];
                
                
                
                NSDictionary *frontBottomLeft = [NSDictionary dictionaryWithObjectsAndKeys:
                                                 [bLeft objectForKey:@"x"], @"x",
                                                 [bLeft objectForKey:@"y"], @"y",
                                                 [NSNumber numberWithDouble:([[bLeft objectForKey:@"z"] doubleValue] + depth)], @"z", nil];
                
                NSDictionary *frontBottomRight = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  [screenBottomRight objectForKey:@"x"], @"x",
                                                  [screenBottomRight objectForKey:@"y"], @"y",
                                                  [NSNumber numberWithDouble:([[bLeft objectForKey:@"z"] doubleValue] + depth)], @"z", nil];
                
                NSDictionary *frontTopLeft = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [screenTopLeft objectForKey:@"x"], @"x",
                                              [screenTopLeft objectForKey:@"y"], @"y",
                                              [NSNumber numberWithDouble:([[bLeft objectForKey:@"z"] doubleValue] + depth)], @"z", nil];
                
                NSDictionary *frontTopRight = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [screenTopRight objectForKey:@"x"], @"x",
                                               [screenTopRight objectForKey:@"y"], @"y",
                                               [NSNumber numberWithDouble:([[bLeft objectForKey:@"z"] doubleValue] + depth)], @"z", nil];
                
                
                screenCoordinates = [NSDictionary dictionaryWithObjectsAndKeys:
                                     bLeft, @"screen_bottom_left",
                                     screenBottomRight, @"screen_bottom_right",
                                     screenTopLeft, @"screen_top_left",
                                     screenTopRight, @"screen_top_right",
                                     frontBottomLeft, @"front_bottom_left",
                                     frontBottomRight, @"front_bottom_right",
                                     frontTopLeft, @"front_top_left",
                                     frontTopRight, @"front_top_right",
                                     [NSNumber numberWithDouble:(context.bounds.size.width / ([iBox width] / 10.))], @"units_per_cm_width",
                                     [NSNumber numberWithDouble:(context.bounds.size.height / ([iBox height] / 10.))], @"units_per_cm_height",
                                     [NSNumber numberWithDouble:(depth / ([iBox depth] / 10.))], @"units_per_cm_depth",
                                     nil];
                
                // center de la iBox
                
                [screenCoordinates retain];
                
                
                initialized = YES;
                
            }
            
        }
        
        
        
        self.outputScreen = screenCoordinates;
        
        
        
        self.outputFrame = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithInteger:[frame id]], @"ID",
                            [NSNumber numberWithInteger:[frame timestamp]], @"timestamp", nil];
        
        

        
        [self performGesturesInContext:context];
        self.outputGesture = gestures;
        
        
        
        int i = 0;
        for (LeapHand *hand in [frame hands]) {
            
            if ([hand isValid]) {
                BOOL isRightMost = NO;
                BOOL isLeftMost = NO;
                BOOL isFrontMost = NO;
                
                if ([hand isEqualTo:[[frame hands] rightmost]]) {
                    isRightMost = YES;
                }
                
                if ([hand isEqualTo:[[frame hands] leftmost]]) {
                    isLeftMost = YES;
                }
                
                if ([hand isEqualTo:[[frame hands] frontmost]]) {
                    isFrontMost = YES;
                }
                
                [handsOut setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithBool:[hand isValid]], @"is_hand", 
                                     [self dictionaryWithLeapVector:[hand palmPosition] inContext:context], @"palm_position",
                                     [self dictionaryWithLeapVector:[hand stabilizedPalmPosition] inContext:context], @"stabilized_palm_position",
                                     [NSNumber numberWithDouble:[self scaleMeasure:[hand sphereRadius] inContext:context]], @"hand_sphere_radius",
                                     [self dictionaryWithLeapVector:[hand sphereCenter] inContext:context], @"hand_sphere_center",
                                     [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithDouble:[[hand palmNormal] x]], @"x",
                                      [NSNumber numberWithDouble:[[hand palmNormal] y]], @"y",
                                      [NSNumber numberWithDouble:[[hand palmNormal] z]], @"z", nil], @"hand_palm_normal",
                                     [self velocityWithLeapVector:[hand palmVelocity] inContext:context], @"hand_palm_velocity",
                                     [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithDouble:[[hand direction] x]], @"x",
                                      [NSNumber numberWithDouble:[[hand direction] y]], @"y",
                                      [NSNumber numberWithDouble:[[hand direction] z]], @"z", nil], @"hand_direction",
                                     [NSNumber numberWithDouble:[[hand direction] pitch] * LEAP_RAD_TO_DEG], @"hand_pitch",
                                     [NSNumber numberWithDouble:[[hand palmNormal] roll] * LEAP_RAD_TO_DEG], @"hand_roll",
                                     [NSNumber numberWithDouble:[[hand direction] yaw] * LEAP_RAD_TO_DEG], @"hand_yaw",
                                     [NSNumber numberWithBool:isRightMost], @"is_rightmost",
                                     [NSNumber numberWithBool:isLeftMost], @"is_leftmost",
                                     [NSNumber numberWithBool:isFrontMost], @"is_frontmost",
                                     [NSNumber numberWithInteger:[[hand pointables] count]], @"pointables_count",
                                     [self fingersInHand:hand inContext:context], @"pointables",
                                     nil]
                             forKey:[NSString stringWithFormat:@"%i", [hand id]]];
                
                
                [fingersOut setObject:[self fingersInHand:hand inContext:context] forKey:[NSString stringWithFormat:@"%i", i]];
                
            }
            
            
            
            i++;
            
            
            
        }
        
        self.outputHands = handsOut;
        self.outputFingers = fingersOut;
        
        
        [handsOut release];
        [fingersOut release];

        
        lastFrame = frame;
        
    
    }



	return YES;
}

- (void)disableExecution:(id <QCPlugInContext>)context
{
	[aLeapController release];
    [screenCoordinates release];
    [gestures release];
    frame = nil;
    iBox = nil;
    initialized = NO;
}

- (void)stopExecution:(id <QCPlugInContext>)context
{
	
}

- (double) scaleLeapValue:(double)value fromMin:(double)fromMin fromMax:(double)fromMax toMin:(double)toMin toMax:(double)toMax
{
    return (((toMax - toMin) * (value - fromMin)) / (fromMax - fromMin)) + toMin;
}

- (double) scaleMeasure:(double)leapMeasure inContext:(id <QCPlugInContext>)context
{
    double iBoxWidth = [iBox width];

    return (context.bounds.size.width * leapMeasure) / iBoxWidth;
}

- (LeapVector *) scaleLeapVector:(LeapVector *)vector inContext:(id <QCPlugInContext>)context
{
    LeapVector *normalizedPosition = [iBox normalizePoint:(const LeapVector *)vector clamp:YES];
    double z = ([normalizedPosition z] * depth) - (depth / 2.);
    z = [self scaleLeapValue:z fromMin:-depth / 2. fromMax:depth / 2. toMin:self.inputMinZ toMax:self.inputMaxZ];
    
    return [[LeapVector alloc] initWithX:([normalizedPosition x] * context.bounds.size.width) - (context.bounds.size.width / 2.)
                                       y:([normalizedPosition y] * context.bounds.size.height) - (context.bounds.size.height / 2.)
                                       z:z];
    
}

- (NSDictionary *) dictionaryWithLeapVector:(LeapVector *)leapVector inContext:(id <QCPlugInContext>)context
{
    
    LeapVector *normalizedPosition = [iBox normalizePoint:(const LeapVector *)leapVector clamp:YES];
    
    
    // ---- Old code : could be replaced by a scaleLeapValue method call
    //      TODO : check
    //
    double x = ([normalizedPosition x] * context.bounds.size.width) - (context.bounds.size.width / 2.);
    double y = ([normalizedPosition y] * context.bounds.size.height) - (context.bounds.size.height / 2.);
    double z = ([normalizedPosition z] * depth) - (depth / 2.);
    z = [self scaleLeapValue:z fromMin:-depth / 2. fromMax:depth / 2. toMin:self.inputMinZ toMax:self.inputMaxZ];
    
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithDouble:x], @"x",
            [NSNumber numberWithDouble:y], @"y",
            [NSNumber numberWithDouble:z], @"z", nil];
    
}

- (NSDictionary *) velocityWithLeapVector:(LeapVector *)leapVector inContext:(id <QCPlugInContext>)context
{
    
    double x = [self scaleLeapValue:[leapVector x] fromMin:0 fromMax:[iBox width] toMin:-1 toMax:1];
    double y = [self scaleLeapValue:[leapVector y] fromMin:0 fromMax:[iBox height] toMin:-1 toMax:1];
    double z = [self scaleLeapValue:[leapVector z] fromMin:0 fromMax:[iBox depth] toMin:-1 toMax:1];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithDouble:x], @"x",
            [NSNumber numberWithDouble:y], @"y",
            [NSNumber numberWithDouble:z], @"z", nil];
    
}








- (NSDictionary *) fingersInHand:(LeapHand *) hand inContext:(id <QCPlugInContext>)context
{
    NSMutableDictionary *fing = [[[NSMutableDictionary alloc] init] autorelease];
    
    int i = 0;
    for (LeapPointable *finger in [hand pointables]) {
        
        BOOL isRightMost = NO;
        BOOL isLeftMost = NO;
        BOOL isFrontMost = NO;
        
        
        
        
        if ((int32_t)[finger id] == (int32_t)[[[hand fingers] isRightmost] id]) {
            isRightMost = YES;
        }
        
        if ((int32_t)[finger id] == (int32_t)[[[hand fingers] isLeftmost] id]) {
            isLeftMost = YES;
        }
        
        if ((int32_t)[finger id] == (int32_t)[[[hand fingers] isFrontmost] id]) {
            isFrontMost = YES;
        }

        LeapVector *basePosition = [[[LeapVector alloc] initWithX:(-[[finger direction] x] * [finger length]) + [[finger tipPosition] x]
                                                                y:(-[[finger direction] y] * [finger length]) + [[finger tipPosition] y]
                                                                z:(-[[finger direction] z] * [finger length]) + [[finger tipPosition] z]]
                                    autorelease];

        
        
        // ---- About finger roll.
        //
        //      https://developer.leapmotion.com/forums/forums/support/topics/attitude-information-from-leap-motion-controller
        //
        //      To get the finger tip roll value, we would have to calculate the normal of the "tip plane".
        
        
        [fing setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                         [NSNumber numberWithInt:[finger id]], @"pointable_id",
                         [NSNumber numberWithBool:[finger isTool]], @"is_tool",
                         [self dictionaryWithLeapVector:[finger tipPosition] inContext:context], @"tip_position",
                         [self dictionaryWithLeapVector:[finger stabilizedTipPosition] inContext:context], @"stabilized_tip_position",
                         [self dictionaryWithLeapVector:basePosition inContext:context], @"base_position",
                         [self velocityWithLeapVector:[finger tipVelocity] inContext:context], @"tip_velocity",
                         [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithDouble:[[finger direction] x]], @"x",
                          [NSNumber numberWithDouble:[[finger direction] y]], @"y",
                          [NSNumber numberWithDouble:[[finger direction] z]], @"z", nil], @"pointable_direction",
                         [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithDouble:[[finger direction] roll] * LEAP_RAD_TO_DEG], @"roll",
                          [NSNumber numberWithDouble:[[finger direction] pitch] * LEAP_RAD_TO_DEG], @"pitch",
                          [NSNumber numberWithDouble:[[finger direction] yaw] * LEAP_RAD_TO_DEG], @"yaw", nil], @"pointable_rotation",
                         [NSNumber numberWithDouble:[self scaleMeasure:[finger length] inContext:context]], @"pointable_length",
                         [NSNumber numberWithDouble:[self scaleMeasure:[finger width] inContext:context]], @"pointable_width",
                         [NSNumber numberWithBool:isRightMost], @"is_rightmost",
                         [NSNumber numberWithBool:isLeftMost], @"is_leftmost",
                         [NSNumber numberWithBool:isFrontMost], @"is_frontmost",
                         nil]
                 forKey:[NSString stringWithFormat:@"%d", [finger id]]];
        
        
        NSDictionary *gesturesForFinger = [self gesturesForPointableAtId:(int)[finger id]];
        
        if (gesturesForFinger != nil) {
            [[fing objectForKey:[NSString stringWithFormat:@"%d", [finger id]]] setObject:gesturesForFinger forKey:@"gestures"];
        }
        
        i++;
    }
    
    return [[fing copy] autorelease];
    
}







- (void) performGesturesInContext:(id <QCPlugInContext>)context
{
    NSArray* gesturesFromLastFrame = [frame gestures:lastFrame];
    NSArray* gesturesThisFrame = [frame gestures:nil];
    
    [gestures removeAllObjects];
    
    if ([gesturesFromLastFrame count] > 0) {
        [self feedGesturesWithGesturesArray:gesturesFromLastFrame inContext:context];
    }
    
    // ---- TODO : check if this call should be in a condition too
    // 
    [self feedGesturesWithGesturesArray:gesturesThisFrame inContext:context];
}

- (void) feedGesturesWithGesturesArray:(NSArray *)gesturesArray inContext:(id <QCPlugInContext>)context
{

    
    
    for (LeapGesture *gesture in gesturesArray) {
        
        switch ((int)[gesture type]) {
            case LEAP_GESTURE_TYPE_CIRCLE: {
                
                
                if ([gesture state] != LEAP_GESTURE_STATE_INVALID) {
                    
                    LeapCircleGesture *circleGesture = (LeapCircleGesture *)gesture;
                    
                    NSNumber *clockwiseness;
                    NSNumber *progress;
                    double angle = [[[circleGesture pointable] direction] angleTo:[circleGesture normal]];
                    
                    if (angle <= LEAP_PI/2.) {
                        clockwiseness = [NSNumber numberWithBool:YES];
                        progress = [NSNumber numberWithFloat:[circleGesture progress] * 360. * -1.];
                    } else {
                        clockwiseness = [NSNumber numberWithBool:NO];
                        progress = [NSNumber numberWithFloat:[circleGesture progress] * 360.];
                    }
                    
                    
                    // Calculate the angle swept since the last frame
                    double sweptAngle = 0;
                    
                    if([circleGesture state] != LEAP_GESTURE_STATE_START) {
                        LeapCircleGesture *previousUpdate = (LeapCircleGesture *)[[aLeapController frame:1] gesture:[gesture id]];
                        
                        if ([previousUpdate type] != LEAP_GESTURE_TYPE_INVALID) {
                            sweptAngle = (circleGesture.progress - previousUpdate.progress) * 2 * LEAP_PI;
                            
                            if (angle <= LEAP_PI / 4) {
                                sweptAngle *= -1.;
                            }
                        }
                        
                    }
                    
                    NSMutableArray *pointables = [[NSMutableArray alloc] init];
                    NSMutableArray *gestHands = [[NSMutableArray alloc] init];
                    
                    for (LeapPointable *point in [gesture pointables]) {
                        [pointables addObject:[NSNumber numberWithInteger:[point id]]];
                    }
                    
                    for (LeapHand *aHand in [gesture hands]) {
                        [gestHands addObject:[NSNumber numberWithInteger:[aHand id]]];
                    }
                    
                    [gestures setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                         @"CIRCLE", @"type",
                                         [self gestureState:[gesture state]], @"state",
                                         progress, @"angle",
                                         [self dictionaryWithLeapVector:[circleGesture center] inContext:context], @"center",
                                         [NSNumber numberWithDouble:[self scaleMeasure:[circleGesture radius] inContext:context]], @"radius",
                                         [NSNumber numberWithDouble:(sweptAngle * LEAP_RAD_TO_DEG)], @"angle_since_last_frame",
                                         clockwiseness, @"clockwise",
                                         [NSNumber numberWithDouble:[circleGesture durationSeconds]], @"duration_seconds",
                                         [[pointables copy] autorelease], @"pointables_ids",
                                         [[gestHands copy] autorelease], @"hands_ids",
                                         nil]
                     
                                 forKey:[NSString stringWithFormat:@"%i", [circleGesture id]]];
                    
                    [pointables release];
                    [gestHands release];
                    
                }
                
                
                break;
            }
            case LEAP_GESTURE_TYPE_SWIPE: {
                
                if ([gesture state] != LEAP_GESTURE_STATE_INVALID) {
                    
                    LeapSwipeGesture *swipeGesture = (LeapSwipeGesture *)gesture;
                    
                    
                    
                    NSMutableArray *pointables = [[NSMutableArray alloc] init];
                    NSMutableArray *gestHands = [[NSMutableArray alloc] init];
                    
                    for (LeapPointable *point in [gesture pointables]) {
                        [pointables addObject:[NSNumber numberWithInteger:[point id]]];
                    }
                    
                    for (LeapHand *aHand in [gesture hands]) {
                        [gestHands addObject:[NSNumber numberWithInteger:[aHand id]]];
                    }
                    
                    [gestures setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                         @"SWIPE", @"type",
                                         [self gestureState:[gesture state]], @"state",
                                         [NSNumber numberWithDouble:[swipeGesture durationSeconds]], @"duration_seconds",
                                         [self dictionaryWithLeapVector:[swipeGesture startPosition] inContext:context], @"start_position",
                                         [self dictionaryWithLeapVector:[swipeGesture position] inContext:context], @"position",
                                         [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithDouble:[[swipeGesture direction] x]], @"x",
                                          [NSNumber numberWithDouble:[[swipeGesture direction] y]], @"y",
                                          [NSNumber numberWithDouble:[[swipeGesture direction] z]], @"z", nil], @"direction",
                                         [NSNumber numberWithDouble:[self scaleMeasure:[swipeGesture speed] inContext:context]], @"speed",
                                         [[pointables copy] autorelease], @"pointables_ids",
                                         [[gestHands copy] autorelease], @"hands_ids",
                                         nil]
                     
                                 forKey:[NSString stringWithFormat:@"%i", [swipeGesture id]]];
                    
                    [pointables release];
                    [gestHands release];
                    
                }
                
                break;
            }
            case LEAP_GESTURE_TYPE_KEY_TAP:
            {
                
                if ([gesture state] != LEAP_GESTURE_STATE_INVALID) {
                    
                    LeapKeyTapGesture *keyTapGesture = (LeapKeyTapGesture *)gesture;
                    
                    
                    
                    NSMutableArray *pointables = [[NSMutableArray alloc] init];
                    NSMutableArray *gestHands = [[NSMutableArray alloc] init];
                    
                    for (LeapPointable *point in [gesture pointables]) {
                        [pointables addObject:[NSNumber numberWithInt:[point id]]];
                    }
                    
                    for (LeapHand *aHand in [gesture hands]) {
                        [gestHands addObject:[NSNumber numberWithInt:[aHand id]]];
                    }
                    
                    [gestures setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                         @"KEY_TAP", @"type",
                                         [self gestureState:[gesture state]], @"state",
                                         [NSNumber numberWithDouble:[keyTapGesture durationSeconds]], @"duration_seconds",
                                         [NSNumber numberWithDouble:[keyTapGesture progress]], @"progress",
                                         [self dictionaryWithLeapVector:[keyTapGesture position] inContext:context], @"position",
                                         [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithDouble:[[keyTapGesture direction] x]], @"x",
                                          [NSNumber numberWithDouble:[[keyTapGesture direction] y]], @"y",
                                          [NSNumber numberWithDouble:[[keyTapGesture direction] z]], @"z", nil], @"direction",
                                         [[pointables copy] autorelease], @"pointables_ids",
                                         [[gestHands copy] autorelease], @"hands_ids",
                                         nil]
                     
                                 forKey:[NSString stringWithFormat:@"%i", [keyTapGesture id]]];
                    
                    [pointables release];
                    [gestHands release];
                    
                }
                break;
            }
            case LEAP_GESTURE_TYPE_SCREEN_TAP:
            {
                
                if ([gesture state] != LEAP_GESTURE_STATE_INVALID) {
                    
                    LeapScreenTapGesture *screenTapGesture = (LeapScreenTapGesture *)gesture;
                    
                    
                    
                    NSMutableArray *pointables = [[NSMutableArray alloc] init];
                    NSMutableArray *gestHands = [[NSMutableArray alloc] init];
                    
                    for (LeapPointable *point in [gesture pointables]) {
                        [pointables addObject:[NSNumber numberWithInteger:[point id]]];
                    }
                    
                    for (LeapHand *aHand in [gesture hands]) {
                        [gestHands addObject:[NSNumber numberWithInteger:[aHand id]]];
                    }
                    
                    [gestures setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                         @"SCREEN_TAP", @"type",
                                         [self gestureState:[gesture state]], @"state",
                                         [NSNumber numberWithDouble:[screenTapGesture durationSeconds]], @"duration_seconds",
                                         [NSNumber numberWithDouble:[screenTapGesture progress]], @"progress",
                                         [self dictionaryWithLeapVector:[screenTapGesture position] inContext:context], @"position",
                                         [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithDouble:[[screenTapGesture direction] x]], @"x",
                                          [NSNumber numberWithDouble:[[screenTapGesture direction] y]], @"y",
                                          [NSNumber numberWithDouble:[[screenTapGesture direction] z]], @"z", nil], @"direction",
                                         [[pointables copy] autorelease], @"pointables_ids",
                                         [[gestHands copy] autorelease], @"hands_ids",
                                         nil]
                     
                                 forKey:[NSString stringWithFormat:@"%i", [screenTapGesture id]]];
                    
                    [pointables release];
                    [gestHands release];
                    
                }
                break;
            }
            default:
                NSLog(@"Unknown gesture type");
                break;
        }
        
        
    }

}

- (NSDictionary *) gesturesForPointableAtId:(int)thePointableID
{
    NSMutableDictionary *gestInPointable = [[[NSMutableDictionary alloc] init] autorelease];
    
   
    
    for (id key in gestures) {

        for (NSNumber *pointableID in [[gestures objectForKey:key] objectForKey:@"pointables_ids"]) {
            
            if (thePointableID == [pointableID intValue]) {
                
                [gestInPointable setObject:[gestures objectForKey:key] forKey:[pointableID stringValue]];
                
            }
            
        }
        
    }

    
    
    if ([[gestInPointable allKeys] count]  > 0) {
        return  [[gestInPointable copy] autorelease];
    }
    
    return nil;
    
}

- (NSString *) gestureState:(int)state
{
    switch (state) {
        case LEAP_GESTURE_STATE_INVALID:
            return @"STATE_INVALID";
        case LEAP_GESTURE_STATE_START:
            return @"STATE_START";
        case LEAP_GESTURE_STATE_UPDATE:
            return @"STATE_UPDATED";
        case LEAP_GESTURE_STATE_STOP:
            return @"STATE_STOP";
        default:
            return @"STATE_INVALID";
    }
}

@end
