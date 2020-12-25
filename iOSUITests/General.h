//
//  NSObject+General.h
//  iOSUITests
//
//  Created by burnsoft on 12/24/20.
//  Copyright © 2020 burnsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

NS_ASSUME_NONNULL_BEGIN

@interface General: NSObject
+(void)sendTextToKeyBoard:(XCUIApplication *) app :(NSString *) value;
@end

NS_ASSUME_NONNULL_END
