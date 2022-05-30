%Get an image as parameter
%Convert it in HSV color model
%calculate the sum of the values in a 5x5 window for each plane
%create 3 ratio images, (hs,hv,sv) and calculate the ratio for each
%the new pixel valure is set in the pixel i,j of each different ratio
%lbp computing
%sends the full feature vector to the calling function

function y=HSVprocess(tmpimage,variance)
    image=rgb2hsv(tmpimage);
    [vert,oriz,plane]=size(image);
    %MAPPING=getmapping(8,'u2');
    MAPPING=0;
    
    %initialize ratio images
    hs=zeros(vert,oriz);
    sv=zeros(vert,oriz);
    hv=zeros(vert,oriz);
    
    
    
    %get ratio values of each pixel
    for i=1:vert
        for j=1:oriz
            if variance==1
                sumH=0;
                sumS=0;
                sumV=0;
                %bit in the middle
                sumH=sumH+image(i,j,1);
                sumS=sumS+image(i,j,2);
                sumV=sumV+image(i,j,3);
                %Check other bits around to avoid errors and sum them if
                %possible
                if (i>1)
                    sumH=sumH+image(i-1,j,1);
                    sumS=sumS+image(i-1,j,2);
                    sumV=sumV+image(i-1,j,3);
                    
                    if (j>1)
                        sumH=sumH+image(i-1,j-1,1);
                        sumS=sumS+image(i-1,j-1,2);
                        sumV=sumV+image(i-1,j-1,3);
                    end
                    if (j<oriz)
                        sumH=sumH+image(i-1,j+1,1);
                        sumS=sumS+image(i-1,j+1,2);
                        sumV=sumV+image(i-1,j+1,3);
                    end
                end
                if (i<vert)
                    sumH=sumH+image(i+1,j,1);
                    sumS=sumS+image(i+1,j,2);
                    sumV=sumV+image(i+1,j,3);
                    if (j>1)
                        sumH=sumH+image(i+1,j-1,1);
                        sumS=sumS+image(i+1,j-1,2);
                        sumV=sumV+image(i+1,j-1,3);
                    end
                    if (j<oriz)
                        sumH=sumH+image(i+1,j+1,1);
                        sumS=sumS+image(i+1,j+1,2);
                        sumV=sumV+image(i+1,j+1,3);
                    end
                end
                if(j<oriz)
                    sumH=sumH+image(i,j+1,1);
                    sumS=sumS+image(i,j+1,2);
                    sumV=sumV+image(i,j+1,3);
                end
                if(j>1)
                    sumH=sumH+image(i,j-1,1);
                    sumS=sumS+image(i,j-1,2);
                    sumV=sumV+image(i,j-1,3);
                end
                if(i>2)
                    sumH=sumH+image(i-2,j,1);
                    sumS=sumS+image(i-2,j,2);
                    sumV=sumV+image(i-2,j,3);
                    if(j>1)
                        sumH=sumH+image(i-2,j-1,1);
                        sumS=sumS+image(i-2,j-1,2);
                        sumV=sumV+image(i-2,j-1,3);
                    end
                    if(j<oriz)
                        sumH=sumH+image(i-2,j+1,1);
                        sumS=sumS+image(i-2,j+1,2);
                        sumV=sumV+image(i-2,j+1,3);
                    end
                    if(j>2)
                        sumH=sumH+image(i-2,j-2,1);
                        sumS=sumS+image(i-2,j-2,2);
                        sumV=sumV+image(i-2,j-2,3);
                    end
                    if(j<oriz-1)
                        sumH=sumH+image(i-2,j+2,1);
                        sumS=sumS+image(i-2,j+2,2);
                        sumV=sumV+image(i-2,j+2,3);
                    end
                end
                if(i<vert-1)
                    sumH=sumH+image(i+2,j,1);
                    sumS=sumS+image(i+2,j,2);
                    sumV=sumV+image(i+2,j,3);
                    if(j>1)
                        sumH=sumH+image(i+2,j-1,1);
                        sumS=sumS+image(i+2,j-1,2);
                        sumV=sumV+image(i+2,j-1,3);
                    end
                    if(j<oriz)
                        sumH=sumH+image(i+2,j+1,1);
                        sumS=sumS+image(i+2,j+1,2);
                        sumV=sumV+image(i+2,j+1,3);
                    end
                    if(j>2)
                        sumH=sumH+image(i+2,j-2,1);
                        sumS=sumS+image(i+2,j-2,2);
                        sumV=sumV+image(i+2,j-2,3);
                    end
                    if(j<oriz-1)
                        sumH=sumH+image(i+2,j+2,1);
                        sumS=sumS+image(i+2,j+2,2);
                        sumV=sumV+image(i+2,j+2,3);
                    end
                end
                if(j>2)
                    sumH=sumH+image(i,j-2,1);
                    sumS=sumS+image(i,j-2,2);
                    sumV=sumV+image(i,j-2,3);
                    if(i>1)
                        sumH=sumH+image(i-1,j-2,1);
                        sumS=sumS+image(i-1,j-2,2);
                        sumV=sumV+image(i-1,j-2,3);
                    end
                    if(i<vert)
                        sumH=sumH+image(i+1,j-2,1);
                        sumS=sumS+image(i+1,j-2,2);
                        sumV=sumV+image(i+1,j-2,3);
                    end
                end
                if(j<(oriz-1))
                    sumH=sumH+image(i,j+2,1);
                    sumS=sumS+image(i,j+2,2);
                    sumV=sumV+image(i,j+2,3);
                    if(i>1)
                        sumH=sumH+image(i-1,j+2,1);
                        sumS=sumS+image(i-1,j+2,2);
                        sumV=sumV+image(i-1,j+2,3);
                    end
                    if(i<vert)
                        sumH=sumH+image(i+1,j+2,1);
                        sumS=sumS+image(i+1,j+2,2);
                        sumV=sumV+image(i+1,j+2,3);
                    end
                end
                
                
                %New Pixel Value, calculated with the ratio of the sum
                %obtained with the sum of the bits in the window of each
                %plane
                hs(i,j)=log((sumH+0.000000000001)/(sumS+0.000000000001));
                sv(i,j)=log((sumS+0.000000000001)/(sumV+0.000000000001));
                hv(i,j)=log((sumH+0.000000000001)/(sumV+0.000000000001));
            elseif variance==2
                %Second variance of the feature, there's no window, the
                %ratio goes within the pixel
                
                hs(i,j)=log((double(image(i,j,1))+0.000000000001)/(double(image(i,j,2))+0.000000000001));
                sv(i,j)=log((double(image(i,j,2))+0.000000000001)/(double(image(i,j,3))+0.000000000001));
                hv(i,j)=log((double(image(i,j,1))+0.000000000001)/(double(image(i,j,3))+0.000000000001));
            end
        end
    end
    %get lbp feature vector of each ratio
    lbphs=lbp(hs,3,8,MAPPING,'hist');
    lbphv=lbp(hv,3,8,MAPPING,'hist');
    lbpsv=lbp(sv,3,8,MAPPING,'hist');
    %          lbphs=localBinaryPattern(hs);
    %          lbphv=localBinaryPattern(hv);
    %          lbpsv=localBinaryPattern(sv);
    
    %Combine the 3 vectors in one
    tmp=cat(2,lbphs,lbphv);
    y=cat(2,tmp,lbpsv);
end