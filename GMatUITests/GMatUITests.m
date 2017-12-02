//
//  GMatUITests.m
//  GMatUITests
//
//  Created by hublot on 2017/1/6.
//  Copyright © 2017年 thinku. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface GMatUITests : XCTestCase

@end

@implementation GMatUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = true;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
	
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}
//
//- (void)testExample {
//	
//	
////	[NSThread sleepUntilDate:[NSDate distantFuture]];
//}

- (void)testSmallKnowledgePointBook {
	[NSThread sleepForTimeInterval:2];
	
	XCUIApplication *app = [[XCUIApplication alloc] init];
	[app.tabBars.buttons[@"\u5c0f\u8bb2\u5802"] tap];
	[NSThread sleepForTimeInterval:0.5];
	
	XCUIElementQuery *tablesQuery2 = app.tables;
	XCUIElement *crButton = tablesQuery2.buttons[@"\u903b\u8f91CR"];
	[crButton tap];
	[NSThread sleepForTimeInterval:0.5];
	
	XCUIElement *backButton = app.navigationBars[@"\u903b\u8f91CR"].buttons[@"Back"];
	[backButton tap];
	[NSThread sleepForTimeInterval:0.5];
	
	XCUIElementQuery *tablesQuery = tablesQuery2;
	[tablesQuery.buttons[@"\u8bed\u6cd5SC"] tap];
	[NSThread sleepForTimeInterval:0.5];
	
	[app.navigationBars[@"\u8bed\u6cd5SC"].buttons[@"Back"] tap];
	[NSThread sleepForTimeInterval:0.5];
	
	[tablesQuery.buttons[@"\u9605\u8bfbRC"] tap];
	[NSThread sleepForTimeInterval:0.5];
	
	[app.navigationBars[@"\u9605\u8bfbRC"].buttons[@"Back"] tap];
	[NSThread sleepForTimeInterval:0.5];

	[tablesQuery.buttons[@"\u6570\u5b66Q"] tap];
	[NSThread sleepForTimeInterval:0.5];

	[app.navigationBars[@"\u6570\u5b66Q"].buttons[@"Back"] tap];
	[NSThread sleepForTimeInterval:0.5];

	[crButton tap];
	[NSThread sleepForTimeInterval:0.5];

	[tablesQuery.staticTexts[@"CR\u5907\u8003\u7bc7"] tap];
	[NSThread sleepForTimeInterval:0.5];

	[tablesQuery.staticTexts[@"CR\u89e3\u9898\u601d\u8def"] tap];
	[NSThread sleepForTimeInterval:0.5];

	
	XCUIElement *textView = [[[[[[[[[[[[[app childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeTextView].element;
	[textView swipeUp];
	[NSThread sleepForTimeInterval:0.5];

	[textView swipeUp];
	[NSThread sleepForTimeInterval:0.5];

	[app.navigationBars[@"CR\u89e3\u9898\u601d\u8def"].buttons[@"Back"] tap];
	[NSThread sleepForTimeInterval:0.5];

	[app.navigationBars[@"CR\u5907\u8003\u7bc7"].buttons[@"Back"] tap];
	[NSThread sleepForTimeInterval:0.5];

	[backButton tap];
	[NSThread sleepForTimeInterval:0.5];

}

@end
