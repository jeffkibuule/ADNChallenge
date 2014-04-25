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

- (void) testCreatePostFromDict
{
    NSMutableArray *firstPostArray = [[NSMutableArray alloc] init];
    
    // Grab the array of JSON data from the file
    NSArray *jsonArray = [[TestHelper dataFromJSONFileNamed:@"adntest1"] objectForKey:@"data"];
    
    // First check - do we have live data
    XCTAssertTrue([jsonArray count] == 20, @"JSON Serialization - FAILED");
    
    // Loop through all of the dictionary items to create ADNPost objects
    for (NSDictionary *postDict in jsonArray)
    {
        ADNStream *postStream = [[ADNStream alloc] init];
        ADNPost *post = [postStream createPostFromDict:postDict];
        [firstPostArray addObject:post];
    }
    
    // Second check - did we process all the posts
    XCTAssertTrue([firstPostArray count] == 20, @"ADNPost creation - FAILED");
    
    // Grab the first post
    ADNPost *post = [firstPostArray objectAtIndex:0];
    
    // Third check - profile name should be Evan
    XCTAssertTrue([post.profileName compare:@"Evan"] == NSOrderedSame, @"Profile name parse - FAILED");
}

// Tests adding posts to the the stream, then trying to add the same posts to the stream (nothing should happen), then adding new posts to the stream
- (void) testAddPostsFromArray
{
    // Initial test setup - exact same as testCreatePostFromDict
    NSArray *jsonArray = [[TestHelper dataFromJSONFileNamed:@"adntest1"] objectForKey:@"data"];
    XCTAssertTrue([jsonArray count] == 20, @"JSON Serialization - FAILED");
    
    // Create a stream object
    ADNStream *adnStream = [[ADNStream alloc] init];
    
    // Use the previous postArray to add some posts to this stream
    [adnStream addPostsFromJSON:jsonArray];
    
    // First check - we should have 20 posts
    XCTAssertTrue([adnStream numPosts] == 20, @"ADNStream add posts from array - FAILED");
    
    // Second check - first post should have a profile name of Evan
    ADNPost *post = [adnStream.streamPostsArray objectAtIndex:0];
    
    // Third check - profile name should be Evan
    XCTAssertTrue([post.profileName compare:@"Evan"] == NSOrderedSame, @"Profile name parse - FAILED");
    
    // Fourth check - If we try to add the same posts, nothing more should get added
    [adnStream addPostsFromJSON:jsonArray];
    XCTAssertTrue([adnStream numPosts] == 20, @"ADNStream adding duplicate posts to stream - FAILED");
    
    // Fifth check - Add newer data to the array, should have 40 total posts now
    jsonArray = [[TestHelper dataFromJSONFileNamed:@"adntest2"] objectForKey:@"data"];
    
    [adnStream addPostsFromJSON:jsonArray];
    XCTAssertTrue([adnStream numPosts] == 40, @"ADNStream adding new posts to stream - FAILED");
    
    // Sixth check - profile name at the top should be Roger Prokic
    post = [adnStream.streamPostsArray objectAtIndex:0];
    XCTAssertTrue([post.profileName compare:@"Roger Prokic"] == NSOrderedSame, @"Profile name parse - FAILED");
}

@end
