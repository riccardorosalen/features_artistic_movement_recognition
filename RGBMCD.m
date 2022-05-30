function out=MCD(parImg,palette)
    out=zeros(1,size(palette,1));
    objImg=double(imresize(parImg,'OutputSize',[256 256]));
        parfor (x=1:size(palette,1),8)
            out(x)=0;
            %pal(1:3,1)=palette(x,:);
            for i=1:256
                for j=1:256
                    dist=sqrt((palette(x,1)-objImg(i,j,1))^2+(palette(x,2)-objImg(i,j,2))^2+(palette(x,3)-objImg(i,j,3))^2);
                    out(x)=out(x)+1/(dist);
                    
                end
            end
        end
   
    
end