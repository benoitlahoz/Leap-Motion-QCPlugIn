

/**
 * "Helper" patch used to get readable outputs from 
 *          the device plugin Pointables structure output
 *          the Hand Reader plugin Pointables structure output
 *
 * Two modes are allowed : 
 *
 * "One Pointable" (default) : the user has to input the pointable index in the choosen hand (input hand index) and the plugin outputs plain values instead of xyz structures
 * "All Pointables" :   the plug-in outputs the values for all the found fingers. Each finger is assigned to an output according to its ID, so we can for example draw easily
 *                      because there's no jump (eg. in a Queue structure atatched to the tip position) between the current frame an the previous one. 
 */


@interface hOzLeapPointableReaderPlugIn : QCPlugIn
{
    /**
     * Values stored in the composition to remember what outputs where exposed.
     *
     * In the Settings Panel, the user can choose the mode and the values to output
     */
    
    BOOL                        _onePointable;
    
    BOOL                        _exposeRelativePosition;
    BOOL                        _exposeTipPosition;
    BOOL                        _exposeTipRotation;
    BOOL                        _exposeStabilizedPosition;
    BOOL                        _exposeVelocity;
    BOOL                        _exposeDirection;
    BOOL                        _exposeLength;
    BOOL                        _exposeWidth;
    BOOL                        _exposeTool;
    BOOL                        _exposeGestures;
    
    
    /** 
     * The dictionay and the array used for the pointable "tracking" (not real tracking in fact, as the plug-in is not able to keep a finger 
     * which changed its ID but is approximatively at the same place, attached to a port: in the TODO list)
     */
    NSMutableDictionary         *associativeIDs;
    NSMutableArray              *ports;

}





@end



@interface hOzLeapPointableReaderPlugIn (Execution)

/**
 * Ports management
 */
- (void) assignFingersIDToPorts:(NSDictionary *)theHand;
- (BOOL) isAssignedToPort:(NSNumber *)fingerID;
- (BOOL) removeIDs:(NSDictionary *)theHand;

/**
 * Prepare outputs
 */
- (void) performPointable:(NSDictionary *)pointable;
- (void) performOutputs:(NSDictionary *) theHand;

@end