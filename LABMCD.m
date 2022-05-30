
function out=LABMCD(parImage,palette)
    out=zeros(1,size(palette,1));
    objImg=imresize(parImage,'OutputSize',[256 256]);
    pal=zeros(3,1);
    pix=zeros(3,1);
    for x=1:size(palette,1)
        out(x)=0;
        pal=zeros(3,1);
        pal(1:3,1)=palette(x,:);
        for i=1:256
            for j=1:256
                pix=zeros(3,1);
                pix(1:3,1)=objImg(i,j,:);
                Ldis=abs(pal(1)-pix(1));
                nPal=sqrt(pal(1,1)^2+pal(2,1)^2+pal(3,1)^2);
                nImg=sqrt(pix(1,1)^2+pix(2,1)^2+pix(3,1)^2);
                phs=acos(pix(1)*pal(1)+pix(2)*pal(2)+pix(3)*pal(3))/(nPal*nImg+0.1);
                delta=abs(nPal-nImg);
                dist=Ldis+phs+delta;
                out(x)=out(x)+1/(dist);
            end
        end
    end
end
