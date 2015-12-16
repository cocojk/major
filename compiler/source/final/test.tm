* TINY Compilation to TM Code
* File: test.tm
* Standard prelude:
* End of standard prelude.
  0:    ADD  3,4,5 	move sp -> fp
  1:    LDC  5,1(0) 	temp use zp for push
  2:    ADD  4,4,5 	push stack address
  3:    LDC  5,0(0) 	return zp 0
  4:    LDC  0,0(0) 	local variable store at ac
  5:     ST  0,1(3) 	local variable store at localoff(fp)
  6:    LDC  5,1(0) 	temp use zp for push
  7:    ADD  4,4,5 	push stack address
  8:    LDC  5,0(0) 	return zp 0
  9:    LDC  0,0(0) 	local variable store at ac
 10:     ST  0,2(3) 	local variable store at localoff(fp)
 11:    LDC  5,1(0) 	temp use zp for push
 12:    ADD  4,4,5 	push stack address
 13:    LDC  5,0(0) 	return zp 0
* -> assign
 14:     IN  0,0,0 	standard input
 15:     ST  0,1(3) 	load local id value
* -> assign
 16:     IN  0,0,0 	standard input
 17:     ST  0,2(3) 	load local id value
* function call use var or fun
* -> Id
 18:     LD  0,1(3) 	load local id value
* <- Id
 19:     ST  0,0(4) 	insert parameter 
 20:    LDC  5,1(0) 	temp use zp for push
 21:    ADD  4,4,5 	push stack address
 22:    LDC  5,0(0) 	return zp 0
* function call use var or fun
* -> Id
 23:     LD  0,2(3) 	load local id value
* <- Id
 24:     ST  0,0(4) 	insert parameter 
 25:    LDC  5,1(0) 	temp use zp for push
 26:    ADD  4,4,5 	push stack address
 27:    LDC  5,0(0) 	return zp 0
 28:     ST  3,0(4) 	save old fp
 29:    LDC  5,1(0) 	temp use zp for push
 30:    ADD  4,4,5 	push stack address
 31:    LDC  5,0(0) 	return zp 0
 32:    ADD  3,4,5 	sp->fp
 33:    LDC  0,3(0) 	parameternum -> ac
 34:     ST  0,0(4) 	save old sp
 35:    LDC  5,1(0) 	temp use zp for push
 36:    ADD  4,4,5 	push stack address
 37:    LDC  5,0(0) 	return zp 0
* -> if
* if test start
* -> Op
* -> Id
 38:     LD  0,-2(3) 	load local id value
* <- Id
 39:     ST  0,0(4) 	op: push left
 40:    LDC  5,1(0) 	temp use zp for push
 41:    ADD  4,4,5 	push stack address
 42:    LDC  5,0(0) 	return zp 0
* -> Const
 43:    LDC  0,0(0) 	load const
* <- Const
 44:    LDC  5,1(0) 	temp use zp for pop
 45:    SUB  4,4,5 	pop stack address
 46:    LDC  5,0(0) 	return zp 0
 47:     LD  1,0(4) 	op: load left
 48:    SUB  0,1,0 	op ==
 49:    JEQ  0,2(7) 	br if true
 50:    LDC  0,0(0) 	false case
 51:    LDA  7,1(7) 	unconditional jmp
 52:    LDC  0,1(0) 	true case
* <- Op
* if test end
* if: jump to else belongs here
* if true start
* -> Id
 54:     LD  0,-3(3) 	load local id value
* <- Id
* if true end
* if: jump to end belongs here
 53:    JEQ  0,2(7) 	if: jmp to else
* if false start
* function call use var or fun
* -> Id
 56:     LD  0,-2(3) 	load local id value
* <- Id
 57:     ST  0,0(4) 	insert parameter 
 58:    LDC  5,1(0) 	temp use zp for push
 59:    ADD  4,4,5 	push stack address
 60:    LDC  5,0(0) 	return zp 0
* no delclration parameter insert
* -> Op
* -> Id
 61:     LD  0,-3(3) 	load local id value
* <- Id
 62:     ST  0,0(4) 	op: push left
 63:    LDC  5,1(0) 	temp use zp for push
 64:    ADD  4,4,5 	push stack address
 65:    LDC  5,0(0) 	return zp 0
* -> Op
* -> Op
* -> Id
 66:     LD  0,-3(3) 	load local id value
* <- Id
 67:     ST  0,0(4) 	op: push left
 68:    LDC  5,1(0) 	temp use zp for push
 69:    ADD  4,4,5 	push stack address
 70:    LDC  5,0(0) 	return zp 0
* -> Id
 71:     LD  0,-2(3) 	load local id value
* <- Id
 72:    LDC  5,1(0) 	temp use zp for pop
 73:    SUB  4,4,5 	pop stack address
 74:    LDC  5,0(0) 	return zp 0
 75:     LD  1,0(4) 	op: load left
 76:    DIV  0,1,0 	op /
* <- Op
 77:     ST  0,0(4) 	op: push left
 78:    LDC  5,1(0) 	temp use zp for push
 79:    ADD  4,4,5 	push stack address
 80:    LDC  5,0(0) 	return zp 0
* -> Id
 81:     LD  0,-2(3) 	load local id value
* <- Id
 82:    LDC  5,1(0) 	temp use zp for pop
 83:    SUB  4,4,5 	pop stack address
 84:    LDC  5,0(0) 	return zp 0
 85:     LD  1,0(4) 	op: load left
 86:    MUL  0,1,0 	op *
* <- Op
 87:    LDC  5,1(0) 	temp use zp for pop
 88:    SUB  4,4,5 	pop stack address
 89:    LDC  5,0(0) 	return zp 0
 90:     LD  1,0(4) 	op: load left
 91:    SUB  0,1,0 	op -
* <- Op
 92:     ST  0,0(4) 	insert parameter 
 93:    LDC  5,1(0) 	temp use zp for push
 94:    ADD  4,4,5 	push stack address
 95:    LDC  5,0(0) 	return zp 0
 96:    LDC  7,28(0) 	jmp to defined function
* if false end
 55:    LDA  7,41(7) 	jmp to end
* <- if
 97:     LD  1,0(3) 	old sp ->ac
 98:    SUB  4,3,1 	reset old sp
 99:     LD  3,-1(3) 	reset old fp
100:    OUT  0,0,0 	standard output
* End of execution.
101:   HALT  0,0,0 	
