function [hamr,xtraj,utraj,ctraj,btraj,...
    psitraj,etatraj,jltraj, kltraj, straj,z,F,info,infeasible_constraint_name] = runVariationalTrajOpt()

% file
urdf = fullfile(getDrakePath,'examples', 'HAMR-URDF', 'urdf', 'HAMRVariational_scaledV2_LB.urdf');

% options
options.terrain = RigidBodyFlatTerrain();
options.ignore_self_collisions = true;
options.collision_meshes = false;
options.use_bullet = false;
options.floating = true;
options.collision = true;

hamr = HamrVariationalRBM(urdf,options);
v = hamr.constructVisualizer();

% state/input dimenisons
nq = hamr.getNumPositions();
nv = hamr.getNumVelocities();
nx = nq+nv;
nu = hamr.getNumInputs();

% ---- Nominal Data----
T = 1e3;                        % 1 second
N = 11;                         % number of knot points
x0 = hamr.getInitialState(); 
q0 = x0(1:nq); v0 = x0(nq+1:(nq+nv)); 
x1 = x0; x1(1) = 10;            % move 10 mm


% --- Initialize TrajOpt---
T_span = [T T];

options.sweight = 1e5; 
traj_opt = VariationalTrajectoryOptimization(hamr,N,T_span,options);

% ---- Initial Guess ----%
t_init = linspace(0,T,N);

traj_init.x = PPTrajectory(foh([0 T],[x0, x1]));
traj_init.u = PPTrajectory(zoh(t_init,0.1*randn(nu,N)));
traj_init.c = PPTrajectory(zoh([0, T], [1e-3*rand(traj_opt.nC, 1), 1e-3*rand(traj_opt.nC, 1)])); 
traj_init.b = PPTrajectory(zoh([0, T], [1e-3*rand(traj_opt.nD*traj_opt.nC, 1), 1e-3*rand(traj_opt.nD*traj_opt.nC, 1)])); 
traj_init.psi = PPTrajectory(zoh([0, T], [1e-3*rand(traj_opt.nC, 1), 1e-3*rand(traj_opt.nC, 1)])); 
traj_init.eta = PPTrajectory(zoh([0, T], [1e-3*rand(traj_opt.nC*traj_opt.nD, 1), 1e-3*rand(traj_opt.nC*traj_opt.nD, 1)])); 
traj_init.jl = PPTrajectory(zoh([0, T], [1e-3*rand(traj_opt.nJL, 1), 1e-3*rand(traj_opt.nJL, 1)])); 
traj_init.kl = PPTrajectory(zoh([0, T], [1e-3*rand(traj_opt.nKL, 1), 1e-3*rand(traj_opt.nKL, 1)])); 

% -- Constraints and costs ---%
traj_opt = traj_opt.addRunningCost(@running_cost_fun);
traj_opt = traj_opt.addFinalCost(@final_cost_fun);
traj_opt = traj_opt.addPositionConstraint(ConstantConstraint(q0),1);
traj_opt = traj_opt.addVelocityConstraint(ConstantConstraint(v0),1);
traj_opt = traj_opt.addTrajectoryDisplayFunction(@displayTraj);

% 
% y_ub = q0(2) + 10;
% y_lb = q0(2) - 10;
% z_ub = q0(3) + 2;
% z_lb = q0(3) - 3;

% traj_opt = traj_opt.addPositionConstraint(BoundingBoxConstraint(...
%     [y_lb; z_lb] ,[z_ub; y_ub]),2:N-1, 2:3);

% traj_opt = traj_opt.addVelocityConstraint(ConstantConstraint(zeros(nv,1)),1);

% Flim = 0.2; % mN
% traj_opt = traj_opt.addInputConstraint(BoundingBoxConstraint(-Flim*ones(nu,1),Flim*ones(nu,1)),1:N-1);

% Solver options
traj_opt = traj_opt.setSolver('snopt');
traj_opt = traj_opt.setSolverOptions('snopt','MajorIterationsLimit',10000);
traj_opt = traj_opt.setSolverOptions('snopt','MinorIterationsLimit',200000);
traj_opt = traj_opt.setSolverOptions('snopt','IterationsLimit',1000000);
traj_opt = traj_opt.setSolverOptions('snopt','SuperbasicsLimit',1000);


disp('Solving...')
tic
[xtraj,utraj,ctraj,btraj, psitraj,etatraj,jltraj, kltraj,straj, ...
    z,F,info,infeasible_constraint_name] = traj_opt.solveTraj(t_init,traj_init);
toc

    function [f,df] = running_cost_fun(h,x,u)
        Flim = 0.3;                     % 300 mN of max force
        R = 2*(1/Flim)^2*eye(nu);
        g = (1/2)*u'*R*u;
        f = h*g;
        df = [g, zeros(1,nx), h*u'*R];
    end


    function [f,df] = final_cost_fun(tf,x)       
        f = -x(1); 
        df = zeros(1, nx+1); 
        df(2) = -1;
    end

    function displayTraj(h,x,u)
        disp('Displaying Trajectory...')
        h = h/1e3; 
        ts = [0;cumsum(h)];
        for i=1:length(ts)
            v.drawWrapper(0,x(:,i));
            pause(h(1));
        end

    end
end
