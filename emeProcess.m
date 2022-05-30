function y=emeProcess(parImage,variance)
    image =parImage;
    [vert,oriz,pl]=size(image);
    
    %initialize contrast images
    new=zeros(vert,oriz,pl);
    conf=config_gist();
    %min and max values of each 3x3 window
    for k=1:3
        for i=1:vert
            min=uint8(255);
            max=0;
            for j=1:oriz
                %bit attuale
                if(image(i,j,k)<min)
                    min=image(i,j,k);
                elseif(image(i,j,k)>max)
                    max=image(i,j,k);
                end
                if (i>1)
                    if(image(i-1,j,k)<min)
                        min=image(i-1,j,k);
                    elseif(image(i-1,j,k)>max)
                        max=image(i-1,j,k);
                    end
                    if (j>1)
                        if(image(i-1,j-1,k)<min)
                            min=image(i-1,j-1,k);
                        elseif(image(i-1,j-1,k)>max)
                            max=image(i-1,j-1,k);
                        end
                    end
                    if (j<oriz)
                        if(image(i-1,j+1,k)<min)
                            min=image(i-1,j+1,k);
                        elseif(image(i-1,j+1,k)>max)
                            max=image(i-1,j+1,k);
                        end
                    end
                end
                if (i<vert)
                    if(image(i+1,j,k)<min)
                        min=image(i+1,j,k);
                    elseif(image(i+1,j,k)>max)
                        max=image(i+1,j,k);
                    end
                    if (j>1)
                        if(image(i+1,j-1,k)<min)
                            min=image(i+1,j-1,k);
                        elseif(image(i+1,j-1,k)>max)
                            max=image(i+1,j-1,k);
                        end
                    end
                    if (j<oriz)
                        if(image(i+1,j+1,k)<min)
                            min=image(i+1,j+1,k);
                        elseif(image(i+1,j+1,k)>max)
                            max=image(i+1,j+1,k);
                        end
                    end
                end
                if(j<oriz)
                    if(image(i,j+1,k)<min)
                        min=image(i,j+1,k);
                    elseif(image(i,j+1,k)>max)
                        max=image(i,j+1,k);
                    end
                end
                if(j>1)
                    if(image(i,j-1,k)<min)
                        min=image(i,j-1,k);
                    elseif(image(i,j-1,k)>max)
                        max=image(i,j-1,k);
                    end
                end
                newvalue=(4/10)*(1-((double(max)/(double(min)+0.1))^(1/10)))+(6/10)*(image(i,j,k));
                new(i,j,k)=newvalue;
            end
        end
    end
    if variance==1
        y=lbp(new,3,8,0,'hist');
    elseif variance==2
        y=extract_gist(single(new));
    end
end