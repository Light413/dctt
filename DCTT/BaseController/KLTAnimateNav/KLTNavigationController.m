//
//  CZNavigationController.m
//  ChongZu
//
//  Created by cz10000 on 16/4/27.
//  Copyright © 2016年 cz10000. All rights reserved.
//

#import "KLTNavigationController.h"
#import "AnimationContoller.h"

#define ColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface KLTNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>
@property(strong,nonatomic)UIImageView * screenshotImgView;
@property(strong,nonatomic)UIView * coverView;
@property(strong,nonatomic)NSMutableArray * screenshotImgs;


@property(nonatomic,strong)UIImage * nextVCScreenShotImg;


@property(nonatomic,strong)AnimationContoller * animationController;

@end

@implementation KLTNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    
    self.navigationBar.tintColor = ColorFromRGB(0x6F7179);
    
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(-0.8, 0);
    self.view.layer.shadowOpacity = 0.6;
    
    
    // Do any additional setup after loading the view.
    // 1,创建Pan手势识别器,并绑定监听方法
    
    
    _panGestureRec = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRec:)];
    _panGestureRec.edges = UIRectEdgeLeft;
    // 为导航控制器的view添加Pan手势识别器
    [self.view addGestureRecognizer:_panGestureRec];
    
    // 2.创建截图的ImageView
    _screenshotImgView = [[UIImageView alloc] init];
    // app的frame是包括了状态栏高度的frame
    _screenshotImgView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    
    // 3.创建截图上面的黑色半透明遮罩
    _coverView = [[UIView alloc] init];
    // 遮罩的frame就是截图的frame
    _coverView.frame = _screenshotImgView.frame;
    // 遮罩为黑色
    _coverView.backgroundColor = [UIColor blackColor];
    
    // 4.存放所有的截图数组初始化
    _screenshotImgs = [NSMutableArray array];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0)
{
    self.animationController.navigationOperation = operation;
    self.animationController.navigationController = self;
    //    self.animationController.lastVCScreenShot = self.lastVCScreenShotImg;
    // self.animationController.nextVCScreenShot = self.nextVCScreenShotImg;
    return self.animationController;
}
- (AnimationContoller *)animationController
{
    if (_animationController == nil) {
        _animationController = [[AnimationContoller alloc]init];
        
    }
    return _animationController;
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    
    // 只有在导航控制器里面有子控制器的时候才需要截图
    if (self.viewControllers.count >= 1) {
        // 调用自定义方法,使用上下文截图
        [self screenShot];
    }
    
    [super pushViewController:viewController animated:animated];
    
    
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    NSInteger index = self.viewControllers.count;
    NSString * className = nil;
    if (index >= 2) {
        className = NSStringFromClass([self.viewControllers[index -2] class]);
    }
    
    if (_screenshotImgs.count >= index - 1) {
        [_screenshotImgs removeLastObject];
    }
    
    
    return [super popViewControllerAnimated:animated];
}
- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    NSInteger removeCount = 0;
    for (NSInteger i = self.viewControllers.count - 1; i > 0; i--) {
        if (viewController == self.viewControllers[i]) {
            break;
        }
        
        [_screenshotImgs removeLastObject];
        removeCount ++;
        
    }
    _animationController.removeCount = removeCount;
    return [super popToViewController:viewController animated:animated];
}
- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated
{
    [_screenshotImgs removeAllObjects];
    [_animationController removeAllScreenShot];
    return [super popToRootViewControllerAnimated:animated];
}
// 使用上下文截图,并使用指定的区域裁剪,模板代码
- (void)screenShot
{
    // 将要被截图的view,即窗口的根控制器的view(必须不含状态栏,默认ios7中控制器是包含了状态栏的)
    UIViewController *beyondVC = self.view.window.rootViewController;
    // 背景图片 总的大小
    CGSize size = beyondVC.view.frame.size;
    // 开启上下文,使用参数之后,截出来的是原图（YES  0.0 质量高）
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    // 要裁剪的矩形范围
    CGRect rect = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    //注：iOS7以后renderInContext：由drawViewHierarchyInRect：afterScreenUpdates：替代
    //判读是导航栏是否有上层的Tabbar  决定截图的对象
    if (self.tabBarController == beyondVC) {
        [beyondVC.view drawViewHierarchyInRect:rect  afterScreenUpdates:NO];
    }
    else
    {
        [self.view drawViewHierarchyInRect:rect afterScreenUpdates:NO];
    }
    // 从上下文中,取出UIImage
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    // 添加截取好的图片到图片数组
    if (snapshot) {
        [_screenshotImgs addObject:snapshot];
        //self.lastVCScreenShotImg = snapshot;
    }
    
    
    // 千万记得,结束上下文(移除栈顶的基于当前位图的图形上下文)
    UIGraphicsEndImageContext();
    
}


// 监听手势的方法,只要是有手势就会执行
- (void)panGestureRec:(UIScreenEdgePanGestureRecognizer *)panGestureRec
{
    
    // 如果当前显示的控制器已经是根控制器了，不需要做任何切换动画,直接返回
    if(self.visibleViewController == self.viewControllers[0]) return;
    
    // 判断pan手势的各个阶段
    switch (panGestureRec.state) {
        case UIGestureRecognizerStateBegan:
            // 开始拖拽阶段
            [self dragBegin];
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded:
            // 结束拖拽阶段
            [self dragEnd];
            break;
            
        default:
            // 正在拖拽阶段
            [self dragging:panGestureRec];
            break;
    }
}


#pragma mark 开始拖动,添加图片和遮罩
- (void)dragBegin
{
    // 重点,每次开始Pan手势时,都要添加截图imageview 和 遮盖cover到window中
    [self.view.window insertSubview:_screenshotImgView atIndex:0];
    [self.view.window insertSubview:_coverView aboveSubview:_screenshotImgView];
    
    // 并且,让imgView显示截图数组中的最后(最新)一张截图
    _screenshotImgView.image = [_screenshotImgs lastObject];
    //_screenshotImgView.transform = CGAffineTransformMakeTranslation(ScreenWidth, 0);
}


// 默认的将要变透明的遮罩的初始透明度(全黑)
#define kDefaultAlpha 0.6


// 当拖动的距离,占了屏幕的总宽高的3/4时, 就让imageview完全显示，遮盖完全消失
#define kTargetTranslateScale 0.75
#pragma mark 正在拖动,动画效果的精髓,进行位移和透明度变化
- (void)dragging:(UIPanGestureRecognizer *)pan
{
    
    // 得到手指拖动的位移
    CGFloat offsetX = [pan translationInView:self.view].x;
    
    // 让整个view都平移     // 挪动整个导航view
    if (offsetX > 0) {
        self.view.transform = CGAffineTransformMakeTranslation(offsetX, 0);
    }
    
    
    // 计算目前手指拖动位移占屏幕总的宽高的比例,当这个比例达到3/4时, 就让imageview完全显示，遮盖完全消失
    double currentTranslateScaleX = offsetX/self.view.frame.size.width;
    
    if (offsetX < ScreenWidth) {
        
        _screenshotImgView.transform = CGAffineTransformMakeTranslation((offsetX - ScreenWidth) * 0.6, 0);
    }
    
    // 让遮盖透明度改变,直到减为0,让遮罩完全透明,默认的比例-(当前平衡比例/目标平衡比例)*默认的比例
    double alpha = kDefaultAlpha - (currentTranslateScaleX/kTargetTranslateScale) * kDefaultAlpha;
    _coverView.alpha = alpha;
}

#pragma mark 结束拖动,判断结束时拖动的距离作相应的处理,并将图片和遮罩从父控件上移除
- (void)dragEnd
{
    // 取出挪动的距离
    CGFloat translateX = self.view.transform.tx;
    // 取出宽度
    CGFloat width = self.view.frame.size.width;
    
    if (translateX <= 40) {
        // 如果手指移动的距离还不到屏幕的一半,往左边挪 (弹回)
        [UIView animateWithDuration:0.3 animations:^{
            // 重要~~让被右移的view弹回归位,只要清空transform即可办到
            self.view.transform = CGAffineTransformIdentity;
            // 让imageView大小恢复默认的translation
            _screenshotImgView.transform = CGAffineTransformMakeTranslation(-ScreenWidth, 0);
            // 让遮盖的透明度恢复默认的alpha 1.0
            _coverView.alpha = kDefaultAlpha;
        } completion:^(BOOL finished) {
            // 重要,动画完成之后,每次都要记得 移除两个view,下次开始拖动时,再添加进来
            [_screenshotImgView removeFromSuperview];
            [_coverView removeFromSuperview];
        }];
    } else {
        // 如果手指移动的距离还超过了屏幕的一半,往右边挪
        [UIView animateWithDuration:0.3 animations:^{
            // 让被右移的view完全挪到屏幕的最右边,结束之后,还要记得清空view的transform
            self.view.transform = CGAffineTransformMakeTranslation(width, 0);
            // 让imageView位移还原
            _screenshotImgView.transform = CGAffineTransformMakeTranslation(0, 0);
            // 让遮盖alpha变为0,变得完全透明
            _coverView.alpha = 0;
        } completion:^(BOOL finished) {
            // 重要~~让被右移的view完全挪到屏幕的最右边,结束之后,还要记得清空view的transform,不然下次再次开始drag时会出问题,因为view的transform没有归零
            self.view.transform = CGAffineTransformIdentity;
            // 移除两个view,下次开始拖动时,再加回来
            [_screenshotImgView removeFromSuperview];
            [_coverView removeFromSuperview];
            
            // 执行正常的Pop操作:移除栈顶控制器,让真正的前一个控制器成为导航控制器的栈顶控制器
            [self popViewControllerAnimated:NO];
            
            // 重要~记得这时候,可以移除截图数组里面最后一张没用的截图了
            // [_screenshotImgs removeLastObject];
            [self.animationController removeLastScreenShot];
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
//    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
//    if (self.childViewControllers.count == 1) {
//        // 表示用户在根控制器界面，就不需要触发滑动手势，
//        return NO;
//    }
//
//    return YES;
//}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
