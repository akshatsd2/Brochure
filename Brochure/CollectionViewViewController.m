//
//  CollectionViewViewController.m
//  Brochure
//
//  Created by Akshat Mittal on 27/06/16.
//  Copyright © 2016 Akshat Mittal. All rights reserved.
//

#import "CollectionViewViewController.h"

@interface CollectionViewViewController ()

@end

@implementation CollectionViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.articleArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ArticlesImageCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *cellImageView = (UIImageView *)[cell viewWithTag:1];
    
    Articles *article = [self.articleArray objectAtIndex:indexPath.row];
    
    NSString *url = article.article_image;
    if(!url || [url isEqual:[NSNull null]] ||[url isKindOfClass:[NSNull class]]) return cell;
    NSURL *Url = [NSURL URLWithString: url];
    [cellImageView sd_setImageWithURL:Url placeholderImage:nil options:SDWebImageRetryFailed
                                       completed:^(UIImage *image, NSError *error, SDImageCacheType c, NSURL *url) {
                                           if (image) {
                                               cellImageView.image = [Utility scalingAndCroppingImageForSize:cellImageView.frame.size imageToModified:image];
                                              
                                           }
                                       }];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = indexPath.row;
    [self performSegueWithIdentifier:@"detailVC" sender:self];

}


#pragma mark Segue delegate

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([[segue identifier] isEqualToString:@"detailVC"]){
        
        UINavigationController *nav = segue.destinationViewController;
        DetailViewController *svc = [nav.viewControllers objectAtIndex:0];
        svc.hidesBottomBarWhenPushed = YES;
        svc.selectedArticle = [self.articleArray objectAtIndex:self.selectedIndex];
    }
}


@end
