//
//  TableViewController.m
//  Brochure
//
//  Created by Akshat Mittal on 27/06/16.
//  Copyright © 2016 Akshat Mittal. All rights reserved.
//

#import "TableViewController.h"
#import "DetailViewController.h"
#import "CollectionViewViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nextArticleID = 0;
    self.noNewData  = NO;
    self.articleArray = [[NSMutableArray alloc]init];
    self.tabBarController.delegate = self;
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    self.FontSizeOfTitle =  [[user_defaults objectForKey:@"fontSizeTitle"]integerValue];
    if([Utility needsToDownloadArticles]){
        self.isRequesting = YES;
        self.BDM = [[BrochureDataManager alloc]init];
        [self.BDM callApiRequest:@"1"];
    }
    else{
        self.isRequesting = NO;
        [self loadDataInTable:nil];
    }
    [notification_defaults addObserver:self selector:@selector(loadDataInTable:) name:@"data:saved" object:nil];

}




-(void)viewWillDisappear:(BOOL)animated{
    [notification_defaults removeObserver:@"data:saved"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Notification
-(void) loadDataInTable:(NSNotification *)notification
{
    if(notification){
        NSArray *newArticles = [[notification userInfo]objectForKey:@"newArticles"];
        self.isRequesting = NO;
        if(newArticles.count){
            [self.articleArray addObjectsFromArray:newArticles];
            [self.tableView reloadData];
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
            [self.tableView reloadData];
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


#pragma mark Table View delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio
{
    return self.articleArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *tableIdentifier = @"ArticleCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    Articles *article  = [self.articleArray objectAtIndex:indexPath.row];
    cell.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    cell.textLabel.font = [UIFont systemFontOfSize:self.FontSizeOfTitle];
    cell.textLabel.text = article.article_title;
    // cell.textLabel.textColor = [UIColor colorWithRed:195/255.0 green:153/255.0 blue:107/255.0 alpha:1];
    // cell.textLabel.font = [UIFont fontWithName:@"BebasNeue" size:14];
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedIndex = indexPath.row;
    [self performSegueWithIdentifier:@"detailVC" sender:self];
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
            [self loadDataInTable:nil];
        }
    }
}

#pragma mark UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.tableView]) {
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
    
    if ([viewController isKindOfClass:[CollectionViewViewController class]]){
        CollectionViewViewController *svc = (CollectionViewViewController *) viewController;
        svc.articleArray = self.articleArray;
    }
    return TRUE;
}


@end
