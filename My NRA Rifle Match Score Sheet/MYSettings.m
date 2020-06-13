//
//  MYSettings.m
//  MyEssentialOilRemedies
//
//  Created by burnsoft on 6/23/16.
//  Copyright © 2016 burnsoft. All rights reserved.
//

#import "MYSettings.h"

@implementation MYSettings
/*!
 @brief  Check to see if the application is the full or lite version, if it is the lite version it will restrict the number of items that can be entered into the application.
 @return return <#description#>True if it is the Lite version and False if it is the full version
 */
+(BOOL) IsLiteVersion
{
    NSString *targetName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];

    if ([targetName isEqualToString: @FULLVERSIONNAME])
    {
        return NO;
    } else {
        return YES;
    }
}
@end
