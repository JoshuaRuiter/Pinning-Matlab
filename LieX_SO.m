function mat = LieX_SO(MatrixSize, Root_System, FormMatrix, alpha, v)
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    
    q = Root_System.Rank;
    assert(Root_System.IsRoot(alpha));
    assert(MatrixSize > 2*q);
    mat = sym(zeros(MatrixSize));
    n = MatrixSize;
    diff = n-2*q;

    %%%%%%%%%%%%%%%%%%%%%%%%%%
    c = FormMatrix.AnisotropicPartVector;
    % for i=1:diff
    %     c(i) = FormMatrix(q+i, q+i);
    % end
    
    %sum alpha to find out the type, possible sums are -2,-1,0,1,2
    type = sum(alpha);
 
    % root with 2d map
    if type == 1 || type == -1
        for i = 1:q
            if alpha(i) == 1
                for s=1:diff
                    mat(i,2*q+s) = -c(s)*v(s);
                    mat(2*q+s,q+i) = v(s);
                end
                break
            elseif alpha(i) == -1
                for s=1:(diff)
                    mat(q+i,2*q+s) = -c(s)*v(s);
                    mat(2*q+s,i) = v(s);
                end
                break
            end
        end

    % roots with 1d map
    elseif type == 0
        a = 0;
        b = 0;
        for i = 1:q
            if alpha(i) == 1
                a = i;
            elseif alpha(i) == -1
                b = i;
            end
        end
        mat(a,b) = v(1);
        mat(q+b, q+a) = -v(1);

    elseif type == 2
        a = [0,0];
        index = 1;
        for i = 1:q
            if alpha(i) == 1
                a(index) = i;
                index = index + 1;
            end
        end
        mat(a(1),q+a(2)) = v(1);
        mat(a(2),q+a(1)) = -v(1);

    elseif type == -2
        a = [0,0];
        index = 1;
        for i = 1:q
            if alpha(i) == -1
                a(index) = i;
                index = index + 1;
            end
        end
        mat(q+a(1),a(2)) = v(1);
        mat(q+a(2),a(1)) = -v(1);
    end    
end