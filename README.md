# Walletverse  Core 接入文档

> [Walletverse 项目地址](https://github.com/Walletverse/walletverse-ios)
>可下载demo查看具体接入细节
>
> [Walletverse framework 地址](https://github.com/Walletverse/walletverse-ios/tree/master/Walletverse/IosSDK)
>
> [Walletverse ipa包](https://github.com/Walletverse/walletverse-ios/tree/master/demo) 下载地址

### 1、 集成

---

[comment]: <> (下载[ipa]&#40;http://walletverse.tech/&#41;包，并添加到工程中)

##### 1.1 将 SDK 项目 walletverse-ios 目录中的如下文件夹添加到开发项目中。

```swift
IosSDK
```

##### 1.2 开发项目 Podfile 文件中添加以下依赖库。

```swift
pod 'CryptoSwift'
pod 'SwiftyJSON'
pod 'Then'
pod 'Moya'
pod 'HandyJSON'
pod 'MBProgressHUD'
pod 'GRDB.swift','~>3.7.0'
```

##### 1.3 命令行在开发项目根目录下执行 Pod 命令同步依赖库。

```shell
pod install
```

##### 1.4 开发项目添加网络请求权限。开发项目 info 文件中添加如下权限。

```info
<key>NSAppTransportSecurity</key>
<dict>
<key>NSAllowsArbitraryLoads</key>
<true/>
</dict>
```

### 2、 初始化

>初始化需要下列配置参数，如APP中有切换语言，切换显示单位，切换换算单位功能，请调用正确方法通知SDK，相关方法调用请参照文档下方 --《其它相关调用》
---

```swift
APPID = "testappid"
APPKEY = "testappkey"

uuid //设备唯一id
language //enum 语言
currency //enum 显示单位
unit //enum 代币换算单位
userConfig = UserConfig(uuid: uuid, language: language, currency: currency, cs: unit)


Walletverse.install(appId: Constants.APPID, appKey: Constants.APPKEY, userConfig: userConfig) { (result) in
    if let isTrue = resultData {
        // Success
    } else {
        // Failed
    }
}

```

### 3、 调用

---

##### 3.0 说明

> 为了方便开发这使用，在使用SDK的api调用时，我们会限定请求参数数据，已帮助开发者
>
>如果您的项目中使用swift开发语言，并且支持协程，SDK也同样支持协程的调用方式，例如3.1。其他方法也是一样的调用方式

##### 3.1 创建账户

```swift
 let params = JSCoreParams()
          .put(key: "chainId", value: "0x1") ?? JSCoreParams()  //链id
 Walletverse.generateAccount(params: params) { (returnData, error) in
    if let mnemonic = resultData {    //创建账户成功
        // Success
    } else {
        // Failed
    }
 }
```

##### 3.2 创建助记词

```swift
 let params = JSCoreParams()
         .put(key: "chainId", value: String) ?? JSCoreParams()  //链id
 Walletverse.generateMnemonic(params: params) { (returnData, error) in
    if let mnemonic = resultData {    //创建助记词成功
        // Success
    } else {
        // Failed
    }
 }


```

##### 3.3 获取私钥

```swift
 let params = JSCoreParams()
         .put(key: "chainId", value: String)?   //链id
         .put(key: "mnemonic", value: String) ?? JSCoreParams()  //助记词
 Walletverse.getPrivateKey(params: params) { (returnData, error) in
    if let privateKey = resultData {    //创建私钥成功
        // Success
    } else {
        // Failed
    }
 }


```

##### 3.4 获取地址

```swift
 let params = JSCoreParams()
         .put(key: "chainId", value: String)?   //链id
         .put(key: "privateKey", value: String) ?? JSCoreParams()  //私钥
 Walletverse.getAddress(params: params) { (returnData, error) in
    if let address = resultData {    //获取地址 成功
        // Success
    } else {
        // Failed
    }
 }


```

##### 3.5 验证地址合法

```swift
 let params = ValidateAddressParams(
      chainId: String?, //链id
      address: String? //地址
 )
 Walletverse.validateAddress(params: params) { (return) in
    if let isTrue = resultData {
        // Success
    } else {
        // Failed
    }
 }


```

##### 3.6 验证私钥合法

```swift
 let params = ValidatePrivateKeyParams(
     chainId: String?, //链id
     privateKey: String? //私钥
 )
 Walletverse.validatePrivateKey(params: params) { (return) in
    if let isTrue = resultData {
        // Success
    } else {
        // Failed
    }
 }

```

##### 3.7 验证助记词合法

```swift
 let params = ValidateMnemonicParams(
    chainId: String?, //链id
    mnemonic: String? //助记词
 )
 Walletverse.validateMnemonic(params: params) { (return) in
    if let isTrue = resultData {
        // Success
    } else {
        // Failed
    }
 }

```

##### 3.8 签名信息

```swift
 let params = SignMessageParams(
    chainId: String?, //链id
    privateKey: String?, //私钥
    message: String?,
 )
 Walletverse.signMessage(params: params) { (returnData) in
    if let data = resultData {
        // Success
    } else {
        // Failed
    }
 }

```

##### 3.9 签名交易

```swift
 let params = SignTransactionParams(
    chainId: String?, //链id
    privateKey: String?, //私钥
    to: String?,   //收款地址
    value: String?, //数量
    decimals: Int?, //精度
    gasPrice: String?,
    gasLimit: String?,
    nonce: String?,
    inputData: String?,  //当转账为子币时，此参数必传
    contractAddress: String?,  //当转账为子币时，此参数必传
 )
 Walletverse.signTransaction(params: params) { (returnData) in
    if let sign = resultData {  //签名后的数据
        // Success
    } else {
        // Failed
    }
 }

```


##### 3.10 发送交易

```swift
 let params = TransactionParams(
    chainId: String?,
    from: String?,
    to: String?,//收款地址
    sign: String?, //签名
    value: String?,//数量
    contractAddress: String?, //当转账为子币时，此参数必传
 )
 Walletverse.transaction(params: params) { (returnData) in
    if let hash = resultData {  //hash不为空表示交易发送成功，但具体是否转账成功，需要链上信息作为最终确认结果
        // Success
    } else {
        // Failed
    }
 }

```

##### 3.11 签名并发送交易

```swift
 let params = SignAndTransactionParams(
    chainId: String?,
    privateKey: String?,
    from: String?,
    to: String?,   //收款地址
    value: String?, //数量
    decimals: Int?,
    gasPrice: String?,
    gasLimit: String?,
    inputData: String?="",//子币转账必传
    contractAddress: String? = "",//当转账为子币时，此参数必传
    walletPin: String?
 )
 Walletverse.signAndTransaction(params: params) { (returnData) in
    if let hash = resultData {  //hash不为空表示交易发送成功，但具体是否转账成功，需要链上信息作为最终确认结果
        // Success
    } else {
        // Failed
    }
 }

```

##### 3.12 创建合约Transfer信息

```swift
 let params = GenerateTransferParams(
     chainId: String?,
     privateKey: String?,
     to: String?,
     value: String?,
     contractAddress: String?,
 )
 Walletverse.generateTransferData(params: params) { (returnData, error) in
    if let data = resultData {
        // Success
    } else {
        // Failed
    }
 }

```

##### 3.13 创建合约Approve信息

```swift
 let params = GenerateTransferParams(
    chainId: String?,
    privateKey: String?,
    to: String?,
    value: String?,
    contractAddress: String?,
 )
 Walletverse.generateApproveData(params: params) { (returnData, error) in
    if let data = resultData {
        // Success
    } else {
        // Failed
    }
 }

```

##### 3.14 获取Nonce

```swift
 let params = JSCoreParams()
        .put(key: "chainId", value: String)?
        .put(key: "address", value: String)?
        .put(key: "contractAddress", value: String) ?? JSCoreParams()
 Walletverse.nonce(params: params) { (returnData, error) in
    if let nonce = resultData {
        // Success
    } else {
        // Failed
    }
 }

```

##### 3.15 获取Balance

```swift
 let params = JSCoreParams()
       .put(key: "chainId", value: String)?
       .put(key: "address", value: String)?
       .put(key: "contractAddress", value: String) ?? JSCoreParams()
 Walletverse.balance(params: params) { (returnData, error) in
    if let balance = resultData {
        // Success
    } else {
        // Failed
    }
 }

```

##### 3.16 获取Decimals

```swift
 let params = JSCoreParams()
      .put(key: "chainId", value: String)?
      .put(key: "address", value: String)?
      .put(key: "contractAddress", value: String) ?? JSCoreParams()
 Walletverse.decimals(params: params) { (returnData, error) in
    if let decimal = resultData {
        // Success
    } else {
        // Failed
    }
 }

```

##### 3.17 获取GasFee

```swift
 let params = JSCoreParams()
     .put(key: "chainId", value: String)?
     .put(key: "from", value: String)?
     .put(key: "to", value: String)?
     .put(key: "value", value: String)?                 //如果是子币，请传""或者"0"
     .put(key: "decimals", value: String)?
     .put(key: "data", value: String) ?? JSCoreParams() //合约数据，入参为encodeERC20ABI方法返回数据
 Walletverse.fee(params: params) { (returnData, error) in
    if let fee = resultData {
        // Success
    } else {
        // Failed
    }
 }

```

##### 3.18 获取GasPrice

```swift
 let params = JSCoreParams()
    .put(key: "chainId", value: String) ?? JSCoreParams()
 Walletverse.gasPrice(params: params) { (returnData, error) in
    if let gasPrice = resultData {
        // Success
    } else {
        // Failed
    }
 }

```

##### 3.19 获取币价格

```swift
 let params = GetPriceParams(
    symbol: String,
    contractAddress: String
 )
 Walletverse.getPrice(params: params) { (resultData) in
    if let price = resultData {
        // Success
    } else {
        // Failed
    }
 }

```

##### 3.20 生成钱包id

```swift
 Walletverse.generateWid(appId: String) { (resultData) in
    if let wid = resultData {
        // Success
    } else {
        // Failed
    }
 }

```

##### 3.21 支持的主链（暂时只支持EVM）

```swift
 let params = GetChainsParams(
       vm: "EVM"
 )
 Walletverse.getSupportChains(params: params) { (resultData) in
    if let coinArray = resultData { // [Coin]
        // Success
    } else {
        // Failed
    }
 }

```

##### 3.22 代币列表

```swift
 let params = TokenParams(
      page: String,
      size: String,
      chainId: String
 )
 Walletverse.getTokenList(params: params) { (resultData) in
    if let coinArray = resultData { // [Coin]
        // Success
    } else {
        // Failed
    }
 }

```

##### 3.23 搜索代币

```swift
 let params = GetTokenParams(
     chainId: String,
     contractAddress: String
 )
 Walletverse.getToken(params: params) { (resultData) in
    if let coin = resultData { // Coin
        // Success
    } else {
        // Failed
    }
 }

```

##### 3.24 获取交易记录

```swift
 let params = TransactionRecordParams(
    page: String,
    size: String,
    chainId: String,
    address: String,
    condition: Condition,  //交易记录类型
    contractAddress: String = ""
 )
 Walletverse.getTransactionRecords(params: params) { (resultData) in
    if let recordArray = resultData { // [TransactionRecord]
        // Success
    } else {
        // Failed
    }
 }

```

##### 3.25 初始化主链

> 如果您的app有选择主链的逻辑，可忽略此方法。此方法用于App中没有明确选择主链的界面，并且需要初始化主链时调用，可初始化的主链为SDK支持的主链

```swift
 let params = InitChainParams(
    "wid",     //钱包id
    "address", //当前钱包地址
    "privateKey", //私钥
    "walletPin", //以demo为例，入参为创建钱包时的6位pin，调用encodeAuth后的数据，如果没有可传""，注意：传""，我们也会加密，在您需要解密时，请使用""作为解密参数
    "chainId",
    "contract",
    "symbol",
 )
 Walletverse.initChain(params: params) { (resultData) in
    if let coin = resultData { // Coin
        // Success
    } else {
        // Failed
    }
 }

```

##### 3.26 加密PIN

> demo用于加密PIN

```swift
 let params = JSCoreParams()
        .put(key: "pin", value: String)?   //密码
        .put(key: "UniqueDeviceId", value: String) ?? JSCoreParams()  //设备唯一id
 Walletverse.encodeAuth(params: params) { (returnData, error) in
    if let auth = resultData {
        // Success
    } else {
        // Failed
    }
 }

```

##### 3.27 解密PIN

```swift
 let params = JSCoreParams()
       .put(key: "encodePin", value: String)?   //加密后的密码
       .put(key: "UniqueDeviceId", value: String) ?? JSCoreParams()  //设备唯一id
 Walletverse.encodeAuth(params: params) { (returnData, error) in
    if let auth = resultData {
        // Success
    } else {
        // Failed
    }
 }

```

##### 3.28 加密数据

> 您可以用此方法加密任何你想加密的数据

```swift
 let params = JSCoreParams()
      .put(key: "message", value: String)?   //需要加密的数据
      .put(key: "encodePin", value: String) ?? JSCoreParams()  //一般为加密后的密码
 Walletverse.encodeMessage(params: params) { (returnData, error) in
    if let message = resultData {
        // Success
    } else {
        // Failed
    }
 }

```

##### 3.29 解密数据

```swift
 let params = JSCoreParams()
     .put(key: "message", value: String)?   //需要解密的数据
     .put(key: "encodePin", value: String) ?? JSCoreParams()  //一般为加密后的密码
 Walletverse.decodeMessage(params: params) { (returnData, error) in
    if let message = resultData {
        // Success
    } else {
        // Failed
    }
 }

```

##### 3.30 保存币信息到当前钱包资产

```swift
 let saveCoinParams = SaveCoinParams(
    wid: String,   //钱包id
    pin: String, //加密后的pin
    coin: WalletCoinModel //需要保存的WalletCoinModel实体
 )
 Walletverse.saveWalletCoin(saveCoinParams: saveCoinParams) { (result) in
    if let isTrue = result {
        // Success
    } else {
        // Failed
    }
 }

```

##### 3.31 删除当前钱包资产代币

```swift
 let walletCoinModel = WalletCoinModel() //需要删除的coin实体,
 Walletverse.deleteWalletCoin(walletCoinModel: walletCoinModel) { (result) in
    if let isTrue = result {
        // Success
    } else {
        // Failed
    }
 }

```

##### 3.32 更新钱包资产的代币信息

```swift
 let walletCoinModel = WalletCoinModel() //需要更新的coin实体,
 Walletverse.updateWalletCoin(walletCoinModel: walletCoinModel) { (result) in
    if let isTrue = result {
        // Success
    } else {
        // Failed
    }
 }

```

##### 3.33 查询钱包资产的代币信息

```swift
 let walletCoinModel = WalletCoinModel(
      wid: String, //钱包id
      contract: String, //可选 主链
      symbol: String , //可选 币名
      address: String, //可选 地址
 )
 Walletverse.queryWalletCoin(walletCoinModel: walletCoinModel) { (resultData) in
    if let walletCoin = returnData { // WalletCoinModel
        // Success
    } else {
        // Failed
    }
 }

```

##### 3.34 查询钱包资产的所有币

```swift
 let walletCoinModel = WalletCoinModel(
     wid: String //钱包id
 )
 Walletverse.queryWalletCoins(walletCoinModel: walletCoinModel) { (resultData) in
    if let walletCoinArray = returnData { // [WalletCoinModel]
        // Success
    } else {
        // Failed
    }
 }

```

##### 3.35 保存钱包身份

```swift
 let identityModel = IdentityModel() //Identity实体
 Walletverse.insertIdentity(identityModel: identityModel) { (result) in
    if let isTrue = result {
        // Success
    } else {
        // Failed
    }
 }

```

##### 3.36 删除钱包身份

```swift
 let identityModel = IdentityModel() //Identity实体
 Walletverse.deleteIdentity(identityModel: identityModel) { (result) in
    if let isTrue = result {
        // Success
    } else {
        // Failed
    }
 }

```

##### 3.37 更新钱包身份信息

```swift
 let identityModel = IdentityModel() //Identity实体
 Walletverse.updateIdentity(identityModel: identityModel) { (result) in
    if let isTrue = result {
        // Success
    } else {
        // Failed
    }
 }

```

##### 3.38 查询钱包身份信息

```swift
 let identityModel = IdentityModel(
    wid: String //钱包id
 )
 Walletverse.queryIdentity(identityModel: identityModel) { (resultData) in
    if let identity = returnData { // IdentityModel
        // Success
    } else {
        // Failed
    }
 }

```

##### 3.39 查询钱包所有身份信息

```swift
 Walletverse.queryIdentities() { (resultData) in
    if let identityArray = returnData { // [IdentityModel]
        // Success
    } else {
        // Failed
    }
 }

```

##### 3.40 保存主链及代币信息

```swift
 let coinModel = CoinModel()    //Coin实体
 Walletverse.insertCoin(coinModel: coinModel) { (result) in
    if let isTrue = result {
        // Success
    } else {
        // Failed
    }
 }

```

##### 3.41 查询主链信息或代币信息

```swift
 let coinModel = CoinModel(
     contract: String, //可选 主链
     symbol: String , //可选 币名
     address: String, //可选 地址
 )
 Walletverse.queryCoin(coinModel: coinModel) { (resultData) in
    if let coin = returnData { // CoinModel
        // Success
    } else {
        // Failed
    }
 }

```

##### 3.42 查询主链及代币信息列表

```swift
 let coinModel = CoinModel(
    chainId: String = "",
    contract: String = "",
    symbol: String = "",
 )  //查询所有,可不传
 Walletverse.queryCoins(coinModel: coinModel) { (resultData) in
    if let coinArray = returnData { // [CoinModel]
         // Success
    } else {
         // Failed
    }
 }

```

##### 3.43 获取签名数据

```swift
 let params = EncodeERC20ABIParams(
      chainId: String?,
      contractMethod: String?,  //合约方法
      contractAddress: String?,
      params: [String]?,        //合约参数
      abi: [[String: Any]]?,    //自定义
 )
 Walletverse.encodeERC20ABI(params: params) { (returnData, error) in
      if let inputData = returnData {
         // Success
      } else {
         // Failed
      }
 }

```

##### 3.44 转十六进制字符串

```swift
 let params = JSCoreParams()
     .put(key: "value", value: String)?     //需要转换的数据
     .put(key: "decimals", value: String) ?? JSCoreParams()     //可选，具体使用场景请查看demo
 Walletverse.toHex(params: params) { (returnData, error) in
     if let hex = result {
         // Success
     } else {
         // Failed
     }
 }

```

### 联合登录相关调用


>以Google登录为例

1.注册Google账号

2.打开[Google登录Android文档](https://developers.google.com/identity/sign-in/android/start-integrating)官方文档，按要求配置相关Google Play相关服务

3.获取Google登录返回的唯一id

4.创建web2.0钱包

>4.1 调用 generateWidWithWeb2()生成钱包id,用于存储本地数据库Identity使用(sdk内部处理)
>
>4.2 调用 signInWeb2()验证2.0用户数据，如果返回结果为空，则表示为新用户。如果不为空，则表示为已注册用户，需要进行2.0钱包恢复流程（见下恢复2.0钱包流程）。
>
>4.3 调用 generateMnemonic()生成助记词，以及初始化主链，钱包名称，2.0钱包密码，钱包PIN（没有可传""）等,调用createWeb2Wallet()创建2.0钱包。

5.恢复web2.0钱包

>5.1 调用 generateWidWithWeb2()生成钱包id,用于存储本地数据库Identity使用(sdk内部处理)
>
> 5.2 调用 signInWeb2()验证2.0用户数据，如果返回结果不为空，则表示为已注册用户，需要进行2.0钱包恢复流程，此方法会返回加密分割后的助记词。
>
> 5.3 调用 restoreWeb2Wallet()，将signInWeb2()返回的wallets，shards，2.0钱包密码等作为参数，恢复钱包。

>具体参数请查看demo





##### 3.45 联合登录生成钱包id

```swift
 let params = FederatedParams(
     providerKey: String, //一般为用户的邮箱，如果没有获取到邮箱，可以使用用户昵称
     providerUid: String, //联合登录平台的用户唯一id
     providerId: Channel, //enum，SDK提供的联合登录渠道
     auth: String         //如果email登录方式，此参数必传，联合登录方式可不传
 )
 Walletverse.generateWidWithWeb2(params: params) { (result) in
    if let wid = result {
        // Success
    } else {
        // Failed
    }
 }

```

##### 3.46 验证2.0用户数据

```swift
 let params = FederatedParams(
    providerKey: String, //一般为用户的邮箱，如果没有获取到邮箱，可以使用用户昵称
    providerUid: String, //联合登录平台的用户唯一id
    providerId: Channel, //enum，SDK提供的联合登录渠道
    auth: String         //如果email登录方式，此参数必传，联合登录方式可不传
 )
 Walletverse.signInWeb2(params: params) { (result) in
    if let userprofile = resultData {   //如果result为空，则表示新用户，否则为已注册的用户
        // Success
        result.wid //钱包id
        result.shards //加密分割后的shard数组
        result.wallets //钱包的资产，如果用户成功使用联合登录方式登录，并添加了代币，此参数返回不为空。反之为空
    } else {
        // Failed
    }
 }

```


##### 3.47 创建2.0用户数据

```swift
 let params = RestoreWeb2Params(
    shards: [String],       //助记词分割后的shard
    wallets: [Coin],        //钱包资产
    walletName: String,     //钱包名
    walletPin: String,      //钱包PIN
    password: String,       //2.0钱包登录密码（此密码不同于PIN，此密码用于登录2.0钱包和恢复2.0钱包所用）
    federatedParams: FederatedParams    //联合登录参数
 )
 Walletverse.userCrypto(params: params) { (result) in
    if let isTrue = result {
         // Success
    } else {
         // Failed
    }
 }

```


##### 3.48 创建2.0钱包

```swift
 let params = CreateWeb2Params(
      mnemonic: String,     //助记词
      wallets: List<Coin>,  //钱包资产
      walletName: String,   //钱包名
      walletPin: String,    //钱包PIN
      password: String,     //2.0钱包登录密码（此密码不同于PIN，此密码用于登录2.0钱包和恢复2.0钱包所用）
      federatedParams: FederatedParams  //联合登录参数
 )
 Walletverse.createWeb2Wallet(params: params) { (result) in
     if let isTrue = result {
         // Success
     } else {
         // Failed
     }
 }

```

##### 3.49 恢复2.0钱包

```swift
 let params = RestoreWeb2Params(
     shards: [String],  //加密分割后的shard数组
     wallets: [Coin],   //钱包资产
     walletName: String,//钱包名
     walletPin: String, //钱包PIN
     password: String,  //2.0钱包登录密码（此密码不同于PIN，此密码用于登录2.0钱包和恢复2.0钱包所用）
     federatedParams: FederatedParams   //联合登录参数
 )
 Walletverse.restoreWeb2Wallet(params: params) { (result) in
    if let isTrue = result {
        // Success
    } else {
        // Failed
    }
 }

```


##### 3.50 获取图形验证码

```swift
 Walletverse.getGraphicsCode() { (returnData) in
    if let emailCodeModel = resultData {
        // Success
        emailCodeModel.data  //svg数据
        emailCodeModel.text  //用于获取邮箱验证码入参
    } else {
        // Failed
    }
 }

```

##### 3.51 获取邮箱验证码

```swift
 let params = EmailCodeParams(
    vcode: String,  //图形验证码
    text: String,   //与图形验证码一起返回的text
 )
 Walletverse.getEmailCode(params: params) { (result) in
    if let isTrue = result {
        // Success
    } else {
        // Failed
    }
 }

```

##### 3.52 验证邮箱验证码

```swift
 let params = EmailVerifyParams(
      vcode: String?,   //邮箱验证码
      account: String?, //email账户
 )
 Walletverse.requestEmailVerify(params: params) { (result) in
    if let auth = result {  //auth用于创建或者恢复2.0钱包时使用
        // Success
    } else {
        // Failed
    }
 }

```


##### 3.53 加密分割助记词

```swift
 let params = JSCoreParams()
    .put(key: "shards", value: String)?                //助记词
    .put(key: "password", value: String)?              //2.0钱包密码
    .put(key: "wid", value: String) ?? JSCoreParams()  //2.0钱包id
 Walletverse.encodeShard(params: params) { (returnData, error) in
    if let shards = returnData {    //助记词加密分割后的数组
        // Success
    } else {
        // Failed
    }
 }

```

##### 3.54 解密分割后的助记词

```swift
 let params = JSCoreParams()
     .put(key: "shards", value: [String])?              //助记词加密分割后的数组
     .put(key: "password", value: String)?              //2.0钱包密码
     .put(key: "wid", value: String) ?? JSCoreParams()  //2.0钱包id
 Walletverse.decodeShard(params: params) { (returnData, error) in
    if let mnemonic = returnData {  //助记词
        // Success
    } else {
        // Failed
    }
 }

```



### 其它相关调用

##### 3.55 获取sdk版本号

```swift
Walletverse.getSDKVersionCode() -> Int
```

##### 3.56 获取sdk版本名

```swift
Walletverse.getSDKVersionName() -> String
```

##### 3.57 更改显示单位

```swift
Walletverse.changeCurrency(currency: Currency) -> Bool
```

##### 3.58 更改显示语言

```swift
Walletverse.changeLanguage(language: Language) -> Bool
```

##### 3.59 更改换算单位

```swift
Walletverse.changeUnit(unit: Unit) -> Bool
```

##### 3.60 校验联合登录方式的密码

```swift
Walletverse.validatePassword(value: String) -> Bool
```


### NFT相关调用

##### 3.61 NFT列表

```swift
 let nftItemsParams = NftItemsParams(
    chainId,
    address, //当前钱包地址
    contractAddress, //合约地址
    )
 Walletverse.getNftItems(params: nftItemsParams) { (result) in
    // 成功
    if let nftArray = result {
        nftArray为对象，nftArray.items为nft列表
    }
 }

```

##### 3.62 NFT详情

```swift
let nftDetailParams = NftDetailParams(
    chainId,
    tokenId, //NFT的id
    contractAddress, //合约地址
    )
 Walletverse.getNftDetail(params: nftDetailParams) { (result) in
    // 成功
    if let nftArray = result {
        nftArray为对象，nftArray.items为nft列表
    }
 }

```

##### 3.63 NFT转账数据生成

```swift
 let nftTransferDataParams = NftTransferDataParams(
    chainId, // 链id
    tokenId, // nft的id
    contractAddress, // nft合约地址
    from, // 转出地址
    to, // 转入地址
 )
 Walletverse.getNftTransferData(params: nftTransferDataParams) { (result) in
    // 成功
    if let message = result {

    }
 }

```

##### 3.63 NFT获取Token URI

```swift
 let nftTokenURIParams = NftTokenURIParams(
    chainId, // 链id
    tokenId, // nft的id
    contractAddress, // nft合约地址
 )
 Walletverse.getNftTokenURI(params: nftTokenURIParams) { (result) in
    // 成功
    if let message = result {

    }
 }

```


### 币转账流程

>完整的转账流程如下：
>
> 1.获取nonce

```swift
 let params = JSCoreParams()
    .put(key: "message", value: String)?
    .put(key: "password", value: String) ?? JSCoreParams()
 Walletverse.nonce(params: params) { (returnData, error) in
    if let nonce = returnData {
        // Success
    } else {
        // Failed
    }
 }

```

> 2.获取inputData (主币转账无需调用)

```swift
 let params = EncodeERC20ABIParams(
     chainId: String?,
     contractMethod: "transfer",         //合约方法
     contractAddress: String?,
     params: [String]?,         //[收款地址 ,转账数量（需转为16进制）] 例：Walletverse.toHexAsync(HexParams(value, decimals))
     abi: [[String: Any]]?,
 )
 Walletverse.encodeERC20ABI(params: params) { (returnData, error) in
     if let inputData = returnData {
        // Success
     } else {
        // Failed
     }
 }

```

> 3.解密私钥

```swift
 let params = JSCoreParams()
    .put(key: "message", value: String)?
    .put(key: "password", value: String) ?? JSCoreParams()
 Walletverse.decodeMessage(params: params) { (returnData, error) in
    if let inputData = returnData {
        // Success
    } else {
        // Failed
    }
 }

```

> 4.签名交易信息

```swift
 let params = SignTransactionParams(
     chainId: String?,      //链id
     privateKey: String?,   //私钥
     to: String?,           //收款地址
     value: String?,        //数量
     decimals: String?,        //精度
     gasPrice: String?,
     gasLimit: String?,
     nonce: String?,
     inputData: String?,    //当转账为子币时，此参数必传
     contractAddress: String?,      //当转账为子币时，此参数必传
 )
 Walletverse.signTransaction(params: params) { (result) in
     if let sign = result { //签名后的数据
         // Success
     } else {
         // Failed
     }
}

```

> 5.发送交易

```swift
 let params = TransactionParams(
     chainId: String?,
     from: String?,
     to: String?,      //收款地址
     sign: String?,    //签名
     value: String?,   //数量
     contractAddress: String?,     //当转账为子币时，此参数必传
 )
 Walletverse.transaction(params: params) { (result) in
     // hash不为空表示交易发送成功，但具体是否转账成功，需要链上信息作为最终确认结果
     if let hash = result {
         // Success
     } else {
         // Failed
     }
}

```

>以上为整个交易发送过程，如不关心发送过程，请调用如下方法，提供对应参数即可

> 1.获取inputData (主币转账无需调用)

```swift
 let params = EncodeERC20ABIParams(
     chainId: String?,
     contractMethod: "transfer",         //合约方法
     contractAddress: String?,
     params: [String]?,         //[收款地址 ,转账数量（需转为16进制）] 例：Walletverse.toHexAsync(HexParams(value, decimals))
     abi: [[String: Any]]?,
 )
 Walletverse.encodeERC20ABI(params: params) { (returnData, error) in
    if let inputData = returnData {
        // Success
    } else {
        // Failed
    }
}

```

> 2.签名并发送交易

```swift
 let params = SignAndTransactionParams(
    chainId: String?,
    privateKey: String?,
    from: String?,
    to: String?,
    value: String?,
    decimals: String?,
    gasPrice: String?,
    gasLimit: String?,
    inputData: String?,
    contractAddress: String?,
    walletPin: String?,
 )
 Walletverse.signAndTransaction(params: params) { (result) in
    // hash不为空表示交易发送成功，但具体是否转账成功，需要链上信息作为最终确认结果
    if let hash = result {
        // Success
    } else {
        // Failed
    }
}

```
