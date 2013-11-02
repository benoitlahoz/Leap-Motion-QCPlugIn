#import <OpenGL/CGLMacro.h>

#import "hOzLeap3DTransformationPlugIn.h"

#define	kQCPlugIn_Name				@"h[Oz].leap 3D Transformation"
#define	kQCPlugIn_Description		@"h[Oz] Leap Motion v.0.03\n\nWorks like the usual 3D Transformation patch : Translates, Scales and Rotates the Hand and Pointables of a Hands input.\nOutputs the same dictionary as the Hands one but transformed.\n\nCopyright 2013 - h[Oz]\nBenoît Lahoz www.benoitlahoz.net\nfor L'ange Carasuelo | Mélange Karburant 3\nhttp://www.carasuelo.org | http://www.melangekarburant3.org\n\nCreative Commons Share Alike Attribution 3.0 (Commercial)\nhttp://www.creativecommons.org\n\nThis patch was specifically commissioned by Jonathan Hammond (Just Add Music Media, www.justaddmusicmedia.com)"

@implementation hOzLeap3DTransformationPlugIn

@dynamic inputHands;
@dynamic inputOriginX;
@dynamic inputOriginY;
@dynamic inputOriginZ;
@dynamic inputTranslationX;
@dynamic inputTranslationY;
@dynamic inputTranslationZ;
@dynamic inputRotationX;
@dynamic inputRotationY;
@dynamic inputRotationZ;
@dynamic inputScaleX;
@dynamic inputScaleY;
@dynamic inputScaleZ;

@dynamic outputHands;


+ (NSDictionary *)attributes
{
    return @{QCPlugInAttributeNameKey:kQCPlugIn_Name, QCPlugInAttributeDescriptionKey:kQCPlugIn_Description};
}

+ (NSDictionary *)attributesForPropertyPortWithKey:(NSString *)key
{
	
    if([key isEqualToString:@"inputHands"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Hands", QCPortAttributeNameKey, nil];
    
    if([key isEqualToString:@"inputOriginX"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Origin X", QCPortAttributeNameKey,
                [NSNumber numberWithDouble:0.], QCPortAttributeDefaultValueKey, nil];
    
    if([key isEqualToString:@"inputOriginY"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Origin Y", QCPortAttributeNameKey,
                [NSNumber numberWithDouble:0.], QCPortAttributeDefaultValueKey, nil];
    
    if([key isEqualToString:@"inputOriginZ"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Origin Z", QCPortAttributeNameKey,
                [NSNumber numberWithDouble:0.], QCPortAttributeDefaultValueKey, nil];
    
    
    if([key isEqualToString:@"inputTranslationX"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Translation X", QCPortAttributeNameKey,
                [NSNumber numberWithDouble:0.], QCPortAttributeDefaultValueKey, nil];
    
    if([key isEqualToString:@"inputTranslationY"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Translation Y", QCPortAttributeNameKey,
                [NSNumber numberWithDouble:0.], QCPortAttributeDefaultValueKey, nil];
    
    if([key isEqualToString:@"inputTranslationZ"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Translation Z", QCPortAttributeNameKey,
                [NSNumber numberWithDouble:0.], QCPortAttributeDefaultValueKey, nil];
    
    if([key isEqualToString:@"inputRotationX"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Rotation X", QCPortAttributeNameKey,
                [NSNumber numberWithDouble:0.], QCPortAttributeDefaultValueKey, nil];
    
    if([key isEqualToString:@"inputRotationY"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Rotation Y", QCPortAttributeNameKey,
                [NSNumber numberWithDouble:0.], QCPortAttributeDefaultValueKey, nil];
    
    if([key isEqualToString:@"inputRotationZ"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Rotation Z", QCPortAttributeNameKey,
                [NSNumber numberWithDouble:0.], QCPortAttributeDefaultValueKey, nil];
    
    if([key isEqualToString:@"inputScaleX"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Scale X", QCPortAttributeNameKey,
                [NSNumber numberWithDouble:1.], QCPortAttributeDefaultValueKey, nil];
    
    if([key isEqualToString:@"inputScaleY"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Scale Y", QCPortAttributeNameKey,
                [NSNumber numberWithDouble:1.], QCPortAttributeDefaultValueKey, nil];
    
    if([key isEqualToString:@"inputScaleZ"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Scale Z", QCPortAttributeNameKey,
                [NSNumber numberWithDouble:1.], QCPortAttributeDefaultValueKey, nil];
    
    
    
    if([key isEqualToString:@"outputHands"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Hands", QCPortAttributeNameKey, nil];
    
    
    
    
	return nil;
}

+ (QCPlugInExecutionMode)executionMode
{
	// Return the execution mode of the plug-in: kQCPlugInExecutionModeProvider, kQCPlugInExecutionModeProcessor, or kQCPlugInExecutionModeConsumer.
	return kQCPlugInExecutionModeProcessor;
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

@implementation hOzLeap3DTransformationPlugIn (Execution)

- (BOOL)startExecution:(id <QCPlugInContext>)context
{
	
	
	return YES;
}

- (void)enableExecution:(id <QCPlugInContext>)context
{

}

- (BOOL)execute:(id <QCPlugInContext>)context atTime:(NSTimeInterval)time withArguments:(NSDictionary *)arguments
{
    
    if (self.inputHands != nil) {
        
        NSMutableDictionary *handsOut = [self.inputHands mutableCopy];
        
        
        // ---- For each hand
        //
        for (id keyHand in self.inputHands) {
            
            NSMutableDictionary *hand = [[self.inputHands objectForKey:keyHand] mutableCopy];
            
            // ---- Palm position
            //
            NSDictionary *palmPositionDefinition = [hand objectForKey:@"palm_position"];
            LeapVector *palmPosition = [[LeapVector alloc] initWithX:[[palmPositionDefinition objectForKey:@"x"] doubleValue]
                                                                   y:[[palmPositionDefinition objectForKey:@"y"] doubleValue]
                                                                   z:[[palmPositionDefinition objectForKey:@"z"] doubleValue]];
            
            palmPosition = [self scaleVector:palmPosition];
            palmPosition = [self rotateVector:palmPosition];
            palmPosition = [self translateVector:palmPosition];
            
            [hand setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithDouble:[palmPosition x]], @"x",
                             [NSNumber numberWithDouble:[palmPosition y]], @"y",
                             [NSNumber numberWithDouble:[palmPosition z]], @"z", nil]
                     forKey:@"palm_position"];
            
            
            
            
            
            
            // ---- Stabilized Palm Position
            //
            NSDictionary *stabilizedPalmPositionDefinition = [hand objectForKey:@"stabilized_palm_position"];
            LeapVector *stabilizedPalmPosition = [[LeapVector alloc] initWithX:[[stabilizedPalmPositionDefinition objectForKey:@"x"] doubleValue]
                                                                             y:[[stabilizedPalmPositionDefinition objectForKey:@"y"] doubleValue]
                                                                             z:[[stabilizedPalmPositionDefinition objectForKey:@"z"] doubleValue]];
            
            stabilizedPalmPosition = [self scaleVector:stabilizedPalmPosition];
            stabilizedPalmPosition = [self rotateVector:stabilizedPalmPosition];
            stabilizedPalmPosition = [self translateVector:stabilizedPalmPosition];
            
            [hand setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithDouble:[stabilizedPalmPosition x]], @"x",
                             [NSNumber numberWithDouble:[stabilizedPalmPosition y]], @"y",
                             [NSNumber numberWithDouble:[stabilizedPalmPosition z]], @"z", nil]
                     forKey:@"stabilized_palm_position"];
            
            
            // ---- Hand Direction | Hand Normal
            //
            //      TODO
            
            
            
            NSMutableDictionary *pointables = [[[NSMutableDictionary alloc] init] autorelease];
            
            
            // ---- For each pointable
            //
            for (id keyPointable in [hand objectForKey:@"pointables"]) {
                
                
                NSMutableDictionary *pointable = [[[hand objectForKey:@"pointables"] objectForKey:keyPointable] mutableCopy];
                
                
                // ---- Tip position
                //
                NSDictionary *tipPositionDefinition = [pointable objectForKey:@"tip_position"];
                
                LeapVector *tipPosition = [[LeapVector alloc] initWithX:[[tipPositionDefinition objectForKey:@"x"] doubleValue]
                                                                      y:[[tipPositionDefinition objectForKey:@"y"] doubleValue]
                                                                      z:[[tipPositionDefinition objectForKey:@"z"] doubleValue]];
                
                tipPosition = [self scaleVector:tipPosition];
                tipPosition = [self rotateVector:tipPosition];
                tipPosition = [self translateVector:tipPosition];
                
                [pointable
                 
                 setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithDouble:[tipPosition x]], @"x",
                            [NSNumber numberWithDouble:[tipPosition y]], @"y",
                            [NSNumber numberWithDouble:[tipPosition z]], @"z", nil]
                 
                 forKey:@"tip_position"];
                
                
                
                
                
                
                // ---- Stabilized Tip Position
                //
                NSDictionary *stabilizedTipPositionDefinition = [pointable objectForKey:@"stabilized_tip_position"];
                
                LeapVector *stabilizedTipPosition = [[LeapVector alloc] initWithX:[[stabilizedTipPositionDefinition objectForKey:@"x"] doubleValue]
                                                                                y:[[stabilizedTipPositionDefinition objectForKey:@"y"] doubleValue]
                                                                                z:[[stabilizedTipPositionDefinition objectForKey:@"z"] doubleValue]];
                
                stabilizedTipPosition = [self scaleVector:stabilizedTipPosition];
                stabilizedTipPosition = [self rotateVector:stabilizedTipPosition];
                stabilizedTipPosition = [self translateVector:stabilizedTipPosition];
                
                [pointable
                 
                 setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithDouble:[stabilizedTipPosition x]], @"x",
                            [NSNumber numberWithDouble:[stabilizedTipPosition y]], @"y",
                            [NSNumber numberWithDouble:[stabilizedTipPosition z]], @"z", nil]
                 
                 forKey:@"stabilized_tip_position"];
                
                
                
                
                
                
                
                // ---- Base Tip Position
                //
                NSDictionary *basePositionDefinition = [pointable objectForKey:@"base_position"];
                
                LeapVector *basePosition = [[LeapVector alloc] initWithX:[[basePositionDefinition objectForKey:@"x"] doubleValue]
                                                                       y:[[basePositionDefinition objectForKey:@"y"] doubleValue]
                                                                       z:[[basePositionDefinition objectForKey:@"z"] doubleValue]];
                
                basePosition = [self scaleVector:basePosition];
                basePosition = [self rotateVector:basePosition];
                basePosition = [self translateVector:basePosition];
                
                [pointable
                 
                 setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithDouble:[basePosition x]], @"x",
                            [NSNumber numberWithDouble:[basePosition y]], @"y",
                            [NSNumber numberWithDouble:[basePosition z]], @"z", nil]
                 
                 forKey:@"base_position"];
                
                
                
                

                
                
                // ---- Pointable Direction
                //
                //      TODO
                
                
                [pointables setObject:pointable forKey:keyPointable];
                
                
            }
            
            
            [hand setObject:pointables forKey:@"pointables"];
            [handsOut setObject:hand forKey:keyHand];
            
            
            
        }
        
        
        
        self.outputHands = handsOut;
        
        
        [handsOut release]; // ???
        
        
        
    }


	return YES;
}

- (void)disableExecution:(id <QCPlugInContext>)context
{

}

- (void)stopExecution:(id <QCPlugInContext>)context
{
	
}



- (LeapVector *) translateVector:(LeapVector *)leapVector
{
    return [[LeapVector alloc] initWithX:[leapVector x] + self.inputTranslationX
                                       y:[leapVector y] + self.inputTranslationY
                                       z:[leapVector z] + self.inputTranslationZ];
}


- (LeapVector *) scaleVector:(LeapVector *)leapVector
{
    // ---- If scale == 1, we don't perform the scale operation
    //
    if (self.inputScaleX != 1. ||
        self.inputScaleY != 1. ||
        self.inputScaleZ != 1.) {
        return [[LeapVector alloc] initWithX:[leapVector x] * self.inputScaleX
                                           y:[leapVector y] * self.inputScaleY
                                           z:[leapVector z] * self.inputScaleZ];
    }
    
    return leapVector;
    
}


- (LeapVector *) rotateVector:(LeapVector *)leapVector
{
    
    // ---- We use 3 transformations, one for each Euler Angle
    //
    LeapVector *rotX = [self rotateVectorOnX:leapVector];
    LeapVector *rotY = [self rotateVectorOnY:rotX];
    LeapVector *rotZ = [self rotateVectorOnZ:rotY];
    
    return rotZ;
}


- (LeapVector *) rotateVectorOnX:(LeapVector *)leapVector
{

    if (self.inputRotationX > TINY_ZERO || self.inputRotationX < -TINY_ZERO) {
        
        double angle = self.inputRotationX * LEAP_DEG_TO_RAD;
        
        LeapMatrix *matrix = [[LeapMatrix alloc] initWithXBasis:[[LeapVector alloc] initWithX:1.
                                                                                            y:0.
                                                                                            z:0.]
                                                         yBasis:[[LeapVector alloc] initWithX:0.
                                                                                            y:cos(angle)
                                                                                            z:sin(angle)]
                                                         zBasis:[[LeapVector alloc] initWithX:0.
                                                                                            y:-sin(angle)
                                                                                            z:cos(angle)]
                                                         origin:[[LeapVector alloc] initWithX:self.inputOriginX
                                                                                            y:self.inputOriginY
                                                                                            z:self.inputOriginZ]];
        
        
        return [matrix transformPoint:leapVector];
        
    }
    
    return leapVector;
    
}

- (LeapVector *) rotateVectorOnY:(LeapVector *)leapVector
{
    
    if (self.inputRotationY > TINY_ZERO || self.inputRotationY < -TINY_ZERO) {
        
        double angle = self.inputRotationY * LEAP_DEG_TO_RAD;
        
        LeapMatrix *matrix = [[LeapMatrix alloc] initWithXBasis:[[LeapVector alloc] initWithX:cos(angle)
                                                                                            y:0.
                                                                                            z:-sin(angle)]
                                                         yBasis:[[LeapVector alloc] initWithX:0.
                                                                                            y:1.
                                                                                            z:0.]
                                                         zBasis:[[LeapVector alloc] initWithX:sin(angle)
                                                                                            y:-0.
                                                                                            z:cos(angle)]
                                                         origin:[[LeapVector alloc] initWithX:self.inputOriginX
                                                                                            y:self.inputOriginY
                                                                                            z:self.inputOriginZ]];
        
        
        return [matrix transformPoint:leapVector];
    }

    return leapVector;
    
}

- (LeapVector *) rotateVectorOnZ:(LeapVector *)leapVector
{
    
    if (self.inputRotationZ > TINY_ZERO || self.inputRotationZ < -TINY_ZERO) {
        
        double angle = self.inputRotationZ * LEAP_DEG_TO_RAD;
        
        
        LeapMatrix *matrix = [[LeapMatrix alloc] initWithXBasis:[[LeapVector alloc] initWithX:cos(angle)
                                                                                            y:sin(angle)
                                                                                            z:0.]
                                                         yBasis:[[LeapVector alloc] initWithX:sin(angle)
                                                                                            y:cos(angle)
                                                                                            z:0.]
                                                         zBasis:[[LeapVector alloc] initWithX:0.
                                                                                            y:0.
                                                                                            z:1.]
                                                         origin:[[LeapVector alloc] initWithX:self.inputOriginX
                                                                                            y:self.inputOriginY
                                                                                            z:self.inputOriginZ]];
        
        
        return [matrix transformPoint:leapVector];
    }

    return leapVector;
    
}


@end
