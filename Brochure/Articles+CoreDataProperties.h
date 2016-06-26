//
//  Articles+CoreDataProperties.h
//  Brochure
//
//  Created by Akshat Mittal on 27/06/16.
//  Copyright © 2016 Akshat Mittal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Articles.h"

NS_ASSUME_NONNULL_BEGIN

@interface Articles (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *article_id;
@property (nullable, nonatomic, retain) NSString *article_title;
@property (nullable, nonatomic, retain) NSString *article_subtitle;
@property (nullable, nonatomic, retain) NSString *article_detailText;
@property (nullable, nonatomic, retain) NSString *article_image;
@property (nullable, nonatomic, retain) NSNumber *article_toShow;

@end

NS_ASSUME_NONNULL_END
