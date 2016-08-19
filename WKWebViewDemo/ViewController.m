//
//  ViewController.m
//  WKWebViewDemo
//
//  Created by 唐明明 on 16/8/19.
//  Copyright © 2016年 Methodname. All rights reserved.
//

#import "ViewController.h"
#import "WKWebViewJavascriptBridge.h"
#import <WebKit/WebKit.h>

@interface ViewController ()<WKNavigationDelegate,WKUIDelegate>


@property (weak, nonatomic) WKWebView *webView;


@property WKWebViewJavascriptBridge * bridge;

@property(nonatomic,assign)BOOL bodyColorIsBlack;


@property(nonatomic,assign)int fontSize;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _bodyColorIsBlack = NO;
    _fontSize = 15;
    WKWebView* webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    [self.view addSubview:webView ];
    
    self.webView = webView;
    [WKWebViewJavascriptBridge enableLogging];
    _bridge = [WKWebViewJavascriptBridge bridgeForWebView:webView];
    [_bridge setWebViewDelegate:self];
    [self loadExamplePage:webView];
    
    
    //registerHandler 【OC接收JS的消息】
    [self.bridge registerHandler:@"ClickTest" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"%@",data);
    }];
    
    //点赞
    [_bridge registerHandler:@"ClickSupportHandler" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"点赞");
    }];
    
    //字体大小
    [_bridge registerHandler:@"ChangeFontSizeHandler" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"字体大小回调");
    }];
    
    //回复
    [_bridge registerHandler:@"RestoreHandler" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"弹出回复输入框");
    }];
    
    //回复
    [_bridge registerHandler:@"GotoAboutNewsDetailHandler" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"查看相关的新闻详情");
        
    }];

    
    
    
    [self loadExamplePage:webView];
  
}


/*!
 *  @author methodname, 16-08-10 13:08:36
 *
 *  加载本地HTML文件内容
 *
 *  @param webView
 */
- (void)loadExamplePage:(WKWebView*)webView
{
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"Test" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:[self replaceWithModelAppHemlString:appHtml] baseURL:baseURL];
    
//    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"Test" ofType:@"html"];
//    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
//    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
//    [webView loadHTMLString:appHtml baseURL:baseURL];
}



/*!
 *  @author methodname, 16-08-17 14:08:11
 *
 *  替换模板内容
 *
 *  @param str 模板HTML字符串
 *
 *  @return 填充后的HTML字符串
 */
-(NSMutableString *)replaceWithModelAppHemlString:(NSString *)str
{
    NSMutableString *mstr = [NSMutableString stringWithString:str];
    
    //背景颜色
    NSRange bodyBGColorRange = [mstr rangeOfString:@"[-bodyBGColor-]"];
    if (_bodyColorIsBlack) {
        [mstr replaceCharactersInRange:bodyBGColorRange withString:@" style = \"background:#000000\""];
    }
    else
    {
        [mstr replaceCharactersInRange:bodyBGColorRange withString:@" style = 'background:#ffffff'"];
    }
    
    //标题
    NSRange titleRange = [mstr rangeOfString:@"[-newsTitle-]"];
    [mstr replaceCharactersInRange:titleRange withString:@"知情人:王宝强离婚案内幕非常复杂 涉刑事问题"];
    
    //发布时间
    NSRange dateRange = [mstr rangeOfString:@"[-newsDate-]"];
    [mstr replaceCharactersInRange:dateRange withString:@"2016-08-17 01:30:44"];
    
    
    
    //作者
    NSRange authorRange = [mstr rangeOfString:@"[-newsAuthor-]"];
    [mstr replaceCharactersInRange:authorRange withString:@"来源: 新京报(北京)"];
    
    
    //新闻内容
    NSRange contentRange = [mstr rangeOfString:@"[-newsContent-]"];
    [mstr replaceCharactersInRange:contentRange withString:@"<p style='text-align:center;font-size:20px;'>我是标题，我就是可以这么大</p>"
     @"<img src=\"http://img4.cache.netease.com/ent/2016/8/17/20160817112834038e8.jpg\"/>"
     @"<p style='text-align:center'>该店铺</p>"
     @"<img src=\"http://img3.cache.netease.com/ent/2016/8/17/20160817112836d4fb2_550.jpg\"/>"
     @"新京报讯 王宝强离婚案再曝重磅消息。昨日，王宝强妻子马蓉向朝阳法院起诉，称王宝强14日凌晨发布离婚声明涉嫌名誉侵权。而之前一天，王宝强本人在律师陪同下，在北京朝阳法院起诉马蓉要求离婚。（新京报昨日报道）知情人告诉新京报记者，王宝强银行账户余额只剩下十几万，其他的财产部分被转移。"
     @"<img src=\"http://img3.cache.netease.com/ent/2016/8/17/20160817112836d4fb2_550.jpg\"/>"
     @"<img src=\"http://img4.cache.netease.com/ent/2016/8/17/20160817112834038e8.jpg\"/>"
     @"马蓉起诉要求王宝强删博道歉"
     @"昨日一早，一名律师持马蓉的委托手续及诉状等材料至北京朝阳法院，以王宝强构成名誉侵权为由申请立案。"
     @"<img src=\"http://img3.cache.netease.com/ent/2016/8/17/20160817112836d4fb2_550.jpg\"/>"
     @"<img src=\"http://img3.cache.netease.com/ent/2016/8/17/20160817112836d4fb2_550.jpg\"/>"
     @"<img src=\"http://img3.cache.netease.com/ent/2016/8/17/20160817112836d4fb2_550.jpg\"/>"
     @"马蓉在起诉书中称，其与王宝强系夫妻关系，8月14日零点21分，王宝强在其实名认证个人微博中发布声明。该微博发布后，一些不明真相的网友基于前述造谣内容，对其进行大肆诋毁、谩骂，甚至连两个年幼的孩子都不放过。"
     @"<img src=\"http://img3.cache.netease.com/ent/2016/8/17/20160817112836d4fb2_550.jpg\"/>"
     @"马蓉认为，上述内容对其构成造谣诋毁，系恶意对其进行人身攻击，王宝强所发布的造谣诽谤言论给其个人名誉和社会评价造成严重负面影响，并给其造成极其严重的精神损害。为维护合法权益，减少因王宝强行为给两个年幼孩子所造成的心理创伤，诉至法院，要求王宝强停止侵权，立即删除2016年8月14日零点21分发布的微博，并在其个人微博首页置顶赔礼道歉连续不低于30天。"
     @"<img src=\"http://img3.cache.netease.com/ent/2016/8/17/20160817112836d4fb2_550.jpg\"/>"
     @"经审查符合立案条件，北京朝阳法院已正式受理此案。"
     @"<img src=\"http://img3.cache.netease.com/ent/2016/8/17/20160817112836d4fb2_550.jpg\"/>"
     @"<img src=\"http://img3.cache.netease.com/ent/2016/8/17/20160817112836d4fb2_550.jpg\"/>"
     @"<p style = 'font-size:12px;text-align:right;color:rgb(245, 245, 245);'><font>Copyright &copy; 面包财经</font></p>"];
    
    //标签
    NSRange tagsRange = [mstr rangeOfString:@"[-newsTags-]"];
    [mstr replaceCharactersInRange:tagsRange withString:@"<a class=\"bq\">头条</a>"
     @"<a class=\"bq\">娱乐</a>"
     @"<a class=\"bq\">关注</a>"];
    
    //相关新闻
    NSRange aboutnewsRange = [mstr rangeOfString:@"[-aboutNewsList-]"];
    [mstr replaceCharactersInRange:aboutnewsRange withString:@"<div class=\"containerNews\">"
     @"<div class=\"AbountImageDiv\">"
     @"<img src=\"http://www.360haoshidai.com/images/new_index_45.jpg\" class=\"AbountImage\" />"
     @"</div>"
     @"<div class=\"abountNewsContentDiv\">"
     @"<p class=\"abountNewsContent\">【环球时报综合报道】“中国女子入境越南时被边检人员在护照上写脏话”事件引起中国网民愤怒。</p>"
     @"<p class=\"abountNewsTime\">11:11<span class=\"abountNewsType\">新闻类型</span></p>"
     @"</div>"
     @"<hr style=\"clear: both;\" />"
     @"</div>"
     @"<div class=\"containerNews\">"
     @"<div class=\"AbountImageDiv\">"
     @"<img src=\"http://www.360haoshidai.com/images/new_index_45.jpg\" class=\"AbountImage\" />"
     @"</div>"
     @"<div class=\"abountNewsContentDiv\">"
     @"<p class=\"abountNewsContent\">【环球时报综合报道】“中国女子入境越南时被边检人员在护照上写脏话”事件引起中国网民愤怒。</p>"
     @"<p class=\"abountNewsTime\">11:11<span class=\"abountNewsType\">新闻类型</span></p>"
     @"</div>"
     @"<hr style=\"clear: both;\" />"
     @"</div>"
     @"<div class=\"containerNews\">"
     @"<div class=\"AbountImageDiv\">"
     @"<img src=\"http://www.360haoshidai.com/images/new_index_45.jpg\" class=\"AbountImage\" />"
     @"</div>"
     @"<div class=\"abountNewsContentDiv\">"
     @"<p class=\"abountNewsContent\">【环球时报综合报道】“中国女子入境越南时被边检人员在护照上写脏话”事件引起中国网民愤怒。</p>"
     @"<p class=\"abountNewsTime\">11:11<span class=\"abountNewsType\">新闻类型</span></p>"
     @"</div>"
     @"<hr style=\"clear: both;\" />"
     @"</div>"];
    
    //评论列表
    NSRange hfRange = [mstr rangeOfString:@"[-newshfList-]"];
    [mstr replaceCharactersInRange:hfRange withString:@"<div class=\"hfRow\">"
     @"<div class=\"hfRowHeadIcon\">"
     @"<div class=\"im-com\"></div></div>"
     @"<div class=\"hfRowCell\"></div>"
     @"<div class=\"hfRowContent\">"
     @"<p class=\"hfRowContent1\">森昊一枝花76357<span>"
     @"<a class =\"zhan upZhan\"><i class='fa fa-thumbs-o-up' ></i><span>1564</span></a>"
     @"<a class=\"downZhan\"><i class='fa fa-thumbs-o-down'></i><span>45</span></a></span></p>"
     @"<p class=\"hfRowContent2\">井陉党员兄弟携手转移198人 获＂燕赵楷模＂称号</p>"
     @"<p class=\"hfRowContent3\">25分钟前<a>回复</a></p>"
     @"</div>"
     @"</div>"];
    
    
    
    
    return mstr;
}


/*!
 *  @author methodname, 16-08-10 13:08:16
 *
 *  WKWebView加载完成后
 *
 *  @param webView
 *  @param navigation
 */
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    if (self.bodyColorIsBlack) {
        id data = @{ @"isOn": @"1" };
        //发送数据
        [_bridge callHandler:@"ClickTest" data:data responseCallback:^(id response) {
            
        }];
    }else{
        id data = @{ @"isOn": @"0" };
        //发送数据
        [_bridge callHandler:@"ClickTest" data:data responseCallback:^(id response) {
            
        }];
    }
}

- (IBAction)changeBGColorClick:(id)sender
{
    self.bodyColorIsBlack = !self.bodyColorIsBlack;
    //callHandler【OC向JS发生消息】
    if (self.bodyColorIsBlack) {
        id data = @{ @"isOn": @"1" };
        //发送数据
        [_bridge callHandler:@"ClickTest" data:data responseCallback:^(id response) {
            
        }];
    }else{
        id data = @{ @"isOn": @"0" };
        //发送数据
        [_bridge callHandler:@"ClickTest" data:data responseCallback:^(id response) {
            
        }];
    }


}

- (IBAction)changeFontSizeClick:(id)sender
{
    id data = @{ @"fontsize": @(self.fontSize) };
    [_bridge callHandler:@"ChangeFontSizeHandler" data:data responseCallback:nil];
    _fontSize +=2;
}


- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{    // js 里面的alert实现，如果不实现，网页的alert函数无效
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler();
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:^{}];
    
}





@end
