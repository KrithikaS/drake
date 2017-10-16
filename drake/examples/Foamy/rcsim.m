%--- Simulation Parameters ---%
x = [0 0 0 0 -1/sqrt(2) 1/sqrt(2) 0 0 0 0 0 0 0]'; %Initial State (pointing East)
u = [0 0 0 0]'; %Initial controls

plant = FoamyPlant();
vis = FoamyVisualizer(plant);
vis.draw(0,x);

%Setup RC Controller
js = vrjoystick(1);

loop_timer = tic;
while true
    
    %Read control inputs from RC controller
    rc = read(js);
    u = [0.5*(1+rc(2)); -rc(3); -rc(4); -rc(1)];
    
    %Simulate forward one timestep
    dt = toc(loop_timer);
    [x, xdot] = foamy_midpoint(x,u,dt);
    loop_timer = tic;
    
    vis.draw(0,x);
end

