# Image analysis using python

Initial idead: 
 - given a capacha image, split it into multiple files, each containing a letter
 

##Basic Processing using python:

[Here](http://scipy-lectures.github.io/advanced/image_processing/)  is the baic code to read an image in python and make some modification.

## remove noice in backgrund

input image ![alt example](https://raw.githubusercontent.com/kuberiitb/analytics/master/imageAnalysis/data/input00.jpg)

### code to clean:

```py
# read from jpg file
def read_clean_image(image_file_name = '../input/input00.jpg', max_black = 150, clean = 0 ):
    # ideal_black =0
    image_pixels = misc.imread(image_file_name)
    # print image_pixel_values
    new_image_pixels = image_pixels.copy()
    print image_pixels.shape
    imh = image_pixels.shape[1]
    imw = image_pixels.shape[0]
    for rowId in range(imw):
        for colId in range(imh):
            p = image_pixels[rowId, colId]
            if (p[0]<=max_black)*(p[1]<=max_black)*(p[2]<=max_black) ==0:
                new_image_pixels[rowId, colId] =  [255]*3
            else:
                new_image_pixels[rowId, colId] = [0]*3
    if clean == 1:
        # plot the image
        plt.imshow(new_image_pixels)
        plt.show()
        # return the object of image
        return new_image_pixels
    else:
        plt.imshow(image_pixels)
        plt.show()
        return image_pixels    


read_clean_image(image_file_name = '../input/input02.jpg', max_black = 100, clean = 1 )
```

processed image looks like this ![alt processed](https://raw.githubusercontent.com/kuberiitb/analytics/master/imageAnalysis/output/input02.jpg)
