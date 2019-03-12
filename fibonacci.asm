.int t 0

.!str reqstr Enter some number:
.int reqstrptr $reqstr
.int space 32
.str newline \n
.int one 1
.int two 2
.!int zero 0
.int minusone -1
.int minustwo -2
.int reg 0

# print_str(reqstr)
S 0 &t &t
S 0 &>ret &t
S 0 $sp $sp
S 0 &t $sp
S 0 &minusone &sp
S 0 &t &t
S 0 &reqstrptr &t
S 0 &t &reg  # reg = &reqstr
S 0 &>jump $zero
.int >jump @ - @print_str
.int >ret @


.str mindigit 0
.int ten 10
.int reg2 0

# read a number
@start2
S 0 &reg &reg
S 0 -1 &reg  # input -> reg
S 0 &t &t
S 0 &reg &t
S 0 &reg2 &reg2
S 0 &t &reg2  # reg2 = reg
S 0 &mindigit &reg  # if reg < '0' or reg > '9': goto start3
S $reg &>jump $zero
.int >jump @ - @continue2
S 0 &>jump $zero
.int >jump @ - @start3
@continue2
S 0 &ten &reg
S $reg &>jump $zero
.int >jump @ - @start3

S 0 &mindigit &reg2  # reg2 -= '0'
.int accum 0
.int reg3 0
S 0 &reg3 &reg3  # accum = 10 * accum + reg2
S 0 &accum &reg3
S 0 &accum &reg3
S 0 &accum &reg3
S 0 &accum &reg3
S 0 &accum &reg3
S 0 &accum &reg3
S 0 &accum &reg3
S 0 &accum &reg3
S 0 &accum &reg3
S 0 &accum &reg3
S 0 &reg2 &reg3
S 0 &accum &accum
S 0 &reg3 &accum
S 0 &>jump $zero  # goto start2
.int >jump @ - @start2


@start3


.!buf stack 300
.int sp $stack

.!str resstr Your fibonacci number is
.int resstrptr $resstr

# print_str(resstr)
S 0 &t &t
S 0 &>ret &t
S 0 $sp $sp
S 0 &t $sp
S 0 &minusone &sp
S 0 &t &t
S 0 &reg &reg
S 0 &resstrptr &t
S 0 &t &reg  # reg = &resstr
S 0 &>jump $zero
.int >jump @ - @print_str
.int >ret @

# fib(accum)
S 0 &t &t
S 0 &>ret &t
S 0 $sp $sp
S 0 &t $sp
S 0 &minusone &sp
S 0 &t &t
S 0 &accum &t
S 0 &reg &reg
S 0 &t &reg  # reg = accum
S 0 &>jump $zero
.int >jump @ - @fib
.int >ret @

# print_int(reg)
S 0 &t &t
S 0 &>ret &t
S 0 $sp $sp
S 0 &t $sp
S 0 &minusone &sp
S 0 &t &t
S 0 &reg &t
S 0 &var_a &var_a
S 0 &t &var_a  # var_a = reg
S 0 &>jump $zero
.int >jump @ - @print_int
.int >ret @

# output <- \n
S 0 &newline -1

# exit
S 0 &>halt $zero
.int >halt @ - -1


@fib
#push reg
S 0 &t &t
S 0 &reg &t
S 0 $sp $sp
S 0 &t $sp
S 0 &minusone &sp

# if reg -= 2 <= 1: return 1
S 0 &two &reg
S $reg &>jump $zero
.int >jump @ - @fib_go
S 0 &reg &reg
S 0 &minusone &reg
S 0 &two &sp
S 0 &t &t
S 0 &>jump &t
S 0 $sp &t
S 0 &t $zero
.int >jump 0 - @

@fib_go
# fib(reg += 1)
S 0 &minusone &reg
S 0 &t &t
S 0 &>ret &t
S 0 $sp $sp
S 0 &t $sp
S 0 &minusone &sp
S 0 &>jump $zero
.int >jump @ - @fib
.int >ret @

# push reg
S 0 &t &t
S 0 &reg &t
S 0 $sp $sp
S 0 &t $sp

# reg = *(sp - 2) - 2
S 0 &one &sp
S 0 &t &t
S 0 $sp &t
S 0 &reg &reg
S 0 &t &reg
S 0 &two &reg
S 0 &minustwo &sp

# fib(reg)
S 0 &t &t
S 0 &>ret &t
S 0 $sp $sp
S 0 &t $sp
S 0 &minusone &sp
S 0 &>jump $zero
.int >jump @ - @fib
.int >ret @

# reg += *(sp - 1)
S 0 &one &sp
S 0 &reg2 &reg2
S 0 $sp &reg2
S 0 &reg2 &reg

# return
S 0 &two &sp
S 0 &t &t
S 0 &>jump &t
S 0 $sp &t
S 0 &t $zero
.int >jump 0 - @


.int var_a 0
.int var_k 1

@print_int #(a, k), k = 10^i
# push k
S 0 &t &t
S 0 &var_k &t
S 0 $sp $sp
S 0 &t $sp
S 0 &minusone &sp

# if a - k < 0: goto print_int_ret
S 0 &t &t
S 0 &var_a &t
S 0 &reg &reg
S 0 &t &reg
S 0 &var_k &reg
S $reg &>jump $zero
.int >jump @ - @print_int_cont
S 0 &>jump $zero
.int >jump @ - @print_int_ret

@print_int_cont
# k *= 10
S 0 &reg &reg
S 0 &var_k &reg
S 0 &var_k &reg
S 0 &var_k &reg
S 0 &var_k &reg
S 0 &var_k &reg
S 0 &var_k &reg
S 0 &var_k &reg
S 0 &var_k &reg
S 0 &var_k &reg
S 0 &var_k &reg
S 0 &var_k &var_k
S 0 &reg &var_k

# print_int(a, k)
S 0 &t &t
S 0 &>ret &t
S 0 $sp $sp
S 0 &t $sp
S 0 &minusone &sp
S 0 &>jump $zero
.int >jump @ - @print_int
.int >ret @

# k = *(sp - 1)
S 0 &one &sp
S 0 &t &t
S 0 $sp &t
S 0 &var_k &var_k
S 0 &t &var_k
S 0 &minusone &sp


.int var_c 0

# while a >= 0: a -= k, c += 1
S 0 &var_c &var_c
@print_int_startloop
S 0 &one &var_c
S 0 &var_k &var_a
S $var_a &>jump $zero
.int >jump @ - @print_int_startloop

# a += k
S 0 &reg &reg
S 0 &var_k &reg
S 0 &reg &var_a

# output <- c + mindigit - 1
S 0 &t &t
S 0 &reg2 &reg2
S 0 &mindigit &t
S 0 &t &reg2
S 0 &var_c &reg2
S 0 &one &reg2
S 0 &reg2 -1

@print_int_ret
S 0 &two &sp
S 0 &t &t
S 0 &>jump &t
S 0 $sp &t
S 0 &t $zero
.int >jump 0 - @


@print_str  #(reg)
# reg2 = *reg - 1
S 0 &t &t
S 0 &reg2 &reg2
S 0 $reg &t
S 0 &t &reg2
S 0 &one &reg2

# if reg2 < 0: output <- ' ', return
S $reg2 &>jump $zero
.int >jump @ - @print_str_cont
S 0 &space -1
S 0 &one &sp
S 0 &t &t
S 0 &>jump &t
S 0 $sp &t
S 0 &t $zero
.int >jump 0 - @

@print_str_cont
# output <- reg2 + 1
S 0 &minusone &reg2
S 0 &reg2 -1

# reg += 1, tail call
S 0 &minusone &reg
S 0 &>jump $zero
.int >jump @ - @print_str
