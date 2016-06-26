//
//  ApiRequest.h
//  Brochure
//
//  Created by Akshat Mittal on 26/06/16.
//  Copyright © 2016 Akshat Mittal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@protocol ApiResponseDelegate <NSObject>
@optional
-(void)GETResponseReceived:(id)response;
@end

@interface ApiRequest : NSObject
{
    MBProgressHUD *HUD;
}
@property (nonatomic,weak) id<ApiResponseDelegate> delegate;

-(void)sendGETRequestWithURL:(NSString *)page displayHUD:(BOOL)displayHUD withAccess_token:(NSString *)access_token;

@end
