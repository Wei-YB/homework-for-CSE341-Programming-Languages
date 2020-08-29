fun is_older(date1: int * int * int, date2 : int * int * int) = 
    if #1 date1 < #1 date2
    then true
    else if #1 date1 = #1 date2 andalso #2  date1 < #2 date2
    then true
    else if #1 date1 = #1 date2 andalso #2 date1 = #2 date2 andalso #3 date1 < #3 date2
    then true
    else false

fun number_in_month(dates : (int * int * int) list, month : int) =
    if null dates
    then 0
    else if #2 (hd dates) = month 
    then 1 + number_in_month(tl dates, month)
    else number_in_month(tl dates, month)

fun number_in_months(dates : (int * int * int) list, months : int list) =
    if null months
    then 0
    else number_in_month(dates, hd months) + number_in_months(dates, tl months)

fun dates_in_month(dates : (int * int * int) list, month : int) =
    if null dates
    then []
    else if #2 (hd dates) = month 
    then hd dates :: dates_in_month(tl dates, month)
    else dates_in_month(tl dates, month)

fun dates_in_months(dates : (int * int * int) list, month : int list) =
    if null month
    then []
    else dates_in_month(dates, hd month) @ dates_in_months(dates, tl month)

fun get_nth(strings : string list, n : int) =
    if n = 1
    then hd strings
    else get_nth(tl strings, n - 1)

fun date_to_string(date : (int * int * int)) =
    let
        fun get_month_str(month : int) =
            get_nth(["January", "February" , "March"   , 
                     "April"  , "May"      , "June"    , 
                     "July"   , "August"   ,"September",
                     "October", "November" ,"December"], month)
    in
        get_month_str(#2 date) ^ " " ^ Int.toString(#3 date) ^ ", " ^ Int.toString(#1 date)
    end

fun number_before_reaching_sum(sum : int, nums : int list) =
    let
        val sum_prev = sum - hd nums
    in
        if sum_prev > 0
        then 1 + number_before_reaching_sum(sum_prev, tl nums)
        else 0
    end 

fun what_month(days : int) =
    number_before_reaching_sum(days, [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]) + 1

fun month_range(day1 : int, day2 : int) =
    if day1 > day2
    then []
    else what_month(day1) :: month_range(day1 + 1, day2)

fun oldest(dates : (int * int * int) list) =
    if null dates
    then NONE
    else
        let val old = oldest(tl dates)
        in 
            if isSome old andalso is_older(valOf(old), hd dates)
            then old
            else SOME(hd dates)
        end


(*  helper function for problem 12
    remove duplicates in num_list  *)
fun unique num_list = 
    let
        fun add_new_num (new, new_list) = 
            if List.exists( fn num : int => num = new) new_list
            then new_list
            else new :: new_list 
    in
        List.foldr add_new_num [] num_list
    end

fun number_in_months_challenge(dates : (int * int * int) list, months : int list) =
    number_in_months(dates, unique(months))

fun dates_in_months_challenge(dates : (int * int * int) list, months : int list) =
    dates_in_months(dates, unique(months))

fun reasonable_date(date : int * int * int) =
    let 
        val is_leap_year = (#1 date mod 400 = 0) orelse 
                           (#1 date mod 4 = 0 andalso #1 date mod 100 <> 0)
        val is_valid_year = #1 date > 0
        val is_valid_month = #2 date > 0 andalso #2 date < 13
        val months = if is_leap_year 
                     then [31,29,31,30,31,30,31,31,30,31,30,31]
                     else[31,28,31,30,31,30,31,31,30,31,30,31]
        
        fun get_nth(index : int, num_list : int list) = 
            if index = 1
            then hd num_list
            else get_nth(index - 1, tl num_list)
        
        val is_valid_day = is_valid_month andalso #3 date > 0 andalso 
                           #3 date <= get_nth(#2 date, months)
    in
        is_valid_day andalso is_valid_month andalso is_valid_year
    end