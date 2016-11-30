import UIKit

class ViewController: UIViewController, UIWebViewDelegate {
  let webView: UIWebView = UIWebView()

  override func viewDidLoad() {
    super.viewDidLoad()

    webView.frame = view.bounds
    webView.delegate = self
    webView.scrollView.bounces = false
    view.addSubview(webView)

    let url = Bundle.main.url(forResource: "index", withExtension: ".html")!
    let urlRequest = URLRequest(url: url)
    webView.loadRequest(urlRequest)
  }

  let kScheme = "native://";

  func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    if let url = request.url?.absoluteString {
      if url.hasPrefix(kScheme) {
        evaluateJs("addTextNode('\(url) ');")
        return false  // ページ遷移を行わないようにfalseを返す
      }
    }
    return true
  }

  @discardableResult
  func evaluateJs(_ script: String) -> String? {
    return webView.stringByEvaluatingJavaScript(from: script)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}
