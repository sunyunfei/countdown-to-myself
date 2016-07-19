//
//  ViewController.m
//  倒计时
//
//  Created by 孙云 on 16/7/19.
//  Copyright © 2016年 haidai. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *showTimerlabel;
@property (weak, nonatomic) IBOutlet UILabel *footLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self currentTimer];
    [self timerDoing];
    [self countDown];
}

- (void)timerDoing{

    __block typeof(self)weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        if (NO) {
            dispatch_cancel(timer);
        }else{
        
            [weakSelf currentTimer];
        }
    });
    dispatch_resume(timer);
}

- (void)currentTimer{

    __block typeof(self)weakSelf = self;
    //获得当前时间
    NSDate *date = [[NSDate alloc]init];
    //转换为nssstring
    NSDateFormatter *matter = [[NSDateFormatter alloc]init];
    [matter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [matter stringFromDate:date];
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.showTimerlabel.text = dateStr;
    });
    
}
#pragma mark----倒计时

- (void)countDown{

    __block typeof(self)weakSelf= self;
    //倒计时的端点设为2016年7月21日
    NSDate *nextDate = [self acceptTimer];
    NSDate *nowDate = [[NSDate alloc]init];
   __block NSTimeInterval interval = [nextDate timeIntervalSinceDate:nowDate];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
       
        if (interval <= 0) {
            dispatch_cancel(_timer);
            weakSelf.footLabel.text = @"倒计时结束";
        }else{
        
            //获得天数
            int day = ((int)interval)/(60 * 60 * 24);
            int hour = ((int)interval)%(60 * 60 * 24) / (60 * 60);
            int minute = ((int)interval)%(60 * 60 * 24) % (60 * 60) / 60;
            int second = ((int)interval)%(60 * 60 * 24) % (60 * 60) % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                weakSelf.footLabel.text = [NSString stringWithFormat:@"剩余时间:%i 天 %i 时 %i 分 %i 秒",day,hour,minute,second];
            });
           
            interval --;
        }
        
    });
    dispatch_resume(_timer);
}

//获得端点时间
- (NSDate *)acceptTimer{

    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *dateComp = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:[[NSDate alloc]init]];
    dateComp.year = 2016;
    dateComp.month = 7;
    dateComp.day = 21;
    dateComp.hour = 0;
    dateComp.minute = 0;
    dateComp.second = 0;
    NSDate *date = [cal dateFromComponents:dateComp];
    return date;
}
@end
