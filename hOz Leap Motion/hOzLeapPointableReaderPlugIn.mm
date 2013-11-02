
#import <OpenGL/CGLMacro.h>

#import "hOzLeapPointableReaderPlugIn.h"


#define	kQCPlugIn_Name				@"h[Oz].leap Pointable Reader"
#define	kQCPlugIn_Description		@"h[Oz] Leap Motion v.0.03\n\nA \"helper\" patch that organize the data from the Pointables output of the Device or the Hand Reader plug-ins, avoiding the use of a lot of structures reader.\nThe user may have a look at the Settings Panel and choose if they want to read One Pointable (defined by an index input) or all the Pointables. If all, the Pointables are mapped to a unique port, so they can, eg., use a Queue Structure patch to draw with their fingers.\n\nCopyright 2013 - h[Oz]\nBenoît Lahoz www.benoitlahoz.net\nfor L'ange Carasuelo | Mélange Karburant 3\nhttp://www.carasuelo.org | http://www.melangekarburant3.org\n\nCreative Commons Share Alike Attribution 3.0 (Commercial)\nhttp://www.creativecommons.org\n\nThe 0.3 version bugs correction and new outputs were commissioned by Jonathan Hammond (Just Add Music Media, www.justaddmusicmedia.com)"

@implementation hOzLeapPointableReaderPlugIn

// @dynamic inputFingers;
// @dynamic inputHandIndex;

+ (NSDictionary *)attributes
{
	// Return a dictionary of attributes describing the plug-in (QCPlugInAttributeNameKey, QCPlugInAttributeDescriptionKey...).
    return @{QCPlugInAttributeNameKey:kQCPlugIn_Name, QCPlugInAttributeDescriptionKey:kQCPlugIn_Description};
}

+ (NSDictionary *)attributesForPropertyPortWithKey:(NSString *)key
{
	
    if([key isEqualToString:@"inputFingers"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Fingers", QCPortAttributeNameKey, nil];

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




- (void) setOneHand:(BOOL)oneH
{

    if (oneH == NO) {
        if (_onePointable == YES) {
            // Les inputs de One Hand sont présents
            [self removeInputPortForKey:@"fingerIndex"];
            
        } 
    } else {
        [self addInputPortWithType:QCPortTypeIndex forKey:@"fingerIndex" withAttributes:[NSDictionary dictionaryWithObject:@"Pointable Index" forKey:QCPortAttributeNameKey]];
    }
    
    BOOL tipPos, stabTip, tipRot, tipVel, tipDir, tipLen, tipWid, tipRel, gest;
    
    tipPos = _exposeTipPosition;
    stabTip = _exposeStabilizedPosition;
    tipRot = _exposeTipRotation;
    tipVel = _exposeVelocity;
    tipDir = _exposeDirection;
    tipLen = _exposeLength;
    tipWid = _exposeWidth;
    tipRel = _exposeRelativePosition;
    gest = _exposeGestures;
    
    [self setExposeTipPosition:NO];
    [self setExposeStabilizedPosition:NO];
    [self setExposeTipRotation:NO];
    [self setExposeVelocity:NO];
    [self setExposeDirection:NO];
    [self setExposeLength:NO];
    [self setExposeWidth:NO];
    [self setExposeRelativePosition:NO];
    [self setExposeGestures:NO];
    
    _onePointable = oneH;
    
    [self setExposeTipPosition:tipPos];
    [self setExposeStabilizedPosition:stabTip];
    [self setExposeTipRotation:tipRot];
    [self setExposeVelocity:tipVel];
    [self setExposeDirection:tipDir];
    [self setExposeLength:tipLen];
    [self setExposeWidth:tipWid];
    [self setExposeRelativePosition:tipRel];
    [self setExposeGestures:gest];
    
    // _onePointable = oneH; -> est passé dans refresh
    
}

- (BOOL) oneHand
{
    return _onePointable;
}


- (void) setExposeTipPosition:(BOOL)exposeTipPos
{

    if (_exposeTipPosition == YES && exposeTipPos == NO) {
        
        if (_onePointable == NO) {
            // On retire les ports
            for (int i = 0; i < 5; i++) {
                [self removeOutputPortForKey:[NSString stringWithFormat:@"tipPos_%i", i]];
            }
            
        } else {
            [self removeOutputPortForKey:@"tipPosX"];
            [self removeOutputPortForKey:@"tipPosY"];
            [self removeOutputPortForKey:@"tipPosZ"];
        }
        
    } else if (_exposeTipPosition == NO && exposeTipPos == YES)  {
        
        if (_onePointable == NO) {
            // On ajoute les ports
            for (int i = 0; i < 5; i++) {
                
                [self addOutputPortWithType:QCPortTypeStructure forKey:[NSString stringWithFormat:@"tipPos_%i", i]
                             withAttributes:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Tip Position - Pointable %i", i] forKey:QCPortAttributeNameKey]];
                
            }
        } else {
            [self addOutputPortWithType:QCPortTypeNumber forKey:@"tipPosX" withAttributes:[NSDictionary dictionaryWithObject:@"Tip Position X" forKey:QCPortAttributeNameKey]];
            [self addOutputPortWithType:QCPortTypeNumber forKey:@"tipPosY" withAttributes:[NSDictionary dictionaryWithObject:@"Tip Position Y" forKey:QCPortAttributeNameKey]];
            [self addOutputPortWithType:QCPortTypeNumber forKey:@"tipPosZ" withAttributes:[NSDictionary dictionaryWithObject:@"Tip Position Z" forKey:QCPortAttributeNameKey]];
        }

    }
    
    
    
    _exposeTipPosition = exposeTipPos;
}


- (BOOL) exposeTipPosition
{
    return _exposeTipPosition;
}



- (void) setExposeStabilizedPosition:(BOOL)exposeStabPos
{

    if (_exposeStabilizedPosition == YES && exposeStabPos == NO) {
        
        if (_onePointable == NO) {
            // On retire les ports
            for (int i = 0; i < 5; i++) {
                [self removeOutputPortForKey:[NSString stringWithFormat:@"stabPos_%i", i]];
            }
            
        } else {
            [self removeOutputPortForKey:@"stabPosX"];
            [self removeOutputPortForKey:@"stabPosY"];
            [self removeOutputPortForKey:@"stabPosZ"];
        }
        
    } else if (_exposeStabilizedPosition == NO && exposeStabPos == YES)  {
        
        if (_onePointable == NO) {
            // On ajoute les ports
            for (int i = 0; i < 5; i++) {
                
                [self addOutputPortWithType:QCPortTypeStructure forKey:[NSString stringWithFormat:@"stabPos_%i", i]
                             withAttributes:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Stabilized Position - Pointable %i", i] forKey:QCPortAttributeNameKey]];
                
            }
        } else {
            [self addOutputPortWithType:QCPortTypeNumber forKey:@"stabPosX" withAttributes:[NSDictionary dictionaryWithObject:@"Stabilized Position X" forKey:QCPortAttributeNameKey]];
            [self addOutputPortWithType:QCPortTypeNumber forKey:@"stabPosY" withAttributes:[NSDictionary dictionaryWithObject:@"Stabilized Position Y" forKey:QCPortAttributeNameKey]];
            [self addOutputPortWithType:QCPortTypeNumber forKey:@"stabPosZ" withAttributes:[NSDictionary dictionaryWithObject:@"Stabilized Position Z" forKey:QCPortAttributeNameKey]];
        }
        
    }

    _exposeStabilizedPosition = exposeStabPos;
}

- (BOOL) exposeStabilizedPosition
{
    return _exposeStabilizedPosition;
}



- (void) setExposeTipRotation:(BOOL)exposeTipRot
{
    
    if (_exposeTipRotation == YES && exposeTipRot == NO) {
        
        if (_onePointable == NO) {
            // On retire les ports
            for (int i = 0; i < 5; i++) {
                [self removeOutputPortForKey:[NSString stringWithFormat:@"tipRot_%i", i]];
            }
            
        } else {
            [self removeOutputPortForKey:@"tipRotRoll"];
            [self removeOutputPortForKey:@"tipRotPitch"];
            [self removeOutputPortForKey:@"tipRotYaw"];
        }
        
    } else if (_exposeTipRotation == NO && exposeTipRot == YES)  {
        
        if (_onePointable == NO) {
            // On ajoute les ports
            for (int i = 0; i < 5; i++) {
                
                [self addOutputPortWithType:QCPortTypeStructure forKey:[NSString stringWithFormat:@"tipRot_%i", i]
                             withAttributes:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Tip Rotation - Pointable %i", i] forKey:QCPortAttributeNameKey]];
                
            }
        } else {
            [self addOutputPortWithType:QCPortTypeNumber forKey:@"tipRotRoll" withAttributes:[NSDictionary dictionaryWithObject:@"Tip Roll" forKey:QCPortAttributeNameKey]];
            [self addOutputPortWithType:QCPortTypeNumber forKey:@"tipRotPitch" withAttributes:[NSDictionary dictionaryWithObject:@"Tip Pitch" forKey:QCPortAttributeNameKey]];
            [self addOutputPortWithType:QCPortTypeNumber forKey:@"tipRotYaw" withAttributes:[NSDictionary dictionaryWithObject:@"Tip Yaw" forKey:QCPortAttributeNameKey]];
        }
        
    }
    
    
    
    _exposeTipRotation = exposeTipRot;
}


- (BOOL) exposeTipRotation
{
    return _exposeTipRotation;
}




- (void) setExposeVelocity:(BOOL)exposeVel
{

    if (_exposeVelocity == YES && exposeVel == NO) {
        
        if (_onePointable == NO) {
            // On retire les ports
            for (int i = 0; i < 5; i++) {
                [self removeOutputPortForKey:[NSString stringWithFormat:@"vel_%i", i]];
            }
            
        } else {
            [self removeOutputPortForKey:@"velX"];
            [self removeOutputPortForKey:@"velY"];
            [self removeOutputPortForKey:@"velZ"];
        }
        
        
        
    } else if (_exposeVelocity == NO && exposeVel == YES) {
        // On ajoute les ports
        
        if (_onePointable == NO) {
            for (int i = 0; i < 5; i++) {
                
                [self addOutputPortWithType:QCPortTypeStructure forKey:[NSString stringWithFormat:@"vel_%i", i]
                             withAttributes:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Velocity - Pointable %i", i] forKey:QCPortAttributeNameKey]];
                
            }
        } else {
            [self addOutputPortWithType:QCPortTypeNumber forKey:@"velX" withAttributes:[NSDictionary dictionaryWithObject:@"Velocity X" forKey:QCPortAttributeNameKey]];
            [self addOutputPortWithType:QCPortTypeNumber forKey:@"velY" withAttributes:[NSDictionary dictionaryWithObject:@"Velocity Y" forKey:QCPortAttributeNameKey]];
            [self addOutputPortWithType:QCPortTypeNumber forKey:@"velZ" withAttributes:[NSDictionary dictionaryWithObject:@"Velocity Z" forKey:QCPortAttributeNameKey]];
        }
        
        
        
    }
    
    _exposeVelocity = exposeVel;
}


- (BOOL) exposeVelocity
{
    return _exposeVelocity;
}




- (void) setExposeDirection:(BOOL)exposeDir
{
    if (_exposeDirection == YES && exposeDir == NO) {
        // On retire les ports
        
        if (_onePointable == NO) {
            for (int i = 0; i < 5; i++) {
                [self removeOutputPortForKey:[NSString stringWithFormat:@"dir_%i", i]];
            }
        } else {
            [self removeOutputPortForKey:@"dirX"];
            [self removeOutputPortForKey:@"dirY"];
            [self removeOutputPortForKey:@"dirZ"];
        }
        
    } else if (_exposeDirection == NO && exposeDir == YES) {
        // On ajoute les ports
        
        if (_onePointable == NO) {
            for (int i = 0; i < 5; i++) {
                
                [self addOutputPortWithType:QCPortTypeStructure forKey:[NSString stringWithFormat:@"dir_%i", i]
                             withAttributes:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Direction - Pointable %i", i] forKey:QCPortAttributeNameKey]];
                
            }
        } else {
            [self addOutputPortWithType:QCPortTypeNumber forKey:@"dirX" withAttributes:[NSDictionary dictionaryWithObject:@"Direction X" forKey:QCPortAttributeNameKey]];
            [self addOutputPortWithType:QCPortTypeNumber forKey:@"dirY" withAttributes:[NSDictionary dictionaryWithObject:@"Direction Y" forKey:QCPortAttributeNameKey]];
            [self addOutputPortWithType:QCPortTypeNumber forKey:@"dirZ" withAttributes:[NSDictionary dictionaryWithObject:@"Direction Z" forKey:QCPortAttributeNameKey]];
        }
        
    }
    
    _exposeDirection = exposeDir;
}


- (BOOL) exposeDirection
{
    return _exposeDirection;
}




- (void) setExposeLength:(BOOL)exposeLen
{
    if (_exposeLength == YES && exposeLen == NO) {
        // On retire les ports
        
        if (_onePointable == NO) {
            for (int i = 0; i < 5; i++) {
                [self removeOutputPortForKey:[NSString stringWithFormat:@"len_%i", i]];
            }

        } else {
            [self removeOutputPortForKey:@"len"];
        }
                
        
        
    } else if (_exposeLength == NO && exposeLen == YES) {
        // On ajoute les ports
        if (_onePointable == NO) {
            for (int i = 0; i < 5; i++) {
                
                [self addOutputPortWithType:QCPortTypeNumber forKey:[NSString stringWithFormat:@"len_%i", i]
                             withAttributes:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Length - Pointable %i", i] forKey:QCPortAttributeNameKey]];
                
            }
        } else {
            [self addOutputPortWithType:QCPortTypeNumber forKey:@"len" withAttributes:[NSDictionary dictionaryWithObject:@"Length" forKey:QCPortAttributeNameKey]];
        }
        
        
        
    }
    
    _exposeLength = exposeLen;
}


- (BOOL) exposeLength
{
    return _exposeLength;
}



- (void) setExposeWidth:(BOOL)exposeWid
{
    if (_exposeWidth == YES && exposeWid == NO) {
        // On retire les ports
        if (_onePointable == NO) {
            for (int i = 0; i < 5; i++) {
                [self removeOutputPortForKey:[NSString stringWithFormat:@"width_%i", i]];
            }
        } else {
            [self removeOutputPortForKey:@"width"];
        }
        
        
        
        
    } else if (_exposeWidth == NO && exposeWid == YES) {
        // On ajoute les ports
        if (_onePointable == NO) {
            for (int i = 0; i < 5; i++) {
                
                [self addOutputPortWithType:QCPortTypeNumber forKey:[NSString stringWithFormat:@"width_%i", i]
                             withAttributes:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Width - Pointable %i", i] forKey:QCPortAttributeNameKey]];
                
            }
        } else {
            [self addOutputPortWithType:QCPortTypeNumber forKey:@"width" withAttributes:[NSDictionary dictionaryWithObject:@"Width" forKey:QCPortAttributeNameKey]];
        }
        
        
        
    }
    
    _exposeWidth = exposeWid;
}


- (BOOL) exposeWidth
{
    return _exposeWidth;
}



- (void) setExposeRelativePosition:(BOOL)exposeRelativePos
{
    
    if (_exposeRelativePosition == YES && exposeRelativePos == NO) {
        // On retire les ports
        
        [self removeOutputPortForKey:@"frontmost"];
        [self removeOutputPortForKey:@"rightmost"];
        [self removeOutputPortForKey:@"leftmost"];
        
        
    } else if (_exposeRelativePosition == NO && exposeRelativePos == YES) {
        // On ajoute les ports
        
        [self addOutputPortWithType:QCPortTypeIndex forKey:@"frontmost" withAttributes:[NSDictionary dictionaryWithObject:@"Frontmost" forKey:QCPortAttributeNameKey]];
        [self addOutputPortWithType:QCPortTypeIndex forKey:@"rightmost" withAttributes:[NSDictionary dictionaryWithObject:@"Rightmost" forKey:QCPortAttributeNameKey]];
        [self addOutputPortWithType:QCPortTypeIndex forKey:@"leftmost" withAttributes:[NSDictionary dictionaryWithObject:@"Leftmost" forKey:QCPortAttributeNameKey]];
        
    }
    
    _exposeRelativePosition = exposeRelativePos;
    
}

- (BOOL) exposeRelativePosition
{
    return _exposeRelativePosition;
}


- (void) setExposeTool:(BOOL)exposeTo
{
    if (_exposeTool == YES && exposeTo == NO) {
        // On retire les ports
        if (_onePointable == NO) {
            for (int i = 0; i < 5; i++) {
                [self removeOutputPortForKey:[NSString stringWithFormat:@"isTool_%i", i]];
            }
        } else {
            [self removeOutputPortForKey:@"isTool"];
        }
        
        
        
        
    } else if (_exposeTool == NO && exposeTo == YES) {
        // On ajoute les ports
        if (_onePointable == NO) {
            for (int i = 0; i < 5; i++) {
                [self addOutputPortWithType:QCPortTypeBoolean forKey:[NSString stringWithFormat:@"isTool_%i", i]
                             withAttributes:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Is Tool - Pointable %i", i] forKey:QCPortAttributeNameKey]];
            }
        } else {
            [self addOutputPortWithType:QCPortTypeBoolean forKey:@"isTool" withAttributes:[NSDictionary dictionaryWithObject:@"Is Tool" forKey:QCPortAttributeNameKey]];
        }
        
        
        
    }
    
    _exposeTool = exposeTo;
}


- (BOOL) exposeTool
{
    return _exposeTool;
}

- (void) setExposeGestures:(BOOL)exposeGest
{
    if (_exposeGestures == YES && exposeGest == NO) {
        // On retire les ports
        if (_onePointable == NO) {
            for (int i = 0; i < 5; i++) {
                [self removeOutputPortForKey:[NSString stringWithFormat:@"gestures_%i", i]];
            }
        } else {
            [self removeOutputPortForKey:@"gestures"];
        }
        
        
        
        
    } else if (_exposeGestures == NO && exposeGest == YES) {
        // On ajoute les ports
        if (_onePointable == NO) {
            for (int i = 0; i < 5; i++) {
                
                [self addOutputPortWithType:QCPortTypeStructure forKey:[NSString stringWithFormat:@"gestures_%i", i]
                             withAttributes:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Gestures - Pointable %i", i] forKey:QCPortAttributeNameKey]];
                
            }
        } else {
            [self addOutputPortWithType:QCPortTypeStructure forKey:@"gestures" withAttributes:[NSDictionary dictionaryWithObject:@"Gestures" forKey:QCPortAttributeNameKey]];
        }
        
        
        
    }
    
    _exposeGestures = exposeGest;
}


- (BOOL) exposeGestures
{
    return _exposeGestures;
}

- (QCPlugInViewController *) createViewController
{
    return [[QCPlugInViewController alloc] initWithPlugIn:self viewNibName:@"hOzLeapPointableReaderPlugIn"];
}

+ (NSArray*) plugInKeys
{
	/* Return the list of KVC keys corresponding to our internal settings */
	return [NSArray arrayWithObjects:@"oneHand", @"exposeTipPosition", @"exposeStabilizedPosition", @"exposeTipRotation", @"exposeVelocity", @"exposeDirection", @"exposeLength", @"exposeWidth", @"exposeTool", @"exposeRelativePosition", @"exposeGestures", nil];
}



- (id)init
{
	self = [super init];
	if (self) {

        [self addInputPortWithType:QCPortTypeStructure forKey:@"hands" withAttributes:[NSDictionary dictionaryWithObject:@"Pointables" forKey:QCPortAttributeNameKey]];
        [self addInputPortWithType:QCPortTypeIndex forKey:@"handIndex" withAttributes:[NSDictionary dictionaryWithObject:@"Hand Index" forKey:QCPortAttributeNameKey]];
        
		[self setOneHand:YES];
        [self setExposeTipPosition:YES];


	}
	
	return self;
}


@end

@implementation hOzLeapPointableReaderPlugIn (Execution)

- (BOOL)startExecution:(id <QCPlugInContext>)context
{
	
	
	return YES;
}

- (void)enableExecution:(id <QCPlugInContext>)context
{
    associativeIDs = [[NSMutableDictionary alloc] init];
    ports = [[NSMutableArray alloc] init];
    [ports addObjectsFromArray:[NSArray arrayWithObjects:
                                [NSNumber numberWithInt:4],
                                [NSNumber numberWithInt:3],
                                [NSNumber numberWithInt:2],
                                [NSNumber numberWithInt:1],
                                [NSNumber numberWithInt:0],
                                nil]];
    
}

- (BOOL)execute:(id <QCPlugInContext>)context atTime:(NSTimeInterval)time withArguments:(NSDictionary *)arguments
{
    NSDictionary *hand = nil;
    NSDictionary *pointable = nil;
    
    if ([self valueForInputKey:@"hands"] != nil && [[self valueForInputKey:@"hands"] count] > 0) {
        
        // ---- We check if the Pointables input is from the Hand Reader or from the Device plug-ins
        //
        if ([[[self valueForInputKey:@"hands"] objectForKey:[[[self valueForInputKey:@"hands"] allKeys] objectAtIndex:0]] objectForKey:@"tip_position"] == nil) {
            // C'est un input de Device
            if ([[self valueForInputKey:@"hands"] count] > [[self valueForInputKey:@"handIndex"] integerValue]) {
                hand  = (NSDictionary *)[[self valueForInputKey:@"hands"] objectForKey:[NSString stringWithFormat:@"%li", (unsigned long)[[self valueForInputKey:@"handIndex"] integerValue]]];
            }
        } else {
            // C'est un input de Hand Reader
            hand  = (NSDictionary *)[self valueForInputKey:@"hands"];
            
        }
        
        if (_onePointable == YES) {

            if ([[self valueForInputKey:@"fingerIndex"] integerValue] < [hand count]) {
                
                pointable = [hand objectForKey:[[hand allKeys] objectAtIndex:[[self valueForInputKey:@"fingerIndex"] integerValue]]];

            }
            
        } 
    
    }
    
    
    // -------- OPTIMISER CI-DESSOUS ET NE BOUCLER QU'UNE FOIS, AVEC DES TAGS POUR SAVOIR S'IL FAUT PERFORMER LES OUTPUTS SPECIFIQUES
    //
    // ---- Could be optimized with only one loop and a tag system to see if we have to perform specific outputs
    //
    
    if (hand != nil && _onePointable == NO) {

        [self assignFingersIDToPorts:hand];

        [self performOutputs:hand];
        
    } else if (pointable != nil && _onePointable == YES) {
        [self performPointable:pointable];
    }

    
	return YES;
}

- (void)disableExecution:(id <QCPlugInContext>)context
{
    [associativeIDs release];
    [ports release];
}

- (void)stopExecution:(id <QCPlugInContext>)context
{
	
}






- (void) performPointable:(NSDictionary *)pointable
{
    if (_exposeTipPosition == YES) {
        [self setValue:[[pointable objectForKey:@"tip_position"] objectForKey:@"x"] forOutputKey:@"tipPosX"];
        [self setValue:[[pointable objectForKey:@"tip_position"] objectForKey:@"y"] forOutputKey:@"tipPosY"];
        [self setValue:[[pointable objectForKey:@"tip_position"] objectForKey:@"z"] forOutputKey:@"tipPosZ"];
    }
    
    if (_exposeStabilizedPosition == YES) {
        [self setValue:[[pointable objectForKey:@"stabilized_tip_position"] objectForKey:@"x"] forOutputKey:@"stabPosX"];
        [self setValue:[[pointable objectForKey:@"stabilized_tip_position"] objectForKey:@"y"] forOutputKey:@"stabPosY"];
        [self setValue:[[pointable objectForKey:@"stabilized_tip_position"] objectForKey:@"z"] forOutputKey:@"stabPosZ"];
    }
    
    if (_exposeTipRotation == YES) {
        [self setValue:[[pointable objectForKey:@"pointable_rotation"] objectForKey:@"roll"] forOutputKey:@"tipRotRoll"];
        [self setValue:[[pointable objectForKey:@"pointable_rotation"] objectForKey:@"pitch"] forOutputKey:@"tipRotPitch"];
        [self setValue:[[pointable objectForKey:@"pointable_rotation"] objectForKey:@"yaw"] forOutputKey:@"tipRotYaw"];
    }
    
    if (_exposeVelocity == YES) {
        [self setValue:[[pointable objectForKey:@"tip_velocity"] objectForKey:@"x"] forOutputKey:@"velX"];
        [self setValue:[[pointable objectForKey:@"tip_velocity"] objectForKey:@"y"] forOutputKey:@"velY"];
        [self setValue:[[pointable objectForKey:@"tip_velocity"] objectForKey:@"z"] forOutputKey:@"velZ"];
    }
    
    if (_exposeDirection == YES) {
        [self setValue:[[pointable objectForKey:@"pointable_direction"] objectForKey:@"x"] forOutputKey:@"dirX"];
        [self setValue:[[pointable objectForKey:@"pointable_direction"] objectForKey:@"y"] forOutputKey:@"dirY"];
        [self setValue:[[pointable objectForKey:@"pointable_direction"] objectForKey:@"z"] forOutputKey:@"dirZ"];
    }
    
    if (_exposeLength == YES) {
        [self setValue:[pointable objectForKey:@"pointable_length"] forOutputKey:@"len"];
    }
    
    if (_exposeWidth == YES) {
        [self setValue:[pointable objectForKey:@"pointable_width"] forOutputKey:@"width"];
    }
    
    if (_exposeRelativePosition == YES) {
        [self setValue:[pointable objectForKey:@"is_frontmost"] forOutputKey:@"frontmost"];
        [self setValue:[pointable objectForKey:@"is_rightmost"] forOutputKey:@"rightmost"];
        [self setValue:[pointable objectForKey:@"is_leftmost"] forOutputKey:@"leftmost"];
    }
    
    if (_exposeTool == YES) {
        [self setValue:[pointable objectForKey:@"is_tool"] forOutputKey:@"isTool"];
    }
    
    if (_exposeGestures == YES) {
        [self setValue:[pointable objectForKey:@"gestures"] forOutputKey:@"gestures"];
    }

}








- (void) assignFingersIDToPorts:(NSDictionary *)theHand
{

    // On vérifie les fingers
    for (id key in theHand) {
        
        if ([self isAssignedToPort:key] == NO) {
            
            if ([ports count] > 0) {
                // Il reste des ports non alloués, on alloue le dernier de la liste
                [associativeIDs setObject:[[ports lastObject] copy] forKey:key];
                [ports removeLastObject];
                
            } else {
                // On cherche à libérer un port
                if ([self removeIDs:theHand]) {
                    // Si on a réussi on assigne
                    [associativeIDs setObject:[[ports lastObject] copy] forKey:key];
                    [ports removeLastObject];
                } 
            }

        } 
        
    }
    
}

- (BOOL) isAssignedToPort:(NSString *)fingerID
{
    for (id key in associativeIDs) {
        
        if ([key intValue] == [fingerID intValue]) {
            return YES;
        }
        
    }
    
    return NO;
}

- (BOOL) removeIDs:(NSDictionary *)theHand
{
    NSArray *idsAsso = [associativeIDs allKeys];
    NSArray *idsHand = [theHand allKeys];
    NSMutableArray *intermediate = [NSMutableArray arrayWithArray:idsAsso];

    [intermediate removeObjectsInArray:idsHand];
    
    for (id fingerID in intermediate) {
        [ports addObject:[[associativeIDs objectForKey:fingerID] copy]];
    }

    [associativeIDs removeObjectsForKeys:intermediate];

    if ([intermediate count] > 0) {
        return YES;
    }
    
    return NO;
    
}

- (void) performOutputs:(NSDictionary *) theHand
{
    
    // On assigne NULL aux ports quand il n'y a plus de doigts du tout

    if ([[theHand allKeys] count] == 0) {
        for (int i = 0; i < 5; i++) {
            
            if (_exposeTipPosition == YES) {
                [self setValue:[[[NSDictionary alloc] init] autorelease] forOutputKey:[NSString stringWithFormat:@"tipPos_%i", i]];
            }
            if (_exposeStabilizedPosition == YES) {
                [self setValue:[[[NSDictionary alloc] init] autorelease] forOutputKey:[NSString stringWithFormat:@"stabPos_%i", i]];
            }
            if (_exposeTipRotation == YES) {
                [self setValue:[[[NSDictionary alloc] init] autorelease] forOutputKey:[NSString stringWithFormat:@"tipRot_%i", i]];
            }
            if (_exposeVelocity == YES) {
                [self setValue:[[[NSDictionary alloc] init] autorelease] forOutputKey:[NSString stringWithFormat:@"vel_%i", i]];
            }
            if (_exposeDirection == YES) {
                [self setValue:[[[NSDictionary alloc] init] autorelease] forOutputKey:[NSString stringWithFormat:@"dir_%i", i]];
            }
            if (_exposeLength == YES) {
                [self setValue:[[[NSDictionary alloc] init] autorelease] forOutputKey:[NSString stringWithFormat:@"len_%i", i]];
            }
            if (_exposeWidth == YES) {
                [self setValue:[[[NSDictionary alloc] init] autorelease] forOutputKey:[NSString stringWithFormat:@"width_%i", i]];
            }
            
        }

    }


    
    for (id key in theHand) {
        
        if ([associativeIDs objectForKey:key] != nil) {
            
            if (_exposeTool == YES) {
                [self setValue:[[theHand objectForKey:key] objectForKey:@"is_tool"] forOutputKey:[NSString stringWithFormat:@"isTool_%i", [[associativeIDs objectForKey:key] intValue]]];
            }
            
            if (_exposeTipPosition == YES) {
                [self setValue:[[theHand objectForKey:key] objectForKey:@"tip_position"] forOutputKey:[NSString stringWithFormat:@"tipPos_%i", [[associativeIDs objectForKey:key] intValue]]];
            }
        
            if (_exposeStabilizedPosition == YES) {
                [self setValue:[[theHand objectForKey:key] objectForKey:@"stabilized_tip_position"] forOutputKey:[NSString stringWithFormat:@"stabPos_%i", [[associativeIDs objectForKey:key] intValue]]];
            }
            
            if (_exposeTipRotation == YES) {
                [self setValue:[[theHand objectForKey:key] objectForKey:@"tip_rotation"] forOutputKey:[NSString stringWithFormat:@"tipRot_%i", [[associativeIDs objectForKey:key] intValue]]];
            }
            
            if (_exposeVelocity == YES) {
                [self setValue:[[theHand objectForKey:key] objectForKey:@"tip_velocity"] forOutputKey:[NSString stringWithFormat:@"vel_%i", [[associativeIDs objectForKey:key] intValue]]];
            }
            
            if (_exposeDirection == YES) {
                [self setValue:[[theHand objectForKey:key] objectForKey:@"pointable_direction"] forOutputKey:[NSString stringWithFormat:@"dir_%i", [[associativeIDs objectForKey:key] intValue]]];
            }
            
            if (_exposeLength == YES) {
                [self setValue:[[theHand objectForKey:key] objectForKey:@"pointable_length"] forOutputKey:[NSString stringWithFormat:@"len_%i", [[associativeIDs objectForKey:key] intValue]]];
            }
        
            if (_exposeWidth == YES) {
                [self setValue:[[theHand objectForKey:key] objectForKey:@"pointable_width"] forOutputKey:[NSString stringWithFormat:@"width_%i", [[associativeIDs objectForKey:key] intValue]]];
            }
            
            if (_exposeGestures == YES) {
                [self setValue:[[theHand objectForKey:key] objectForKey:@"gestures"] forOutputKey:[NSString stringWithFormat:@"gestures_%i", [[associativeIDs objectForKey:key] intValue]]];
            }
        
        }
        
    }
    
    
    if (_exposeRelativePosition == YES) {
        
        NSUInteger frontMost = -1, rightMost = -1, leftMost = -1;
        
        for (id key in theHand) {
            
            if ([[[theHand objectForKey:key] objectForKey:@"is_frontmost"] boolValue] == YES) {
                frontMost = [[associativeIDs objectForKey:key] integerValue];
            }
            
            if ([[[theHand objectForKey:key] objectForKey:@"is_rightmost"] boolValue] == YES) {
                rightMost = [[associativeIDs objectForKey:key]  integerValue];
            }
            
            if ([[[theHand objectForKey:key] objectForKey:@"is_leftmost"] boolValue] == YES) {
                leftMost = [[associativeIDs objectForKey:key]  integerValue];
            }
            
        }
        
        [self setValue:[NSNumber numberWithInteger:frontMost] forOutputKey:@"frontmost"];
        [self setValue:[NSNumber numberWithInteger:rightMost] forOutputKey:@"rightmost"];
        [self setValue:[NSNumber numberWithInteger:leftMost] forOutputKey:@"leftmost"];
    }
    
    
}

@end
