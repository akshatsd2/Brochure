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
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    if([Utility needsToDownloadArticles]){
        self.isRequesting = YES;
        self.BDM = [[BrochureDataManager alloc]init];
        [self.BDM callApiRequest:@"1"];
    }
    else{
        self.isRequesting = NO;
        [self loadDateInCollectionView:nil];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadDateInCollectionView:) name:@"data:saved" object:nil];
    
}


-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:@"data:saved"];
}


#pragma CollectionView Delegates

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

#pragma mark - Notification
-(void) loadDateInCollectionView:(NSNotification *)notification
{
    if(notification){
        NSArray *newArticles = [[notification userInfo]objectForKey:@"newArticles"];
        self.isRequesting = NO;
        if(newArticles.count){
            [self.articleArray addObjectsFromArray:newArticles];
            [self.collectionView reloadData];
        }
        else{
            self.noNewData = YES;
        }
    }
    else if(!self.noNewData){
        if(self.articleArray.count)
            self.nextArticleID = self.articleArray.count;
        else
            self.nextArticleID = 0;
        NSArray *newArticles = [BrochureDataManager fetchArticlesFrom:self.nextArticleID];
        if(newArticles.count){
            self.isRequesting = NO;
            [self.articleArray addObjectsFromArray:newArticles];
            [self.collectionView reloadData];
        }
        else{
            int pageIndex = (int)self.articleArray.count/kNumberOfArticlesInOnePage + 1;
            self.isRequesting = YES;
            if(!_BDM)
                _BDM = [[BrochureDataManager alloc]init];
            [_BDM callApiRequest:[NSString stringWithFormat:@"%d",pageIndex]];
        }
    }
    else{
        self.isRequesting = NO;
        [Utility showAlertWithTitle:@"Bump" message:@"No New Data!"];
    }
}



#pragma ScrollView Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    float reload_distance = 5;
    if(y > h + reload_distance && !self.isRequesting) {
        if(self.articleArray.count % kNumberOfArticlesInOnePage == 0){
            self.isRequesting = YES;
            [self loadDateInCollectionView:nil];
        }
    }
}

#pragma mark UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.collectionView]) {
        return NO;
    }
    return YES;
}

#pragma mark Segue delegate

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
//    if([[segue identifier] isEqualToString:@"detailVC"]){
//        
//        UINavigationController *nav = segue.destinationViewController;
//        DetailViewController *svc = [nav.viewControllers objectAtIndex:0];
//        svc.hidesBottomBarWhenPushed = YES;
//        svc.selectedArticle = [self.articleArray objectAtIndex:self.selectedIndex];
//    }
    if([[segue identifier] isEqualToString:@"detailVC"]){
        DetailViewController *svc = segue.destinationViewController;
        svc.hidesBottomBarWhenPushed = YES;
        svc.selectedArticle = [self.articleArray objectAtIndex:self.selectedIndex];
    }
}


#pragma mark TabBar delegate

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    if ([viewController isKindOfClass:[TableViewController class]]){
        TableViewController *svc = (TableViewController *) viewController;
        svc.articleArray = self.articleArray;
    }
    return TRUE;
}


@end
