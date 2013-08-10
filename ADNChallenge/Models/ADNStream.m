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

@synthesize streamName;
@synthesize streamPostsArray;

@synthesize streamAPIPointURL;

@synthesize streamDelegate;

// Initialize the class
- (id) init
{
    if (self = [super init])
    {
        // Initialize objects
        streamName = @"";
        streamPostsArray = [[NSMutableArray alloc] init];
        
        streamAPIPointURL = @"";
    }
    
    return self;
}

// Sets the API point for this class
- (void) setAPIPoint:(NSString *)APIPointURL
{
    streamAPIPointURL = APIPointURL;
}

// Refreshes the stream by asking for more data via JSON via an asynchronous even to prevent thread blocking
- (void) refreshStream
{
    // We use Grand Central Dispatch to pull data from the Internet on a background queue to prevent blocking of the UI thread
    // fetchedData will get called when we have data (or an error occurs)
    NSURL *adnGlobalStreamURL = [NSURL URLWithString:streamAPIPointURL];
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: adnGlobalStreamURL];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
    });
}

// Parses the new data into our data structure (ADNPost)
- (void)fetchedData:(NSData *) responseData {
    // Parse out the JSON data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    // Get all of the latests posts
    NSArray* latestPosts = [json objectForKey:@"data"]; 
    
    // Make sure there are no errors
    if (!error)
    {
        [self addPostsFromJSONArray:latestPosts];
    }
    
    // Notify the delegate of our results
    if (streamDelegate != nil)
        [streamDelegate streamRefreshedWithError:error];
    else
        NSLog (@"No delegate for %@ stream has been set", self.streamName);
}

// Adds posts from an array to our stream array
- (void) addPostsFromJSONArray: (NSArray *) latestPosts
{
    // If there are no posts in the stream, we can just add all of them
    if ([self.streamPostsArray count] == 0)
    {
        // Go through all of the latest posts
        for (NSDictionary *postDict in latestPosts)
        {
            // Process each dictionary item and create a new post
            ADNPost *post = [[ADNPost alloc] init];
            [post getPostFromDict:postDict];
            [streamPostsArray addObject:post];
        }
    }
    
    // Since there are posts in the stream, we need to make sure that we only add those that are newer than the one on the top (the newest item)
    else
    {
        
        // Previous top item
        ADNPost *topPost = [self.streamPostsArray objectAtIndex:0];
        NSMutableArray *newPostsArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *postDict in latestPosts)
        {
            // Process each dictionary item
            ADNPost *post = [[ADNPost alloc] init];
            [post getPostFromDict:postDict];
            
            // Compare the date times, the post needs to be newer than the top post to be added
            if ([post.postTimestampDate compare:topPost.postTimestampDate] == NSOrderedDescending)
            {
                [newPostsArray addObject:post];
            }
        }
        
        // Add all of the new posts in FRONT of the previous newest post
        [newPostsArray addObjectsFromArray:self.streamPostsArray];
        self.streamPostsArray = newPostsArray;
        newPostsArray = nil; // We set this to nil to release those objects, even if we have ARC, just in case
    }
    
    // Sanity check - are we getting good data?
    //NSLog(@"Added %@'s post to %@ stream array. Now %d post(s) in stream.", adnPost.profileName, self.streamName, [self numPosts]);
}

// Returns the number of posts in this stream
- (NSUInteger) numPosts
{
    // Make sure we have a data array
    if (streamPostsArray != nil)
        return [streamPostsArray count];
    
    // Something went wrong
    NSLog (@"streamPostArray object is dead");
    
    return 0;
}

// Gets the post at a specific index in the stream
- (ADNPost *) getPostAtIndex:(NSUInteger ) postIndex
{
    // Check and make sure the request is in-bounds
    if (postIndex < [streamPostsArray count])
        return [streamPostsArray objectAtIndex:postIndex];
    
    NSLog(@"Requesting post #%d in %@ stream which is out of bounds", postIndex, self.streamName);
    return nil;
}


@end
