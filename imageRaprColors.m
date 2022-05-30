function y=objImgRaprColors(objImg)
    resIm=imresize(objImg,'OutputSize',[256 256]);
    nColors=8;
      
    [pixel_labels,centroids] = imsegkmeans(resIm,nColors,'NumAttempts',3);
    
    %imshow(pixel_labels,[]);
    y=centroids;
end