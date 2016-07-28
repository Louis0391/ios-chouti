//
//  DragViewController.m
//  抽屉效果的的编写
//
//  Created by hqc on 15/11/11.
//  Copyright © 2015年 hqc. All rights reserved.
//

#import "DragViewController.h"

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
#define targetL -275
#define targetR 275

@interface DragViewController ()

/** mainV */
@property(nonatomic, weak) UIView *mainV;
/** leftV */
@property(nonatomic, weak) UIView *leftV;
/** rightV */
@property(nonatomic, weak) UIView *rightV;
@end

@implementation DragViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加子控件View
    [self setUpSubVies];
    
    //添加手势(拖拽手势)
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.mainV addGestureRecognizer:pan];
    
    //添加点按手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    
    [self.view addGestureRecognizer:tap];
}

//当点击mainv的旁边让mainV做复位动作
-(void)tap{
    [UIView animateWithDuration:0.25 animations:^{
        self.mainV.frame = self.view.bounds;
    }];
    
}
//当手指在mainV上拖拽时调用
-(void)pan:(UIPanGestureRecognizer *)pan{
//获取手指偏移量
    CGPoint transP = [pan translationInView:self.mainV];
    self.mainV.frame = [self frameWithOffsetX:transP.x];
    if (self.mainV.frame.origin.x > 0) {
        self.rightV.hidden = YES;
    }else{
        self.rightV.hidden = NO;
    }
    
    //手指松开时做定位
    if (pan.state == UIGestureRecognizerStateEnded) {
        CGFloat target = 0;
        if (self.mainV.frame.origin.x > screenWidth * 0.5) {
            target = targetR;
        }else if(CGRectGetMaxX(self.mainV.frame) < screenWidth * 0.5){
            target = targetL;
        }
        CGFloat offsetX = target - self.mainV.frame.origin.x;
        [UIView animateWithDuration:0.5 animations:^{
            self.mainV.frame = [self frameWithOffsetX:offsetX];
        }];
        
    }
    //复位
    [pan setTranslation:CGPointZero inView:self.mainV];
}
//根据一个偏移量计算frame

#define maxY 100


-(CGRect)frameWithOffsetX:(CGFloat)offsetX{
    CGRect frame = self.mainV.frame;
    //计算mainV的原点x值坐标
    frame.origin.x += offsetX;
    //动态计算mainV的y值坐标
    frame.origin.y =fabs(maxY * frame.origin.x / screenWidth);
    //动态计算mainV的高度
    frame.size.height = screenHeight - 2 *  frame.origin.y;
//    self.mainV.frame = frame;
    return frame;
}
-(void)setUpSubVies{
    UIView *leftView = [[UIView alloc] initWithFrame:self.view.bounds];
    //leftView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    leftView.backgroundColor = [UIColor blueColor];
    self.leftV = leftView;
    [self.view addSubview:leftView];
    
    UIView *rightView = [[UIView alloc] initWithFrame:self.view.bounds];
    rightView.backgroundColor = [UIColor greenColor];
    self.rightV = rightView;
    [self.view addSubview:rightView];
    
    UIView *mainView = [[UIView alloc] initWithFrame:self.view.bounds];
    mainView.backgroundColor = [UIColor redColor];
    self.mainV = mainView;
    [self.view addSubview:mainView];

}
@end
