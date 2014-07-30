//
//  RSSItem.m
//  YahooWeatherStation
//
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


#import "RSSItem.h"
#import "RSSChannel.h"

@implementation RSSItem

@synthesize title, link, parentParserDelegate;

int forecast_ctr = 0; // YahooRSS has two yweather:forcast tags (today and tommrow)

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
   attributes:(NSDictionary *)attributeDict
{
    
    RSSITEM_LOG(@"%@ found a %@ element", self, elementName);
    // currentElement = [[NSString alloc] initWithString:elementName];
    
    if ([elementName isEqual:@"title"]) {
        currentString = [[NSMutableString alloc] init];
        [self setTitle:currentString];
    } // if
    else if ([elementName isEqual:@"link"]) {
        currentString = [[NSMutableString alloc] init];
        [self setLink:currentString];
    } // else if
    else if ([elementName isEqual:@"yweather:condition"]) {
        if ([attributeDict count] > 0) {
            RSSITEM_LOG(@"\n>yweather:condition (%d) %@/n/n",[attributeDict count], attributeDict);
            [parentParserDelegate setYapiCondition:attributeDict]; // set parent's (RSSChannel) iVar
        } //if
    } // else if
    else if ([elementName isEqual:@"yweather:forecast"]) {
        forecast_ctr++;
        if ([attributeDict count] > 0) {
            RSSITEM_LOG(@"\n>yweather:forecast (%d-%d) %@/n/n",forecast_ctr, [attributeDict count], attributeDict);
            switch (forecast_ctr) {
                case 1:
                    [parentParserDelegate setYapiForecastToday:attributeDict]; // set parent's (RSSChannel) iVar
                    break;
                case 2:
                    [parentParserDelegate setYapiForecastTommorow:attributeDict]; // set parent's (RSSChannel) iVar
                    forecast_ctr=0;
                    break;
                default:
                    break;
            } // switch
        } //if
    } // else if
    
} // didStartElement:

-(void)parser:(NSXMLParser *)parser
foundCharacters:(NSString *)str
{
    [currentString appendString:str];
    // DEBUG_LOG(@">(RSSItem)parser:foundCharacters: %@, currentString: %@ \n",str, currentString);
}

-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
    // DEBUG_LOG(@"**ended element: %@\n", elementName);
    
    currentString = nil;
    
    if([elementName isEqual:@"item"]) {
        // pass up control
        [parser setDelegate:parentParserDelegate];
    } // if
    
} // didEndElement

@end
