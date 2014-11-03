iOSでガワネイティブ
=================

ネイティブアプリなんだけどネイティブのコードは極力書かず、
WebViewを使ってhtml+JavaScriptを使ってアプリを組みたい。
今回はiOS, Swiftで作ってみる。

## Storyboardを使わないようにする
単純なレイアウトなのでStoryboardを使わない。
XCodeでSwiftのプロジェクトを作った時に自動的に作られるMain.storyboardを使わないようにする。

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

* `webView`の`frame`を`view.bounds`にしてやると全画面になる

## htmlの表示
htmlをリソースとしてアプリ内部に持ち、それをWebViewで表示する

```swift
class ViewController: UIViewController, UIWebViewDelegate {
  ...

  override func viewDidLoad() {
    ...
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
html内で相対パスで書けば、リソース内のファイルが自動的に読み込まれる

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

### ネイティブからJavaScriptを呼び出す
`UIWebView#stringByEvaluatingJavaScriptFromString`を使用する：
```swift
func evaluateJs(script: String) -> String? {
  return webView.stringByEvaluatingJavaScriptFromString(script)
}
```

全部文字列にしないといけないのがアレだけど…
