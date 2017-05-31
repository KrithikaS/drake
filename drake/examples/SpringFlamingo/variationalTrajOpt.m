function [p,xtraj,utraj,ctraj,btraj,straj,z,F,info,infeasible_constraints,traj_opt] = variationalTrajOpt()

options.terrain = RigidBodyFlatTerrain();
options.floating = true;
options.ignore_self_collisions = true;
options.use_bullet = false;
p = PlanarRigidBodyManipulator('urdf/spring_flamingo_passive_ankle.urdf',options);
v = p.constructVisualizer;

N = 25;
T0 = 2.5;

nq = p.getNumPositions();
nv = p.getNumVelocities();
nx = nq+nv;
nu = p.getNumInputs();

% ----- Periodicity Constraint ----- %
% Positions

% q_periodic = zeros(p.getNumPositions);
% q_periodic(2,2) = 1; %z 
% q_periodic(3,3) = 1; %pitch
% q_periodic(4:6,7:9) = eye(3); %leg joints w/symmetry
% q_periodic(7:9,4:6) = eye(3); %leg joints w/symmetry
%          
% R_periodic = [q_periodic, blkdiag(0, -eye(nq-1))];
%               
% periodic_constraint = LinearConstraint(zeros(nq,1),zeros(nq,1),R_periodic);
% periodic_constraint = periodic_constraint.setName('periodicity');

% ----- Initial Guess ----- %
q0 = [0; .875; 0; 0;0;0;0;0;0];
q1 = [-0.3; .875; 0; 0;0;0;0;0;0];
x0 = [q0;zeros(nv,1)];
x1 = [q1;zeros(nv,1)];

t_init = linspace(0,T0,N);
% traj_init.x = PPTrajectory(foh([0 T0/2 T0],[x0, xm, x1]));
traj_init.x = PPTrajectory(foh([0 T0],[x0, x1]));
traj_init.u = PPTrajectory(zoh(t_init,0.1*randn(nu,N)));
T_span = [.5 T0];

traj_opt = VariationalTrajectoryOptimization(p,N,T_span);
traj_opt = traj_opt.addRunningCost(@running_cost_fun);
traj_opt = traj_opt.addPositionConstraint(ConstantConstraint(q0),1);  
% traj_opt = traj_opt.addPositionConstraint(ConstantConstraint(qm),7);
traj_opt = traj_opt.addPositionConstraint(ConstantConstraint(q1),N);
traj_opt = traj_opt.addVelocityConstraint(ConstantConstraint([-0.25;zeros(nv-1,1)]),1);
[q_lb, q_ub] = getJointLimits(p);
q_ub(2) = q0(2)+0.001;
traj_opt = traj_opt.addPositionConstraint(BoundingBoxConstraint(q_lb,q_ub),2:N-1);

% traj_opt = traj_opt.addPositionConstraint(ConstantConstraint(qf(1:6)),N);
%traj_opt = traj_opt.addInputConstraint(ConstantConstraint(zeros(3,1)),1:N-1);
%traj_opt = traj_opt.addStateConstraint(ConstantConstraint(qm(1:6)),8);
% traj_opt = traj_opt.addStateConstraint(ConstantConstraint(qf(1:6)),N);
% traj_opt = traj_opt.addPositionConstraint(periodic_constraint,{[1 N]});

traj_opt = traj_opt.setSolverOptions('snopt','MajorIterationsLimit',10000);
traj_opt = traj_opt.setSolverOptions('snopt','MinorIterationsLimit',200000);
traj_opt = traj_opt.setSolverOptions('snopt','IterationsLimit',1000000);

traj_opt = traj_opt.addTrajectoryDisplayFunction(@displayTraj);

tic
[xtraj,utraj,ctraj,btraj,straj,z,F,info,infeasible_constraint_name] = traj_opt.solveTraj(t_init,traj_init);
toc

v.playback(xtraj,struct('slider',true));

function [f,df] = running_cost_fun(h,x,u)
  qx = [0.1*ones(nq,1); 10*ones(nv,1)];
  qx(1) = 0;
  qx(2) = 10;
  qx(3) = 1;
  Q = diag(qx);
  R = 100*eye(nu);
  g = (1/2)*(x-x1)'*Q*(x-x1) + (1/2)*u'*R*u;
  f = h*g;
  df = [g, h*(x-x1)'*Q, h*u'*R];
end


  function displayTraj(h,x,u)
  
    ts = [0;cumsum(h)];
    for i=1:length(ts)
      v.drawWrapper(ts(i),x(:,i));
%       pause(h(1)/50);
    end
   
end
end