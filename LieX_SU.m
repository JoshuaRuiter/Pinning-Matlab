function mat = LieX_SU(MatrixSize, Root_System, FormMatrix, alpha, u)
    % Takes inputs alpha (a root), root_system the root system it comes from, 
    % and u (a vector, possibly symbolic)
    % Output the associated element of the Lie algebra

    n = MatrixSize;
    q = Root_System.Rank;

    % validate inputs - alpha is a root, and u is the right length
    assert(Root_System.IsRoot(alpha))
    assert(length(u) == RootSpaceDimensionSU(Root_System,alpha))

    % assume all entries of u are "real"
    if isa(u,'sym')
        for k=1:length(u)
            warning('off','all')
            assumeAlso(u(k),'real')
            warning('on','all')
        end
    end

    % create a nxn matrix of zeros, that allows symbolic
    mat = SymbolicZeros(n);
    
    if IsLong(alpha)
        % In this case, the root alpha is of the form 
        % +/- 2alpha_i for some i
        i = find(alpha~=0);
        
        % In this case, the input should be a scalar 
        % (a single element of the base field k)
        assert(length(u)==1);
        
        if sum(alpha) == 2
            % alpha = 2alpha_i
            mat(i,i+q) = u;
        elseif sum(alpha) == -2
            % alpha = -2alpha_i
            mat(i+q,i) = u;
        else
            % something is wrong, throw an error
            printf("A long root has the wrong form.");
            assert(false);
        end

    elseif IsShort(alpha)
        % In this case, the root alpha is of the form 
        % +/- alpha_i for some i
        i = find(alpha~=0);

        % In this case, the input should have length 2*(n-2q)
        assert(length(u)==2*(n-2*q));
        assumeAlso(u,'real');
        
        if sum(alpha) == 1
            % alpha = alpha_i
            for j = (2*q)+1 : n

                % Cora's code
                mat(i,j) = u(j-2*q);
                mat(j,q+i) = -u(j-2*q);

            end
        elseif sum(alpha) == -1
            % alpha = -alpha_i
            for j = (2*q)+1 : n

                % Haven't checked this
                mat(q+i,j) = -u(j-2*q);
                mat(j,q) = u(j-2*q);
            end
        else
            % something is wrong, throw an error
            printf("A short root has the wrong form.");
            assert(false);
        end

    elseif IsMedium(alpha)

        % In this case, the input should vector of length 2,
        % which carries the "real" part in the first entry 
        % and the "imaginary" part in the second entry
        assert(length(u)==2);
        if isa(u,'sym')
            warning('off','all')
            assumeAlso(u(1),'real');
            assumeAlso(u(2),'real');
            warning('on','all')
        end

        % switch to viewing u as a single complex number
        u_complex = u(1) + 1i*u(2);

        if sum(alpha)==0
            % alpha = alpha_i - alpha_j
            i = find(alpha==1);
            j = find(alpha==-1);

            mat(i,j) = u_complex; 
            mat(j+q,i+q) = -conj(u_complex);
            
        elseif sum(alpha)==2
            % alpha = alpha_i + alpha_j, with i and j distinct
            % convention: i is less than j

            % F finds the first two indices of alpha where the value is 1
            % and puts them into a 1x2 array
            F = find(alpha==1,2);
            i = F(1);
            j = F(2);
            assert(i<j);

            mat(i,j+q) = u_complex;
            mat(j,i+q) = conj(u_complex);

        elseif sum(alpha)==-2
            % alpha = -alpha_i - alpha_j, with i and j distinct
            % convention: i is less than j

            % F finds the first two indices of alpha where the value is -1
            % and puts them into a 1x2 array
            F = find(alpha==-1,2); 
            i = F(1);
            j = F(2);
            assert(i<j);

            mat(j+q,i) = u_complex;
            mat(i+q,j) = conj(u_complex);
        else
            % something is wrong, throw an error
            printf("A normal root isn't of the right form.");
            assert(false);
        end
    else
        % Something is wrong, throw an error
        printf("A root is neither long, short, nor medium.");
        assert(false);
    end

    assert(length(mat)==MatrixSize);
end

function bool = IsShort(alpha)
    bool = (dot(alpha,alpha)==1);
end
function bool = IsMedium(alpha)
    bool = (dot(alpha,alpha)==2);
end
function bool = IsLong(alpha)
    bool = (dot(alpha,alpha)==4);
end
