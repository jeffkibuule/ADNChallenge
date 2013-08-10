//
//  TestHelper.m
//  ADNChallenge
//
//  Created by Joefrey Kibuule on 8/9/13.
//  Copyright (c) 2013 Joefrey Kibuule. All rights reserved.
//

#import "TestHelper.h"

@implementation TestHelper

#pragma mark -
#pragma mark Helper Methods
+ (id)dataFromJSONFileNamed:(NSString *)fileName
{
    //    NSString *resource = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:fileName ofType:@"json"];
    
    if (NSClassFromString(@"NSJSONSerialization"))
    {
        NSInputStream *inputStream = [NSInputStream inputStreamWithFileAtPath:resource];
        [inputStream open];
        
        return [NSJSONSerialization JSONObjectWithStream:inputStream options:0 error:nil];
    }
    
    //STFail(@"Couldn't load data");
    return nil;
}

@end
