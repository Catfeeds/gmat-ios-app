
#define AppendString(domain, detail) [NSString stringWithFormat:@"%@%@", domain, detail]

// gmat 域名拼接, 如需切换测试环境可以把 DomainGmatNormal 换成 DomainGmatTest, 不过测试环境很少用
#define GmatApi(detail) AppendString(DomainGmatNormal, detail)

// gmat 文件资源域名拼接
#define GmatResourse(detail) AppendString(DomainGmatResourceNormal, detail)

// 商城域名拼接
#define ShopApi(detail) AppendString(DomainShopNormal, detail)

// 商城文件资源域名拼接
#define ShopResourse(detail) AppendString(DomainShopResourceNormal, detail)

// 八卦域名拼接
#define GossIpApi(detail) AppendString(DomainGossipNormal, detail)

// 用户系统域名拼接
#define LoginApi(detail) AppendString(DomainLoginNormal, detail)




#define DomainGmatNormal @"http://www.gmatonline.cn/index.php?web/webapi"
#define DomainGmatResourceNormal @"http://www.gmatonline.cn/"

#define DomainGmatTest @"http://test.gmat.viplgw.cn/index.php?web/webapi"
#define DomainGmatResourceTest @"http://test.gmatonline.cn/"




#define DomainShopNormal @"http://open.viplgw.cn/cn"
#define DomainShopResourceNormal @"http://open.viplgw.cn/cn/"




#define DomainGossipNormal @"http://bbs.viplgw.cn/cn/app-api"

#define DomainLoginNormal @"http://login.gmatonline.cn/cn/app-api"
