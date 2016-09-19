//
//  ViewController.m
//  侧滑
//
//  Created by ilsxl13 on 2016/8/24.
//  Copyright © 2016年 SQLSXL. All rights reserved.
//

#import "ViewController.h"

#define kWidth 64 //右侧的宽度
#define kSpeed 1200 //侧滑成功需要的最小速度

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *slideButton;
@property (assign, nonatomic) BOOL isSlide;//判断是否已经侧滑
@end

@implementation ViewController

- (IBAction)slideButtonClick:(UIButton *)sender {
    if (self.isSlide == YES) return;
    [self slideToRightWithTimeInterval:0.2];
}

-(void)slide:(UIPanGestureRecognizer *)sender
{
    CGPoint pointInTop = [sender locationInView:self.topView];
    CGPoint pointInBottom = [sender translationInView:self.view];
    CGRect frame = self.topView.frame;
    frame.origin.x += pointInBottom.x;
    CGPoint velocity = [sender velocityInView:self.view];
    double speed = sqrt(velocity.x * velocity.x + velocity.y *velocity.y);
    NSLog(@"speed = %.2lf",speed);
    if (pointInTop.x > 0 && pointInTop.x < kWidth) {
        if (frame.origin.x == 0) {
            frame.origin.x = 0;
            self.isSlide = NO;
            self.slideButton.alpha = 1;
        }
        else if (frame.origin.x == self.view.bounds.size.width - kWidth) {
            frame.origin.x = self.view.bounds.size.width - kWidth;
            self.isSlide = YES;
            self.slideButton.alpha = 0;
        }
        self.topView.frame = frame;
        [sender setTranslation:CGPointZero inView:self.view];
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (frame.origin.x > self.view.bounds.size.width / 2) {
            if (self.isSlide == YES) {
                if (speed < kSpeed) {
                    [self slideToRightWithTimeInterval:0.1];
                }
                else
                {
                    [self slideToLeftWithTimeInterval:0.1];
                    NSLog(@"最终speed = %.2lf",speed);
                }
            }
            else
            {
                [self slideToRightWithTimeInterval:0.1];
            }
        }
        else if(frame.origin.x < self.view.bounds.size.width / 2)
        {
            if (self.isSlide == NO) {
                if (speed <kSpeed) {
                    [self slideToLeftWithTimeInterval:0.1];
                }
                else
                {
                    [self slideToRightWithTimeInterval:0.1];
                    NSLog(@"最终speed = %.2lf",speed);
                }
            }
            else
            {
                [self slideToLeftWithTimeInterval:0.1];
            }
        }
    }
}

-(void)slideToLeftWithTimeInterval:(NSTimeInterval)timeInterval
{
    [UIView animateWithDuration:timeInterval animations:^{
        CGRect frame = self.topView.frame;
        frame.origin = CGPointMake(0, 0);
        self.topView.frame = frame;
        self.slideButton.alpha = 1;
    } completion:^(BOOL finished) {
        self.isSlide = NO;
    }];
}

-(void)slideToRightWithTimeInterval:(NSTimeInterval)timeInterval
{
    [UIView animateWithDuration:timeInterval animations:^{
        CGRect frame = self.topView.frame;
        frame.origin = CGPointMake(self.view.bounds.size.width - kWidth, 0);
        self.topView.frame = frame;
        self.slideButton.alpha = 0;
    } completion:^(BOOL finished) {
        self.isSlide = YES;
    }];
}

-(void)tap:(UITapGestureRecognizer *)sender
{
    CGPoint pointInTop = [sender locationInView:self.topView];
    if (pointInTop.x > 0 && pointInTop.x < kWidth)
    {
        [self slideToLeftWithTimeInterval:0.2];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isSlide = NO;
    UIPanGestureRecognizer *pgr = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(slide:)];
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:pgr];
    [self.view addGestureRecognizer:tgr];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
