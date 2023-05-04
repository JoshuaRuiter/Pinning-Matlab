function mat = LieX_SO(MatrixSize, Root_System, FormMatrix, alpha, v)
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    
    q = Root_System.Rank;
    assert(Root_System.IsRoot(alpha));
    assert(MatrixSize > 2*q);
    mat = SymbolicZeros(MatrixSize);
    n = MatrixSize;
    diff = n-2*q;

    %%%%%%%%%%%%%%%%%%%%%%%%%%
    c = sym('c',diff);
    for i=1:diff
        c(i) = FormMatrix(q+i, q+i);
    end

    %c1 = FormMatrix(q+1,q+1);
    %c2 = FormMatrix(q+2,q+2);
    
    %sum alpha to find out the type, possible sums are -2,-1,0,1,2
    function type = rootType(alpha)
        type = 0;
        for j=1:length(alpha)
            type = type + alpha(j);
        end
    end
    
    type = rootType(alpha);
    % root with 2d map
    if type == 1 || type == -1
        for i = 1:q
            if alpha(i) == 1
                for s=1:diff
                    mat(i,q+s) = -c(s)*v(s);
                    mat(q+s,q+diff+i) = v(s);
                end
                break
            elseif alpha(i) == -1
                for s=1:(diff)
                    mat(q+s,i) = v(s);
                    mat(q+diff+i,q+s) = -c(s)*v(s);
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
        mat(q+2+b, q+2+a) = -v(1);
    elseif type == 2
        a = [0,0];
        index = 1;
        for i = 1:q
            if alpha(i) == 1
                a(index) = i;
                index = index + 1;
            end
        end
        mat(a(1),q+2+a(2)) = v(1);
        mat(a(2),q+2+a(1)) = -v(1);
    elseif type == -2
        a = [0,0];
        index = 1;
        for i = 1:q
            if alpha(i) == -1
                a(index) = i;
                index = index + 1;
            end
        end
        mat(q+2+a(1),a(2)) = v(1);
        mat(q+2+a(2),a(1)) = -v(1);
    end    
end