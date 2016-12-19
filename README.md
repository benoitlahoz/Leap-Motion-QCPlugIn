h[Oz] Leap Motion Quartz Composer Plug-In v0.03
===============================================

THIS PLUGIN IS DEPRECATED, PLEASE CHECK FOR VERSION 2 HERE: http://www.oz432.info/?p=48

A set of 4 patches to get the data out of the Leap Motion device.
- Device: output keyed structures for the positions, directions, dimensions and gestures of hands and pointables.
- Hands Reader: helper patch that avoid using "structures member" patch to get usable info.
- Pointables Reader: helper patch that can output one or the five pointables of the provided hand structure and keep the pointables attached to an unique output.
- 3D Transformation: works like the usual 3D transformation patch but with the hands and pointables coordinates.
	
NB : the 3D Transformation patch doesn't work on direction and normals for the moment (TODO list).
