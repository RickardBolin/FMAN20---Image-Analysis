%% Task 1
[X, Y] = meshgrid(linspace(0,1,5), linspace(0,1,5));
f_vals = X.*(1-Y) + Y.*(1-X);
surf(X,Y,f_vals)

quant_img = floor((f_vals)./(1/15))


%% Task 7
phi_1 = (1/3)*[0,1,0; 1,1,1; 1,0,1; 1,1,1];
phi_2 = (1/3)*[1,1,1; 1,0,1; -1,-1,-1; 0,-1,0];
phi_3 = (1/2)*[1,0,-1; 1,0,-1; 0,0,0; 0,0,0];
phi_4 = (1/2)*[0,0,0; 0,0,0; 1,0,-1; 1,0,-1];
f = [-2,6,3; 
     13,7,5;
      7,1,8; 
    -3,3,4];

[u_p, e] = projection(f, {phi_1, phi_2, phi_3, phi_4});

%% Task 8 - looking at the test sets
n = 3;
idx = randi([1, 400], 1, n);
for test_set_ = 1:2
    figure
    test_set = stacks{test_set_};
    for i = 1:length(idx)
        subplot(1,n,i)
        imshow(test_set(:,:,idx(i))/255)
    end
end
%% Task 8 - looking at the bases
n = 4;
for base_ = 1:3
    figure
    base = bases{base_};
    for i = 1:4
        subplot(1,n,i)
        imshow(abs(base(:,:,i))./max(max(abs(base(:,:,i)))))
    end
end
%%
load('./inl1_to_students/assignment1bases.mat')
for base_ = 1:3
    for test_set_ = 1:2
        % Extract base and test set:
        base = bases{base_};
        test_set = stacks{test_set_};
        % Loop over test set
        [~,~,N] = size(test_set);
        e_tot = 0;
        for i = 1:N
            u = test_set(:,:,i);
            [u_p, e] = projection(u, {base(:,:,1), base(:,:,2), base(:,:,3), base(:,:,4)});
            e_tot = e_tot + e;
        end
        
        figure
        subplot(2,2,1)
        imshow(u/255)
        subplot(2,2,2)
        imshow(u_p/255)
        % Mean of all errors in test set
        e_mean = e_tot/N;
        disp(['The mean error of test set ', num2str(test_set_),' with basis ', num2str(base_) ,' is ', num2str(e_mean),'.']);
    end
end