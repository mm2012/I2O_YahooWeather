//
//  RSSChannel.m
//  YahooWeatherStation
//
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


#import "RSSChannel.h"
#import "RSSItem.h"

@implementation RSSChannel

@synthesize items, title, infoString, yapiCondition,
yapiForecastToday, yapiForecastTommorow,
parentParserDelegate;

-(id)init
{
    self = [super init];
    
    if (self) {
        items = [[NSMutableArray alloc] init];
    } // self
    
    return self;
}

#pragma mark parser stuff

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
   attributes:(NSDictionary *)attributeDict  {
    
    RSSCHANNEL_LOG(@"%@ found element: %@",
              self, elementName);
    
    if ([elementName isEqual:@"title"]) {
        currentString = [[NSMutableString alloc] init];
        [self setTitle:currentString];
    } // if
    else if ([elementName isEqual:@"description"]) {
        currentString = [[NSMutableString alloc] init ];
        [self setInfoString:currentString];
    } // else if
    // --- if its an "item" (child element), drill-down to its child elements
    else if ([elementName isEqual:@"item"]){
        RSSItem *entry = [[RSSItem alloc] init]; // create child
        
        [entry setParentParserDelegate:self];  // set parent delegate so control can be returned
            // from child (RSSItem) back to parent (RSSChannel)

            // set parser to RSSItem
        [parser setDelegate:entry];
       
      [items addObject:entry];
        DEBUG_LOG(@"\nItems > %@", items);
    }// else if
    
}  // didStartElement

-(void)parser:(NSXMLParser *)parser
foundCharacters:(NSString *)str
{
    [currentString appendString:str];
            //RSSCHANNEL_LOG(@"\n(channel)parser > foundCharacters - str:%@, currentString: %@\n",str, currentString);
    
} // foundCharacters

-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
    // if we were in an Element that were we were collecting string for,
    // this releases our hold on it and the permamanent instance variable keeps ownership now
    // if werent parsing such an element, currentString is nil already
    currentString = nil;
    
    // if the element that ended was 'channel', then give up control to
    // who gave us control in the first place (or the parent)
    if ([elementName isEqual:@"channel"]) {
        [parser setDelegate:parentParserDelegate];
    } // if
} // didEndElement

@end
