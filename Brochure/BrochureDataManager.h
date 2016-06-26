//
//  BrochureDataManager.h
//  Brochure
//
//  Created by Akshat Mittal on 27/06/16.
//  Copyright © 2016 Akshat Mittal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiRequest.h"
#import "Utility.h"

@interface BrochureDataManager : NSObject<ApiResponseDelegate>

-(void)callApiRequest:(NSString*)page;
+(NSString *)fetchDescriptionOfArticle:(NSNumber*)articleId;
+(NSArray *)fetchArticlesFrom:(NSNumber*)articleId;
@end
