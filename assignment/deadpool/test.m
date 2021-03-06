function test(pseudonym)
%  TEST  Runs test on readData.m, getData.m, and static properties of Norm2d
%
% Set deadpool as default pseudonym
    if nargin<1
        pseudonym = 'deadpool';
    end

% Check for class Norm2d
    try
        this = [];
        eval(sprintf('this = %s.Norm2d();', pseudonym))
    catch me
        fprintf('I couldn''t find a class named %s.Norm2d.\n', pseudonym);
        throw(me)
    end

    throwAsCaller = @(x)warning(x.message);

%% Report
    % Start printing a little report to screen
    % make a long line
    dashline = repmat('-', 1, 77);

    % print a line
    fprintf('#%s#\n', dashline);

    % print time and date
    fprintf('# %74s  #\n', datestr(now))

    % print report title
    fprintf('#%-77s#\n', sprintf('  Test suite for "%s"  ', class(this)))

    % print a line
    fprintf('#%s#\n', dashline); 

% Test for Equality between Matlab functions and estimate.
    % Data matrix for test
    test.data = [-1,0,1;3.2,-2,-1.2];
    % Reference: Mean vector using matlab function
    ref.mean = mean(test.data,2);
    % Reference: Covariance matrix using matlab function
    ref.covariance = cov(test.data.');
    % Reference: Precision matrix using matlab function
    ref.pres = inv(ref.covariance);
    % Reference: Correlation from matlab function
    ref.cor = corr(test.data.');
    ref.cor = ref.cor(1,2);
    % New object with updated properties to be tested
    tobe_tested = this().estimate(test.data);

    % Test that the mean is correct
    assertEqualUpToTol(ref.mean, tobe_tested.Mean, 'equallity of Means')
    % Test that the Covariance matrix is correct
    assertEqualUpToTol(ref.covariance, tobe_tested.Covariance, 'equallity of Covariance matrix')
    % Test that the Presicion matrix is correct    
    assertEqualUpToTol(ref.pres, tobe_tested.Precision, 'equallity of Presicion matrix')
    % Test that the correlation is correct    
    assertEqualUpToTol(ref.cor, tobe_tested.Correlation, 'equality of Correlation')


% Negative tests confirm that errors are thrown when expected
    % Test for errors when data matrix contains values that are not allowed
    try
        test.data = [1:3;1:3;1:3]; % wrong dimentions
        this().estimate(test.data);  
        errorThrown = false;
    catch
    errorThrown = true;
    end
    assertErrorThrown(errorThrown, 'Data file . enforce matrix size (2 x N)')

    % Test for Data matrix with all finite values
    try
        test.data = [1:3;Inf,2,3]; % infinite value at position 2,1
        this().estimate(test.data);  
        errorThrown = false;
    catch
    errorThrown = true;
    end
    assertErrorThrown(errorThrown, 'Data file . enforce all finite values')

    % Test for Data matrix with all real values
    try
        test.data = [1:3;1i+2,2,3]; % imaginary value at position 2,1
        this().estimate(test.data);  
        errorThrown = false;
    catch
    errorThrown = true;
    end
    assertErrorThrown(errorThrown, 'Data file . enforce all real values')

    % Test for Data matrix with all numerical values
    try
        test.data = [1:3;'c',2,3]; % imaginary value at position 2,1
        this().estimate(test.data);  
        errorThrown = false;
    catch
    errorThrown = true;
    end
    assertErrorThrown(errorThrown, 'Data file . enforce all numeric values')


% Test getData function 
    % Test for random URL
    try
        test.url = 'http://asjhbaksjdgal.com';
        getData(test.url);  
        errorThrown = false;
    catch
    errorThrown = true;
    end
    assertErrorThrown(errorThrown, 'URL . enforce valid URL')


% Test readData function 
    % Test for random path
    try
        test.path = '~/some_random_file.csv';
        getdata(test.path);  
        errorThrown = false;
    catch
    errorThrown = true;
    end
    assertErrorThrown(errorThrown, 'File Path . enforce valid path to data file') 

% Wrapup
    fprintf('#%s#\n', dashline);
    fprintf('# %74s  #\n', datestr(now))
    fprintf('#%-77s#\n', sprintf('  All tests passed for "%s"  ', class(this)))
    fprintf('#%s#\n', dashline);


% Additional functions for tests:    
% Assert an approximate equality
    function assertEqualUpToTol(a, b, condition)
        if all(abs(a-b) < 1e-10)
            success(condition)
        else
            fprintf('#%s#\n', dashline);
            fprintf('!  Test failed: %s\n', condition)
            disp('!  I expected a==b:')
            a
            b
            throwAsCaller(failure(condition))
        end
    end

% Assert that an error was thrown on a call
    function assertErrorThrown(a,condition)
        if a
            success(condition)
        else
            fprintf('#%s#\n', dashline);
            fprintf('!  Test failed: %s\n', condition)
            disp('!  I expected an error to be thrown')
            throwAsCaller(failure(condition))
        end
    end

% Success message
    function success(condition)
        fprintf('# %-67s ', sprintf(' %s', condition));
        lookBusy(2)
        fprintf('passed  #\n');
    end

% Failure message
    function me = failure(condition)
        fprintf('# %-67s FAILED  #\n', sprintf(' %s', condition));
        fprintf('#%s#\n', dashline);
        me = ...
            MException( ....
                'magneto:testSuite', ...
                sprintf('TESTSUITE failed for condition "%s"', condition));
    end

% If reports generate too fast, people don't believe they did anything
    function lookBusy(k)
        for r = 1:k
            for s = '\|/-'
                fprintf('%s', s);
                pause(.005)
                fprintf('\b');
            end
        end
    end

end