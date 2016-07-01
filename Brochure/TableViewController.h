//
//  TableViewController.h
//  Brochure
//
//  Created by Akshat Mittal on 27/06/16.
//  Copyright © 2016 Akshat Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "ApiRequest.h"
#import "BrochureDataManager.h"

@interface TableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,ApiResponseDelegate,UITabBarControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *pageTitle;
@property BOOL isRequesting;
@property int nextArticleID;
@property (strong,nonatomic) NSMutableArray *articleArray;
@property NSUInteger selectedIndex;
@property (strong,nonatomic) BrochureDataManager *BDM;
@property BOOL noNewData;
@end
