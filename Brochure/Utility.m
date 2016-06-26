//
//  Utility.m
//  Brochure
//
//  Created by Akshat Mittal on 27/06/16.
//  Copyright © 2016 Akshat Mittal. All rights reserved.
//

#import "Utility.h"
#import "Reachability.h"

static UIAlertView *alert;


@implementation Utility

+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    if (![alert isVisible] || ![alert.title isEqualToString:title] || ![alert.message isEqualToString:message]) {
        
        alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
    
}

+(BOOL)isInternetWorking{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return NO;
    } else {
        return YES;
    }
}

@end
