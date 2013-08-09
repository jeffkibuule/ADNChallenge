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
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData 
                          
                          options:kNilOptions
                          error:&error];
    
    // Get all of the latests posts
    NSArray* latestPosts = [json objectForKey:@"data"]; 
    
    // Make sure there are no errors
    if (!error)
    {
        // Go through all of the latest posts in *reverse order* so that we only add new ones
        // If there are no new posts in the array, we don't need to check then
        if ([self.streamPostsArray count] == 0)
        {
            // Go through all of the latest posts
            for (NSDictionary *postDict in latestPosts)
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
            
            for (NSDictionary *postDict in latestPosts)
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
    
    // Notify the delegate of our results
    if (streamDelegate != nil)
        [streamDelegate streamRefreshedWithError:error];
    else
        NSLog (@"No delegate for %@ stream has been set", self.streamName);
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
    // 
    [streamPostsArray addObject:adnPost];
    
    
    NSLog(@"Added %@'s post to %@ stream array. Now %d post(s) in stream.", adnPost.profileName, self.streamName, [self numPosts]);
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
