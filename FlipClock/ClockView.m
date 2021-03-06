//The MIT License (MIT) Copyright (c) <2013> <Jonathan Salvador>
//
//Permission is hereby granted, free of charge, to any person obtaining a
//copy of this software and associated documentation files (the
//"Software"), to deal in the Software without restriction, including
//without limitation the rights to use, copy, modify, merge, publish,
//distribute, sublicense, and/or sell copies of the Software, and to
//permit persons to whom the Software is furnished to do so, subject to
//the following conditions:
//
//The above copyright notice and this permission notice shall be included
//in all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
//CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
//TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
//SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//  ClockView.m
//  ClockDemo
//
//  Created by Jonathan Salvador on 11/25/12.
//  Copyright (c) 2012 Jonathan Salvador. All rights reserved.
//

#import "ClockView.h"
#import "ClockNode.h"

@implementation ClockView

-(void)awakeFromNib{
    //set military and seconds flags
    Boolean showMilitary = true;
    Boolean showSeconds  = true;
    
    [self drawClockWithMilitary:showMilitary andSeconds:showSeconds];
}

-(void)drawClockWithMilitary:(Boolean)showMilitary andSeconds:(Boolean)showSeconds{
    
    self.backgroundColor = [NSColor colorWithCalibratedRed:0.06f green:0.06f blue:0.06f alpha:1.0f];
    
    // Create an empty scene
    SCNScene *scene = [SCNScene scene];
    self.scene = scene;
    
    // Create a camera
    SCNCamera *camera = [SCNCamera camera];
    camera.xFov = 45;   // Degrees, not radians
    camera.yFov = 45;
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = camera;
    cameraNode.position = [ClockView getCamPositionFor:showMilitary andSeconds:showSeconds];
    [scene.rootNode addChildNode:cameraNode];
    
    [ClockView addLightsToScene:scene];
    
    //add ClockNode
    ClockNode *clock = (ClockNode*)[ClockNode node];
    [scene.rootNode addChildNode:clock];
    
    //move clock a little to the left
    CATransform3D transLeft = [ClockView getClockTransformFor:showMilitary andSeconds:showSeconds]; //move to the right
    clock.transform = transLeft;
    
    [clock startClockWithMilitary:showMilitary andWithSeconds:showSeconds];
}

+(SCNVector3)getCamPositionFor:(Boolean)givenMilitary andSeconds:(Boolean)givenSeconds{
    if(givenMilitary && givenSeconds)
        return SCNVector3Make(0, 0, 38);
    else if(givenMilitary && (!givenSeconds))
        return SCNVector3Make(0, 0, 25);
    else if((!givenMilitary) && givenSeconds)
        return SCNVector3Make(0, 0, 45);
    else
        return SCNVector3Make(0, 0, 30);
}

+(CATransform3D)getClockTransformFor:(Boolean)givenMilitary andSeconds:(Boolean)givenSeconds{
    if(givenMilitary && givenSeconds)
        return CATransform3DMakeTranslation(-23.5, 0, 0);
    else if(givenMilitary && (!givenSeconds))
        return CATransform3DMakeTranslation(-16.3, 0, 0);
    else if((!givenMilitary) && givenSeconds)
        return CATransform3DMakeTranslation(-20.5, 0, 0);
    else
        return CATransform3DMakeTranslation(-13.5, 0, 0);
}

+(void)addLightsToScene:(SCNScene*)givenScene{
    
    // Create ambient light
    SCNLight *ambientLight = [SCNLight light];
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLight.type = SCNLightTypeAmbient;
    ambientLight.color = [NSColor colorWithDeviceWhite:0.1 alpha:1.0];
    ambientLightNode.light = ambientLight;
    [givenScene.rootNode addChildNode:ambientLightNode];
    
    // Create a diffuse light
    SCNLight *diffuseLight = [SCNLight light];
    SCNNode *diffuseLightNode = [SCNNode node];
    diffuseLight.type = SCNLightTypeOmni;
    diffuseLightNode.light = diffuseLight;
    diffuseLightNode.position = SCNVector3Make(-30, 30, 50);
    [givenScene.rootNode addChildNode:diffuseLightNode];
}

@end
