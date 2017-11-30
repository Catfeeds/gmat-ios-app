//
//  HTCopyRightController.m
//  GMat
//
//  Created by hublot on 2016/10/21.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTCopyRightController.h"

@interface HTCopyRightController ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation HTCopyRightController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
}

- (void)initializeUserInterface {
	self.navigationItem.title = @"版权说明";
	[self.view addSubview:self.textView];
}

- (UITextView *)textView {
	if (!_textView) {
		_textView = [[UITextView alloc] initWithFrame:self.view.bounds];
		_textView.alwaysBounceVertical = true;
		_textView.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
		_textView.font = [UIFont ht_fontStyle:HTFontStyleTitleLarge];
		_textView.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
		_textView.text = @"版权声明\n一、用户账号 用户注册成功后，便成为雷哥GMAT的合法用户，会得到一个密码和帐号。用户需采取合理措施维护其密码和帐号的安全。用户对利用该密码和帐号所进行的一切活动负全部责任；由该等活动所导致的任何损失或损害由用户承担，雷哥GMAT不承担任何责任。\n\n二、用户承诺 用户同意遵守《中华人民共和国保守国家秘密法》、《中华人民共和国著作权法》、 《互联网电子公告服务管理规定》、《信息网络传播权保护条例》、《中华人民共和国计算机信息系统安全保护条例》、《计算机软件保护条例》等有关的法律、法规以及政府部门的规定。在任何情况下，如有他人投诉用户违反上述规定的，雷哥GMAT如果认为用户的行为可能违反上述法律、法规，雷哥GMAT可以在任何时候，有权不经事先通知终止向该用户提供服务。 雷哥GMAT欢迎用户举报任何违反上述法律或侵犯他人权利的上传内容，一经发现违法或侵权的上传内容，雷哥GMAT将根据相关的法律规定进行删除。 用户承诺使用雷哥GMAT的过程中，尊重原创作者知识产权等合法权益，不得采取下列行为： \n1、未经权利人许可，将不具有著作权的作品上传致雷哥GMAT； 2、未经雷哥GMAT书面许可，将使用雷哥GMAT站所载作品进行复制及进行信息网络传播； 3、上传侵犯他人人身权的作品； 4、上传泄漏他人商业机密、个人隐私、国家机密作品或者言论的。\n\n三、处罚措施 1、如果雷哥GMAT发现用户违背本协议禁止性规定，有权利注销用户账户。用户发布或传送任何信息、通讯资料和其它内容，如被删除或未予储存，雷哥GMAT毋须承担任何责任。 2、如果用户的违规行为侵犯他人权益或者违反国家法律禁止性规定，雷哥GMAT有权利向权利人以及国家主管机关公开用户注册信息，该行为不视为侵犯用户隐私权。 3、用户在注册账户时填写的电子邮件地址号码视为用户联系地址，就使用过程中出现的事宜，雷哥GMAT将通过该邮箱地址号码与用户进行联系。\n\n版权声明\n雷哥GMAT为非赢利性网站，所提供的资料仅供学习之用，下载后请及时删除，不得用于任何形式的商业性用途，否则由此产生的法律后果与本站无关。\n\n雷哥GMAT网站及其注册用户本网站内的资料提供者拥有此网站内所有资料的版权。未经雷哥GMAT的明确书面许可，任何人不得复制或仿造本网站内容。\n\n雷哥GMAT多站所有页面的版式、图片版权均为本站所有，未得到书面许可之前，不得用于除雷哥GMAT网站之外的任何其它站点。\n\n雷哥GMAT在建设中引用了互联网上的一些资源并对有明确来源的注明了出处，版权归原作者及网站所有，如果您对本站文章及资料的版权归属存有异议，请您致信service@gmatonline.cn，我们会在24小时内做出答复。\n\n网友在雷哥GMAT网站的原创作品，由雷哥GMAT网站与作者共同享有版权，其他网站或传统媒体如需使用，须与本站联系（service@gmatonline.cn），经过本站授权，方可转载，并在转载时注明原创作者及雷哥GMAT网站链接。\n\n雷哥GMAT对发表在网站内的文章有编辑整理的权利。\n\n雷哥GMAT论坛网友所发表的言论仅代表网友自己，与本站观点无关。\n\n阅读本文即表明您已经阅读并接受上述条款。";
	}
	return _textView;
}
@end
