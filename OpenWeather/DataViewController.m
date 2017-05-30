//
//  DataViewController.m
//  OpenWeather
//
//  Created by Phanindra Kumar on 28/05/17.
//  Copyright © 2017 Phanindra Kumar. All rights reserved.
//

#import "DataViewController.h"
#import "WeatherDataTableViewCell.h"
#import "WeatherDataObject.h"

@interface DataViewController ()

@end

@implementation DataViewController
@synthesize weatherModelObject;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.dataLabel.text = [self.dataObject description];
    
    NSLog(@"model object : %@",self.weatherModelObject);
    
    weatherDataArray  = self.weatherModelObject.weatherDataObjectsArray;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"WeatherDataCell";
    
    
    WeatherDataTableViewCell *cell = (WeatherDataTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WeatherDataTableViewCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
       
    }
    
    WeatherDataObject *dataObject = [weatherDataArray objectAtIndex:indexPath.row];
    
    NSArray *datetimearray = [dataObject.dateTimeStr componentsSeparatedByString:@" "];
    NSString *timeStr = [datetimearray objectAtIndex:1];
    
    [cell.timelabel setText:timeStr];
    
    NSDictionary *mainDict = dataObject.mainDict;
    
    NSNumber *tempStr = [mainDict objectForKey:@"temp"];
    NSNumber *humidity = [mainDict objectForKey:@"humidity"];
    
    NSArray *weatherDataAr = dataObject.weatherDataArray;
    
    
    NSDictionary *weatherDict = [weatherDataAr objectAtIndex:0];
    
    NSString *weatherDescription = [weatherDict objectForKey:@"description"];
    [cell.templabel setText:[NSString stringWithFormat:@"%.02f",[tempStr floatValue]]];
    [cell.humidlabel setText:[NSString stringWithFormat:@"%.02f",[humidity floatValue]]];
    
    [cell.weatherlabel setText:weatherDescription];
    
    NSNumber *windSpeed = [dataObject.windDict objectForKey:@"speed"];
    NSNumber *rain;
    if (dataObject.rainDict != nil && [dataObject.rainDict objectForKey:@"3h"]) {
        
         rain = [dataObject.rainDict objectForKey:@"3h"];
    }
    else {
        
        rain = [NSNumber numberWithFloat:0];
    }
   
    
    
    [cell.windlabel setText:[NSString stringWithFormat:@"%.02f",[windSpeed floatValue]]];
    [cell.rainlabel setText:[NSString stringWithFormat:@"%.02f",[rain floatValue]]];

    
    return cell;

    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if (weatherDataArray && weatherDataArray.count) {
        
        return weatherDataArray.count;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    return 124;
    
}

@end
