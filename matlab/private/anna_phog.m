function p = anna_phog(image, varargin)
% ANNA_PHOG  Computes Pyramid Histogram of Oriented Gradient.
%
%   PHOG = ANNA_PHOG(IMAGE)  Computes PHOG descriptor on IMAGE.
%
%   The function accepts the following options:
%
%   Bins:: [8]
%     Number of bins on the histogram .
%
%   Angles:: [360]
%     Number of angles for gradients (must be either 180 or 360).
%
%   Levels:: [2]
%     Number of pyramid levels (the minimum is 0).
%
%   ROI:: [image size]
%     Region Of Interest, a vector (ytop, ybottom, xleft, xright).

% Original code from: http://www.robots.ox.ac.uk/~vgg/research/caltech/phog.html
% Author: Paolo D'Apice

sz = size(image);

conf.bins = 8;
conf.angles = 360;
conf.levels = 2;
conf.roi = [1 sz(1) 1 sz(2)];
conf = vl_argparse(conf, varargin);

% TODO: support colors
if numel(sz) == 3 && sz(3) == 3, image = rgb2gray(image); end

% compute edge gradients
E = edge(image, 'canny');
[GradientX,GradientY] = gradient(double(image)); % XXX single
Gr = sqrt((GradientX.*GradientX)+(GradientY.*GradientY));

% compute angles
if conf.angles == 180
    A = ((atan(GradientY./(GradientX+eps))+(pi/2))*180)/pi;
elseif conf.angles == 360
    A = ((atan2(GradientY,GradientX)+pi)*180)/pi;
end

% compute histograms and gradients
[bh,bv] = anna_binMatrix(A, E, Gr, conf.angles, conf.bins);

% compute phog
roi_y = conf.roi(1):conf.roi(2);
roi_x = conf.roi(3):conf.roi(4);
p = anna_phogDescriptor(bh(roi_y, roi_x), bv(roi_y, roi_x), ...
                        conf.levels, conf.bins);


function [bm,bv] = anna_binMatrix(A, E, G, angle, bin)
% ANNA_BINMATRIX  Computes a Matrix (bm) with the same size of the image
% where the (i,j) position contains the histogram value for the pixel at
% position (i,j) and another matrix (bv) where the position (i,j) contains
% the gradient value for the pixel at position (i,j).
%
% IN:
%   A - Matrix containing the angle values
%   E - Edge Image
%   G - Matrix containing the gradient values
%   angle - 180 or 360
%   bin - Number of bins on the histogram
%
% OUT:
%   bm - matrix with the histogram values
%   bv - matrix with the gradient values (only for the pixels belonging to
%        and edge)

[contours,n] = bwlabel(E);
[Y,X] = size(E);
bm = zeros(Y,X);
bv = zeros(Y,X);

nAngle = angle/bin;

for i = 1:n
    [posY,posX] = find(contours == i);
    for j = 1:size(posY,1)
        pos_x = posX(j,1);
        pos_y = posY(j,1);
        b = ceil(A(pos_y,pos_x)/nAngle);
        if G(pos_y,pos_x) > 0
            bm(pos_y,pos_x) = b;
            bv(pos_y,pos_x) = G(pos_y,pos_x);
        end
    end
end


function p = anna_phogDescriptor(bh, bv, L, bin)
% ANNA_PHOGDESCRIPTOR  Computes PHOG over a ROI.
%
% IN:
%   bh - matrix of bin histogram values
%   bv - matrix of gradient values
%   L - number of pyramid levels
%   bin - number of bins
%
% OUT:
%   p - pyramid histogram of oriented gradients (phog descriptor)

p = zeros(1, bin * sum(4.^(0:L)));

% FIXME: vectorialize this code!!

bh_size = size(bh);
counter = 0;
for l = 0:L
    x = fix(bh_size(2)/(2^l));
    y = fix(bh_size(1)/(2^l));
    for xx = 0:x:bh_size(2) - x - 1
        for yy = 0:y:bh_size(1) - y - 1
            bh_cella = bh(yy+1:yy+y, xx+1:xx+x);
            bv_cella = bv(yy+1:yy+y, xx+1:xx+x);
            p(counter*bin + 1:counter*bin + bin) = histogram(bh_cella, bv_cella, bin);
            counter = counter + 1;
        end
    end
end
% normalize to 1
p = single(p/sum(p));


function p = histogram(bh, bv, bin)
% HISTOGRAM  Compute normalized histogram.
p = zeros(bin, 1);
for b = 1:bin
    p(b) = sum(bv(bh == b));
end
p = single(p./(sum(p)+eps));

