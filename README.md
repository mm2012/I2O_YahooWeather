Readme

This Custom class provides current weather information for a given city identified by a WOEID.
For this Yahoo Weather's web service data is accessed and parsed. Data is received in RSS/XML format.
A fully functional Xcode Project is provided which illustrates the usage of this custom class. Project is targeted for iOS 5.0 upwards.


- Accompanying Project example uses Glasgow`s WOEID to get current weather for Glasgow
- NSXMLParser is used to parse data from Yahoo`s Weather web Service and create a object tree. Weather data is parsed into RSS Channel and RSSItem Custom classes.
- A modified version of Apple`s Reachability Class to listen for network connectivity.

Note:
- SystemConfiguration.framework must be added to the Project (used by Reachability) 


(c) 2013 Mikki Mann