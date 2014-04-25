//
//  ADNStream.m
//  ADNChallenge
//
//  Created by Joefrey Kibuule on 8/8/13.
//  Copyright (c) 2013 Joefrey Kibuule. All rights reserved.
//

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#import "ADNStream.h"

#import "ADNPost.h"

@implementation ADNStream

// Initialize the class
- (id) init
{
    if (self = [super init])
    {
        // Initialize objects
        self->_streamName = @"";
        self->_streamPostsArray = [[NSMutableArray alloc] init];
        
        self->_streamAPIPointURL = @"";
    }
    
    return self;
}

// Sets the API point for this class
- (void) setAPIPoint:(NSString *)APIPointURL
{
    self.streamAPIPointURL = APIPointURL;
}

// Refreshes the stream by asking for more data via JSON via an asynchronous even to prevent thread blocking
- (void) refreshStream
{
    // We use Grand Central Dispatch to pull data from the Internet on a background queue to prevent blocking of the UI thread
    // fetchedData will get called when we have data (or an error occurs)
    __weak ADNStream *weakSelf = self;
    NSURL *adnGlobalStreamURL = [NSURL URLWithString:self.streamAPIPointURL];
    dispatch_async(kBgQueue, ^{
        ADNStream *strongSelf = weakSelf;
        
        NSData* data = [NSData dataWithContentsOfURL: adnGlobalStreamURL];
        [strongSelf fetchedData:data];
    });
}

// Parses the new data into our data structure (ADNPost)
- (void)fetchedData:(NSData *) responseData {
    // Parse out the JSON data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    // Get all of the latests posts
    NSArray* latestPosts =  json[@"data"];
    
    // Make sure there are no errors
    if (!error)
    {
        [self addPostsFromJSON:latestPosts];
        
        // Notify the delegate of our results
        if (self.streamDelegate)
            [self.streamDelegate streamRefreshed];
    }
    else
        NSLog (@"No delegate for %@ stream has been set", self.streamName);
}

- (void) addPostsFromJSON: (NSArray *)JSONArray
{
    // Go through all of the latest posts in *reverse order* so that we only add new ones
    // If there are no new posts in the array, we don't need to check then
    if ([self.streamPostsArray count] == 0)
    {
        // Go through all of the latest posts
        for (NSDictionary *postDict in JSONArray)
        {
            // Process each dictionary item and create a new post
            [self addPost:[self createPostFromDict:postDict] position:0];
        }
    }
    else
    {
        // Previous top item
        ADNPost *topPost = [self.streamPostsArray objectAtIndex:0];
        NSMutableArray *newPostsArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *postDict in JSONArray)
        {
            // Process each dictionary item
            ADNPost *post = [self createPostFromDict:postDict];
            
            // Check and see if the top item has the same ID, if it does, then this post already exists in the stream, otherwise add it
            if ([post.postTimestampDate compare:topPost.postTimestampDate] == NSOrderedDescending)
            {
                [newPostsArray addObject:post];
            }
        }
        
        [newPostsArray addObjectsFromArray:self.streamPostsArray];
        self.streamPostsArray = newPostsArray;
        newPostsArray = nil;
    }
}

// Creates a ADN post from a NSDictionary full of JSON data
- (ADNPost *) createPostFromDict: (NSDictionary *) postDict
{
    ADNPost *adnPost = [[ADNPost alloc] init];
    adnPost.postJSONDict = postDict;
    [adnPost processJSON];
    
    return adnPost;
}

// Adds a post from the stream to the array
- (void) addPost: (ADNPost *) adnPost position:(NSUInteger) postPosition
{
    [self.streamPostsArray addObject:adnPost];
    
    //NSLog(@"Added %@'s post to %@ stream array. Now %lu post(s) in stream.", adnPost.profileName, self.streamName, (unsigned long)[self numPosts]);
}

// Returns the number of posts in this stream
- (NSUInteger) numPosts
{
    // Make sure we have a data array
    if (self.streamPostsArray)
        return [self.streamPostsArray count];
    
    // Something went wrong
    NSLog (@"streamPostArray object is dead");
    
    return 0;
}

// Gets the post at a specific index in the stream
- (ADNPost *) getPostAtIndex:(NSUInteger ) postIndex
{
    // Check and make sure the request is in-bounds
    if (postIndex < [self.streamPostsArray count])
        return self.streamPostsArray[postIndex];
    
    NSLog(@"Requesting post #%lu in %@ stream which is out of bounds", (unsigned long)postIndex, self.streamName);
    return nil;
}

// This will be called when the OS received a memory warning, we loop through and dump all images stored
- (void)didReceiveMemoryWarning
{
    for (ADNPost *post in self.streamPostsArray)
    {
        // Set all images to nil, it will be reloaded if needed by the tableview
        post.profileImage = nil;
    }
}


@end
