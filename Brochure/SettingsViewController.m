//
//  SettingsViewController.m
//  Brochure
//
//  Created by Akshat Mittal on 27/06/16.
//  Copyright © 2016 Akshat Mittal. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.stepperOfSubTitle.userInteractionEnabled = YES;
    self.stepperOfTitle.userInteractionEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    int titleFont = [[user_defaults objectForKey:@"fontSizeTitle"]integerValue];
    int subTitleFont = [[user_defaults objectForKey:@"fontSizeSubTitle"]integerValue];
    
    self.fontSizeOfTitle.text = [NSString stringWithFormat:@"%d",titleFont];
    self.fontSizeOfSubtitle.text = [NSString stringWithFormat:@"%d",subTitleFont];
    self.stepperOfTitle.value = titleFont;
    self.stepperOfSubTitle.value = subTitleFont;
    
}

- (IBAction)titleFontChanged:(UIStepper*)sender {
    double value = [sender value];
    self.fontSizeOfTitle.text = [NSString stringWithFormat:@"%d",(int)value];
}


- (IBAction)subtitleFontChanged:(UIStepper*)sender {
    double value = [sender value];
    self.fontSizeOfSubtitle.text = [NSString stringWithFormat:@"%d",(int)value];
}


- (IBAction)doneClicked:(id)sender {
    [user_defaults setObject:self.fontSizeOfTitle.text forKey:@"fontSizeTitle"];
    [user_defaults setObject:self.fontSizeOfSubtitle.text forKey:@"fontSizeSubTitle"];
    [user_defaults synchronize];
    [Utility showAlertWithTitle:@"Success!" message:@"Font Size Updated Successfully!"];
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
