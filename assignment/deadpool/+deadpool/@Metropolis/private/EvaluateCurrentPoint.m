function dy = EvaluateCurrentPoint(obj)
% EvaluateCurrentPoint - targetlogpdf at x

    % Compute the ln of the posterior distribution at current point.
    dy = obj.TargetLogPdf(obj.PointX);
end