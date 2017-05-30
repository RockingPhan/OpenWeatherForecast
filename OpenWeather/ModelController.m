//
//  ModelController.m
//  OpenWeather
//
//  Created by Phanindra Kumar on 28/05/17.
//  Copyright © 2017 Phanindra Kumar. All rights reserved.
//

#import "ModelController.h"
#import "DataViewController.h"
#import "WeatherDataObject.h"
#import "ModelDataObject.h"

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */


@interface ModelController ()

@end

@implementation ModelController

- (instancetype)init {
    self = [super init];
    if (self) {
        // Create the data model.
       
       // _pageData = [NSArray arrayWithObjects:@"Mon",@"Tue",@"Wed",@"Thu",@"Fri", nil];
        
        duplicateDatesArray = [[NSMutableArray alloc] init];
        weatherInfoArray = [[NSMutableArray alloc] init];
        
    }
    return self;
}

-(void) createArrayForDataSource:(NSMutableArray *)dataArray {
    
    [duplicateDatesArray removeAllObjects];
    
    for (WeatherDataObject *obj in dataArray) {
        
        
        NSString *dateOnlyStr = obj.dateOnlyStr;
        [duplicateDatesArray addObject:dateOnlyStr];
        
    }
    
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:duplicateDatesArray];
    _pageData = [orderedSet array];
    
    [weatherInfoArray removeAllObjects];
    
    for (NSString *dateObj in _pageData)
    {
        NSPredicate *datepredicate = [NSPredicate predicateWithFormat:@"SELF.dateOnlyStr contains[cd] %@",dateObj];
        ModelDataObject *modelData = [[ModelDataObject alloc] init];
        
        modelData.weatherDate = dateObj;
        
        modelData.weatherDataObjectsArray = [dataArray filteredArrayUsingPredicate:datepredicate];
        NSLog(@"HERE %@",modelData.weatherDataObjectsArray);
        
        [weatherInfoArray addObject:modelData];
        modelData = nil;
        
    }
    
}

- (DataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard {
    // Return the data view controller for the given index.
    if (([self.pageData count] == 0) || (index >= [self.pageData count])) {
        return nil;
    }

    // Create a new view controller and pass suitable data.
    DataViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"DataViewController"];
    dataViewController.dataObject = self.pageData[index];
    dataViewController.weatherModelObject = [weatherInfoArray objectAtIndex:index];
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(DataViewController *)viewController {
    // Return the index of the given data view controller.
    // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    return [self.pageData indexOfObject:viewController.dataObject];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageData count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageData count];
}
- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end
