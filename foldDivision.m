%create division between training and test set and corresponding labels
%featureVec: feature vector with all images from the dataset
%class: class of the elements of the output
%actual fold: the fold that contains test set
%nFolds: total number of folds
%nImages: total amount of images of the class

function [TR,TS,lTR,lTS]=foldDivision(featureVec,class,actualFold,nFolds,nImages)
    %get orizontal dimension
    [vert,oriz,genres]=size(featureVec);
    %number of test samples
    test=floor(nImages/nFolds);
    %initialize four output matrix
    TR=zeros((nImages-test),oriz);
    TS=zeros(test,oriz);
    %labels
    lTS=class*ones(test,1);
    lTR=class*ones(nImages-test,1);
    
    %insert elements in the output matrices
    TR(1:(actualFold-1)*test,:)=featureVec(1:(actualFold-1)*test,:,class);
    if(actualFold~=5)
        TS=featureVec(((actualFold-1)*test)+1:actualFold*test,:,class);
        TR(((actualFold-1)*test+1):(nImages-test),:)=featureVec(actualFold*test+1:nImages,:,class);
    else
        TS=featureVec((actualFold-1)*test+1:nImages,:,class);
    end
        
end