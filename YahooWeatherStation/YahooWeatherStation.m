//
//  YahooWeatherStation.m
//  YahooWeatherStation
///
//  Copyright (c) 2013 Mikki Man,, Idea2Objects. All rights reserved.
//
/*
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 */



#import "YahooWeatherStation.h"
#import "RSSChannel.h"

@implementation YahooWeatherStation


@synthesize delegate;


/*------- data structure of received Channel data
 
 Condition: {
 code = 30;
 date = "Sun, 28 Apr 2013 2:18 pm BST";
 temp = 9;
 text = "Showers in the Vicinity";
 }
 
 Forecast-today: {
 code = 12;
 date = "28 Apr 2013";
 day = Sun;
 high = 8;
 low = 4;
 text = "Rain/Wind Late";
 }
 
 Forecast-tommrow: {
 code = 12;
 date = "29 Apr 2013";
 day = Mon;
 high = 9;
 low = 3;
 text = "Rain/Wind";
 }
 
 */

#pragma mark initialize

/*--- designated initialize  */

-(id)initWithRSSURL:(NSString*)RSSURL startFetch:(BOOL)f
{
    self = [super init];
    
    if (self && f) {
        [self fetchEntries:RSSURL];
    } //if
    
    return self;
}

/* any use of init will be redirected to Designated init */

-(id)init {
    
    @throw [NSException exceptionWithName:@"WeatherStation"
                                   reason:@"Provide a valid URL for the RSS feed."
                                 userInfo:nil];
    return nil;
}


#pragma mark URL data fetch

-(void)fetchEntries:(NSString*)RSSURL
{
    // create a data container for the stuff that comes from the web service
    xmlData = [[NSMutableData alloc] init];
    // concatenate a URL that will ask the (web) service for data
    NSURL *url  = [NSURL URLWithString:RSSURL];
    NSURLRequest *req =[NSURLRequest requestWithURL:url];// put that into a Request
    // create a connection - to request data
    connection = [[NSURLConnection alloc] initWithRequest:req
                                                 delegate:self
                                         startImmediately:YES];
}


-(void)connection:(NSURLConnection *)conn
   didReceiveData:(NSData *)data
{
    [xmlData appendData:data];
} // didReceivedata

-(void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    // create a SAX Parser object
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData]; // dump recvd data into Parser
    //set delegate
    [parser setDelegate:self];
    // tell Parser to start parsing AND delegate of the Parser will get all the Parser's messages
    //
    [parser parse];
    xmlData = nil; // we no londer need it
    connection = nil;
    
    /*
     DEBUG_LOG(@"\n\nChannel: %@\n Title: %@\n Infostring: %@\n Condition: %@, Forecast-today: %@, Forecast-tommrow: %@",
     channel, [channel title], [channel infoString], [channel yapiCondition],
     [channel yapiForecastToday], [channel yapiForecastTommorow]); */
    
    /* check to ensure XML data is received
     NSString *xmlCheck = [[NSString alloc] initWithData:xmlData
     encoding:NSUTF8StringEncoding];
     //show and tell
     NSLog(@"%@",xmlCheck); */
    
} //connectionDidFnishLoading:

#pragma mark URL connection - error processing

-(void)connection:(NSURLConnection *)conn
 didFailWithError:(NSError *)error
{
    connection = nil;
    xmlData = nil;
    
    [self showErrorMessage:error];
    
    
} // didFailWithError


#pragma mark parser stuff

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
   attributes:(NSDictionary *)attributeDict
{
    RSSCHANNEL_LOG(@"%@ found a %@ element", self, elementName);
    
    if ([elementName isEqual:@"channel"])
    {
        channel = [[RSSChannel alloc] init]; // if parser saw a channel element...
        [channel setParentParserDelegate:self]; // give channel object a pointer back to ourselsves for later
        [parser setDelegate:channel];
        
    } // if
    
} // didStartElement:

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    //DEBUG_LOG(@"\n\n...document ended.\n");
    
    DEBUG_LOG(@"\n**[self yapixxx]\n Channel: %@\n Title: %@\n Infostring: %@\n Condition: %@, Forecast-today: %@, Forecast-tommrow: %@",
              channel, [channel title],
              [channel infoString],
              [channel yapiCondition],
              [channel yapiForecastToday],
              [channel yapiForecastTommorow]);
    
    // pass message to Delegate object / invoke
    [[self delegate] didFinishParsingRSSDoc:self condition:[channel yapiCondition] forecastToday:[channel yapiForecastToday] forecastTommorow:[channel yapiForecastTommorow]];
    
} // didEndDocument:


#pragma mark error processing

-(void)showErrorMessage:(NSError*)error
{
    // invoke Delegate method / send message
    [[self delegate] didEncounterError:self errorDescription:[error localizedDescription]];
    
    
    DEBUG_LOG(@"YahooWeatherStation:Fetch failed: %@", [error localizedDescription]);
    /*
     //grab error descriptor
     NSString *errorString = [NSString stringWithFormat:
     @"Fetch failed: %@", [error localizedDescription]];
     ///create, show alert
     UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"URL error"
     message:errorString
     delegate:nil
     cancelButtonTitle:@"ok"
     otherButtonTitles:nil];
     [av show]; */
    
} // showErrorMessage:

-(NSString*)desc {
    return @"Yahoo Weather station from YahooWeather API for url";
}




@end
