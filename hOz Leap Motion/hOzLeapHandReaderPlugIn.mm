//
//  h_Oz__Leap_MotionPlugIn.m
//  h[Oz] Leap Motion
//
//  Created by Benoît LAHOZ on 24/07/13.
//  Copyright (c) 2013 h[Oz]. All rights reserved.
//

// It's highly recommended to use CGL macros instead of changing the current context for plug-ins that perform OpenGL rendering
#import <OpenGL/CGLMacro.h>

#import "hOzLeapHandReaderPlugIn.h"


#define	kQCPlugIn_Name				@"h[Oz].leap Hand Reader"
#define	kQCPlugIn_Description		@"h[Oz] Leap Motion v.0.03\n\nA \"helper\" patch that organize the data from a Hands Device-Plug-In output, avoiding the use of a lot of structures reader.\n\nCopyright 2013 - h[Oz]\nBenoît Lahoz www.benoitlahoz.net\nfor L'ange Carasuelo | Mélange Karburant 3\nhttp://www.carasuelo.org | http://www.melangekarburant3.org\n\nCreative Commons Share Alike Attribution 3.0 (Commercial)\nhttp://www.creativecommons.org\n\nThe 0.3 version bugs correction and new outputs were commissioned by Jonathan Hammond (Just Add Music Media, www.justaddmusicmedia.com)"

@implementation hOzLeapHandReaderPlugIn

@dynamic inputHands;
@dynamic inputHandIndex;

@dynamic outputIsHand;

@dynamic outputPalmPos;
@dynamic outputStabilizedPalmPos;

@dynamic outputHandPitch;
@dynamic outputHandRoll;
@dynamic outputHandYaw;

@dynamic outputHandPalmVelocity;

@dynamic outputHandDir;

@dynamic outputHandPalmNormal;

@dynamic outputHandSphereCenter;

@dynamic outputHandSphereRadius;

@dynamic outputIsFrontMost;
@dynamic outputIsRightMost;
@dynamic outputIsLeftMost;

@dynamic outputFingers;

/* ---- TODO
 
@dynamic outputAvgFingX;
@dynamic outputAvgFingY;
@dynamic outputAvgFingZ;
*/

+ (NSDictionary *)attributes
{
	// Return a dictionary of attributes describing the plug-in (QCPlugInAttributeNameKey, QCPlugInAttributeDescriptionKey...).
    return @{QCPlugInAttributeNameKey:kQCPlugIn_Name, QCPlugInAttributeDescriptionKey:kQCPlugIn_Description};
}

+ (NSDictionary *)attributesForPropertyPortWithKey:(NSString *)key
{
	
    if([key isEqualToString:@"inputHands"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Hands", QCPortAttributeNameKey, nil];
    
    if([key isEqualToString:@"inputHandIndex"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Hand Index", QCPortAttributeNameKey,
                [NSNumber numberWithInteger:0], QCPortAttributeMinimumValueKey, nil];
    
    if([key isEqualToString:@"outputIsHand"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Is Hand", QCPortAttributeNameKey, nil];
    
    if([key isEqualToString:@"outputPalmPos"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Palm Position", QCPortAttributeNameKey, nil];
    
    if([key isEqualToString:@"outputStabilizedPalmPos"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Stabilized Palm Position", QCPortAttributeNameKey, nil];

    if([key isEqualToString:@"outputHandPitch"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Pitch", QCPortAttributeNameKey, nil];
    
    if([key isEqualToString:@"outputHandRoll"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Roll", QCPortAttributeNameKey, nil];
    
    if([key isEqualToString:@"outputHandYaw"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Yaw", QCPortAttributeNameKey, nil];
    
    if([key isEqualToString:@"outputHandPalmVelocity"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Velocity", QCPortAttributeNameKey, nil];
    
    if([key isEqualToString:@"outputHandDir"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Direction", QCPortAttributeNameKey, nil];
    
    if([key isEqualToString:@"outputHandPalmNormal"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Normal", QCPortAttributeNameKey, nil];
    
    if([key isEqualToString:@"outputHandSphereCenter"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Sphere Center", QCPortAttributeNameKey, nil];
    
    if([key isEqualToString:@"outputHandSphereRadius"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Sphere Radius", QCPortAttributeNameKey, nil];
    
    if([key isEqualToString:@"outputIsRightMost"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Rightmost", QCPortAttributeNameKey, nil];
    
    if([key isEqualToString:@"outputIsLeftMost"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Leftmost", QCPortAttributeNameKey, nil];
    
    if([key isEqualToString:@"outputIsFrontMost"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Frontmost", QCPortAttributeNameKey, nil];
    
    if([key isEqualToString:@"outputFingers"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Pointables", QCPortAttributeNameKey, nil];
    
    
    
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
	return kQCPlugInTimeModeNone;
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

@implementation hOzLeapHandReaderPlugIn (Execution)

- (BOOL)startExecution:(id <QCPlugInContext>)context
{
	
	
	return YES;
}

- (void)enableExecution:(id <QCPlugInContext>)context
{

}

- (BOOL)execute:(id <QCPlugInContext>)context atTime:(NSTimeInterval)time withArguments:(NSDictionary *)arguments
{
    
    
    if ([self.inputHands count] > self.inputHandIndex) {

        
        NSDictionary *hand = [self.inputHands objectForKey:[[self.inputHands allKeys] objectAtIndex:self.inputHandIndex]];
        
        self.outputIsHand = [[hand objectForKey:@"is_hand"] boolValue];
        
        self.outputIsRightMost = [[hand objectForKey:@"is_rightmost"] boolValue];
        self.outputIsLeftMost = [[hand objectForKey:@"is_leftmost"] boolValue];
        self.outputIsFrontMost = [[hand objectForKey:@"is_frontmost"] boolValue];
        
        self.outputPalmPos = [hand objectForKey:@"palm_position"];
        self.outputStabilizedPalmPos = [hand objectForKey:@"stabilized_palm_position"];
        self.outputHandPalmVelocity = [hand objectForKey:@"hand_palm_velocity"];
        
        self.outputHandPitch = [[hand objectForKey:@"hand_pitch"] doubleValue];
        self.outputHandRoll = [[hand objectForKey:@"hand_roll"] doubleValue];
        self.outputHandYaw = [[hand objectForKey:@"hand_yaw"] doubleValue];
        
        self.outputHandDir = [hand objectForKey:@"hand_direction"];
        
        self.outputHandPalmNormal = [hand objectForKey:@"hand_palm_normal"];
        
        self.outputHandSphereCenter = [hand objectForKey:@"hand_sphere_center"];
        
        self.outputHandSphereRadius = [[hand objectForKey:@"hand_sphere_radius"] doubleValue];
        
        self.outputFingers = [hand objectForKey:@"pointables"];
        
    }

    
	return YES;
}

- (void)disableExecution:(id <QCPlugInContext>)context
{

}

- (void)stopExecution:(id <QCPlugInContext>)context
{
	
}

@end
