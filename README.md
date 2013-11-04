h[Oz] Leap Motion Quartz Composer Plug-In v0.03
===============================================

A set of 4 patches to get the data out of the Leap Motion device.
- Device: output keyed structures for the positions, directions, dimensions and gestures of hands and pointables.
- Hands Reader: helper patch that avoid using "structures member" patch to get usable info.
- Pointables Reader: helper patch that can output one or the five pointables of the provided hand structure and keep the pointables attached to an unique output.
- 3D Transformation: works like the usual 3D transformation patch but with the hands and pointables coordinates.
	
NB : the 3D Transformation patch doesn't work on direction and normals for the moment (TODO list).

Copyright 2013 - hOz for L'ange Carasuelo | Mélange Karburant 3 
www.benoitlahoz.net | www.carasuelo.org | www.melangekarburant3.org

3D Transformation patch, many bugs correction and new features were commissioned 
by Jonathan Hammond (Just Add Music Media) www.justaddmusicmedia.com

MultiHandFingers.qtz and VelocityPainting.qtz are example patches provided by J.Hammond.
