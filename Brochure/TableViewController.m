//
//  TableViewController.m
//  Brochure
//
//  Created by Akshat Mittal on 27/06/16.
//  Copyright © 2016 Akshat Mittal. All rights reserved.
//

#import "TableViewController.h"


@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if([Utility needsToDownloadArticles]){
        BrochureDataManager *dm = [[BrochureDataManager alloc]init];
        [dm callApiRequest:@"1"];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadDataInTable:) name:@"data:received" object:nil];

}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:@"data:received"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Notification
-(void) loadDataInTable:(NSNotification *) notification
{
    if ([notification.object isKindOfClass:[NSArray class]])
    {
        
        
    }
    else
    {
        NSLog(@"Error, object not recognised.");
    }
}



@end
