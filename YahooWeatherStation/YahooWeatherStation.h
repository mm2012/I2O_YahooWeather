//
//  YahooWeatherStation.h
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


/*
 Purpose: Get weather and condition from Yahoo Weather RSS URL.
 
 Steps: Grab Yahoo Weather RSS URL, Parse with ios SAX parser XMLParser, store Channel and Item elements, write to View
 
 Dependencies: Yahoo Weather API URL, RSSChannel, RSSItem, Definitions.h, I2OViewController_iPhone.xib,  I2OViewController_iPad.xib
 */


#import <Foundation/Foundation.h>

@class RSSChannel;  // forward declaration


// -------------setting up Delegate Protocol declaration
@class YahooWeatherStation;

@protocol YahooWeatherStationDelegate <NSObject>

@required

-(void)didFinishParsingRSSDoc:(YahooWeatherStation*)ys
                    condition:(NSDictionary*)currentCondition
                forecastToday:(NSDictionary*)forecast1
             forecastTommorow:(NSDictionary*)forecast2;

-(void)didEncounterError:(YahooWeatherStation*)ys errorDescription:(NSString*)desc;

@end // end of Protocol defintion


@interface YahooWeatherStation : NSObject <NSXMLParserDelegate>
{
    NSURLConnection *connection;
    NSMutableData *xmlData;
    RSSChannel *channel;
}

// delegate iVar
@property (nonatomic, weak) id <YahooWeatherStationDelegate> delegate;

-(id)init;
-(id)initWithRSSURL:(NSString*)RSSURL startFetch:(BOOL)flag;
-(void)fetchEntries:(NSString*)RSSURL;
-(NSString *)desc;

@end
