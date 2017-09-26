//
//  HTReportSingleFourthCell.m
//  GMat
//
//  Created by hublot on 16/11/30.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTReportSingleFourthCell.h"
#import "HTReportModel.h"
#import "NSString+HTString.h"
#import <NSObject+HTTableRowHeight.h>

@interface HTReportSingleFourthCell ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation HTReportSingleFourthCell

- (void)didMoveToSuperview {
	self.backgroundColor = [UIColor clearColor];
	[self addSubview:self.textView];
	[self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsZero);
	}];
}

- (void)setModel:(HTReportModel *)model row:(NSInteger)row {
	NSString *textViewString = @"";
	if (self.reportStyle == 1) {
		if (model.sc_data.correctAll >= 80) {
			textViewString = @"SC部分的正确率可以达到80%以上，说明你距离700更近一步了呢。在接下来的日子里，只需要保持常规训练，以10道左右为佳，维持 自己现有的题感就可以了。如果还想继续冲刺，则需要多花一点时间在错题分析上面。资料的话:自己的错题库+prep(建议08-12-07)";
		} else if (model.sc_data.correctAll >= 65) {
			textViewString = @"65%-80%，SC部分这个正确率有很大可能性是忽略了逻辑语义这个考点，要多去练习一些全句画线或者句式有变化的句子;还有一 种可能性是某几个知识点没有掌握清楚。这个建议先去看一下相关知识点讲解，再重新做题。资料的话:自己的错题库+prep(建议08-12- 07) 知识点可以配合《曼哈顿语法》或者《白勇语法》以及雷哥知识库(http://www.gmatonline.cn/learn/64.html)";
		} else if (model.sc_data.correctAll >= 50) {
			textViewString = @"50%-65%，建议重新过一遍知识点，分析自己做错的题目当中的所有错误选项原因，务必做到搞懂才放过。建议10-20道一组，每天 3-5组进行训练。资料的话:自己的错题库+OG+prep(建议08-12-07) 知识点可以配合《曼哈顿语法》或者《白勇语法》以及雷哥知识库 (http://www.gmatonline.cn/learn/64.html)";
		} else {
			textViewString = @"50%以下，重新学习吧。磨刀不误砍柴工，要把每一个知识点都弄懂哦~熟悉GMAT的九大考点。从粗再细最后形成系统。资料的 话，建议先看雷哥知识库(http://www.gmatonline.cn/learn/64.html)或《曼哈顿语法》或者《白勇语法》熟悉基本考点，然后再去OG，等 正确率上来后，在做prep(建议08-12-07)。";
		}
	} else if (self.reportStyle == 2) {
		if (model.rc_data.correctAll >= 60) {
			textViewString = @"RC的正确率达到60%，并不是说就万事大吉了，一定多去关注自己错题有没有集合在同一篇文章下，对于这种文章，要多注意总结 分析结构。一般来说，只要阅读可以保证每篇错不超过一半，就可以保证不掉库。每天的练习量需要以文章类型或者题型为主。如果是文 章类型的问题，那么要多注意分析文章结构;如果是题型问题，则需要多总结相关的题型技巧。资料的话:自己的错题库+prep(建议08- 12-07)";
		} else if (model.rc_data.correctAll >= 40) {
			textViewString = @"40%-60%，分析题型和篇章结构，先分析是什么导致正确率上不去的罪魁祸首。其次，熟悉文章的篇章结构。观察自己的定位是不是 每次都可以定准确。每一篇文章可以稍微多花一点时间用来分析。建议一篇一篇去做，同类型的文章放在一起做。资料的话:雷哥知识库 (http://www.gmatonline.cn/learn/65.html)+OG+prep(建议08-12-07)，如果是方法问题，可以看《小安阅读法》;长难句则看《杨鹏长难 句》即可。";
		} else {
			textViewString = @"40%以下，需要背诵单词，长难句训练。精度阅读内容，掌握篇章结构。一篇阅读建议读2-3遍之后，再做题。资料的话，长难句可 以看《杨鹏阅读难句》，方法及题型可以参照雷哥知识库(http://www.gmatonline.cn/learn/65.html)，这时候，用OG来配合熟悉方法，稍 微好一点之后，在做prep(建议08-12-07)";
		}
	} else if (self.reportStyle == 3) {
		if (model.cr_data.correctAll >= 70) {
			textViewString = @"CR的正确率达到70%以上，如果还想提高，就只有在错题上面多下一点功夫，在分析错题的时候主要以错误选项为主，看能不能从 错误选项当中推出相似的思维模式。多总结自己的易错点，从而达到提高的作用。除此之外，每天保证10道新题的练习量就可以了。资料 的话:自己的错题库+prep(建议08-12-07)";
		} else if (model.cr_data.correctAll >= 50) {
			textViewString = @"50%-70%，对于做错的题目分门别类，从题型入手，逐步突破。一定要搞定错题原因，同时对照自己的错题原因，强化自己的思维习 惯，做到同类题不再错。建议每次5-10题一组，每天3-5组进行训练。必要时，需要做长难句概括训练以及词汇积累。这个部分的资料比较 少，可以通过看知识点的报告和分数段，从而在雷哥题库上练习。建议做OG+prep(建议08-12-07)。雷哥知识库链接: http://www.gmatonline.cn/learn/63.html";
		} else {
			textViewString = @"50%以下，首先判断是不是单词和长难句原因，如果是那么就去练习吧。如果不是，那么就需要看一些逻辑相关的书籍来补充自己的 商科思维。判断方法:把题目翻译成中文，如果有很大几率做对，那一般就是单词原因。资料的话，建议先看雷哥知识库 (http://www.gmatonline.cn/learn/63.html)或《bible》熟悉基本方法，然后再去OG，等正确率上来后，在做prep(建议08-12-07)。";
		}
	} else if (self.reportStyle == 4) {
		if (model.quant_data.correctAll >= 90) {
			textViewString = @"90%的正确率已经说明你的数学没有太大的问题，只有继续保持就可以了~多注意易错点就好。资料的话:自己的错题库+prep07(考 前必做)";
		} else if (model.quant_data.correctAll >= 80) {
			textViewString = @"80%-90%，首先查看自己对于DS题型的考试方式是否已全部知晓，这个正确率有很大可能性都是因为不了解DS考法，尤其是自己细 想有没有找不出错题原因的题目。如果是，纠正思路。其次，查看是不是有术语或者数学表达方式不熟，要对其多加防范，总结句式例 题。必要时，加强长难句训练。最后，易错点逐个攻破，加深印象。资料的话:自己的错题库+prep07(考前必做) 知识点可以在雷哥知 识库(http://www.gmatonline.cn/learn/66.html)里查看。";
		} else if (model.quant_data.correctAll >= 60) {
			textViewString = @"60%-80%，一定是有某些知识点没有特别清楚。建议学习后，再练习习题，而不要一味的做题。知识点可以参考雷哥知识库 (http://www.gmatonline.cn/learn/66.html)，题目练习以prep 07和OG为主。";
		} else {
			textViewString = @"60%以下，背诵数学词汇，看数学知识点，逐个攻破。之后，再去做题。先看OG math review，掌握考试大纲及基本词汇后，再做OG 数学部分。如果还有知识点有问题，可以看雷哥知识库(http://www.gmatonline.cn/learn/66.html)或《陈向东数学高分突破》或上网搜索， 稍微熟悉一点后，再做prep07.";
		}
	}

	self.textView.text = textViewString;
    self.textView.ht_h = [self.textView.text ht_stringHeightWithWidth:HTSCREENWIDTH font:self.textView.font textView:self.textView];
	CGFloat modelHeight = self.textView.ht_h;
    [model ht_setRowHeightNumber:@(modelHeight) forCellClass:self.class];
}

- (UITextView *)textView {
	if (!_textView) {
		_textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, HTSCREENWIDTH, 0)];
		_textView.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
		_textView.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
		_textView.font = [UIFont systemFontOfSize:13];
		_textView.editable = false;
	}
	return _textView;
}


@end
