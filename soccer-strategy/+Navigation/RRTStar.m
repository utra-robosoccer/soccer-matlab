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
        function obj = RRTStar()
            
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %              Primitives              %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Sample a random vaiable, independent, and identically distributed
        % from the entire occupancymap
        function v = sample(obj)
        
        end
        
        % Sample a random vaiable, independent, and identically distributed
        % from the free space in occupancymap
        function v = freesample(obj)
        
        end
        
        % Use Euclidean distance to find the closest neighbor to point x
        % already in the tree
        function v = nearestneighbor(obj, x)
            
        end
        
        % Returns the vertices in the tree that are contained in a circle
        % of radius r centered at x, a point in the occupancymap
        function v = near(obj, x, r)
            
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
    end
end