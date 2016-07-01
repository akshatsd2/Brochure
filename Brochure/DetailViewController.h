//
//  DetailViewController.h
//  Brochure
//
//  Created by Akshat Mittal on 27/06/16.
//  Copyright © 2016 Akshat Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"

@interface DetailViewController : UIViewController

@property (strong,nonatomic) Articles *selectedArticle;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *articleImage;
@property (weak, nonatomic) IBOutlet UITextView *articleDetailText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *articleHeight;



@end
