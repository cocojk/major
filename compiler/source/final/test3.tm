* TINY Compilation to TM Code
* File: test3.tm
* Standard prelude:
* End of standard prelude.
  0:    ADD  3,4,5 	move sp -> fp
  1:    LDC  5,1(0) 	temp use zp for push
  2:    ADD  4,4,5 	push stack address
  3:    LDC  5,0(0) 	return zp 0
* no delclration parameter insert
* -> Const
  4:    LDC  0,2(0) 	load const
* <- Const
  5:     ST  0,0(4) 	insert parameter 
  6:    LDC  5,1(0) 	temp use zp for push
  7:    ADD  4,4,5 	push stack address
  8:    LDC  5,0(0) 	return zp 0
* no delclration parameter insert
* -> Const
  9:    LDC  0,4(0) 	load const
* <- Const
 10:     ST  0,0(4) 	insert parameter 
 11:    LDC  5,1(0) 	temp use zp for push
 12:    ADD  4,4,5 	push stack address
 13:    LDC  5,0(0) 	return zp 0
 14:     ST  3,0(4) 	save old fp
 15:    LDC  5,1(0) 	temp use zp for push
 16:    ADD  4,4,5 	push stack address
 17:    LDC  5,0(0) 	return zp 0
 18:    ADD  3,4,5 	sp->fp
 19:    LDC  0,3(0) 	parameternum -> ac
 20:     ST  0,0(4) 	save old sp
 21:    LDC  5,1(0) 	temp use zp for push
 22:    ADD  4,4,5 	push stack address
 23:    LDC  5,0(0) 	return zp 0
* -> if
* if test start
* -> Op
* -> Id
 24:     LD  0,-3(3) 	load local id value
* <- Id
 25:     ST  0,0(4) 	op: push left
 26:    LDC  5,1(0) 	temp use zp for push
 27:    ADD  4,4,5 	push stack address
 28:    LDC  5,0(0) 	return zp 0
* -> Const
 29:    LDC  0,0(0) 	load const
* <- Const
 30:    LDC  5,1(0) 	temp use zp for pop
 31:    SUB  4,4,5 	pop stack address
 32:    LDC  5,0(0) 	return zp 0
 33:     LD  1,0(4) 	op: load left
 34:    SUB  0,1,0 	op ==
 35:    JEQ  0,2(7) 	br if true
 36:    LDC  0,0(0) 	false case
 37:    LDA  7,1(7) 	unconditional jmp
 38:    LDC  0,1(0) 	true case
* <- Op
* if test end
* if: jump to else belongs here
* if true start
* if true end
* if: jump to end belongs here
 39:    JEQ  0,1(7) 	if: jmp to else
* if false start
* if false end
 40:    LDA  7,0(7) 	jmp to end
* <- if
* -> if
* if test start
* -> Op
* -> Id
 41:     LD  0,-3(3) 	load local id value
* <- Id
 42:     ST  0,0(4) 	op: push left
 43:    LDC  5,1(0) 	temp use zp for push
 44:    ADD  4,4,5 	push stack address
 45:    LDC  5,0(0) 	return zp 0
* -> Const
 46:    LDC  0,0(0) 	load const
* <- Const
 47:    LDC  5,1(0) 	temp use zp for pop
 48:    SUB  4,4,5 	pop stack address
 49:    LDC  5,0(0) 	return zp 0
 50:     LD  1,0(4) 	op: load left
 51:    SUB  0,1,0 	op >
 52:    JGT  0,2(7) 	br if true
 53:    LDC  0,0(0) 	false case
 54:    LDA  7,1(7) 	unconditional jmp
 55:    LDC  0,1(0) 	true case
* <- Op
* if test end
* if: jump to else belongs here
* if true start
* -> assign
* -> Op
* -> Id
 57:     LD  0,-3(3) 	load local id value
* <- Id
 58:     ST  0,0(4) 	op: push left
 59:    LDC  5,1(0) 	temp use zp for push
 60:    ADD  4,4,5 	push stack address
 61:    LDC  5,0(0) 	return zp 0
* -> Const
 62:    LDC  0,1(0) 	load const
* <- Const
 63:    LDC  5,1(0) 	temp use zp for pop
 64:    SUB  4,4,5 	pop stack address
 65:    LDC  5,0(0) 	return zp 0
 66:     LD  1,0(4) 	op: load left
 67:    SUB  0,1,0 	op -
* <- Op
 68:     ST  0,-3(3) 	load local id value
* function call use var or fun
* -> Id
 69:     LD  0,-3(3) 	load local id value
* <- Id
 70:     ST  0,0(4) 	insert parameter 
 71:    LDC  5,1(0) 	temp use zp for push
 72:    ADD  4,4,5 	push stack address
 73:    LDC  5,0(0) 	return zp 0
* function call use var or fun
* -> Id
 74:     LD  0,-2(3) 	load local id value
* <- Id
 75:     ST  0,0(4) 	insert parameter 
 76:    LDC  5,1(0) 	temp use zp for push
 77:    ADD  4,4,5 	push stack address
 78:    LDC  5,0(0) 	return zp 0
 79:    LDC  7,14(0) 	jmp to defined function
* if true end
* if: jump to end belongs here
 56:    JEQ  0,24(7) 	if: jmp to else
* if false start
* if false end
 80:    LDA  7,0(7) 	jmp to end
* <- if
* -> if
* if test start
* -> Op
* -> Id
 81:     LD  0,-2(3) 	load local id value
* <- Id
 82:     ST  0,0(4) 	op: push left
 83:    LDC  5,1(0) 	temp use zp for push
 84:    ADD  4,4,5 	push stack address
 85:    LDC  5,0(0) 	return zp 0
* -> Const
 86:    LDC  0,0(0) 	load const
* <- Const
 87:    LDC  5,1(0) 	temp use zp for pop
 88:    SUB  4,4,5 	pop stack address
 89:    LDC  5,0(0) 	return zp 0
 90:     LD  1,0(4) 	op: load left
 91:    SUB  0,1,0 	op >
 92:    JGT  0,2(7) 	br if true
 93:    LDC  0,0(0) 	false case
 94:    LDA  7,1(7) 	unconditional jmp
 95:    LDC  0,1(0) 	true case
* <- Op
* if test end
* if: jump to else belongs here
* if true start
* -> assign
* -> Op
* -> Id
 97:     LD  0,-2(3) 	load local id value
* <- Id
 98:     ST  0,0(4) 	op: push left
 99:    LDC  5,1(0) 	temp use zp for push
100:    ADD  4,4,5 	push stack address
101:    LDC  5,0(0) 	return zp 0
* -> Const
102:    LDC  0,1(0) 	load const
* <- Const
103:    LDC  5,1(0) 	temp use zp for pop
104:    SUB  4,4,5 	pop stack address
105:    LDC  5,0(0) 	return zp 0
106:     LD  1,0(4) 	op: load left
107:    SUB  0,1,0 	op -
* <- Op
108:     ST  0,-2(3) 	load local id value
* function call use var or fun
* -> Id
109:     LD  0,-2(3) 	load local id value
* <- Id
110:     ST  0,0(4) 	insert parameter 
111:    LDC  5,1(0) 	temp use zp for push
112:    ADD  4,4,5 	push stack address
113:    LDC  5,0(0) 	return zp 0
* function call use var or fun
* -> Id
114:     LD  0,-3(3) 	load local id value
* <- Id
115:     ST  0,0(4) 	insert parameter 
116:    LDC  5,1(0) 	temp use zp for push
117:    ADD  4,4,5 	push stack address
118:    LDC  5,0(0) 	return zp 0
119:    LDC  7,14(0) 	jmp to defined function
* -> Id
120:     LD  0,-2(3) 	load local id value
* <- Id
121:    OUT  0,0,0 	standard output
* if true end
* if: jump to end belongs here
 96:    JEQ  0,26(7) 	if: jmp to else
* if false start
* if false end
122:    LDA  7,0(7) 	jmp to end
* <- if
123:     LD  1,0(3) 	old sp ->ac
124:    SUB  4,3,1 	reset old sp
125:     LD  3,-1(3) 	reset old fp
* End of execution.
126:   HALT  0,0,0 	
