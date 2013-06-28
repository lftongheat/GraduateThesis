% Figure11: Phase Diagrams of PFP for the Problem Suite USE/Uniform.
% Shaded attribute is the proportion of successful executions
% among total trials, for:
% (a) k-step solution property;
% (b) correct term selection property;
% (c) sign agreement property.
%
% Data dependencies:
%   PFPKNPlane-USE-Uniform-D200.mat (Created by GenDataKNPFP.m)
%

GenFigKNPlane('USE','Uniform',200,0.25,'PFP');
GenFigSignAgreement('USE','Uniform',200,0.25,'PFP');
GenFigCorrectTerm('USE','Uniform',200,0.25,'PFP');
