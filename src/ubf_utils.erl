%%% The MIT License
%%%
%%% Copyright (C) 2011-2013 by Joseph Wayne Norton <norton@alum.mit.edu>
%%% Copyright (C) 2002 by Joe Armstrong
%%%
%%% Permission is hereby granted, free of charge, to any person obtaining a copy
%%% of this software and associated documentation files (the "Software"), to deal
%%% in the Software without restriction, including without limitation the rights
%%% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%%% copies of the Software, and to permit persons to whom the Software is
%%% furnished to do so, subject to the following conditions:
%%%
%%% The above copyright notice and this permission notice shall be included in
%%% all copies or substantial portions of the Software.
%%%
%%% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%%% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%%% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%%% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%%% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%%% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
%%% THE SOFTWARE.

%%% @doc Utilities for UBF
%%%-------------------------------------------------------------------

-module(ubf_utils).
-include("ubf.hrl").
-include("ubf_impl.hrl").

-export([ubf_contract/2]).

ubf_contract(Mod, FileName) ->
    Contract = ubf_contract1(Mod),
    file:write_file(FileName, Contract).

ubf_contract1(Contract) when is_record(Contract,contract) ->
    ubf_contract2(Contract);
ubf_contract1(Mod) when is_list(Mod) ->
    ubf_contract1(list_to_atom(Mod));
ubf_contract1(Mod) ->
    Contract = #contract{name=Mod:contract_name()
                         , vsn=Mod:contract_vsn()
                         , types=Mod:contract_types()
                         , leaftypenames=Mod:contract_leaftypes()
                         , importtypenames=Mod:contract_importtypenames()
                         , records=Mod:contract_records()
                         , transitions=Mod:contract_transitions()
                         , anystate=Mod:contract_anystate()
                        },
    ubf_contract1(Contract).

ubf_contract2(C) ->
    X0 = [""
          , "-ifndef('" ++ C#contract.name ++ ".hrl" ++ "')."
          , "-define('" ++ C#contract.name ++ ".hrl" ++ "', true)."
          , ""
          , ""
          , "%%%"
          , "%%% Auto-generated by ubf_utils:ubf_contract()"
          , "%%% Do not edit manually!"
          , "%%%"
          , ""
          , ""
         ],
    X1 = ["%% --------------------"
          , "%% pre defined types"
          , "%%   - left hand-side is UBF"
          , "%%   - right hand-side is Erlang-like"
          , "%%   - A() means replace with \"A type reference\""
          , "%%   - A() | B() means \"A() or B()\""
          , "%%   - A()? means \"optional A()\""
          , "%%   - A(Attrs) means \"A() subject to the comma-delimited type attributes"
          , "%%"
          , "%%"
          , "%% true\n%%\t\ttrue"
          , "%% false\n%%\t\tfalse"
          , "%% undefined\n%%\t\tundefined"
          , "%%"
          , "%% any()\n%%\t\tany"
          , "%% any()?\n%%\t\tany | undefined"
          , "%%"
          , "%% none()\n%%\t\t /* no result is returned */"
          , "%% none()?\n%%\t\t /* no result is returned */ | undefined"
          , "%%"
          , "%% atom()\n%%\t\tatom"
          , "%% atom()?\n%%\t\tatom | undefined"
          , "%%"
          , "%% binary()\n%%\t\tbinary"
          , "%% binary()?\n%%\t\tbinary | undefined"
          , "%%"
          , "%% float()\n%%\t\tfloat"
          , "%% float()?\n%%\t\tfloat | undefined"
          , "%%"
          , "%% integer()\n%%\t\tinteger"
          , "%% integer()?\n%%\t\tinteger | undefined"
          , "%%"
          , "%% list()\n%%\t\tlist"
          , "%% list()?\n%%\t\tlist | undefined"
          , "%%"
          , "%% tuple()\n%%\t\ttuple"
          , "%% tuple()?\n%%\t\ttuple | undefined"
          , "%%"
          , "%% --------------------"
          , "%% type attributes"
          , "%%"
          , "%%"
          , "%% any(AnyAttrs)\n%%\t\tany"
          , "%% any(AnyAttrs)?\n%%\t\tany | undefined"
          , "%%"
          , "%% atom(AtomAttrs)\n%%\t\tatom"
          , "%% atom(AtomAttrs)?\n%%\t\tatom | undefined"
          , "%%"
          , "%% binary(BinaryAttrs)\n%%\t\tbinary"
          , "%% binary(BinaryAttrs)?\n%%\t\tbinary | undefined"
          , "%%"
          , "%% list(ListAttrs)\n%%\t\tlist"
          , "%% list(ListAttrs)?\n%%\t\tlist | undefined"
          , "%%"
          , "%% tuple(TupleAttrs)\n%%\t\ttuple"
          , "%% tuple(TupleAttrs)?\n%%\t\ttuple | undefined"
          , "%%"
          , "%%"
          , "%% AnyAttrs"
          , "%% \t nonempty"
          , "%% \t nonundefined"
          , "%%"
          , "%% AtomAttrs"
          , "%% \t ascii | asciiprintable"
          , "%% \t nonempty"
          , "%% \t nonundefined"
          , "%%"
          , "%% BinaryAttrs"
          , "%% \t ascii | asciiprintable"
          , "%% \t nonempty"
          , "%%"
          , "%% ListAttrs"
          , "%% \t nonempty"
          , "%%"
          , "%% TupleAttrs"
          , "%% \t nonempty"
          , "%%"
          , "%% --------------------"
          , "%% user-defined attributes"
          , "%%"
          , "%%"
          , "%% {type1() ...}\n%%\t\ttuple"
          , "%% {type1() ...}?\n%%\t\ttuple | undefined"
          , "%%"
          , "%% record()\n%%\t\trecord"
          , "%% record()?\n%%\t\trecord | undefined"
          , "%%"
          , "%% [type()]\n%%\t\tlist of type()"
          , "%% [type()]?\n%%\t\tlist of length 0 or length 1 of type()"
          , "%% [type()]+\n%%\t\tlist of length greater than 0 of type()"
          , "%% [type()]{M}\n%%\t\tlist of length M of type()"
          , "%% [type()]{M,}\n%%\t\tlist of minimum length M of type()"
          , "%% [type()]{,M}\n%%\t\tlist of maximum length M of type()"
          , "%% [type()]{M,N}\n%%\t\tlist of minimum length M and maximum length N of type()"
          , "%%"
          , "%% integer()..integer()\n%%\t\tinteger"
          , "%% ..integer()\n%%\t\tinteger"
          , "%% integer()..\n%%\t\tinteger"
          , ""
          , ""
         ],
    X2 = [""
          , "%% --------------------"
          , "%% records"
          , "%%"
          , ""
          , ""
          , [
             ["%% #'", atom_to_list(Name), "'{}", "\n%%\t"
              , join([ case Default of
                           [] ->
                               io_lib:format("~p::~s", [Field, typeref(ubf,Type,C)]);
                           [D] ->
                               io_lib:format("~p=~p::~s", [Field, D, typeref(ubf,Type,C)])
                       end || {Field,Default,Type} <- FDTs ], ", ")
              , "\n\n-ifndef('$ubf_record_", atom_to_list(Name), "').\n"
              , "-define('$ubf_record_", atom_to_list(Name), "', true).\n"
              , "-record('", atom_to_list(Name), "', {\n\t"
              , join([ case Default of
                           [] ->
                               io_lib:format("~p::~s", [Field, typeref(erlang,Type,C)]);
                           [D] ->
                               io_lib:format("~p=~p::~s", [Field, D, typeref(erlang,Type,C)])
                       end || {Field,Default,Type} <- FDTs ], ", ")
              , "}).\n"
              , "-endif.\n\n"
             ]
             || {{Name,_Size},FDTs} <- C#contract.records ]
          , ""
          , ""
         ],
    X3 = [""
          , "%% --------------------"
          , "%% leaf types"
          , "%%"
          , ""
          , ""
          , [ ["%% ", atom_to_list(Name), "()", "\n%%\t", type(ubf,Name,C)
               , "\n\n-ifndef('$ubf_type_", atom_to_list(Name), "').\n"
               , "-define('$ubf_type_", atom_to_list(Name), "', true).\n"
               , "-type '", atom_to_list(Name), "'()", " :: ", "\n\t", type(erlang,Name,C)
               , ".\n"
               , "-endif.\n\n"
              ]
              || Name <- C#contract.leaftypenames,
                 not lists:member(Name, contract_parser:builtin_types(erlang)) ]
          , ""
          , ""
         ],

    X4 = [""
          , "%% --------------------"
          , "%% UBF-RPC anystate"
          , "%%"
          , ""
         ],
    X5 = [ begin
               {Input, InputType, _} = lookup_type(Input,true,C),
               Params = typeref(ubf,InputType,C),
               Result =
                   case lookup_type(Output,false,C) of
                       {Output, OutputType, _} ->
                           typeref(ubf,OutputType,C);
                       undefined ->
                           io_lib:format("~p()", [Output])
                   end,
               join([
                     ""
                     , "%% ----------"
                     , io_lib:format("%% ~s", [Input])
                     , "%%"
                     , io_lib:format("%%~s =>", [Params])
                     , io_lib:format("%%   ~s;", [Result])
                    ], "\n")
           end
           || {{prim,1,1,Input}, {prim,1,1,Output}} <- C#contract.anystate ],
    X6 = [""
          , ""
          , ""
          , "-endif. % '" ++ C#contract.name ++ ".hrl" ++ "'"
          , ""
          , ""
         ],
    lists:flatten([ join(L, "\n") || L <- [X0, X1, X2, X3, X4, X5, X6] ]).

type(Style,Name,C) ->
    {Name,Type,_} = lookup_type(Name,C),
    io_lib:format("~s", [typeref(Style,Type,C)]).

lookup_type(Name,C) ->
    lookup_type(Name,true,C).

lookup_type(Name,Strict,C) ->
    case [ Type || {N,_,_}=Type <- C#contract.types, N =:= Name ] of
        [{Name, _Type, _Tag}=X] ->
            X;
        [] ->
            if Strict ->
                    exit({undefined_ubf_type,Name});
               true ->
                    undefined
            end
    end.

%% alt
typeref(Style,{alt,Type1,Type2},C) ->
    io_lib:format("~s | ~s", [typeref(Style,Type1,C), typeref(Style,Type2,C)]);
%% prim
typeref(Style,{prim,Min,Max,Tag},C) ->
    case Tag of
        {predef,_} ->
            PrimTag = typeref(Style,Tag,C),
            case {Min,Max} of
                {1,1} ->
                    io_lib:format("~s", [PrimTag]);
                {0,1} ->
                    if Style =:= ubf ->
                            io_lib:format("~s?", [PrimTag]);
                       true ->
                            io_lib:format("~s | undefined", [PrimTag])
                    end;
                {0,0} ->
                    if Style =:= ubf ->
                            io_lib:format("~p{0}", [PrimTag]);
                       true ->
                            io_lib:format("undefined", [])
                    end
            end;
        _ ->
            case {Min,Max} of
                {1,1} ->
                    io_lib:format("~p()", [Tag]);
                {0,1} ->
                    if Style =:= ubf ->
                            io_lib:format("~p()?", [Tag]);
                       true ->
                            io_lib:format("~p() | undefined", [Tag])
                    end;
                {0,0} ->
                    if Style =:= ubf ->
                            io_lib:format("~p{0}", [Tag]);
                       true ->
                            io_lib:format("undefined", [])
                    end
            end
    end;
%% tuple
typeref(Style,{tuple,Elements0},C) ->
    Elements = tuple_to_list(Elements0),
    io_lib:format("{ ~s }", [join([typeref(Style,Element,C) || Element <- Elements], ", ")]);
%% record
typeref(Style,{Tag,Name,Fields,_Defaults,Elements0},C)
  when Tag=:=record;
       Tag=:=record_ext ->
    Elements = tl(tuple_to_list(Elements0)),
    Definition = join([ io_lib:format("~p::~s", [Field, typeref(Style,Element,C)])
                        || {Field,Element} <- lists:zip(Fields,Elements) ], ", "),
    io_lib:format("#~s{ ~s }", [Name, Definition]);
%% list
typeref(ubf=Style,{list,0,infinity,Element},C) ->
    io_lib:format("[~s]", [typeref(Style,Element,C)]);
typeref(ubf=Style,{list,0,1,Element},C) ->
    io_lib:format("[~s]?", [typeref(Style,Element,C)]);
typeref(ubf=Style,{list,1,infinity,Element},C) ->
    io_lib:format("[~s]+", [typeref(Style,Element,C)]);
typeref(ubf=Style,{list,M,M,Element},C) ->
    io_lib:format("[~s]{~p}", [typeref(Style,Element,C), M]);
typeref(ubf=Style,{list,M,infinity,Element},C) ->
    io_lib:format("[~s]{~p,}", [typeref(Style,Element,C), M]);
typeref(ubf=Style,{list,M,N,Element},C) ->
    io_lib:format("[~s]{~p,~p}", [typeref(Style,Element,C), M, N]);
typeref(Style,{list,_M,_N,Element},C) ->
    io_lib:format("[~s]", [typeref(Style,Element,C)]);
%% range
typeref(_Style,{range,infinity,Hi},_C) ->
    io_lib:format("..~p", [Hi]);
typeref(_Style,{range,Lo,infinity},_C) ->
    io_lib:format("~p..", [Lo]);
typeref(_Style,{range,Lo,Hi},_C) ->
    io_lib:format("~p..~p", [Lo, Hi]);
%% atom
typeref(_Style,{atom,Value},_C) ->
    io_lib:format("~p", [Value]);
%% binary
typeref(_Style,{binary,Value},_C) ->
    io_lib:format("~p", [Value]);
%% float
typeref(_Style,{float,Value},_C) ->
    io_lib:format("~p", [Value]);
%% integer
typeref(_Style,{integer,Value},_C) ->
    io_lib:format("~p", [Value]);
%% string
typeref(_Style,{string,Value},_C) ->
    io_lib:format("~p", [Value]);
%% predef
typeref(_Style,{predef,any},_C) ->
    "any()";
typeref(_Style,{predef,none},_C) ->
    "none()";
typeref(_Style,{predef,atom},_C) ->
    "atom()";
typeref(_Style,{predef,binary},_C) ->
    "binary()";
typeref(_Style,{predef,float},_C) ->
    "float()";
typeref(_Style,{predef,integer},_C) ->
    "integer()";
typeref(_Style,{predef,list},_C) ->
    "list()";
typeref(_Style,{predef,tuple},_C) ->
    "tuple()";
%% predef with attributes
typeref(_Style,{predef,{any,Attrs}},_C) ->
    io_lib:format("any(~s)", [join([ atom_to_list(Attr) || Attr <- Attrs ], ",")]);
typeref(_Style,{predef,{atom,Attrs}},_C) ->
    io_lib:format("atom(~s)", [join([ atom_to_list(Attr) || Attr <- Attrs ], ",")]);
typeref(_Style,{predef,{binary,Attrs}},_C) ->
    io_lib:format("binary(~s)", [join([ atom_to_list(Attr) || Attr <- Attrs ], ",")]);
typeref(_Style,{predef,{list,Attrs}},_C) ->
    io_lib:format("list(~s)", [join([ atom_to_list(Attr) || Attr <- Attrs ], ",")]);
typeref(_Style,{predef,{tuple,Attrs}},_C) ->
    io_lib:format("tuple(~s)", [join([ atom_to_list(Attr) || Attr <- Attrs ], ",")]);
%% abnf
typeref(ubf,{abnf_alt,_}=X,_C) ->
    io_lib:format("~p", [X]);
typeref(ubf,{abnf_seq,_}=X,_C) ->
    io_lib:format("~p", [X]);
typeref(ubf,{abnf_repeat,Min,Max,Type},C) ->
    io_lib:format("{abnf_repeat,~s,~s,~s}",
                  [typeref(ubf,Min,C), typeref(ubf,Max,C), typeref(ubf,Type,C)]);
typeref(ubf,{abnf_byte_range,_,_}=X,_C) ->
    io_lib:format("~p", [X]);
typeref(ubf,{abnf_byte_alt,_}=X,_C) ->
    io_lib:format("~p", [X]);
typeref(ubf,{abnf_byte_seq,_}=X,_C) ->
    io_lib:format("~p", [X]);
typeref(ubf,{abnf_byte_val,_}=X,_C) ->
    io_lib:format("~p", [X]);
typeref(_Style,{abnf_alt,_},_C) ->
    "binary()";
typeref(_Style,{abnf_seq,_},_C) ->
    "binary()";
typeref(_Style,{abnf_repeat,_,_,_},_C) ->
    "binary()";
typeref(_Style,{abnf_byte_range,_,_},_C) ->
    "binary()";
typeref(_Style,{abnf_byte_alt,_},_C) ->
    "binary()";
typeref(_Style,{abnf_byte_seq,_},_C) ->
    "binary()";
typeref(_Style,{abnf_byte_val,_},_C) ->
    "binary()";
%% otherwise
typeref(_Style,Type, _C) ->
    io_lib:format("~p()", [Type]).

join(L, Sep) ->
    lists:flatten(join2(L, Sep)).

join2([A, B|Rest], Sep) ->
    [A, Sep|join2([B|Rest], Sep)];
join2(L, _Sep) ->
    L.
