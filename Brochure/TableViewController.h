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

@interface TableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,ApiResponseDelegate>

@end
