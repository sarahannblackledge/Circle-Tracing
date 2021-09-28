function [errorNum, errorDuration, cumulative_errorDuration] = errorCount(timeStamp, error_TF)

%set last value in error_TF to 1 to ensure accurate calculation of error
%duration
error_TF(end) = 1;


diffvals = diff(error_TF);
errorInds = find(diffvals == -1);

TF = isempty(errorInds);

if ~TF
    %Calculate error duration
    errorCorrectInds = find(diffvals == 1);
    
    
    for i = 1:length(errorCorrectInds)
        t2 = timeStamp(errorCorrectInds(i));
        t1 = timeStamp(errorInds(i));
        errorDuration(i) = t2 - t1;
    end
    
    %Remove errors less than 0.1 seconds in length
    errorDuration(errorDuration < 0.1) = [];
    errorNum = length(errorDuration);
    
    %If no errors made, set everything to zero
    if errorNum > 0
        cumulative_errorDuration = sum(errorDuration);
    else
        cumulative_errorDuration = 0;
        errorDuration = 0;
    end
    
else
    errorDuration = 0;
    errorNum = 0;
    cumulative_errorDuration = 0;
    
end