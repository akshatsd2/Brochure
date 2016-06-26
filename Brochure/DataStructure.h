//
//  DataStructure.h
//  Brochure
//
//  Created by Akshat Mittal on 27/06/16.
//  Copyright © 2016 Akshat Mittal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataStructure : NSObject

@end


@interface Article : NSObject

@property (nonatomic, strong) NSNumber *article_id;
@property (nonatomic, strong) NSString *article_title;
@property (nonatomic, strong) NSString *article_subtitle;
@property (nonatomic, strong) NSString *article_detailText;
@property (nonatomic, strong) NSString *article_image;
@property (nonatomic, strong) NSNumber *article_toShow;

@end