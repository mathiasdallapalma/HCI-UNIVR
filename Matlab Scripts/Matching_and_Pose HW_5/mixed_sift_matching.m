function [matches, f_tg, f_ref]= mixed_sift_matching(TgImg,RefImg,peak_thresh,best_frac_match)
%
%

%Compute matching between two image using sift:
run('..\sift\toolbox\vl_setup.m');
%vl_setup("QUIET");
disp('Compute feature points and descriptors...');

[f_tg, d_tg] = vl_sift(single(rgb2gray(TgImg)),'PeakThresh', peak_thresh);
[f_ref, d_ref] = vl_sift(single(rgb2gray(RefImg)),'PeakThresh', peak_thresh);


disp('Compute feture matching...');
[matches, scores] = vl_ubcmatch(d_tg,d_ref);
[drop, perm] = sort(scores, 'ascend') ;
matches = matches(:, perm) ;
scores  = scores(perm) ;
best_n_match=length(matches)*best_frac_match;
matches=matches(:,1:best_n_match);

