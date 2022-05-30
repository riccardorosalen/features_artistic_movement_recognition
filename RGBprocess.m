%Get an image as parameter
%Convert it in HSV color model
%calculate the sum of the values in a 5x5 window for each plane
%create 3 ratio images, (hs,hv,sv) and calculate the ratio for each
%the new pixel valure is set in the pixel i,j of each different ratio
%lbp computing
%sends the full feature vector to the calling function

function y=RGBprocess(parImage,variance)
    [vert,oriz,plane]=size(parImage);
    image=double(parImage);
    
    %initialize ratio images
    rg=zeros(vert,oriz);
    gb=zeros(vert,oriz);
    rb=zeros(vert,oriz);
        MAPPING=0;
    
    %get ratio values of each pixel
    for i=1:vert
        for j=1:oriz
            if variance==1
                sumR=0;
                sumG=0;
                sumB=0;
                %bit in the middle
                sumR=sumR+image(i,j,1);
                sumG=sumG+image(i,j,2);
                sumB=sumB+image(i,j,3);
                %Check other bits around to avoid errors and sum them if
                %possible
                if (i>1)
                    sumR=sumR+image(i-1,j,1);
                    sumG=sumG+image(i-1,j,2);
                    sumB=sumB+image(i-1,j,3);
                    
                    if (j>1)
                        sumR=sumR+image(i-1,j-1,1);
                        sumG=sumG+image(i-1,j-1,2);
                        sumB=sumB+image(i-1,j-1,3);
                    end
                    if (j<oriz)
                        sumR=sumR+image(i-1,j+1,1);
                        sumG=sumG+image(i-1,j+1,2);
                        sumB=sumB+image(i-1,j+1,3);
                    end
                end
                if (i<vert)
                    sumR=sumR+image(i+1,j,1);
                    sumG=sumG+image(i+1,j,2);
                    sumB=sumB+image(i+1,j,3);
                    if (j>1)
                        sumR=sumR+image(i+1,j-1,1);
                        sumG=sumG+image(i+1,j-1,2);
                        sumB=sumB+image(i+1,j-1,3);
                    end
                    if (j<oriz)
                        sumR=sumR+image(i+1,j+1,1);
                        sumG=sumG+image(i+1,j+1,2);
                        sumB=sumB+image(i+1,j+1,3);
                    end
                end
                if(j<oriz)
                    sumR=sumR+image(i,j+1,1);
                    sumG=sumG+image(i,j+1,2);
                    sumB=sumB+image(i,j+1,3);
                end
                if(j>1)
                    sumR=sumR+image(i,j-1,1);
                    sumG=sumG+image(i,j-1,2);
                    sumB=sumB+image(i,j-1,3);
                end
                
                
                
                
                %                 New Pixel Value, calculated with the ratio of the sum
                %                 obtained with the sum of the bits in the window of each
                %                 plane
                rg(i,j)=log((double(sumR)+0.000000000001)/(double(sumG)+0.000000000001));
                gb(i,j)=log((double(sumG)+0.000000000001)/(double(sumB)+0.000000000001));
                rb(i,j)=log((double(sumR)+0.000000000001)/(double(sumB)+0.000000000001));
            elseif variance==2
                
                rg(i,j)=log(image(i,j,1)+0.000000000001)/(image(i,j,2)+0.000000000001);
                gb(i,j)=log(image(i,j,2)+0.000000000001)/(image(i,j,3)+0.000000000001);
                rb(i,j)=log(image(i,j,1)+0.000000000001)/(image(i,j,3)+0.000000000001);
            end
        end
    end
    %get lbp feature vector of each ratio
    lbprg=lbp(rg,3,8,MAPPING,'hist');
    lbprb=lbp(rb,3,8,MAPPING,'hist');
    lbpgb=lbp(gb,3,8,MAPPING,'hist');
    %Combine the 3 vectors in one
    tmp=cat(2,lbprg,lbprb);
    y=cat(2,tmp,lbpgb);
end