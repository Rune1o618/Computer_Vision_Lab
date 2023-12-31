function [ ] = showMosaic( im1, im2, f1, f2, matches, ok, H )

numMatches = size(matches,2);
dh1 = max(size(im2,1)-size(im1,1),0) ;
dh2 = max(size(im1,1)-size(im2,1),0) ;

if sum(ok)~=numMatches
    figure ; clf ;
    subplot(2,1,1) ;
    imagesc([padarray(im1,dh1,'post') padarray(im2,dh2,'post')]) ;
    o = size(im1,2) ;
    line([f1(1,matches(1,:));f2(1,matches(2,:))+o], ...
        [f1(2,matches(1,:));f2(2,matches(2,:))]) ;
    title(sprintf('%d tentative matches', numMatches)) ;
    axis image off ;
    
    subplot(2,1,2) ;
    imagesc([padarray(im1,dh1,'post') padarray(im2,dh2,'post')]) ;
    o = size(im1,2) ;
    line([f1(1,matches(1,ok));f2(1,matches(2,ok))+o], ...
        [f1(2,matches(1,ok));f2(2,matches(2,ok))]) ;
    title(sprintf('%d (%.2f%%) inliner matches out of %d', ...
        sum(ok), ...
        100*sum(ok)/numMatches, ...
        numMatches)) ;
    axis image off ;
    drawnow ;
end

box2 = [1  size(im2,2) size(im2,2)  1 ;
    1  1           size(im2,1)  size(im2,1) ;
    1  1           1            1 ] ;
box2_ = inv(H) * box2 ;
box2_(1,:) = box2_(1,:) ./ box2_(3,:) ;
box2_(2,:) = box2_(2,:) ./ box2_(3,:) ;
ur = min([1 box2_(1,:)]):max([size(im1,2) box2_(1,:)]) ;
vr = min([1 box2_(2,:)]):max([size(im1,1) box2_(2,:)]) ;

[u,v] = meshgrid(ur,vr) ;
im1_ = vl_imwbackward(im2double(im1),u,v) ;

z_ = H(3,1) * u + H(3,2) * v + H(3,3) ;
u_ = (H(1,1) * u + H(1,2) * v + H(1,3)) ./ z_ ;
v_ = (H(2,1) * u + H(2,2) * v + H(2,3)) ./ z_ ;
im2_ = vl_imwbackward(im2double(im2),u_,v_) ;

mass = ~isnan(im1_) + ~isnan(im2_) ;
im1_(isnan(im1_)) = 0 ;
im2_(isnan(im2_)) = 0 ;
mosaic = (im1_ + im2_) ./ mass ;

figure ; clf ;
imagesc(mosaic) ; axis image off ;
title('Mosaic') ;


end

