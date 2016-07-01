//
//  SettingsViewController.h
//  Brochure
//
//  Created by Akshat Mittal on 27/06/16.
//  Copyright © 2016 Akshat Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"

@interface SettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *fontSizeOfTitle;
@property (weak, nonatomic) IBOutlet UIStepper *stepperOfTitle;

@property (weak, nonatomic) IBOutlet UIStepper *stepperOfSubTitle;

@property (weak, nonatomic) IBOutlet UILabel *fontSizeOfSubtitle;

@end
