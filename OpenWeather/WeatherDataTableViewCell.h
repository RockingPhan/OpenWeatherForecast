//
//  WeatherDataTableViewCell.h
//  OpenWeather
//
//  Copyright © 2017 Phanindra Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherDataTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet  UILabel *timelabel;
@property (nonatomic, weak) IBOutlet UILabel *templabel;
@property (nonatomic, weak) IBOutlet UILabel *weatherlabel;
@property (nonatomic, weak) IBOutlet UILabel *humidlabel;
@property (nonatomic, weak) IBOutlet UILabel *windlabel;
@property (nonatomic, weak) IBOutlet UILabel *rainlabel;


@end
