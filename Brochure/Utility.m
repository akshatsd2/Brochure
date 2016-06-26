//
//  Utility.m
//  Brochure
//
//  Created by Akshat Mittal on 27/06/16.
//  Copyright © 2016 Akshat Mittal. All rights reserved.
//

#import "Utility.h"
#import "Reachability.h"
#import "CoreDataManager.h"

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

+(BOOL)needsToDownloadArticles{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Articles" inManagedObjectContext:[CoreDataManager sharedInstance].managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fetchObject = [[CoreDataManager sharedInstance].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if(fetchObject.count>0)
    {return NO;}
    return YES;
}

@end
