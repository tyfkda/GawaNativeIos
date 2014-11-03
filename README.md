iOSでガワネイティブ
=================

ネイティブアプリなんだけどネイティブのコードは極力書かず、
WebViewを使ってhtml+JavaScriptを使ってアプリを組みたい。
今回はiOS, Swiftで作ってみる。

[コード](https://github.com/tyfkda/GawaNativeIos)

## Storyboardを使わないようにする
単にWebViewを全画面に配置するだけの単純なレイアウトなのでStoryboardは必要ない。
なのでXCodeでSwiftのプロジェクトを作った時に自動的に作られるMain.storyboardを使わないようにする。

* XCodeでプロジェクトのターゲット > General > Deployment Info > Main Interface
  を空にする。
* Main.storyboardを削除する
* ViewControllerが呼び出されなくなるので、自前で呼び出す

```swift
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  var navigationController: UINavigationController?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    window = UIWindow(frame: UIScreen.mainScreen().bounds)

    let viewController: ViewController = ViewController()
    window!.rootViewController = viewController
    window!.makeKeyAndVisible()

    return true
  }
  ...
```

## WebViewを全画面の大きさで追加
ViewControllerで全画面のWebViewを追加する。

```swift
class ViewController: UIViewController, UIWebViewDelegate {
  let webView: UIWebView = UIWebView()

  override func viewDidLoad() {
    super.viewDidLoad()

    webView.frame = view.bounds
    webView.delegate = self;
    view.addSubview(webView)
  }
```

* `webView`の`frame`をコントローラ自体の`view.bounds`にしてやると全画面になる

## htmlの表示
htmlは外部httpサーバから取ってくることもできるが、ここではリソースとしてアプリ内部に持ち、
それをWebViewで表示することにする。

```swift
class ViewController: UIViewController, UIWebViewDelegate {
  ...

  override func viewDidLoad() {
    ...
    //let url = NSURL(string: "http://www.example.com/")!
    let path = NSBundle.mainBundle().pathForResource("index", ofType: "html")!
    let url = NSURL(string: path)!
    let urlRequest = NSURLRequest(URL: url)
    webView.loadRequest(urlRequest)
  }
```

* プロジェクトにResourcesとかいうグループを作り、その中にhtmlファイルを追加する
  （ここではindex.htmlにした）
* プロジェクトのBuild Phases > Copy Bundle Resourcesで追加する
  （プロジェクトにファイルを追加したら自動的に登録される？）
* `NSBundle.mainBundle().pathForResource`でリソースのパスを取得
* `UIWebView#loadRequest`でWebViewに読み込む

## htmlから画像、JavaScript、CSSを読み込む
html内で相対パスで書けばリソース内のファイルが自動的に読み込まれる

```html
<link rel="stylesheet" type="text/css" href="main.css" />
<img src="hydlide.png" />
<script type="text/javascript" src="main.js"></script>
```

## JavaScriptとネイティブの連携
### JavaScriptからネイティブを呼び出す
JavaScriptからネイティブに対してなにか起動するにはURLをリクエストして、
`UIWebViewDelegate#webView:shouldStartLoadWithRequest`が呼び出されるのを利用する。

スキーマを`http://`や`https://`じゃなくて独自のものにしておくことで判定する。
ここでは`native://`などとしてみる。

html(JavaScript)側：
```html
<p><a href="native://foo/bar.baz">Push me!</a></p>
```

ネイティブ(Swift)側：
```swift
  func webView(webView: UIWebView!, shouldStartLoadWithRequest request: NSURLRequest!, navigationType: UIWebViewNavigationType) -> Bool {
    let kScheme = "native://";
    let url = request.URL.absoluteString
    if url!.hasPrefix(kScheme) {
      // Do something
      return false  // ページ遷移を行わないようにfalseを返す
    }
    return true
  }
```

* 呼び出されたネイティブ側では、スキーム以外のURLの残り部分を使って自由に処理すればよい

### ネイティブからJavaScriptを呼び出す
`UIWebView#stringByEvaluatingJavaScriptFromString`を使用する：
```swift
  webView.stringByEvaluatingJavaScriptFromString(script)
```

毎回evalすることになるし全部文字列にしないといけないのがアレだけど…
