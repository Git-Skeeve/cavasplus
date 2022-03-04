% ### Facts
% ## Facts and Fact-Values in ASP 
%module(mandatory, 1, (bm1,9;bm2,9;bm3,9)).
%module_tcp(mandatory, 1, 27).

%module(optional, 1, (am11,6;am12,6;am21,6;am22,6;am31,6;am32,6;fm1,6;fm2,6;fm3,6)).
%module(bridge, 1, (fm1,6;fm2,6;fm3,6)).
%module_tcp(optional, 1, 24).

%module(optional, 2, (pm1,12;pm2,12;pm3,12)).
%module_tcp(optional, 2, 24).

%module(mandatory, 2, (im1,15)).
%module_tcp(mandatory, 2, 15).

%module(mandatory, 3, (thesis,30)).
%module_tcp(mandatory, 3, 30).

% ## Facts from SemaLogic - divided optional facts and their attribute 
% Is it better to declare the attribute and this symbols in one line per symbol ? like symbol(bm1,(ects,9)). 
% And how to declare more than one attribute ? symbol(bm1,(ects,9)(time, 30)). 	
{symbol(bm1;bm2;bm3;am11;am12;am21;am22;am31;am32;fm1;fm2;fm3;pm1;pm2;pm3;im1;thesis)}.

% ## Fact-Values e.g. as key-value from SemaLogic - because we dont know which attributes exist
% It is possible to wirte it in a shorter way ?
attribute(bm1, ects, 9) :- symbol(bm1). 
attribute(bm2, ects, 9) :- symbol(bm2).
attribute(bm3, ects, 9) :- symbol(bm3).
attribute(am11, ects, 6) :- symbol(am11). 
attribute(am12, ects, 6) :- symbol(am12).
attribute(am21, ects, 6) :- symbol(am21).
attribute(am22, ects, 6) :- symbol(am22).
attribute(am31, ects, 6) :- symbol(am31).
attribute(am32, ects, 6) :- symbol(am32).
attribute(fm1, ects, 6) :- symbol(fm1). 
attribute(fm2, ects, 6) :- symbol(fm2).
attribute(fm3, ects, 6) :- symbol(fm3).
attribute(pm1, ects, 12) :- symbol(pm1). 
attribute(pm2, ects, 12) :- symbol(pm2).
attribute(pm3, ects, 12) :- symbol(pm3).
attribute(im1, ects, 15) :- symbol(im1).
attribute(thesis, ects, 30) :- symbol(thesis).


% ## grouping facts for use in functions - is it possible, to do this shorter ?
mgroup(optional_modules_group, am11).
mgroup(optional_modules_group, am12).
mgroup(optional_modules_group, am21).
mgroup(optional_modules_group, am22).
mgroup(optional_modules_group, am31).
mgroup(optional_modules_group, am32).
mgroup(optional_modules_group, fm1).
mgroup(optional_modules_group, fm2).
mgroup(optional_modules_group, fm3).

module_function(optional_modules_group, ects, 24).


% ### Rules 

%% Generate all combinations
%{choose(M):module(_,_,M)}.

%% For each mandatory module, choose exactly 1
%:- module(mandatory, _, M),{choose(M)}!=1.

%% For each optional module, either choose it (1) or don't (0)
%:- module(optional, 1, M),2{choose(M)}.

%% Don't choose 3 (or more) bridge modules
%:- 3{choose(M):module(bridge, 1, M)}.

%% The total credit points for each module group must not be exceeded
%:- Tcp != #sum{P,M: choose((M,P)), module(N,G,(M,P))}, module_tcp(N,G,Tcp).

% ## Rules of SemaLogic - we don't want to create all combination - we only want to create the combinations, which are needed and fullfill the sum-rule root
% e.g. modules could be mandatory if an explicit decision is true, so we are not able to chose them before as a fact - so all facts are optional per default
% and therefore i use the short way and declare all facts as optional
% so we give the rule a name and cascade them on the basis of possible facts

% Knowledge-Rules of SemaLogic
mandatory_modules :- symbol(bm1);symbol(bm2);symbol(bm3).
work_methods :- symbol(im1).
project_seminars :- 2{symbol(pm1); symbol(pm2); symbol(pm3)}2.
optional_modules :- {symbol(am11); symbol(am12); symbol(am21); symbol(am22); symbol(am31); symbol(am32); symbol(fm1); symbol(fm2); symbol(fm3)}.
bridge_modules :- 0{symbol(fm1); symbol(fm2); symbol(fm3)}2.

root :- mandatory_modules, work_methods,project_seminars, optional_modules, symbol(thesis) ,bridge_modules.

% Functions to reduce with sum - but doesn't work - please have a look !!!
:- tcp != #sum{P,M: mgroup(G,M), attribute(M,A,P)}, module_function(G,A,TCP).


% Kick-out all sets that doesn't fullfill root-rule
:- not root.

%#show choose/1.
