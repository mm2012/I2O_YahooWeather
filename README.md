Readme

This Custom class accesses Yahoo web service data and parses it for current Weather. Data is received in RSS/XML format.
A fully functional Xcode Project is provided which illustrates the usage of this custom class. Project is targeted for iOS 5.0 upwards.


- Accompanying Project example uses Glasgow`s WOEID to get current weather for Glasgow
- Uses NSXMLParser to parse and process Yahoo`s current weather data into RSS Channel and RSSItem Custom classes.
- Uses a modified version of Apple`s Reachability Class to check network connectivity.

Note:
- Please Add SystemConfiguration.framework must be added to the Project (used by Reachability) 


(c) 2013 Mikki Mann