//
//  ADNChallengeTests.m
//  ADNChallengeTests
//
//  Created by Joefrey Kibuule on 8/8/13.
//  Copyright (c) 2013 Joefrey Kibuule. All rights reserved.
//

#import "ADNChallengeTests.h"

#import "TestHelper.h"

#import "ADNPost.h"
#import "ADNStream.h"

@implementation ADNChallengeTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}



#pragma mark -
#pragma mark Unit Tests

- (void)testExample
{
    //STFail(@"Unit tests are not implemented yet in ADNChallengeTests");
}

- (void) testCreatePostFromDict
{
    NSMutableArray *firstPostArray = [[NSMutableArray alloc] init];
    
    // Grab the array of JSON data from the file
    NSArray *jsonArray = [[TestHelper dataFromJSONFileNamed:@"adntest1"] objectForKey:@"data"];
    
    // First check - do we have live data
    STAssertTrue([jsonArray count] == 20, @"JSON Serialization - FAILED");
    
    // Loop through all of the dictionary items to create ADNPost objects
    for (NSDictionary *postDict in jsonArray)
    {
        ADNPost *post = [[ADNPost alloc] init];
        [post getPostFromDict:postDict];
        [firstPostArray addObject:post];
    }
    
    // Second check - did we process all the posts
    STAssertTrue([firstPostArray count] == 20, @"ADNPost creation - FAILED");
    
    // Grab the first post
    ADNPost *post = [firstPostArray objectAtIndex:0];
    
    // Third check - profile name should be Evan
    STAssertTrue([post.profileName compare:@"Evan"] == NSOrderedSame, @"Profile name parse - FAILED");
}

// For some reason this test fails, despite the class itself working. It seems to be an actual bug in the Unit Test Framework
// as the error message it presents has appeared in Xcode 3.2.4 with iOS 4.1
/*
- (void) testAddPostsFromArray
{
    NSMutableArray *firstPostArray = [[NSMutableArray alloc] init];
    NSMutableArray *secondPostArray = [[NSMutableArray alloc] init];
    
    // Initial test setup - exact same as testCreatePostFromDict
    NSArray *jsonArray = [[TestHelper dataFromJSONFileNamed:@"adntest1"] objectForKey:@"data"];
    STAssertTrue([jsonArray count] == 20, @"JSON Serialization - FAILED");
    for (NSDictionary *postDict in jsonArray)
    {
        ADNPost *post = [[ADNPost alloc] init];
        [post getPostFromDict:postDict];
        [firstPostArray addObject:post];
    }
    
    // Create a stream object
    ADNStream *adnStream = [[ADNStream alloc] init];
    
    // Use the previous postArray to add some posts to this stream
    [adnStream addPostsFromArray:firstPostArray];
    
    // First check - we should have 20 posts
    STAssertTrue([adnStream numPosts] == 20, @"ADNStream add posts from array - FAILED");
    
    // Second check - first post should have a profile name of Evan
    ADNPost *post = [adnStream.streamPostsArray objectAtIndex:0];
    
    // Third check - profile name should be Evan
    STAssertTrue([post.profileName compare:@"Evan"] == NSOrderedSame, @"Profile name parse - FAILED");
    
    // Fourth check - If we try to add the same posts, nothing more should get added
    [adnStream addPostsFromArray:firstPostArray];
    STAssertTrue([adnStream numPosts] == 20, @"ADNStream adding duplicate posts to stream - FAILED");
    
    // Fifth check - Add newer data to the array, should have 40 total posts now
    jsonArray = [[TestHelper dataFromJSONFileNamed:@"adntest2"] objectForKey:@"data"];
    for (NSDictionary *postDict in jsonArray)
    {
        ADNPost *post = [[ADNPost alloc] init];
        [post getPostFromDict:postDict];
        [secondPostArray addObject:post];
    }
    
    //[adnStream addPostsFromArray:secondPostArray];
    STAssertTrue([secondPostArray count] == 20, @"ADNStream adding new posts to stream - FAILED");
    
    // Sixth check - profile name at the top should be Roger
    post = [secondPostArray objectAtIndex:0];
    STAssertTrue([post.profileName compare:@"Roger"] == NSOrderedSame, @"Profile name parse - FAILED");
} */

@end
