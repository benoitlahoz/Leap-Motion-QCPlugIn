

/**
 * To avoid 'double' equality problems
 */
#define TINY_ZERO 0.000001

@interface hOzLeap3DTransformationPlugIn : QCPlugIn 



/**
 * Made to look like the original 3D Transformation patch
 */

@property (assign) NSDictionary *inputHands;
@property double                inputOriginX;
@property double                inputOriginY;
@property double                inputOriginZ;
@property double                inputTranslationX;
@property double                inputTranslationY;
@property double                inputTranslationZ;
@property double                inputRotationX;
@property double                inputRotationY;
@property double                inputRotationZ;
@property double                inputScaleX;
@property double                inputScaleY;
@property double                inputScaleZ;


/**
 * Outputs the same dictionary as the DevicePlugIn
 */

@property (assign) NSDictionary *outputHands;

@end




@interface hOzLeap3DTransformationPlugIn (Execution)

/**
 * translateVector adds the second vector value to the concerned vector. 
 * scaleVector multiplies the second vector value to the concerned vector. 
 * rotateVectorOn... use matrices to perform rotation in Euler angles (gimbal lock could occur)
 */
- (LeapVector *) translateVector:(LeapVector *)leapVector;
- (LeapVector *) scaleVector:(LeapVector *)leapVector;
- (LeapVector *) rotateVector:(LeapVector *)leapVector;

- (LeapVector *) rotateVectorOnX:(LeapVector *)leapVector;
- (LeapVector *) rotateVectorOnY:(LeapVector *)leapVector;
- (LeapVector *) rotateVectorOnZ:(LeapVector *)leapVector;

@end