import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
  let webView: WKWebView = WKWebView()

  override func viewDidLoad() {
    super.viewDidLoad()

    webView.frame = view.bounds
    webView.navigationDelegate = self
    webView.scrollView.bounces = false
    view.addSubview(webView)

    let url = Bundle.main.url(forResource: "index", withExtension: ".html")!
    let urlRequest = URLRequest(url: url)
    webView.load(urlRequest)
  }

  let kScheme = "native://";

  func webView(_ webView: WKWebView,
               decidePolicyFor navigationAction: WKNavigationAction,
               decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    var policy = WKNavigationActionPolicy.allow
    if let url = navigationAction.request.url?.absoluteString {
      if url.hasPrefix(kScheme) {
        evaluateJs("addTextNode('\(url) ');")
        policy = WKNavigationActionPolicy.cancel  // ページ遷移を行わないようにcancelを返す
      }
    }
    decisionHandler(policy)
  }

  func evaluateJs(_ script: String) {
    webView.evaluateJavaScript(script, completionHandler: {(result: Any?, error: Error?) in
      print("JS result=\(result), error=\(error)")
    })
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}
