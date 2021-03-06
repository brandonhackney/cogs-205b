function mustBeSimm(obj)
% Validates if the covariance matrix is positive semi-definite
    if ~(issymmetric(obj))
        eidType = "Covariance:notsymmetric";
        msgType = 'Covariance matrix is not Symmetric.';
        throwAsCaller(MException(eidType,msgType));
    end
end