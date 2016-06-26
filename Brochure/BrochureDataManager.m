//
//  BrochureDataManager.m
//  Brochure
//
//  Created by Akshat Mittal on 27/06/16.
//  Copyright © 2016 Akshat Mittal. All rights reserved.
//

#import "BrochureDataManager.h"
#import "CoreDataManager.h"
#import "Articles+CoreDataProperties.h"

@implementation BrochureDataManager


+(NSString *)fetchDescriptionOfArticle:(NSNumber*)articleId{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Articles" inManagedObjectContext:[CoreDataManager sharedInstance].managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(article_id = %@)" ,articleId];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:1];
    NSError *error;
    NSMutableArray *fetchObject = [[[CoreDataManager sharedInstance].managedObjectContext executeFetchRequest:fetchRequest error:&error]mutableCopy];
    if(fetchObject.count){
        Articles *dict = [fetchObject objectAtIndex:0];
        return dict.article_detailText;
    }
    else
        return nil;

}
+(NSArray *)fetchArticlesFrom:(NSNumber*)articleId{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Articles" inManagedObjectContext:[CoreDataManager sharedInstance].managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *srt = [NSSortDescriptor sortDescriptorWithKey:@"article_title" ascending:NO];
    
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:srt]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(article_id = %@)" ,articleId];
    [fetchRequest setPredicate:predicate];
    NSError *error;
    NSMutableArray *fetchObject = [[[CoreDataManager sharedInstance].managedObjectContext executeFetchRequest:fetchRequest error:&error]mutableCopy];
    return fetchObject;

}



-(void)callApiRequest:(NSString*)page{
    ApiRequest *request = [[ApiRequest alloc]init];
    [request setDelegate:self];
    [request sendGETRequestWithURL:page displayHUD:YES withAccess_token:nil];
}

#pragma ApiResponseDelegate

-(void)GETResponseReceived:(id)response{
    if(response){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"data:received" object:response];
    }
    else{
        if([[response objectForKey:@"message"] isKindOfClass: [NSArray class]])
        {
            [Utility showAlertWithTitle:@"Try Again!" message:[response objectForKey:@"message"][0]];
        }
        else
        {
            [Utility showAlertWithTitle:@"Try Again!" message:[response objectForKey:@"message"]];
        }
    }
    
}

@end
