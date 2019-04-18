i =imread('me.png');
padcam = padarray(i,[50 50],'both');
imshow(padcam);