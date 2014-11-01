import UIKit

class ViewController: UIViewController, UIWebViewDelegate {
  let webview: UIWebView = UIWebView()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

    webview.frame = view.bounds
    webview.delegate = self;
    view.addSubview(webview)

    let path = NSBundle.mainBundle().pathForResource("index", ofType: "html")!
    let url = NSURL(string: path)!
    let urlRequest = NSURLRequest(URL: url)
    webview.loadRequest(urlRequest)
  }

  func webView(webView: UIWebView!, shouldStartLoadWithRequest request: NSURLRequest!, navigationType: UIWebViewNavigationType) -> Bool {
    let kScheme = "native://";
    let url = request.URL.absoluteString
    if url!.hasPrefix(kScheme) {
      evaluateJs("addTextNode('\(url!) ');")
      return false
    }
    return true
  }

  func evaluateJs(script: String) -> String? {
    return webview.stringByEvaluatingJavaScriptFromString(script)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}
