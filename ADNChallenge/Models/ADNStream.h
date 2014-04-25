//
//  ADNStream.h
//  ADNChallenge
//
//  Created by Joefrey Kibuule on 8/8/13.
//  Copyright (c) 2013 Joefrey Kibuule. All rights reserved.
//

#import <Foundation/Foundation.h>

/* Class: ADNStream
 Purpose: Stores all data about a specific ADNStream through an array of posts
 Methods:
 1) streamRefreshedWithError
 Unit tests:   */

@class ADNPost;

// Protocol used to notify a class that the stream has been refreshed with new data (or potential errors)
@protocol ADNStreamDelegate

@required
- (void) streamRefreshed;

@end



@interface ADNStream : NSObject

@property (nonatomic, copy) NSString *streamName;
@property (nonatomic, copy) NSMutableArray *streamPostsArray;
@property (nonatomic, copy) NSString *streamAPIPointURL;
@property (nonatomic, weak) id<ADNStreamDelegate> streamDelegate;


// Methods
- (void) setAPIPoint: (NSString *) APIPoint;
- (void) refreshStream;
- (void) fetchedData: (NSData *)responseData;
- (void) addPostsFromJSON: (NSArray *)JSONDict;


- (NSUInteger) numPosts;
- (ADNPost *) createPostFromDict: (NSDictionary *) postDict;
- (void) addPost: (ADNPost *) adnPost position:(NSUInteger) postPosition;
- (ADNPost *) getPostAtIndex: (NSUInteger) postIndex;

- (void) didReceiveMemoryWarning;
// Unit tests

@end
