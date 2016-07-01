//
//  DetailViewController.m
//  Brochure
//
//  Created by Akshat Mittal on 27/06/16.
//  Copyright © 2016 Akshat Mittal. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Article Details";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage)];
    tap.numberOfTapsRequired = 1;
    [self.articleImage addGestureRecognizer:tap];
    [self.articleImage setUserInteractionEnabled:YES];
    
}
-(void)viewWillAppear:(BOOL)animated{
     self.FontSizeOfTitle =  [[user_defaults objectForKey:@"fontSizeTitle"]integerValue];
    
    [self.navigationController setNavigationBarHidden:NO];
     self.titleLabel.font = [UIFont systemFontOfSize:self.FontSizeOfTitle];
    self.titleLabel.text  = self.selectedArticle.article_title;
    self.articleDetailText.text = self.selectedArticle.article_detailText;
    
    NSString *url = self.selectedArticle.article_image;
    if(!url || [url isEqual:[NSNull null]] ||[url isKindOfClass:[NSNull class]]) {
        self.articleHeight.constant = 0;
    }
    else{
        self.articleHeight.constant = 150;
        NSURL *Url = [NSURL URLWithString: url];
        [self.articleImage sd_setImageWithURL:Url placeholderImage:nil options:SDWebImageRetryFailed
                                completed:^(UIImage *image, NSError *error, SDImageCacheType c, NSURL *url) {
                                    if (image) {
                                        self.articleImage.image = [Utility scalingAndCroppingImageForSize:self.articleImage.frame.size imageToModified:image];
                                        
                                    }
                                }];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
}


-(void)hideImage{
    if(self.selectedArticle.article_image){
        self.articleHeight.constant = 0;
    }
}

- (IBAction)deleteArticle:(id)sender {
    self.selectedArticle.article_toShow = @NO;
    NSError *error = nil;
    if (![[CoreDataManager sharedInstance].managedObjectContext save:&error])
    {
        [Utility showAlertWithTitle:@"Error!" message:@"Error in deleting the article"];
    }
    else{
        [Utility showAlertWithTitle:@"Success!" message:@"Article deleted Successfully"];
        [self.navigationController popViewControllerAnimated:YES];
    }

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
