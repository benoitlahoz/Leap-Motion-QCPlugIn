
/** 
 * "Helper" patch used to get readable outputs from the device plugins structure outputs
 */

@interface hOzLeapHandReaderPlugIn : QCPlugIn 


/*
 * Get the Hands output of the Device PlugIn in input, and the hand indewx we want to dispatch
 */
@property (assign) NSDictionary *inputHands;
@property NSUInteger            inputHandIndex;




/* 
 * Outputs : the name is clear. Please see the Leap Motion dev site, or the LeapObjectiveC file to have details on each value. 
 */

@property BOOL                  outputIsHand;

@property (assign) NSDictionary *outputPalmPos;
@property (assign) NSDictionary *outputStabilizedPalmPos;

@property double                outputHandPitch;
@property double                outputHandRoll;
@property double                outputHandYaw;

@property (assign) NSDictionary *outputHandPalmVelocity;

@property (assign) NSDictionary *outputHandDir;

@property (assign) NSDictionary *outputHandPalmNormal;

@property (assign) NSDictionary *outputHandSphereCenter;

@property double                outputHandSphereRadius;

@property double                outputIsRightMost;
@property double                outputIsLeftMost;
@property double                outputIsFrontMost;

@property (assign) NSDictionary *outputFingers;

@end