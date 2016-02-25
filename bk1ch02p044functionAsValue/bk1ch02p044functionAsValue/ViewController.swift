
import UIKit

func doThis(f:()->()) {
    f()
}

func imageOfSize(size:CGSize, _ whatToDraw:() -> ()) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    whatToDraw()
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result
}




class ViewController: UIViewController {
    
    @IBOutlet weak var myButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        func whatToDo() {
            print("I did it")
        }
        doThis(whatToDo)

        
        func drawing() {
            let p = UIBezierPath(
                roundedRect: CGRectMake(0,0,45,20), cornerRadius: 8)
            p.stroke()
        }
        let image = imageOfSize(CGSizeMake(45,20), drawing)
        
        
        // here, I'll prove we really drew it :)
        let imageView = UIImageView(image:image)
        imageView.frame.origin = CGPointMake(100,100)
        self.view.addSubview(imageView)
        
    }
    
    @IBAction func moveMyButton (sender:AnyObject!) {
        func whatToAnimate() { // self.myButton is a button in the interface
            self.myButton.frame.origin.y += 20
        }
        func whatToDoLater(finished:Bool) {
            print("finished: \(finished)")
        }
        UIView.animateWithDuration(
            0.4, animations: whatToAnimate, completion: whatToDoLater)
    }
    
    func test() {
        let vc = UIViewController()
        func whatToDoLater() {
            print("I finished!")
        }
        self.presentViewController(vc, animated:true, completion:whatToDoLater)
        
    }

    func playingWithFunctionSpecifierSyntax() {
        /*
         Illustrating ways to refer to a function as a value in Swift 2.2 and later.
         You can express the signature, e.g. as a way of disambiguating in case of overload.
         This will also turn out to be essential when using the new #selector syntax.
         You can precede with an explicit instance.
         You can precede with an explicit class. This is because an instance method
         is really a class method; as the calling example shows, this is not the same thing.
         But it will turn out that this can be used the same way in #selector.
         */
        
        let f = moveMyButton
        let ff = moveMyButton(_:)
        let f2 = self.moveMyButton
        let ff2 = self.moveMyButton(_:)
        let f3 = ViewController.moveMyButton
        let ff3 = ViewController.moveMyButton(_:)
        
        f(self.myButton)
        ff(self.myButton)
        f2(self.myButton)
        ff2(self.myButton)
        f3(self)(self.myButton)
        ff3(self)(self.myButton)
    }
    
    // I should probably now discuss #selector syntax at this point in the book
    
    func testSelectorSyntax() {
        let b = UIButton(type: .System)
        b.addTarget(self, action: #selector(doButton), forControlEvents: .TouchUpInside)
        // or:
        b.addTarget(self, action: #selector(doButton(_:)), forControlEvents: .TouchUpInside)
        // or:
        b.addTarget(self, action: #selector(ViewController.doButton(_:)), forControlEvents: .TouchUpInside)
        // and so on; but the point is, you just need to provide enough info ...
        // ... so that the compiler can resolve this method reference for you
        // and it will then form the actual Selector for you! no more "unrecognized selector"!
    }
    
    func doButton(sender:AnyObject) { // must actually exist, or none of the above will compile
        
    }

}

