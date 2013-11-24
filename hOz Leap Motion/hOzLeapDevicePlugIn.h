
/** 
 * The main plugin, that ask the device for data, convert it and output in NSDictionaries
 */



@interface hOzLeapDevicePlugIn : QCPlugIn 
{
    /** 
     * The controller itself, the current frame, the interaction box
     */
    LeapController              *aLeapController;
    LeapFrame                   *frame;
    LeapInteractionBox          *iBox;
    
    /** 
     * Previous frame, used in gesture recognition
     */
    LeapFrame                   *lastFrame;
    
    /**
     * Dictionary used to store the gestures between frames
     */
    NSMutableDictionary         *gestures;
    
    /** 
     * Dictionary used to store screen coordinates
     */ 
    NSDictionary                *screenCoordinates;
    BOOL                        initialized;

    
    /** 
     * Stores the user depth
     */
    double                      depth;
    
    
}


/** 
 * The user choose the depth and position of the QC "interaction box"
 */
@property double                inputMinZ;
@property double                inputMaxZ;

/** 
 *
 * Enable / diable the background applications mode
 */
@property BOOL                  inputBackgroundApp;

/** 
 * Let the user choose the screen (didn't really understand the real use of this, but the controller needs it to find the interaction box)
 */
@property NSUInteger            inputScreen;


/** 
 * outputConnected              Output YES if the controller is connected, NO otherwise
 * outputBackgroundApp          Output YES if background applications are allowed, NO otherwise
 * outputScreen                 Output the interaction box bounds coordinates                                           ---> BUG, TODO : change the if condition
 * outputFrame                  Output the current frame number
 * outputHands                  Output a NSDictionary (keyed structure) that contains all the data from the Hands
 *                                  Hands data
 *                                  Pointables data
 *                                  Gestures data
 * outputFingers                Output a NSDictionary with only the Pointables values organized by Hand                 ---> TODO : organize by pointable, including hand id/index
 * outputGesture                Outputs a NSDictionary with current gestures, organized by gesture ID
 */
@property BOOL                  outputConnected;
@property BOOL                  outputBackgroundApp;
@property (assign) NSDictionary *outputScreen;
@property (assign) NSDictionary *outputFrame;
@property (assign) NSDictionary *outputHands;
@property (assign) NSDictionary *outputFingers;
@property (assign) NSDictionary *outputGesture;

@end





@interface hOzLeapDevicePlugIn (Execution)

/** SCALE
 *
 * scaleLeapValue               returns a value scaled to (oMin, toMax) scale.
 * scaleMeasure                 returns a measure scaled from the interaction box to the QC coordinates
 * scaleLeapVector              returns a vector scaled from the interaction box to the QC coordinates
 *
 */

- (double) scaleLeapValue:(double)value fromMin:(double)fromMin fromMax:(double)fromMax toMin:(double)toMin toMax:(double)toMax;
- (double) scaleMeasure:(double)leapMeasure inContext:(id <QCPlugInContext>)context;
- (LeapVector *) scaleLeapVector:(LeapVector *)vector inContext:(id <QCPlugInContext>)context;


/** PREPARE FOR OUTPUT
 *
 * dictionaryWithLeapVector     returns a dictionary made of the leap vector values (warning : case sensitive)
 *                                  @"x" -> x coordinate
 *                                  @"y" -> y coordinate
 *                                  @"z" -> z coordinate
 * velocityWithLeapVector       returns a dictionary made of a leap vector scaled values   
 *                                  0 -> interaction box width          =           -1 -> 1
 *                                  The method allows velocities to exceed these bounds
 *
 *                                  @"x" -> x velocity
 *                                  @"y" -> y velocity
 *                                  @"z" -> z velocity
 *
 */

- (NSDictionary *) dictionaryWithLeapVector:(LeapVector *)leapVector inContext:(id <QCPlugInContext>)context;
- (NSDictionary *) velocityWithLeapVector:(LeapVector *)leapVector inContext:(id <QCPlugInContext>)context;


/** POINTABLES FOR OUTPUTS
 * Prepares and outputs a dictionary with Pointables values
 * Used by : 
 *      outputHands dictionary  -> @"pointables"
 *      outputPointables        -> direct output
 */
- (NSDictionary *) fingersInHand:(LeapHand *) hand inContext:(id <QCPlugInContext>)context;


/** GESTURES
 * performGesturesInContext         get the controller data for gestures and launch feedGestures with current and previous frame
 * feedGesturesWithGesturesArray    feed the gestures NSDictionary with prepared gestures data
 * gesturesForPointableAtId         feed each pointable dictionary with a gesture found in the gestures dictionary for its ID
 * gestureState                     returns a string for the gesture state
 */
- (void) performGesturesInContext:(id <QCPlugInContext>)context;
- (void) feedGesturesWithGesturesArray:(NSArray *)gesturesArray inContext:(id <QCPlugInContext>)context;
- (NSDictionary *) gesturesForPointableAtId:(int)thePointableID;
- (NSString *) gestureState:(int)state;

@end