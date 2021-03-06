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
//  FlipClockView.m
//  FlipClock
//
//  Created by Jonathan Salvador on 11/25/12.
//  Copyright (c) 2012 Jonathan Salvador. All rights reserved.
//

#import "FlipClockView.h"

@implementation FlipClockView

//static NSString *moduleName;
static NSString * const moduleName = @"com.Goondaba.FlipClock";
static NSString * const isMilitary_str  = @"isMilitary";
static NSString * const hasSeconds_str  = @"hasSeconds";
CGFloat frameRate = 30.0f;

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview{
    
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:1/frameRate];
        
        // Register our default values
        [[self getDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                                    @"NO", isMilitary_str,
                                    @"YES", hasSeconds_str,
                                    nil]];
    }
    return self;
}

- (void)startAnimation{
    [super startAnimation];
    
    //Deal with prefs
    ScreenSaverDefaults *defaults = [self getDefaults];
    
    //create the quartz composition view
    myClockView = [[ClockView alloc] initWithFrame: NSMakeRect(0, 0, NSWidth(self.frame), NSHeight(self.frame))];
    //make sure it resizes with the screensaver view
    [myClockView setAutoresizingMask:(NSViewWidthSizable|NSViewHeightSizable)];
    
    [self addSubview:myClockView];
    
    [myClockView drawClockWithMilitary:[defaults integerForKey:isMilitary_str] andSeconds:[defaults integerForKey:hasSeconds_str]];
}

- (void)stopAnimation{
    [super stopAnimation];
    
    //
    if(myClockView != nil){
        [myClockView removeFromSuperview];
        myClockView = nil;
    }
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
}

- (void)animateOneFrame
{
    return;
}

- (BOOL)hasConfigureSheet{
    return YES;
}

- (NSWindow*)configureSheet{
    
    ScreenSaverDefaults *defaults = [self getDefaults];
    
    if (!configSheet)
    {
        if (![NSBundle loadNibNamed:@"ConfigureSheet" owner:self])
        {
            NSLog( @"Failed to load configure sheet." );
            NSBeep();
        }
    }
    
    //set sheet options to defaults
    [militaryBox setState:[defaults integerForKey:isMilitary_str]];
    [secondsBox  setState:[defaults integerForKey:hasSeconds_str]];
    
    return configSheet;
}

#pragma mark -- Methods for ConfigureSheet

/**
 *  Helper method to grab some default settings
 *
 *  @return The defaults
 */
- (ScreenSaverDefaults*)getDefaults{
    return [ScreenSaverDefaults defaultsForModuleWithName:moduleName];
}

/**
 *  Saves the settings when the cancel button is clicked
 *
 *  @param sender The cancel button
 */
- (IBAction)cancelClick:(id)sender{
    
    ScreenSaverDefaults *defaults = [self getDefaults];
    
    // Update our defaults
    [defaults setInteger:[militaryBox state]   forKey:isMilitary_str];
    [defaults setInteger:[secondsBox state]    forKey:hasSeconds_str];
    
    // Save the settings to disk
    [defaults synchronize];
    
    // Close the sheet
    [[NSApplication sharedApplication] endSheet:configSheet];
}

@end
