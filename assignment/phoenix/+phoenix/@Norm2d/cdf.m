% Cumulative Density Function (cdf, P(X1, X2 <= x1, x2)) for BVN
% Input: 2xn matrix of points. Output: 1xn cumulative density

function cumprob = cdf(obj, val)

     arguments
        obj
        val (2,:) {mustBeFinite, mustBeReal}
     end

     for i = 1:size(val,2)
        cumprob(i) = mvncdf(val(:,i),obj.Mean,obj.Covariance);
end
% Looks good.
% "arguments" looks like a good function to employ. I will try that too


