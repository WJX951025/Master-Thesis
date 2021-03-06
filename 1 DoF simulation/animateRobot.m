function animateRobot(t, x)
% function animateRobot(t, x, figHandle)
    par.l = 4.2e-2;      % link's length [m]
    if (t == 0)
       N = size(x,2);
    else
       N = length(t);
    end
    colors = [0.7 0.5 0.2]; 
    figHandle = figure;
    axesHandle = axes('Parent', figHandle, 'Position', [0 0 1 1]);
    link = patch('Parent', axesHandle, 'FaceColor', colors);
    floor = line('Parent',axesHandle, 'Color',[0 0 0], 'LineWidth',0.1);
    shape = linkshape(-par.l);
    
    % animation
    for i = 1: N
        % get state
        q = x(i);
        q= -q;
        pos1 = move(R(q)*shape,[-par.l*sin(q);par.l*cos(q)]);
        set(link,'Xdata',pos1(1,:),'Ydata',pos1(2,:));
        
        axis([-0.05, 0.05,-0.05, 0.05]);
        floor_pos = [-0.05, 0.05; 0 0];
        set(floor,'Xdata',floor_pos(1,:),'Ydata',floor_pos(2,:));
        axis equal
        drawnow
        pause(0.1);
    end
    
function shape = linkshape(l)
    link_width = 0.005;
    n   = linspace(pi/2,-pi/2,20);
    top_arc    = (link_width/2)*[sin(n);cos(n)];
    bottom_arc = (link_width/2)*[-sin(n);-cos(n)];
    if l<0
        bottom_arc(2,:) = bottom_arc(2,:)+l;
    else
        top_arc(2,:) = top_arc(2,:)+l;
    end
    shape = [top_arc, bottom_arc];


function rot = R(phi)
    rot = [cos(phi)  -sin(phi);
           sin(phi)   cos(phi)];
   
function c = move(a, b)
    c(1,:) = a(1,:) + b(1);
    c(2,:) = a(2,:) + b(2);        