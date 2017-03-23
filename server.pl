%%----- CHR Component

:- use_module(library(chr)).
:- chr_constraint gcd/1, get_gcd/1.

% the classical CHR example for greatest common divisor
gcd(0) <=> true.
gcd(N) \ gcd(M) <=> M >= N | L is M-N, gcd(L).

% constraint to get the current gcd/1 value
gcd(N) \ get_gcd(M) <=> M = N.

% Example call:
%   gcd(12), gcd(8), gcd(16), get_gcd(R).


%%----- Server Component

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_parameters)).
:- http_handler(root(.), handle,[]).

server(Port) :-
   create_chr_thread,
   http_server(http_dispatch, [port(Port)]).

handle(Request) :-
   http_parameters(Request, [ gcd(In, [integer, optional(false)]) ]),
   polling_par(gcd(In), Res),
   format('Content-type: text/html~n~n'),
   format(Res).


%%----- Thread Component

create_chr_thread :-
   message_queue_create(_, [ alias(sub) ]),
   message_queue_create(_, [ alias(par) ]),
   thread_create(polling_sub, _, [ alias(chr) ]).

polling_sub :-
   % listen for new message on `sub` queue
   thread_get_message(sub, gcd(In)),
   % add the given constraints
   gcd(In),
   % get the calculated gcd
   get_gcd(Gcd),
   % send it back to the `par` message queue
   thread_send_message(par, Gcd),
   % repeat
   polling_sub.

polling_par(Goal, Res) :-
   thread_send_message(sub, Goal),
   thread_get_message(par, Res).
