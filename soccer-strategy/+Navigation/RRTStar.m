% Implementation of the Optimized Rapidly-exploring Random Trees as
% described by:
%
% 'Karaman, S. and Frazzoli, E. (2011). Sampling-based algorithms for 
%  optimal motion planning. The International Journal of Robotics Research,
%  30(7), pp.846-894.'

classdef RRTStar
    properties
        occupancymap; % Map.occupancymap 
        numnodes; % Max number of nodes in the tree
        connectiondistance; % Max stepsize between nodes in a tree 
        start; % Initial position 
        goal; % Target position
        tree; % Graph structure containing vertices and edges of tree
    end
    
    methods
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             Constructor                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function obj = RRTStar(occupancymap, connectiondistance, numnodes)
            % Create an RRTStar object, initialize with passed parameters.
            obj.occupancymap = occupancymap;
            obj.connectiondistance = connectiondistance;
            obj.numnodes = numnodes;
            
            % Default: set start to (0,0)
            obj.start = {0 0};
        end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Primitives                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
        % Sample a random variable, independent, and identically distributed
        % from the entire occupancymap
        function v = sample(obj)
            % Range of grid values
            x_range = obj.occupancymap.GridSize(1);
            y_range = obj.occupancymap.GridSize(2);
            
            % Obtain random point from occupancy map.
            x_rand = Navigation.rand() * x_range;
            y_rand = Navigation.rand() * y_range;
            
            % Round values to nearest integer
            x_rand = round(x_rand);
            y_rand = round(y_rand);
            
            % Scale down to occupancy map size 
            x_rand = x_rand/obj.occupancymap.Resolution;
            y_rand = y_rand/obj.occupancymap.Resolution;
            
            % Offset to center of the grid
            x_rand = x_rand + obj.occupancymap.GridLocationInWorld(1);
            y_rand = y_rand + obj.occupancymap.GridLocationInWorld(2);
            
            % Return sample.
            v = [x_rand y_rand];
        end
        
        % Sample a random vaiable, independent, and identically distributed
        % from the free space in occupancymap
        function v = freesample(obj)
            % Obtain a sample
            sample = obj.sample();
            
            % Continue computing a sample until it is not occupied.
            while(obj.occupancymap(sample(1), sample(2)) ~= 0)
                sample = obj.sample();
            end
            
            % Return free sample.
            v = sample;
        end
        
        % Use Euclidean distance to find the closest neighbor to point x
        % already in the tree
        function v = nearestneighbor(obj, x)
            num_v = obj.tree.numnodes();
            min_dist = Inf;
            
            % Loop over all nodes in the tree
            for i = 1:num_v
                node_v = findnode(obj.tree, i);
                %  Compute Euclidean Distance
                dist = (node_v(1,1) - x(1,1))^2 + (node_v(1,2) - x(1,2))^2; %% THIS NEEDS TO BE FIXED, HOW ARE WE GOING TO STUDY COORDINATES FOR THESE NODES
                if(dist < min_dist) 
                    min_dist = dist;
                    v = node_v;
                end
            end
        end
        
        % Returns the vertices in the tree that are contained in a circle
        % of radius r centered at x, a point in the occupancymap
        function v = near(obj, x, r)
            % I don't believe below does what I think it does.
            % v = nearest(obj.tree, x, r);
        end
        
        % Returns a point v in the occupancymap such that v is closer to y
        % than x is. v minimizes distance to y, but also maintains: || v -
        % y || <= connectiondistance
        function v = steer(obj, x, y)
            
        end
        
        % Boolean function, returns True if line segment between x and y
        % lies entirely in free space (i.e no obstacles), otherwise returns
        % False
        function tf = collisionfree(obj, x, y)
            
        end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                      Public Composites Methods                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function obj = explore(obj, goal)
            % Initialize the Tree
            obj.tree = digraph();
            obj.goal = goal;
            
            % Add the start position
        end
        
        function computepath(obj)
            
        end
    end % Methods
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                      Private Primitive Methods                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    methods (Access='protected')
        
    end % Primitive Measures
end