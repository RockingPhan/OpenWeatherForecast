//
//  RootViewController.h
//  OpenWeather
//
//  Created by Phanindra Kumar on 28/05/17.
//  Copyright © 2017 Phanindra Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController <UIPageViewControllerDelegate>
{
    NSMutableArray *weatherListObjects;
}

@property(nonatomic,strong)UIActivityIndicatorView *progressView;

@property (strong, nonatomic) UIPageViewController *pageViewController;

- (void)downloadWeatherData:(NSURL *)url
            completionBlock:(void (^)(BOOL succeeded, NSData *data,NSError *error))completionBlock;


@end

