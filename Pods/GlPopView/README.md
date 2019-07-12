# GlPopView

自定义带箭头的气泡，也支持关闭箭头，四个圆角支持分别设置显示

支持pod导入

pod 'GlPopView'



使用方式：

GlPopView *popView = [[GlPopView alloc] initWithFrame:CGRectMake(10, 110 , 100, 150)];

//箭头朝上

popView.congfig.directionArrow = GlArrowDirectionTop;

//箭头靠右

popView.congfig.alignmentArrow = GlArrowAlignmentRight;

//箭头顶的水平方向偏移值

popView.congfig.offsetopHorizontalArrow = popView.congfig.widthArrow *0.5;

[self.view addSubview:popView];



注意！！！初始化完，后期更改属性，要手动更新请使用：[popView setNeedsDisplay];




![image](https://github.com/gleeeli/GlPopView-Master/blob/master/%E6%95%88%E6%9E%9C%E5%9B%BE.png)
