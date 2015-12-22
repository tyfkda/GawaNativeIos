import UIKit

class ViewController: UIViewController, UIWebViewDelegate {
  let webView: UIWebView = UIWebView()

  override func viewDidLoad() {
    super.viewDidLoad()

    webView.frame = view.bounds
    webView.delegate = self
    webView.scrollView.bounces = false
    view.addSubview(webView)

    let url = NSBundle.mainBundle().URLForResource("index", withExtension: ".html")!
    let urlRequest = NSURLRequest(URL: url)
    webView.loadRequest(urlRequest)
  }

  let kScheme = "native://";

  func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    if let url = request.URL?.absoluteString {
      if url.hasPrefix(kScheme) {
        evaluateJs("addTextNode('\(url) ');")
        return false  // ページ遷移を行わないようにfalseを返す
      }
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
