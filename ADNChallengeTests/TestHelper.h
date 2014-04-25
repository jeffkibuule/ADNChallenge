//
//  TestHelper.h
//  ADNChallenge
//
//  Created by Joefrey Kibuule on 8/9/13.
//  Copyright (c) 2013 Joefrey Kibuule. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

@interface TestHelper : NSObject

// Grabs JSON from a data file
+ (id)dataFromJSONFileNamed:(NSString *)fileName;

@end
