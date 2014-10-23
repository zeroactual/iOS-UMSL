//
//  StopWatchViewController.h
//  Chrono
//
//  Created by Wes Jonas on 9/23/14.
//  Copyright (c) 2014 Wes Jonas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LapCell.h"

@interface StopWatchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView    *lapTableView;
    NSMutableArray          *lapData;
}

@property (weak, nonatomic) IBOutlet UIButton   *startButton;
@property (weak, nonatomic) IBOutlet UIButton   *resetButton;
@property (weak, nonatomic) IBOutlet UIButton   *lapButton;
@property (weak, nonatomic) IBOutlet UIButton   *stopButton;
@property (weak, nonatomic) IBOutlet UILabel    *masterTimer;
@property (weak, nonatomic) IBOutlet UILabel    *lapTimer;
@property (weak, nonatomic) IBOutlet UILabel    *backgroundLabel;

@end
