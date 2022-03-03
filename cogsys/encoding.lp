% ### Facts

module(mandatory, 1, (bm1,9;bm2,9;bm3,9)).
module_tcp(mandatory, 1, 27).

module(optional, 1, (am11,6;am12,6;am21,6;am22,6;am31,6;am32,6;fm1,6;fm2,6;fm3,6)).
module(bridge, 1, (fm1,6;fm2,6;fm3,6)).
module_tcp(optional, 1, 24).

module(optional, 2, (pm1,12;pm2,12;pm3,12)).
module_tcp(optional, 2, 24).

module(mandatory, 2, (im1,15)).
module_tcp(mandatory, 2, 15).

module(mandatory, 3, (thesis,30)).
module_tcp(mandatory, 3, 30).

% ### Rules 

% Generate all combinations
{choose(M):module(_,_,M)}.

% For each mandatory module, choose exactly 1
:- module(mandatory, _, M),{choose(M)}!=1.

% For each optional module, either choose it (1) or don't (0)
:- module(optional, 1, M),2{choose(M)}.

% Don't choose 3 (or more) bridge modules
:- 3{choose(M):module(bridge, 1, M)}.

% The total credit points for each module group must not be exceeded
:- Tcp != #sum{P,M: choose((M,P)), module(N,G,(M,P))}, module_tcp(N,G,Tcp).


#show choose/1.
