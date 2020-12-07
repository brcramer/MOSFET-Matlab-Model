%% Class: mosfet(name_val, k_val, Vt_val, lambda_val)
%   Purpose: store/calculate values associated with MOS transistor
%   Data Members: name, k (k' value), Id, Vov, gm, ro, WL (W/L value), W, L, VG, Vs, VD, Vt, lambda
%   Methods:
%       update
%           update calculates the values of ro, gm, W/L, W if necessary
%           values are set; if necessary values are not set, the values
%           that cannot be calculated are left blank (note that it does not
%           calculate Id or Vov from gm or ro, and the values for ro, gm,
%           W/L, W will be overwritten if they do not match Id or Vov
%           values
%
%   Example usage
%       kn = 100e-6;
%       Vtn = 0.2;
%       lambda = 0.1;
%       M1 = mosfet("M1", kn, Vtn, lambda);
%       M1.Vov = 0.2;
%       M1.Id = 100e-6;
%       M1.update; % ro, gm, W/L, W will all be calculated

classdef mosfet < handle
    properties
        name;
        k {mustBeNumeric};
        Id {mustBeNumeric};
        Vov {mustBeNumeric};
        gm {mustBeNumeric};
        ro {mustBeNumeric};
        WL {mustBeNumeric};
        W {mustBeNumeric};
        L {mustBeNumeric};
        Vg {mustBeNumeric};
        Vs {mustBeNumeric};
        Vd {mustBeNumeric};
        Vt {mustBeNumeric};
        lambda {mustBeNumeric};
    end
    methods
        %% constructor, set values of name, k', Vt, lambda
        function obj = mosfet(name_val, k_val, Vt_val, lambda_val)
            obj.name = name_val;
            obj.k = k_val;
            obj.Vt = Vt_val;
            obj.lambda = lambda_val;
        end
        %% update calculates the values of ro, gm, W/L, W if necessary values are set
        function obj = update(obj)            
            if ~isempty(obj.Id)
                obj.ro = 1/(obj.lambda*obj.Id); % can calculate ro with Id, lambda
                if isempty(obj.Vov)&&~isempty(obj.Id)&&~isempty(obj.WL)
                    obj.Vov = sqrt((2*obj.Id)/(obj.k*obj.WL));
                end
                if ~isempty(obj.Vov)
                    obj.gm = 2*obj.Id/obj.Vov; % can calculate gm with Id, Vov
                    obj.WL = 2*obj.Id/(obj.k*(obj.Vov^2)); % can calculate W/L with Id, Vov, k
                    if ~isempty(obj.L)
                        obj.W = obj.L*obj.WL; % can calculate W with W/L, L
                    end
                end
            end
        end
        %% calculate Vov given k', Vt, lambda, Vd, Vs, Id, W/L
        function obj = calc_Vov(obj)
            if ~isempty(obj.Vd)&&~isempty(obj.Vs)&&~isempty(obj.Id)&&~isempty(obj.WL)
                obj.Vov = obj.Id/(obj.k*(obj.WL)*(obj.Vd-obj.Vs)) + (obj.Vd-obj.Vs)/2;
            end
        end
    end
end