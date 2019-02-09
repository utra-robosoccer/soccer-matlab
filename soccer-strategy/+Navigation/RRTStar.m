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
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %             Constructor              %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function obj = RRTStar(occupancymap, connectiondistance, numnodes)
            % Create an RRTStar object, initialize with passed parameters.
            obj.occupancymap = occupancymap;
            obj.connectiondistance = connectiondistance;
            obj.numnodes = numnodes;
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %              Primitives              %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Sample a random variable, independent, and identically distributed
        % from the entire occupancymap
        function v = sample(obj)
            dims = size(obj.occupancymap);
            
            % Obtain random point from occupancy map.
            x_rand = Navigation.rand() * dims(1,2);
            y_rand = Navigation.rand() * dims(1,1);
            
            % Return sample.
            v = [x_rand y_rand];
        end
        
        % Sample a random vaiable, independent, and identically distributed
        % from the free space in occupancymap
        function v = freesample(obj)
            dims = size(obj.occupancymap);
            
            % Try initial sample of occupancymap.
            x_rand = Navigation.rand() * dims(1,2);
            y_rand = Navigation.rand() * dims(1,1);
            
            % Continue computing a sample until it is not occupied.
            while(obj.occupancymap(x_rand, y_rand) ~= 0)
                x_rand = Navigation.rand() * dims(1,2);
                y_rand = Navigation.rand() * dims(1,1);
            end
            
            % Return free sample.
            v = [x_rand y_rand];
        end
        
        % Use Euclidean distance to find the closest neighbor to point x
        % already in the tree
        function v = nearestneighbor(obj, x)
            num_v = obj.tree.numnodes();
            min_dist = Inf;
            for i = 1:num_v
                node_v = findnode(obj.tree, i);
                dist = (node_v(1,1) - x(1,1))^2 + (node_v(1,2) - x(1,2))^2;
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
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %              Composites              %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function computetree(obj)
            obj.tree = digraph(start);
        end
        
        function computepath(obj)
            
        end
    end
end