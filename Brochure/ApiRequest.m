//
//  ApiRequest.m
//  Brochure
//
//  Created by Akshat Mittal on 26/06/16.
//  Copyright © 2016 Akshat Mittal. All rights reserved.
//

#import "ApiRequest.h"
#import "Utility.h"


@implementation ApiRequest


-(void)sendGETRequestWithURL:(NSString *)requestURL withParameters:(NSString *)parameters displayHUD:(BOOL)displayHUD withAccess_token:(NSString *)access_token
{
    
    if (HUD == nil && displayHUD){
        
        [self setUpHUD];
    }
    
    if(displayHUD && HUD.alpha !=1){
        [HUD showAnimated:YES];
    }
    
    NSURL *completeURL;
    
    if(parameters!=nil)
        completeURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", kServerURL, requestURL, parameters]];
    else
        completeURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kServerURL, requestURL]];
    
    NSLog(@"request url %@",requestURL);
    NSLog(@"complete url %@",completeURL);
    
    NSMutableURLRequest *APIRequest = [NSMutableURLRequest requestWithURL:completeURL];
    
    [APIRequest setHTTPMethod:@"GET"];
    [APIRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [APIRequest setValue:access_token forHTTPHeaderField:@"Access-Token"];
    if(displayHUD){
        [NSURLConnection sendAsynchronousRequest:APIRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
            
            if (connectionError != nil) {
                
                if (connectionError.code == NSURLErrorUserCancelledAuthentication) {
                    
                    [self parseAndForwardResponse:data:@"GET"];
                }
                else
                {
                    [Utility showAlertWithTitle:@"Error!" message:[connectionError localizedDescription]];
                }
            }
            else
            {
                [self parseAndForwardResponse:data:@"GET"];
            }
            
            [HUD hideAnimated:YES];
        }];
    }
    else{
        NSOperationQueue *myQueue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:APIRequest queue:myQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (connectionError != nil) {
                    if (connectionError.code == NSURLErrorUserCancelledAuthentication) {
                        [self parseAndForwardResponse:data:@"GET"];
                        
                    }
                    else
                    {
                        [Utility showAlertWithTitle:@"Error!" message:[connectionError localizedDescription]];
                    }
                }
                else
                {
                    [self parseAndForwardResponse:data:@"GET"];
                }
            }];
        }];
        
    }
}

-(void)setUpHUD{

    if([UIApplication sharedApplication].keyWindow.rootViewController.view){
        
        HUD = [[MBProgressHUD alloc] initWithView: [UIApplication sharedApplication].keyWindow.rootViewController.view];
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:HUD];
        HUD.label.text = @"Loading...";
    }
    
}


-(void)parseAndForwardResponse:(NSData *)data : (NSString*) requestType
{
    NSError *jsonParsingError = nil;
    
    NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",strData);
    
    id receivedResponse;
    
    if (data != nil) {
        
        receivedResponse = [NSJSONSerialization JSONObjectWithData:data
                                                           options:NSJSONReadingMutableContainers error:&jsonParsingError];
    }
    
    if (receivedResponse != nil) {
         if([requestType isEqualToString:@"GET"])
            [self.delegate GETResponseReceived:receivedResponse];
    }
    else
    {
        [Utility showAlertWithTitle:nil message:@"Error while loading data"];
    }
}

@end
