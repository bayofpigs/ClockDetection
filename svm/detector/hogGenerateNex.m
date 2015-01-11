function [ nEx,num ] = hogGenerateNex( bb_tar,featurePym,featureDim,num_nex) 
bb_tar =reshape([bb_tar.gtBb2D],4,[])';
bb_tar = [bb_tar(:,1:2),bb_tar(:,1:2)+bb_tar(:,3:4)];
% that not overlap with bb_tar
H=featureDim(1);
W=featureDim(2);
% generate bbs that not overlab
nEx=nan(prod(featureDim),num_nex);
n=round(num_nex/length(featurePym.feat));
num=1;
for l=1:1:length(featurePym.feat),
    F=featurePym.feat{l};
    left= randvalues([1:1:size(F,2)-W],n);
    top= randvalues([1:1:(size(F,1)-H)],n);
    for k=1:min([n length(left) length(top)])
        maxos = max(overlapinFeature(left(k),top(k),featureDim,bb_tar,featurePym.scale(l)));
        if maxos<0.05
            fea = featurePym.feat{l}(top(k):(top(k)+H-1),left(k):(left(k)+W-1),:);
            fea=fea(:);
            nEx(:,num)=fea;
            num=num+1;
        end
    end
end

nEx=nEx(:,1:num-1);
end
function out = randvalues(in,k)
% Randomly selects 'k' values from vector 'in'.
out = [];
N = size(in,2);
if k == 0
  return;
end

if k > N
  k = N;
end

if k/N < 0.0001
 i1 = unique(ceil(N*rand(1,k)));
 out = in(:,i1);
 
else
 i2 = randperm(N);
 out = in(:,sort(i2(1:k)));
end
end

function over=overlapinFeature(indexes1,indexes2,featureDim, bb_tar,scale)
        if isempty(bb_tar),
            over =0;
            return;
        end

        bb=([indexes1; indexes2; indexes1+featureDim(2);indexes2+featureDim(1)]- 1) * 8 / scale + [1;1;0;0];
        for i =1:size(bb_tar,1)
            a=max(bb(1:2),bb_tar(i,1:2)');
            b=min(bb(3:4),bb_tar(i,3:4)');
            c=min(bb(1:2),bb_tar(i,1:2)');
            d=max(bb(3:4),bb_tar(i,3:4)');
            n=max(0,(b(1)-a(1)))*max(0,(b(2)-a(2)));
            u=((d(1)-c(1))*(d(2)-c(2)));
            over(i)=n/u;
        end
end