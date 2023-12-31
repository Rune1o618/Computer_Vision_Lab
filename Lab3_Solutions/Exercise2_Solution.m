clear all; close all;

% Read QR barcode image
I=imread('QRcode.png');
I=double(I);
I=I/max(I(:));

% Display input image
figure(1)
subplot(1,2,1)
imshow(I);

% NOTE!!!!
% Image coordinate system has reversed y-axis:
% ----> X-axis
% |
% |
% V
%
% Y-axis

% Rectified corner coordinates of the QR barcode (i.e., these are the
% target corner coordinates of your homography.
% NOTE: these are 2D homogeneous coordinates!

p_prime = [ 21  21   1     % Upper left corner
            166 21   1     % Upper right corner
            166 166  1     % Lower right corner
            21  166  1]';  % Lower left corner

% Step 1 - follow instructions in Matlab's command window
figure(2)
imshow(I);
disp('Mark upper left corner of the QR barcode using a single mouse click')
rect=getrect; p(:,1) = [rect(1) rect(2) 1 ];
disp('Mark upper right corner of the QR barcode using a single mouse click')
rect=getrect; p(:,2) = [rect(1) rect(2) 1 ];
disp('Mark lower right corner of the QR barcode using a single mouse click')
rect=getrect; p(:,3) = [rect(1) rect(2) 1 ];
disp('Mark lower left corner of the QR barcode using a single mouse click')
rect=getrect; p(:,4) = [rect(1) rect(2) 1 ];
close(2)

% Step 2
% Now, we wish to find a 3-by-3 homography H that maps the input corner
% coordinates (p) to the rectified corner coordinates (p_prime), i.e.,
%
%   p_prime = H*p;
%
% For help, see slides 47-49 of lecture Lecture3.1-2_ImageFormationPart.pdf.
% NOTE: The eigenvectors of A'*A are calculated using the command
% 
%   [E,V]=eig(A'*A);
%
% The eigenvectors are the columns of E, and the eigenvalues are the on the
% diagonal of V. Let 'i' denote the index of the smallest eigenvalue along
% the diagonal of V, then
%
% H=reshape(E(:,i),3,3)';
%
% So all you have to do here is to define the matrix A and find the index
% 'iMin' of the smallest eigenvalue.

% A = ???
x1 = p(1,1); y1 = p(2,1); xp1 = p_prime(1,1); yp1 = p_prime(2,1);
x2 = p(1,2); y2 = p(2,2); xp2 = p_prime(1,2); yp2 = p_prime(2,2);
x3 = p(1,3); y3 = p(2,3); xp3 = p_prime(1,3); yp3 = p_prime(2,3);
x4 = p(1,4); y4 = p(2,4); xp4 = p_prime(1,4); yp4 = p_prime(2,4);


A = [x1 y1 1 0  0  0 -xp1*x1 -xp1*y1 -xp1;
     0  0  0 x1 y1 1 -yp1*x1 -yp1*y1 -yp1;
     x2 y2 1 0  0  0 -xp2*x2 -xp2*y2 -xp2;
     0  0  0 x2 y2 1 -yp2*x2 -yp2*y2 -yp2;
     x3 y3 1 0  0  0 -xp3*x3 -xp3*y3 -xp3;
     0  0  0 x3 y3 1 -yp3*x3 -yp3*y3 -yp3;
     x4 y4 1 0  0  0 -xp4*x4 -xp4*y4 -xp4;
     0  0  0 x4 y4 1 -yp4*x4 -yp4*y4 -yp4];
 
[E,V]=eig(A'*A);

% iMin = ???
iMin = 1;

H=reshape(E(:,iMin),3,3)';

% Step 3
% Before moving on, you need to check that p_prime = H*p. To do this you
% must transform 'p' to estimate the homogeneous coordinates 'p_prime'
% and convert this estimate to Cartesian coordinates 'p_prime_cart'.
% That is, you must make sure that the extra homogeneous coordinate 
% equals 1 for all points in p_prime.

% p_prime_cart = ???
p_prime_cart = H*p;
for ii=1:size(p_prime_cart,2)
    p_prime_cart(:,ii) = p_prime_cart(:,ii) / p_prime_cart(3,ii);
end

figure(2)
plot(p_prime(1,[1:end 1]),p_prime(2,[1:end 1]),'r',...
     p(1,[1:end 1]),p(2,[1:end 1]),'k',...
     p_prime_cart(1,[1:end 1]),p_prime_cart(2,[1:end 1]),'b--')

% Step 4
% Now, let's rectify the input image.
[X,Y]=meshgrid(1:size(I,1),1:size(I,2));
V = [ X(:) Y(:) ones(size(X(:))) ]';
V = pinv(H)*V;
for i = 1:3
    V(i,:) = V(i,:)./V(3,:);
end
Irectified = interp2(X,Y,I,V(1,:)',V(2,:)');
Irectified = reshape(Irectified,size(I));
figure(1)
subplot(1,2,2)
imshow(Irectified)
