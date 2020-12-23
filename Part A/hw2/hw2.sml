(* Dan Grossman, Coursera PL, HW2 Provided Code *)

(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2

(* put your solutions for problem 1 here *)
fun all_except_option(str, lst) = 
    case lst of 
        [] => NONE
      | s :: lst' => if same_string(str, s)
                     then SOME lst'
                     else case all_except_option(str, lst') of
                              NONE => NONE
                            | SOME res => SOME(s :: res)

fun get_substitutions1(str_list_list, s) = 
    case str_list_list of
        [] => []
      | head :: tail => case all_except_option(s, head) of
                            SOME lst => lst @ get_substitutions1(tail,s)
                          | _ => get_substitutions1(tail,s)

fun get_substitutions2(str_list_list, s) = 
    let
        fun helper(str_list_list, ret_val) = 
            case str_list_list of
                [] => ret_val
              | head :: tail => case all_except_option(s, head) of
                                    SOME lst => helper(tail, lst @ ret_val)
                                  | _ => helper(tail, ret_val)
    in 
        helper(str_list_list,[])
    end

fun similar_names(str_list_list, full_name) = 
    let 
        fun helper(name_list, mid, lst) = 
            case name_list of
                [] => []
              | (head :: tail)=> {first = head, middle = mid, last = lst} :: helper(tail, mid, lst)
    in 
        case full_name of 
           {first = fst, middle = mid, last = lst} => helper(fst::get_substitutions1(str_list_list,fst),mid,lst)
    end


(* you may assume that Num is always used with values 2, 3, ..., 10
   though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove

(* put your solutions for problem 2 here *)
fun card_color c = 
    case c of 
        (Clubs, _) => Black
      | (Spades, _) => Black
      | _ => Red

fun card_value c = 
    case c of 
        (_, Num value) => value
      | (_, Ace) => 11
      | _ => 10

fun remove_card(cs, c, e) =
    case cs of
        [] => raise e
      | head :: tail => if head = c 
                        then tail
                        else head :: remove_card(tail, c, e)

fun all_same_color card_list = 
    case card_list of 
        [] => true
      | _ :: [] => true
      | x :: (y :: z) => card_color x = card_color y andalso all_same_color (y :: z)

fun sum_cards card_list = 
    let 
        fun helper(card_list, acc) = 
            case card_list of 
                [] => acc
              | (x :: y) => helper(y, card_value x + acc)
    in 
        helper(card_list, 0)
    end

fun score (card_list, goal) = 
    let 
        val sum = sum_cards card_list
        val preliminary_score = if sum > goal then 3 * (sum - goal) else goal - sum
    in 
        if all_same_color card_list 
        then preliminary_score div 2 
        else preliminary_score
    end

fun officiate(cards, moves, goal) = 
    let 
        fun helper(cards_held, card_list, moves_left) = 
            case moves_left of
                [] => score(cards_held, goal)
               | (Discard c) :: mv_left => helper(remove_card(cards_held, c, IllegalMove), card_list, mv_left)
               | Draw :: mv_left => case card_list of 
                                        [] => score(cards_held, goal)
                                      | c :: cs => if sum_cards cards_held > goal
                                                   then score(cards_held,goal)
                                                   else helper(c :: cards_held, cs, mv_left)
    in
        helper([], cards, moves)
    end