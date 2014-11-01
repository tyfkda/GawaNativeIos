import UIKit

class ViewController: UIViewController, UIWebViewDelegate {
  var webview: UIWebView = UIWebView()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

    self.webview.frame = self.view.bounds
    self.webview.delegate = self;
    self.view.addSubview(self.webview)

    let url = NSURL(string: "http://www.example.com/")!
    let urlRequest = NSURLRequest(URL: url)
    self.webview.loadRequest(urlRequest)
  }

  func webView(webView: UIWebView!, shouldStartLoadWithRequest request: NSURLRequest!, navigationType: UIWebViewNavigationType) -> Bool {
    return true
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}
