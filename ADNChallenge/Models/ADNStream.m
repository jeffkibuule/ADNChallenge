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

- (void) setAPIPoint:(NSString *)APIPointURL
{
    streamAPIPointURL = APIPointURL;
}

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

- (void)fetchedData:(NSData *) responseData {
    // Parse out the JSON data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData 
                          
                          options:kNilOptions
                          error:&error];
    
    NSArray* latestPosts = [json objectForKey:@"data"];
    
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
            [streamPostsArray insertObject:adnPost atIndex:0];
        
        NSLog(@"name: %@", adnPost.profileName);
    }
    
    
    
    
    
    //NSLog(@"posts: %@", latestPosts);
}


@end
