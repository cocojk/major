
.TITLE output
.FILE "output.dcl"

.EXPORT _main

.IMPORT _input
.IMPORT _output

.VAR
    _x: .WORD 10

.PROC _minloc(.NOCHECK,.SIZE=12,.NODISPLAY,.ASSEMBLY=0)
  .LOCAL _a 8,4 (0,0,0)
  .LOCAL _low 12,4 (0,0,0)
  .LOCAL _high 16,4 (0,0,0)
  .LOCAL _i -4,4 (0,0,0)
  .LOCAL _x -8,4 (0,0,0)
  .LOCAL _k -12,4 (0,0,0)
.ENTRY
        pshAP   4
        derefW
        pshLP   -12
        assignW
        pshAP   4
        derefW
        pshLit  4
        mul     noTrap
        pshAP   0
        derefW
        add     noTrap
        derefW
        pshLP   -8
        assignW
        pshAP   4
        derefW
        pshLit  1
        add     noTrap
        pshLP   -4
        assignW
label0:
        pshLP   -4
        derefW
        pshAP   8
        derefW
        intLS
        brFalse  label1
        pshLP   -4
        derefW
        pshLit  4
        mul     noTrap
        pshAP   0
        derefW
        add     noTrap
        derefW
        pshLP   -8
        derefW
        intLS
        brFalse label2
        pshLP   -4
        derefW
        pshLit  4
        mul     noTrap
        pshAP   0
        derefW
        add     noTrap
        derefW
        pshLP   -8
        assignW
        pshLP   -4
        derefW
        pshLP   -12
        assignW
        branch label3
label2:
label3:
        pshLP   -4
        derefW
        pshLit  1
        add     noTrap
        pshLP   -4
        assignW
        branch  label0
label1:
        pshLP   -12
        derefW
        popRetW
        exit
        exit
        endP
.ENDP

.PROC _sort(.NOCHECK,.SIZE=12,.NODISPLAY,.ASSEMBLY=12)
  .LOCAL _a 8,4 (0,0,0)
  .LOCAL _low 12,4 (0,0,0)
  .LOCAL _high 16,4 (0,0,0)
  .LOCAL _i -4,4 (0,0,0)
  .LOCAL _k -8,4 (0,0,0)
  .LOCAL _t -12,4 (0,0,0)
.ENTRY
        pshAP   4
        derefW
        pshLP   -4
        assignW
label4:
        pshLP   -4
        derefW
        pshAP   8
        derefW
        pshLit  1
        sub     noTrap
        intLS
        brFalse  label5
        pshAP   0
        derefW
        mkPar   4,0
        pshLP   -4
        derefW
        mkPar   4,4
        pshAP   8
        derefW
        mkPar   4,8
        call    _minloc,3
        pshRetW
        pshLP   -8
        assignW
        pshLP   -8
        derefW
        pshLit  4
        mul     noTrap
        pshAP   0
        derefW
        add     noTrap
        derefW
        pshLP   -12
        assignW
        pshLP   -4
        derefW
        pshLit  4
        mul     noTrap
        pshAP   0
        derefW
        add     noTrap
        derefW
        pshLP   -8
        derefW
        pshLit  4
        mul     noTrap
        pshAP   0
        derefW
        add     noTrap
        assignW
        pshLP   -12
        derefW
        pshLP   -4
        derefW
        pshLit  4
        mul     noTrap
        pshAP   0
        derefW
        add     noTrap
        assignW
        pshLP   -4
        derefW
        pshLit  1
        add     noTrap
        pshLP   -4
        assignW
        branch  label4
label5:
        exit
        endP
.ENDP

.PROC _main(.NOCHECK,.SIZE=4,.NODISPLAY,.ASSEMBLY=12)
  .LOCAL _i -4,4 (0,0,0)
.ENTRY
        pshLit  0
        pshLP   -4
        assignW
label6:
        pshLP   -4
        derefW
        pshLit  10
        intLS
        brFalse  label7
        call    _input,0
        pshRetW
        pshLP   -4
        derefW
        pshLit  4
        mul     noTrap
        pshAdr  _x
        add     noTrap
        assignW
        pshLP   -4
        derefW
        pshLit  1
        add     noTrap
        pshLP   -4
        assignW
        branch  label6
label7:
        pshAdr  _x
        mkPar   4,0
        pshLit  0
        mkPar   4,4
        pshLit  10
        mkPar   4,8
        call    _sort,3
        pshLit  0
        pshLP   -4
        assignW
label8:
        pshLP   -4
        derefW
        pshLit  10
        intLS
        brFalse  label9
        pshLP   -4
        derefW
        pshLit  4
        mul     noTrap
        pshAdr  _x
        add     noTrap
        derefW
        mkPar   4,0
        call    _output,1
        pshLP   -4
        derefW
        pshLit  1
        add     noTrap
        pshLP   -4
        assignW
        branch  label8
label9:
        exit
        endP
.ENDP

