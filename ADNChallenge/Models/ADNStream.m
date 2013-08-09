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
        // Go through all of the latest posts
        for (NSDictionary *postDict in latestPosts)
        {
            // Process each dictionary item
            ADNPost *adnPost = [[ADNPost alloc] init];
            adnPost.postJSONDict = postDict;
            [adnPost processJSON];
            
            // Special case, can only insert an object if an object already exists, otherwise do a normal add
            if ([streamPostsArray count] == 0)
                [streamPostsArray addObject:adnPost];
            else
            {
                [streamPostsArray insertObject:adnPost atIndex:0];
            }
            
            // Do we get data?
            NSLog(@"name: %@", adnPost.profileName);
            NSLog(@"image url: %@", adnPost.profileImageURL);
        }
    }
    
    // Notify the delegate of our results
    if (streamDelegate != nil)
        [streamDelegate streamRefreshedWithError:error];
    else
        NSLog (@"No delegate for %@ stream has been set", self.streamName);
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