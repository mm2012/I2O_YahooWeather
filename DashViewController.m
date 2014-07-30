//
//  DashViewController.m
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


#import "DashViewController.h"
//#import "YahooWeatherStation.h"
#import "Reachability.h"

@implementation DashViewController


-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    DEBUG_LOG(@"view loaded");
    DEBUG_LOG(@"is Main thread? %d", [NSThread isMainThread]);
    
    Reachability *reach = [Reachability reachabilityWithHostname:INTERNETCHECK_URL];
    
    // setup Internet availibility notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    [reach startNotifier];
}


-(IBAction)showWeather:(id)sender {
    DEBUG_LOG(@"button pressed");
   
    
    YahooWeatherStation *glasgowWeather = [[YahooWeatherStation alloc] initWithRSSURL:YAPI_URL_GLASGOW startFetch:YES];
    [glasgowWeather setDelegate:self]; // now this ViewController can receve messages
    
   // DEBUG_LOG(@"Glasgow: current conditions are > %@",[glasgowWeather yapiCondition]); //  [glasgowWeather yapiCondition]
} //


// implement delegate protocols

-(void)didFinishParsingRSSDoc:(YahooWeatherStation *)ys
                    condition:(NSDictionary *)currentCondition
                    forecastToday:(NSDictionary *)forecast1
                    forecastTommorow:(NSDictionary *)forecast2 {
    
DEBUG_LOG(@"\n\n(DashviewController) current: %@, high: %@, low: %@",
          [currentCondition objectForKey:@"temp"],
          [forecast1 objectForKey:@"high"],
          [forecast1 objectForKey:@"low"]);
    
    [tempInCelsius setText:[currentCondition objectForKey:@"temp"]];
    [currentConditionText setText:[currentCondition objectForKey:@"text"]];
    [todayForecastHigh setText:[forecast1 objectForKey:@"high"]];
    [todayForecastLow setText:[forecast1 objectForKey:@"low"]];

    ys = nil; // got the needed data - set YahooWeatherStation object to nil
    
} // did FinishParsing

-(void)didEncounterError:(YahooWeatherStation *)ys
        errorDescription:(NSString *)desc {
    
} // didEncounterError

#pragma mark internet reachability
-(void)reachabilityChanged:(NSNotification*)note
{
    DEBUG_LOG(@"reachabilityChanged accessed");
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
        DEBUG_LOG(@"Internet is reachable...");
        //if ([myDelegate globalPlayerPlayStatus] == YES) // if switch was On when Internet went off, resume playing
        // [self playStream:YES];
    }
    else { // no internet
        DEBUG_LOG(@"Internet is NOT reachable...");
        // [self stopStream:NO];
        //[statusText setText:INTERNET_CONNECTION_ERROR_TEXT];
    }
} // reachabilityChange:


@end
