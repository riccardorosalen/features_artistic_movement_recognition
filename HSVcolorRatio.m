clc; clear all; close all;
tic;
%Class indexes from directory reading
%1 northern renaissance
%2 ukiyo
%3 high renaissance
%4 impressionism
%5 post Impressionism
%6 rococo
clear all
warning off

path=".\dataset\orgImg\";
genres={'highRenaissance','impressionism','northRenaiss','postImpress','rococo','ukiyo'};

load Starting.mat;
clear FEAT;
metodoHAND=9;
    if metodoHAND==1
            FEAT=FV1(:,:);
        elseif metodoHAND==2
            FEAT=FV2(:,:);
        elseif metodoHAND==3
            FEAT=FV3(:,:);
        elseif metodoHAND==4
            FEAT=FV4(:,:);
        elseif metodoHAND==5
            FEAT=FV5(:,:);
%         elseif metodoHAND==6
%             FEAT=FV6(:,:,fold);
%         elseif metodoHAND==7
% %             tmp1=cat(2,FV2(:,:),FV3(:,:));
% % %             tmp2=cat(2,tmp1(:,:),FV4(:,:));
% %             tmp3=cat(2,tmp1(:,:),FV5(:,:));
% %             tmp4=cat(2,tmp3(:,:),double(FV8(:,:)));
% %             %tmp5=cat(2,tmp4(:,:),FV10(:,:));
% %             tmp5=cat(2,tmp4(:,:),FV6(:,:,fold));
% %             FEAT=cat(2,tmp5(:,:),FV10(:,:));
%         tmp1=cat(2,FV3(:,:),FV8(:,:));
%         tmp2=cat(2,tmp1(:,:),FV6(:,:,fold));
%         FEAT=cat(2,tmp2(:,:),FV2(:,:));
        elseif metodoHAND==8
            FEAT=FV8(:,:);
        elseif metodoHAND==9
            FEAT=FV9(:,:);
        elseif metodoHAND==10
            FEAT=FV10(:,:);
%         elseif metodoHAND==11
%             FEAT=FV11(:,:,fold);
        end

        clear FT;
nIm=zeros(1,ngenres);        
for img=1:DIM2
    nIm(yE(img))=nIm(yE(img))+1;
    FT(nIm(yE(img)),:,yE(img))=FEAT(img,:);
end
clear FEAT;
FEAT=FT;



%%
%k-fold SVM training
nFolds=10;
globalAvg=0;
%For each fold
fprintf("Start\n");
perf=zeros(15,nFolds);

for k=1:nFolds
    n=0;
    %Process and variables needed to calculate accuracy
    starting=zeros(ngenres+1,1);
    classtest=zeros(ngenres,1);
    ntest=0;    
    for i=1:ngenres
        starting(i)=ntest;
        classtest(i)=floor(nimages(i)/nFolds);
        ntest=ntest+(classtest(i));
    end
    starting(ngenres+1)=ntest;
    
    %Matrix that stores the votes for each one on one
    votes=zeros(ntest,ngenres);
    for i=1:ngenres-1
        %One-vs-One with next classes (in order)
        for j=i+1:ngenres
            %Create specific training and test set for this one-vs-one
            [TRi,TSi,lblTRi,lblTSi]=foldDivision(FEAT,i,k,nFolds,nimages(i));
            [TRj,TSj,lblTRj,lblTSj]=foldDivision(FEAT,j,k,nFolds,nimages(j));
            tmpTR=cat(1,TRi,TRj);
            tmpTS=cat(1,TSi,TSj);
            %Create label column for training and test set
            lblTR=cat(1,lblTRi,lblTRj);
            lblTS=cat(1,lblTSi,lblTSj);
            %Classify
            [output]=PoolSVMnormalizationRID(tmpTR,tmpTS,lblTR,lblTS);
            %Insert votes in table
            for x=1:starting(i+1)-starting(i)
                votes(starting(i)+x,j)=output(x);
            end
            for y=1:(starting(j+1)-starting(j))
                votes(starting(j)+y,i)=output(classtest(i)+y);
            end
        end
    end
    
    %Count correct answers
    avg=0;
    
    for i=1:ngenres-1
        for j=i+1:ngenres
            n=n+1;
            correctAB=0;
            for x=1:starting(i+1)-starting(i)
                if votes(starting(i)+x,j)==i
                    correctAB=correctAB+1;
                end
                
            end
            for y=1:(starting(j+1)-starting(j))
                if votes(starting(j)+y,i)==j
                    correctAB=correctAB+1;
                end
            end
            accuracy=correctAB/(classtest(i)+classtest(j));
            avg=avg+accuracy;
            perf(n,k)=accuracy;
            fprintf("Accuracy %s/%s:%f\n",genres{i},genres{j},accuracy);
        end
    end
    
    avg=avg/15;
    fprintf("Average accuracy=%f\n",avg)
    
end

n=0;
for i=1:ngenres-1
    for j=i+1:ngenres
        n=n+1;
        fprintf("%f\n",mean(perf(n,:)));
    end
end

toc;