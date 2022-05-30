%TR training set, TE test set, yTR training label, yy test label
function [DecisionValuec]=PoolSVMnormalizationRID_tesi(TR,TE,yTR,yy,k)

%normalization between [0,1]
massimo=max(TR)+0.00001;
minimo=min(TR);
training=[];
testing=[];
for i=1:size(TR,2)
    training(1:size(TR,1),i)=double(TR(1:size(TR,1),i)-minimo(i))/(massimo(i)-minimo(i));
end
for i=1:size(TE,2)
    testing(1:size(TE,1),i)=double(TE(1:size(TE,1),i)-minimo(i))/(massimo(i)-minimo(i));
end
tra=[];
TR=training;
TE=testing;

%cd .\dataset\orgImg\

for i=1:max(yTR)
    
    y(find(yTR==i))=1;
    y(find(yTR~=i))=2;
    
    if ~isrow(y)
        y=y';
    end
    if ~isrow(yy)
        yy=yy';
    end
    %model = fitcsvm(TR,y,'KernelFunction','polynomial','PolynomialOrder',3,'BoxConstraint',6/2000);
    model = fitcsvm(TR,y,'KernelFunction','polynomial','BoxConstraint',k);
    %model = fitclinear(TR,y);
    %model = fitcknn(TR,y,'NumNeighbors',30);
    [PreLabel, Score] = predict(model,TE);
    DecisionValuec(:,i)=Score(:,1);
    %DecisionValuec(find(isnan(DecisionValuec)))=0;
    
    
    %if max(yTR)==2
        %DecisionValuec(:,2)=DecisionValuec(:,1)*-1;
        %break;
    %end
    
    
end