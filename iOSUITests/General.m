//
//  NSObject+General.m
//  iOSUITests
//
//  Created by burnsoft on 12/24/20.
//  Copyright © 2020 burnsoft. All rights reserved.
//

#import "General.h"

@implementation General: NSObject

+(void)sendTextToKeyBoard:(XCUIApplication *) app :(NSString *) value
{
    //Start code section for string diesect and send
    NSUInteger len = [value length];
    unichar buffer[len+1];

    [value getCharacters:buffer range:NSMakeRange(0, len)];

    NSLog(@"getCharacters:range: with unichar buffer");
    for(int i = 0; i < len; i++) {
        NSString *newValue = [NSString stringWithFormat:@"%C", buffer[i]];

        if ([newValue length] > 0)
        {
            if ([newValue isEqual:@" "])
            {
                newValue = @"space";
            }
            [app.keys[newValue] tap];
        }
    }
}

@end
