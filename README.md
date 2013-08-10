ADNChallenge
==================

ADNChallenge for ChaiOne


Simple App.net client that reads from the global stream and outputs most recent posts into a UITableView. The table supports pull to refresh popularized by Tweetie. The pull to refresh control also indicates the last time the app was refreshed. If the app is launched with no data connection, the user is notified with an alert (presented only once). Should the app regain connectivity either through Settings.app, Control Center toggles in iOS 7, or a previously poor connection now working, the stream will refresh automatically. Profile images are loaded asynchronously in the background using Grand Central Dispatch. Placeholder images are used as that data is being downloading for a more pleasing asthetic. Images are rounded through a mask layer using Quartz2D and then cached for better scrolling performance. Each cell is appropriately designed similar to other App.net and Twitter apps with a user's image, profile name (in bold), post text, and post timestamp. Post time stamp is in hours:minutes:seconds format to ensure that each post is in the correct order when refreshed as duplicate posts should not be allowed from loaded JSON data.

Future potential tasks:
1) API refresh only calls last 20 posts, not posts since the topmost post.
2) Twitter and App.net clients often show a timestamp in relative time, not absolute time, also posts within the last second tick each second
3) Selecting a post and displaying detailed information about it
4) User interactions (adding a post to user stream, deleting post from user stream, favoriting a post, following and unfollowing a user, etc...)
5) Storing data in a database so that previously loaded tweets from a previous app run are maintained either through a SQLite library or CoreData
6) Receiving push notifications from App.net directly