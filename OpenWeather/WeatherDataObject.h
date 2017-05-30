//
//  WeatherDataObject.h
//  OpenWeather
//
//  Created by Phanindra Kumar on 28/05/17.
//  Copyright © 2017 Phanindra Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherDataObject : NSObject
{
    NSString *unixTimeStamp;
    NSDictionary *mainDict;
    NSArray *weatherDataArray;
    NSDictionary *cloudsDict;
    NSDictionary *windDict;
    NSDictionary *rainDict;
    NSDictionary *sysDict;
    NSString *dateTimeStr;
    NSString *dateOnlyStr;
    
}

@property (nonatomic, strong) NSString *unixTimeStamp;
@property (nonatomic, strong) NSDictionary *mainDict;
@property (nonatomic, strong) NSArray *weatherDataArray;
@property (nonatomic, strong) NSDictionary *cloudsDict;
@property (nonatomic, strong) NSDictionary *windDict;
@property (nonatomic, strong) NSDictionary *rainDict;
@property (nonatomic, strong) NSDictionary *sysDict;
@property (nonatomic, strong)NSString *dateTimeStr;
@property (nonatomic, strong)NSString *dateOnlyStr;


- (instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end
