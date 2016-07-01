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

+(UIImage*)scalingAndCroppingImageForSize:(CGSize)targetSize imageToModified:(UIImage*)sourceImage
{
    UIImage *newImageFormed = nil;
    CGFloat width = sourceImage.size.width;
    CGFloat height = sourceImage.size.height;
    
    CGFloat changeFactor = 0.0;
    CGFloat scaledW = targetSize.width;
    CGFloat scaledH = targetSize.height;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(sourceImage.size, targetSize) == NO)
    {
        CGFloat widthF = targetSize.width / width;
        CGFloat heightF = targetSize.height / height;
        
        if (widthF > heightF)
            changeFactor = widthF; // fit height
        else
            changeFactor = heightF; // fit width
        scaledW = width * changeFactor;
        scaledH = height * changeFactor;
        
        if (widthF > heightF)
        {
            thumbnailPoint.y = (targetSize.height - scaledH) * 0.5;
        }
        else if (widthF < heightF)
        {
            thumbnailPoint.x = (targetSize.width - scaledW) * 0.5;
        }
    }
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
    
    CGRect imageRect = CGRectZero;
    imageRect.origin = thumbnailPoint;
    imageRect.size.width = scaledW;
    imageRect.size.height = scaledH;
    
    [sourceImage drawInRect: imageRect];
    newImageFormed = UIGraphicsGetImageFromCurrentImageContext();
    if(newImageFormed == nil)
        NSLog(@"Could not scale image");
    
    UIGraphicsEndImageContext();
    return newImageFormed;
}
@end
