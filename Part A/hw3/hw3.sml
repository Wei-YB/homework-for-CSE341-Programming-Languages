(* Coursera Programming Languages, Homework 3, Provided Code *)

exception NoAnswer

datatype pattern = Wildcard
		 | Variable of string
		 | UnitP
		 | ConstP of int
		 | TupleP of pattern list
		 | ConstructorP of string * pattern

datatype valu = Const of int
	      | Unit
	      | Tuple of valu list
	      | Constructor of string * valu

fun g f1 f2 p =
    let 
	val r = g f1 f2 
    in
	case p of
	    Wildcard          => f1 ()
	  | Variable x        => f2 x
	  | TupleP ps         => List.foldl (fn (p,i) => (r p) + i) 0 ps
	  | ConstructorP(_,p) => r p
	  | _                 => 0
    end

(**** for the challenge problem only ****)

datatype typ = Anything
	     | UnitT
	     | IntT
	     | TupleT of typ list
	     | Datatype of string

(**** you can put all your code here ****)

(* 1. string list -> string list *)
val only_capitals = List.filter (fn str => Char.isUpper(String.sub(str, 0)))

(* 2. string list -> string *)
val longest_string1 = 
    List.foldl (fn (l, r) => if String.size l > String.size r then l else r) ""

(* 3. string list -> string *)
val longest_string2 = 
    List.foldl (fn (l, r) => if String.size l >= String.size r then l else r) ""

(* 4.1. (int * int -> bool) -> string list -> string *)
fun longest_string_helper func string_list = 
    List.foldl (fn(l, r) => if func(String.size l, String.size r) then l else r) 
                "" string_list

(* 4.2. string list -> string *)
val longest_string3 = longest_string_helper (fn(lhs, rhs) => lhs > rhs)

(* 4.3. string list -> string *)
val longest_string4 = longest_string_helper (fn(lhs, rhs) => lhs >= rhs)

(* 5. string list -> string *)
val longest_capitalized = longest_string1 o only_capitals

(* 6. string -> string *)
val rev_string = String.implode o List.rev o String.explode

(* 7. ('a -> 'b option) -> 'a list -> 'b *)
fun first_answer func [] = raise NoAnswer
  | first_answer func (head::tail) = case func head of 
                                         SOME value => value
                                       | _ => first_answer func tail

(* 8. ('a -> 'b list option) -> 'a list -> 'b list option *)
fun all_answers func lists = 
    let fun helper lists acc = 
        case lists of 
            [] => acc
          | head::tail => (first_answer func [head]) @ helper tail acc
    in  SOME(helper lists []) 
        handle NoAnswer => NONE
    end

(* 9.a. pattern -> int *)
val count_wildcards =  g (fn _ => 1) (fn _ => 0)

(* 9.b. pattern -> int *)
val count_wild_and_variable_lengths = g (fn _ => 1) (fn str => String.size str)

(* 9.c. string * pattern -> int *)
fun count_some_var (str,p) =
    g (fn _ => 0) (fn s => if s = str then 1 else 0) p

(* 10. pattern -> bool *)
fun check_pat p = 
    let 
        fun to_string_list p = 
            case p of   
                Variable str => [str]
              | TupleP ptn_tuple => List.foldl(fn (ptn,acc) => to_string_list ptn @ acc) [] ptn_tuple
              | ConstructorP (_,ptn) => to_string_list ptn 
              | _ => []
        fun check_exist string_list = 
            case string_list of
                [] => false
              | head :: tail => List.exists(fn str => head = str) tail orelse check_exist tail
    in
        not(check_exist(to_string_list p))
    end

(* 11. valu * pattern -> (string * valu) list option *)
fun match (v, p) = 
    case (v, p) of
        (_, Wildcard) => SOME []
      | (v, Variable s) => SOME [(s,v)]
      | (Unit, UnitP) => SOME []
      | (Const cv, ConstP cp) => if   cv = cp
                                 then SOME []
                                 else NONE
      | (Constructor(s1, v), ConstructorP(s2, p)) => if   s1 = s2
                                                     then match(v, p)
                                                     else NONE 
      | (Tuple val_ls, TupleP ptn_ls) => if   List.length val_ls = List.length ptn_ls
                                         then all_answers match (ListPair.zip(val_ls, ptn_ls))
                                         else NONE
      | _ => NONE

(* 12. valu -> pattern list -> (string * valu) list *)
fun first_match v ps =
    SOME (first_answer (fn x => match(v, x)) ps)
    handle NoAnswer => NONE

(* Challenge. ((string * string * tpy) list) * (pattern list) -> typ option*)