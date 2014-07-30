//
//  definitions.h
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



/*----  check first */
#ifndef DEBUG_LOG
    #define DEBUG_LOG(...) NSLog(__VA_ARGS__)
#endif

#define  RSSCHANNEL_LOG(...)   NSLog(__VA_ARGS__) //do {} while(0) 
#define  RSSITEM_LOG(...)     NSLog(__VA_ARGS__)  //   do {} while(0)

#define YAPI_URL_GLASGOW @"http://weather.yahooapis.com/forecastrss?w=21125&u=c" // weather for glasgow
#define INTERNETCHECK_URL @"google.com"
#define INTERNET_CONNECTION_ERROR_TEXT @"Hmmm. Unable to get to Internet. WiFi/Cellular connection Ok?"
#define APPLENEWS_URL @"http://www.apple.com/pr/feeds/pr.rss"
