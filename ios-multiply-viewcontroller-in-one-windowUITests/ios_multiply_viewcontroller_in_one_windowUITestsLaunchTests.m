//
//  ios_multiply_viewcontroller_in_one_windowUITestsLaunchTests.m
//  ios-multiply-viewcontroller-in-one-windowUITests
//
//  Created by 肖湘 on 2021/10/12.
//

#import <XCTest/XCTest.h>

@interface ios_multiply_viewcontroller_in_one_windowUITestsLaunchTests : XCTestCase

@end

@implementation ios_multiply_viewcontroller_in_one_windowUITestsLaunchTests

+ (BOOL)runsForEachTargetApplicationUIConfiguration {
    return YES;
}

- (void)setUp {
    self.continueAfterFailure = NO;
}

- (void)testLaunch {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];

    // Insert steps here to perform after app launch but before taking a screenshot,
    // such as logging into a test account or navigating somewhere in the app

    XCTAttachment *attachment = [XCTAttachment attachmentWithScreenshot:XCUIScreen.mainScreen.screenshot];
    attachment.name = @"Launch Screen";
    attachment.lifetime = XCTAttachmentLifetimeKeepAlways;
    [self addAttachment:attachment];
}

@end
