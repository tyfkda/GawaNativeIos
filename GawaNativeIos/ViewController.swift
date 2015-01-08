import UIKit

class ViewController: UIViewController, UIWebViewDelegate {
  let webView: UIWebView = UIWebView()

  override func viewDidLoad() {
    super.viewDidLoad()

    webView.frame = view.bounds
    webView.delegate = self;
    webView.scrollView.bounces = false
    view.addSubview(webView)

    let path = NSBundle.mainBundle().pathForResource("index", ofType: "html")!
    let url = NSURL(string: path)!
    let urlRequest = NSURLRequest(URL: url)
    webView.loadRequest(urlRequest)
  }

  func webView(webView: UIWebView!, shouldStartLoadWithRequest request: NSURLRequest!, navigationType: UIWebViewNavigationType) -> Bool {
    let kScheme = "native://";
    let url = request.URL.absoluteString
    if url!.hasPrefix(kScheme) {
      evaluateJs("addTextNode('\(url!) ');")
      return false  // ページ遷移を行わないようにfalseを返す
    }
    return true
  }

  func evaluateJs(script: String) -> String? {
    return webView.stringByEvaluatingJavaScriptFromString(script)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}
