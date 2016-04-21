# SwiftyJot
Swift verion of IFFFT's [Jot](https://github.com/IFTTT/jot)

`jot` is an easy way to add touch-controlled drawings and text to images in your iOS app.

## What's `jot` for?
### Annotating Images
`jot` is the easiest way to add annotations to images with a touch interface. You can draw arrows or circle important things, as well as add resizable, rotatable text captions, and easily save the notes on top of a image using `drawOnImage:`.

### Whiteboard or Drawing Apps
`jot` is perfect for quick sketches and notes in your whiteboard or drawing app. It's easy to change the drawing color or stroke width, and when you're done, you can call `renderImageOnColor:` to save the sketch.

### Signatures
`jot` is a great solution if you need to collect user signatures through a touch interface. Set the `drawingColor` to black, set the state to `JotViewStateDrawing`, and save the signature when the user is done by calling `renderImageOnColor:`.

## Example Project

To run the example project, clone the repo, (1) build the framework and (2) run the demo example.

## Usage

Add an instance of `JotViewController` as a child of your view controller. Adjust the size and layout of `JotViewController `'s view however you'd like.

```swift
import SwiftyJot

class ExampleViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        self.jotViewController.delegate = self
        self.jotViewController.state = .Drawing;
        self.jotViewController.textColor = UIColor.blackColor()
        self.jotViewController.font = UIFont.boldSystemFontOfSize(64)
        self.jotViewController.fontSize = 64
        self.jotViewController.textEditingInsets = UIEdgeInsetsMake(12, 6, 0, 6)
        self.jotViewController.initialTextInsets = UIEdgeInsetsMake(6, 6, 6, 6)
        self.jotViewController.textAlignment = .Left
        self.jotViewController.drawingColor = UIColor.cyanColor()
        self.addChildViewController(self.jotViewController)
        self.view.addSubview(self.jotViewController.view)
        self.jotViewController.didMoveToParentViewController(self)
    }
```
Switch between drawing, text manipulation, and text edit mode.

```swift
func switchToDrawMode
{
	self.jotViewController.state = .Drawing
}

func switchToTextMode
{
	self.jotViewController.state = .Text
}

func switchToTextEditMode
{
	self.jotViewController.state = .Text
}
```
Clear the drawing.

```swift
// Clears text and drawing
self.jotViewController.clearAll()

// Clears only text
self.jotViewController.clearText()

// Clears only drawing
self.jotViewController.clearDrawing()
```

### Image Output

Draw on a background image.

```swift
func imageWithDrawing(image:UIImage) {
	let myImage:UIImage = self.imageView.image
	return self.jotViewController.drawOnImage(myImage)
}
```

Draw on a color.

```swift
func imageOnColorWithDrawing -> UIColor {
	let backgroundColor:UIColor = self.view.backgroundColor
	return self.jotViewController.renderImageOnColor(backgroundColor)
}
```

Draw on a transparent background.

```swift
func imageOnColorWithDrawing(image:UIImage) -> UIImage
{
	let backgroundColor = self.view.backgroundColor
	return self.jotViewController.renderImage()
}
```

## Original Creator of Jot

* [Laura Skelton](https://github.com/lauraskelton), creator of [Jot](https://github.com/IFTTT/jot)

## License

`jot` is available under the MIT license. See the LICENSE file for more info.

Copyright for portions of project SwiftyJot are held by Laura Skelton, IFTTT Inc 2015  as part of project Jot. All other copyright for project SwiftyJot are held by Leander Melms, 2016.
