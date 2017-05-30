//
//  RootViewController.m
//  OpenWeather
//
//  Created by Phanindra Kumar on 28/05/17.
//  Copyright © 2017 Phanindra Kumar. All rights reserved.
//

#import "RootViewController.h"
#import "ModelController.h"
#import "DataViewController.h"
#import "WeatherDataObject.h"


NSString * const openWeatherAppJsonUrlString = @"http://api.openweathermap.org/data/2.5/forecast?id=1277333&APPID=f1dfbb490388e8eaf025adaed34701cc";


@interface RootViewController ()

@property (strong, nonatomic) ModelController *modelController;
@end

@implementation RootViewController

@synthesize modelController = _modelController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // Configure the page view controller and add it as a child view controller.
    
    weatherListObjects = [[NSMutableArray alloc] init];
    
    [self  showProgressView];
        
    NSURL *openWeatherAppJsonUrl = [NSURL URLWithString:openWeatherAppJsonUrlString];
    
    [self downloadWeatherData:openWeatherAppJsonUrl completionBlock:^(BOOL succeeded, NSData *data,NSError *error) {
        
        if (succeeded) {
            
            [self hideProgressView];
            
            if (data!=nil) {
                
                
                NSLog(@"data : %@",data);
                
                NSError *errorJson=nil;
                
                
                NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorJson];
                
                NSLog(@"responseDict--->%@",responseDict);
                
                if(responseDict==nil){
                    
                    NSString *errorMsg = nil;
                    
                    if(errorJson)
                        errorMsg = errorJson.localizedDescription;
                    else
                        errorMsg = @"Failed to parse the response";
                    
                    
                    
                    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Parser Failed"
                                                                        message:errorMsg
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                    
                    [alertView show];
                    
                    
                }
                else {
                    
                    NSArray *listArray = [responseDict objectForKey:@"list"];
                    
                    [weatherListObjects removeAllObjects];
                    
                    if (listArray && listArray.count) {
                        
                        for(NSDictionary *weatherDataDict in listArray) {
                            
                            
                            WeatherDataObject *weatherObj = [[WeatherDataObject alloc] initWithDictionary:weatherDataDict];
                            
                            [weatherListObjects addObject:weatherObj];
                            
                            weatherObj = nil;
                            
                        }
                                                
                                               
                        [[self modelController] createArrayForDataSource:weatherListObjects];
                        
                        [self createPageControllerForWeatherDataOnSuccess];

                        
                    }
                    else {
                        
                        // error in data
                        
                        NSLog(@"No weather data Found");
                        
                        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Service Failed"
                                                                            message:@"Error Fetching Weather Details"
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil];
                        
                        [alertView show];
                        
                        
                    }
                    
                    
                }
                
            }
        
            
        }
        else {
            
            NSLog(@"Error");
            
            [self hideProgressView];
            
            NSString *msgStr = nil;
            
            if (error) {
                
                msgStr = error.localizedDescription;
            }
            else
                msgStr = @"Failed to fetch data from server please check internet";
                
            
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error Fetching Data"
                                                                    message:msgStr
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView show];
    
            
        }
        
    }];
    
    
}


- (void)downloadWeatherData:(NSURL *)url
              completionBlock:(void (^)(BOOL succeeded, NSData *data,NSError *error))completionBlock {
    

    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                         timeoutInterval:40];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   NSLog(@"response-->%@",response);
                                   
                                   completionBlock(YES,data,error);
                                   
                               } else{
                                   completionBlock(NO,nil,error);
                               }
                           }];
    
}




-(void)createPageControllerForWeatherDataOnSuccess {
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;
    
    DataViewController *startingViewController = [self.modelController viewControllerAtIndex:0 storyboard:self.storyboard];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.pageViewController.dataSource = self.modelController;
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    
    // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
    CGRect pageViewRect = self.view.bounds;
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        pageViewRect = CGRectInset(pageViewRect, 40.0, 40.0);
        
    }
    
    NSLog(@"page view rect : %@",NSStringFromCGRect(pageViewRect));
    self.pageViewController.view.frame = CGRectMake(pageViewRect.origin.x, 40, pageViewRect.size.width, pageViewRect.size.height - 40);
    
    [self.pageViewController didMoveToParentViewController:self];
    
    
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
    
    
}

-(void)showProgressView
{
    if(!self.progressView)
    {
        _progressView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    
     self.progressView.center = self.view.center;
    [self.view addSubview:self.progressView];
    
    [self.progressView startAnimating];
    
    self.progressView.hidden = NO;
}

-(void)hideProgressView
{
    if(self.progressView)
    {
        [self.progressView stopAnimating];
        self.progressView.hidden = YES;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ModelController *)modelController {
    // Return the model controller object, creating it if necessary.
    // In more complex implementations, the model controller may be passed to the view controller.
    if (!_modelController) {
        _modelController = [[ModelController alloc] init];
    }
    return _modelController;
}

#pragma mark - UIPageViewController delegate methods

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    if (UIInterfaceOrientationIsPortrait(orientation) || ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)) {
        // In portrait orientation or on iPhone: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
        
        UIViewController *currentViewController = self.pageViewController.viewControllers[0];
        NSArray *viewControllers = @[currentViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        
        self.pageViewController.doubleSided = NO;
        return UIPageViewControllerSpineLocationMin;
    }

    // In landscape orientation: Set set the spine location to "mid" and the page view controller's view controllers array to contain two view controllers. If the current page is even, set it to contain the current and next view controllers; if it is odd, set the array to contain the previous and current view controllers.
    DataViewController *currentViewController = self.pageViewController.viewControllers[0];
    NSArray *viewControllers = nil;

    NSUInteger indexOfCurrentViewController = [self.modelController indexOfViewController:currentViewController];
    if (indexOfCurrentViewController == 0 || indexOfCurrentViewController % 2 == 0) {
        UIViewController *nextViewController = [self.modelController pageViewController:self.pageViewController viewControllerAfterViewController:currentViewController];
        viewControllers = @[currentViewController, nextViewController];
    } else {
        UIViewController *previousViewController = [self.modelController pageViewController:self.pageViewController viewControllerBeforeViewController:currentViewController];
        viewControllers = @[previousViewController, currentViewController];
    }
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];


    return UIPageViewControllerSpineLocationMid;
}


@end
