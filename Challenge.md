##ADNChallenge
==================

####ADNChallenge for ChaiOne

TEXT

###General: Create an App.net client that just lists the most recent posts from the public timeline.

###Specifics:
1. Each post should be rendered in a table view cell, with the most recent at the top.
2. Each cell should contain the user's avatar (bonus if the corners are rounded)
3. Each cell should contain the poster's name in bold
4. Each cell should contain the post text, and be variable height, depending on the text size
5. Pull to refresh should be implemented to refresh the timeline
6. The list should scroll quickly, without dropping frames on an iPhone 5

###Interpretation
1. General list of App.net posts, likely using UITableViewController
2. Custom UITableViewCell with users avatar, add a mask to generate corners
3. UILabel with bold text for poster's name
4. More UILabels with text, variable height requires loading the string and computing the height to adjust the size of the UITableViewCell
5. Pull to refresh should load new posts and add them to the UITableViewController table items. 
6. Optimize for performance, iPhone 5 is a reasonable target, though a slow network may make it appear slow (think EDGE, poor signal, etc)

####Likely classes:
1. Class that stores just individual App.net posts. Will be a direct representation of JSON information. Mainly stores data, nothing more. Need username, avatar image, and post text. Can be called ADNPost.
2. Class that stores many ADNPosts. Will take an API end point to parse and store that data. Should be easily reusable for global streams, user streams, messages, etc. Cal be called ADNStream
3. Class that requests post specific to global stream. Can be called ADNGlobalStream. Other classes similar to this would be named ADNUserStream for users posts and ADNMessageStream for users private messages. Update: class not needed.

####Likely view controllers:
1. Single view controller that handles global stream. Will contian one ADNGlobalStream object. Will check for network connectivity, then load data. Also have call to refresh data if pull to refresh is initiated. Needs to also handle slow network connectivity.

####Potential pitfalls:
1. Loading network data can be slow. Network code should be spun off into a separate thread to prevent blocking of the main UI thread. 
2. Loading images can be especially slow. Most users WiFi connections are fast enough to load tiny images in advance, but avatars should only be loaded when needed when on cellular. Update: use placeholder images until profile images are loaded over the web

####Unit Tests:
Will create mirror classes mapping to each relevelant class that tests functionality. Update: Created a single test case for parsing of JSON. Also created another unit test case for making sure posts added are not already present in the stream.

Other:
1. Likely use JSON library to load and parse data. Update: JSON support built directly into iOS frameworks as of iOS 5.
