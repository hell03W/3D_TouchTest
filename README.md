# 3D_TouchTest
3D Touch 作为苹果新出的一个功能, 从开发上面来讲, 还是很简单的, 毕竟是是新功能嘛. 这不是闲着没事, 看了一下, 顺便写个demo, 让更多的人更容易的学习.

3D Touch 可以做的事情:

* icon的菜单
	* 静态菜单
	* 动	态菜单
	* 相应菜单的点击事件, 并做相关的动作
* peek和pop
	* peek 轻摁预览下个控制器
	* pop 重摁跳转到下个控制器
	* peek期间自定义的操作
* force属性

### 1. icon的菜单
如下所示:
![](http://ww3.sinaimg.cn/large/6281e9fbgw1f1m6vqobdaj20uk0js0vl.jpg)
重摁弹出快捷菜单, 这种菜单分为 静态菜单和动态菜单, 创建方式和效果有所区别. 静态菜单通过plist来创建, 在应用第一次安装到手机上未打开过之前就可以使用, 静态菜单在应用运行期间是不会发生变化的; 动态菜单在应用在手机上打开过一次之后可以使用, 是在AppDelegate中通过代码创建的, 在用户安装到手机上之后, 是可以通过改变菜单内容的, 比如通讯录可以做成, 动态菜单展示最近拨打过的电话. 两种菜单最多可以创建四个, 如果一个应用既有静态菜单也有动态菜单, 静态菜单总是会摆放在靠近icon的位置.

 动态菜单和静态菜单点击事件都是在 application: performActionForShortcutItem: completionHandler: 这个方法中监听并实现事件处理和跳转的. 

#### 1.1 通过plist创建静态菜单
如下图所示, 创建静态菜单, 可以配置的有五个属性, 

```
IApplicationShortcutItems // 配置plist时候, 所有子项目需要放在这个键的字典下面
UIApplicationShortcutItemType // 必须有, 可以为空, 用来区别不同的icon
UIApplicationShortcutItemTitle // 必须有, 可以用来区别不同的icon
UIApplicationShortcutItemSubtitle // 非必须, 子标题
UIApplicationShortcutItemIconType // 非必须, 使用系统图标的样式
UIApplicationShortcutItemIconFile // 非必须, 使用的icon文件
```
![](http://ww3.sinaimg.cn/large/6281e9fbgw1f1m74vacpdj21520kstiw.jpg)

#### 1.2 通过代码创建动态菜单
创建动态菜单的代码如下所示, `UIApplicationShortcutItem` 类还是比较简单的, 可以看看api或者官方文档上面的解释. 创建动态菜单需要在 `application:didFinishLaunchingWithOptions:`中创建.

```
- (void)createShortCutItems
{
    UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeAlarm];
    UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeAudio];
    UIApplicationShortcutIcon *icon3 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeBookmark];
    
    UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc] initWithType:@"first" localizedTitle:@"first item" localizedSubtitle:@"第一个" icon:icon1 userInfo:nil];
    UIApplicationShortcutItem *item2 = [[UIApplicationShortcutItem alloc] initWithType:@"second" localizedTitle:@"second item" localizedSubtitle:@"第二个" icon:icon2 userInfo:nil];
    UIApplicationShortcutItem *item3 = [[UIApplicationShortcutItem alloc] initWithType:@"third" localizedTitle:@"third item" localizedSubtitle:@"第三个" icon:icon3 userInfo:nil];
    
    NSArray *newArray = @[item1, item2, item3];
    
    [UIApplication sharedApplication].shortcutItems = newArray;
    
}
```
#### 1.3 处理菜单的点击事件
 当点击 Home Screen Quick Actions 进入应用的时候, 会走这个方法, 不管应用是否在杀死状态, 都会走这个方法(已测试).

 在这个方法里面对点击事件的进行处理, 做相应的操作. 比如, 跳转到指定的页面.

```
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    NSString *itemType = shortcutItem.type;
    if ([itemType isEqualToString:@"first"]) {
        NSLog(@"点击了第一个");
    }
    else if ([itemType isEqualToString:@"second"]) {
        NSLog(@"点击了第二个");
    }
    else if ([itemType isEqualToString:@"third"]) {
        NSLog(@"点击了第三个");
    }
    else if ([itemType isEqualToString:@"forth"]) {
        NSLog(@"点击了第四个");
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:itemType delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}
```

### 2. peek和pop
首先 peek 和 pop 的操作是在`UIViewControllerPreviewingDelegate`这个代理的代理方法中处理的, 所以需要遵循这个代理方法.

把需要支持peek的view注册一下:

```
// 判断控制器是否支持3DTouch
if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
     // 注册支持3DTouch的视图:cell,并设置代理
     // @interface ViewController () <UIViewControllerPreviewingDelegate>
     [self registerForPreviewingWithDelegate:self sourceView:cell];
}
```

#### 2.1 peek操作
在这个方法里面要返回要peek的控制器, 如果是UITableView, 需要去计算点击的位置, 拿到数据源.

```
// If you return nil, a preview presentation will not be performed
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location NS_AVAILABLE_IOS(9_0)
{
// 计算点击的cell的indexPath
    location = [self.tableView convertPoint:location fromView:[previewingContext sourceView]];
    NSIndexPath *path = [self.tableView indexPathForRowAtPoint:location];
    
    SecondViewController *secondVC = [[SecondViewController alloc] init];
    secondVC.content = self.dataArray[path.row];
//    secondVC.preferredContentSize = CGSizeMake(0, 200); // 只能设置高度,宽度是固定的, 这里除了设置高度, 还可以设置很多其他的属性, 详见api

//    vc.view.backgroundColor = [UIColor greenColor]; // 在这里可以对 viewController 进行一些基本的设置
    
    return secondVC;
}
```
#### 2.2 pop操作
pop操作就更简单了, 在这个方法里面, 返回要pop的控制器即可.

```
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit NS_AVAILABLE_IOS(9_0)
{
    [self presentViewController:viewControllerToCommit animated:YES completion:nil];// 动画是无效的
}
```
#### 2.4 peek期间的自定义操作
需要在`- (NSArray<id<UIPreviewActionItem>> *)previewActionItems`方法中返回包含`UIPreviewAction`的数组, 具体代码如下所示.

```
// 使用懒加载的数组.
- (NSArray *)preActions
{
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"大赞" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"你点击了    大赞");
    }];
    
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"中赞" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"你点击了    中赞");
    }];
    
    UIPreviewAction *action3 = [UIPreviewAction actionWithTitle:@"小赞" style:UIPreviewActionStyleSelected handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"你点击了    小赞");
    }];
    
    NSArray *actions = @[action1, action2, action3];
    UIPreviewActionGroup *actionsGroup = [UIPreviewActionGroup actionGroupWithTitle:@"怎么赞呢?" style:UIPreviewActionStyleDefault actions:actions];
    
    return @[actionsGroup];
}

// 这个方法的返回值, 才是会显示的组, 本例使用懒加载加载数据.
- (NSArray<id<UIPreviewActionItem>> *)previewActionItems
{
    return self.preActions;
}
```
### 3. force属性
UITouch和UIPress新增了force属性, 是一个float类型的值, 代表摁压的力度, 数值越大, 标示摁压的力度越大, iPhone测试最大值是: 6.666667 .

```
UITouch *touch = [touches anyObject];
NSLog(@"touch force = %f", touch.force);
```





3DTouch, peek时候, 左右滑动做不同的操作这个是怎么实现的 ?