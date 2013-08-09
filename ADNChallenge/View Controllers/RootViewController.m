//
//  RootViewController.m
//  ADNChallenge
//
//  Created by Joefrey Kibuule on 8/8/13.
//  Copyright (c) 2013 Joefrey Kibuule. All rights reserved.
//

#import "RootViewController.h"

#import "ADNStream.h"
#import "ADNPost.h"
#import "ADNPostCell.h"

@interface RootViewController ()

@end 

@implementation RootViewController

@synthesize streamRefreshControl;

@synthesize adnPlaceholderImage;

@synthesize profileNameFont;
@synthesize profileUsernameFont;
@synthesize postTextFont;

@synthesize globalStream;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        // Custom initialization
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup the refresh control
    streamRefreshControl = [[UIRefreshControl alloc] init];
    [streamRefreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = streamRefreshControl;
    
    // Setup the data object
    globalStream = [[ADNStream alloc] init];
    globalStream.streamName = @"App.net Global Stream";
    globalStream.streamDelegate = self;
    [globalStream setAPIPoint:@"https://alpha-api.app.net/stream/0/posts/stream/global"];
    [globalStream refreshStream];
    
    // Cache the system fonts used when evlanuating the appropriate width and height of UILabel objects
    profileNameFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0];            // Bill Gates
    profileUsernameFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0];       // @billgates
    postTextFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];              // I am Bill Gates
    
    // Set the title
    self.title = globalStream.streamName;
    
    // Load the ADN profile placeholder image
    adnPlaceholderImage = [UIImage imageNamed:@"ADNPlaceholderImage.png"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Custom Methods
- (void)streamRefreshedWithError:(NSError *)error
{
    // No longer refreshing
    [streamRefreshControl endRefreshing];
    
    if (error == nil)
        [self.tableView reloadData];
    else
        NSLog(@"Error loading data: %@", [error description]);
}

#pragma mark -
#pragma mark Refresh Control Methods
-(void)refreshView:(UIRefreshControl *)refresh {
    streamRefreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    
    // custom refresh logic would be placed here...
    [globalStream refreshStream];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
    streamRefreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
}

#pragma mark -
#pragma mark Table Data Source Methods
// This function gets called to find out how many sections are in the table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1; // Only 1 section
}

// This function gets called to find out the number of rows for a particular section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"num posts: %d", [globalStream numPosts]);
	return [globalStream numPosts]; // return current number of posts
}


#pragma mark -
#pragma mark Table View Delegate Methods
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ADNPostCellIdentifier = @"ADNPostCellIdentifier";
	
	// Get the section and row
	NSUInteger section = [indexPath section];
	NSUInteger row = [indexPath row];
    
    ADNPost *adnPost = [globalStream getPostAtIndex: row];
    
    // Get the cell XIB
    ADNPostCell *cell = (ADNPostCell *)[tableView dequeueReusableCellWithIdentifier:ADNPostCellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ADNPostCell"  owner:self options:nil];
        cell = (ADNPostCell *)[nib objectAtIndex:0];
    }
    
    // Load the profile image asychrononously to prevent blocking of the UI thread
    if (adnPost.profileImage == nil)
    {
        // Haven't downloaded this image, set a placeholder image then grab the real one off the web
        cell.profileImage.image = adnPlaceholderImage;
        
        NSString *imageUrl = adnPost.profileImageURL;
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            cell.profileImage.image = [UIImage imageWithData:data];
            adnPost.profileImage = [UIImage imageWithData:data];
        }];
    }
    else
    {
        // We've already cached this image, set it again
        cell.profileImage.image = adnPost.profileImage;
    }
    
    // Fill in profile name and username
    cell.profileName.text = adnPost.profileName;
    cell.profileUsername.text = adnPost.profileUsername;
    cell.postText.text = adnPost.postText;
    
    
    // Adjust the label the the new height.
    CGSize maximumLabelSize = CGSizeMake(kPostTextViewWidth,9999);
    CGSize expectedLabelSize = [adnPost.postText sizeWithFont:postTextFont constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect newFrame = CGRectMake(64, 20, kPostTextViewWidth, 32);
    
    // Set the height of the label
    newFrame.size.height = expectedLabelSize.height+20;
    cell.postText.frame = newFrame;
     
    // Adjust the size of the username 
    maximumLabelSize = CGSizeMake(kMaxUsernameWidth,9999);  // Prevent overrun of the profile name pushing the username off the screen
    expectedLabelSize = [adnPost.profileName sizeWithFont:profileNameFont constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    cell.profileName.frame = CGRectMake (cell.profileName.frame.origin.x, cell.profileName.frame.origin.y, expectedLabelSize.width, cell.profileName.frame.size.height);
    
    
    // Adjust the size and position of the profile username based on the position of profileName
    expectedLabelSize = [adnPost.profileUsername sizeWithFont:profileUsernameFont constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    cell.profileUsername.frame = CGRectMake (cell.profileName.frame.origin.x + cell.profileName.frame.size.width + 5, cell.profileUsername.frame.origin.y, expectedLabelSize.width, 15);
    
    
    return cell;
}

// Customize the height of the table view cell based on the text size
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get the section and row
	NSUInteger section = [indexPath section];
	NSUInteger row = [indexPath row];
    
    NSUInteger height;
    ADNPost *adnPost = [globalStream getPostAtIndex:row];
    
    CGSize maximumLabelSize = CGSizeMake(kPostTextViewWidth,9999);
	CGSize expectedLabelSize = [adnPost.postText sizeWithFont:postTextFont constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
	
    // Set the height of the label and enforce a minimum height
	height = (expectedLabelSize.height+40 > 72 ? expectedLabelSize.height+40 : 72);
    
    return height;
}

@end
