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
+(NSArray *)fetchArticlesFrom:(int)articleId{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Articles" inManagedObjectContext:[CoreDataManager sharedInstance].managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *srt = [NSSortDescriptor sortDescriptorWithKey:@"article_title" ascending:NO];
    
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:srt]];
    NSNumber *startId = [NSNumber numberWithInt:articleId];
    NSNumber *endId = [NSNumber numberWithInt:articleId + kNumberOfArticlesInOnePage-1];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"article_id >= %@ && article_id <= %@" ,startId, endId];
    [fetchRequest setPredicate:predicate];
    NSError *error;
    NSMutableArray *fetchObject = [[[CoreDataManager sharedInstance].managedObjectContext executeFetchRequest:fetchRequest error:&error]mutableCopy];
    if(fetchObject.count)
        return fetchObject;
    return nil;
}



-(void)callApiRequest:(NSString*)page{
    ApiRequest *request = [[ApiRequest alloc]init];
    [request setDelegate:self];
    [request sendGETRequestWithURL:page displayHUD:YES withAccess_token:nil];
}

#pragma ApiResponseDelegate

-(void)GETResponseReceived:(id)response{
    if(response){
        [self saveArticlesInCoreData:response];
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

-(void)saveArticlesInCoreData:(id)response{
    if(response){
        if ([response isKindOfClass:[NSArray class]])
        {
            NSMutableArray *newArticles = [[NSMutableArray alloc]init];
            for (NSDictionary *Article in response)
                {
                    if(![self checkAlreadyExist:[Article objectForKey:@"articleId"]]){
                        Articles *article = (Articles *)[NSEntityDescription insertNewObjectForEntityForName:@"Articles" inManagedObjectContext:[CoreDataManager sharedInstance].managedObjectContext];
                        article.article_toShow = @YES;
                        NSNumber *articleID = [Article objectForKey:@"articleId"];
                        if (![articleID isKindOfClass:[NSNull class]]) {
                            article.article_id = articleID;
                        }
                        NSString *articleImage =[Article objectForKey:@"articleImage"];
                        if(![articleImage isKindOfClass:[NSNull class]])
                        {
                            article.article_image = articleImage;
                        }
                        NSString *articleSubtitle =[Article objectForKey:@"articleSubTitle"];
                        if(![articleSubtitle isKindOfClass:[NSNull class]])
                        {
                            article.article_subtitle = articleSubtitle;
                        }
                        NSString *articleTitle =[Article objectForKey:@"articleTitle"];
                        if(![articleTitle isKindOfClass:[NSNull class]])
                        {
                            article.article_title = articleTitle;
                        }
                        NSString *articleDesc =[Article objectForKey:@"articleSubTitle"];
                        if(![articleDesc isKindOfClass:[NSNull class]])
                        {
                            article.article_detailText = articleDesc;
                        }
                        [newArticles addObject:article];
                    }
                }
            NSError *error = nil;
            if (![[CoreDataManager sharedInstance].managedObjectContext save:&error])
            {
                NSLog(@"Failed to save - error: %@", [error localizedDescription]);
            }
            else{
                NSLog(@"Data Saved Sucessfully");
                NSDictionary *userInfo = [[NSDictionary alloc]initWithObjectsAndKeys:newArticles,@"newArticles", nil];
                [notification_defaults postNotificationName:@"data:saved" object:self userInfo:userInfo];
            }
        }
    }
    else
    {
        NSLog(@"Error, object not recognised.");
    }
    
}

-(BOOL)checkAlreadyExist:(NSNumber *)articleID{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Articles" inManagedObjectContext:[CoreDataManager sharedInstance].managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(article_id = %@)" ,articleID];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:1];
    NSError *error;
    NSMutableArray *fetchObject = [[[CoreDataManager sharedInstance].managedObjectContext executeFetchRequest:fetchRequest error:&error]mutableCopy];
    if(fetchObject.count){
        return YES;
    }
    else
        return NO;
}

@end
