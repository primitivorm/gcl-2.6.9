; 07 Jan 2010 16:46:11 EST

; menu-settrans.lsp  -- translation of menu-set.lsp       Gordon S. Novak Jr.

; Copyright 2006 Gordon S. Novak Jr. and The University of Texas at Austin.

; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.

; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.

; You should have received a copy of the GNU General Public License
; along with this program; if not, write to the Free Software
; Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

; Written by: Gordon S. Novak Jr., Department of Computer Sciences,
; University of Texas at Austin  78712.    novak@cs.utexas.edu

(defmacro nconc1 (lst x) `(nconc ,lst (cons ,x nil)))

(defmacro glmethod (class selector)
  `(cadr (assoc ,selector (getf (cdr (get ,class 'glstructure)) 'msg))) )

(SETF (GET 'MENU-SET 'GLSTRUCTURE)
      '((LISTOBJECT (WINDOW WINDOW) (MENU-ITEMS (LISTOF MENU-SET-ITEM))
            (COMMANDFN ANYTHING))
        MSG
        ((DRAW MENU-SET-DRAW) (SELECT MENU-SET-SELECT)
         (NAMED-MENU MENU-SET-NAMED-MENU)
         (NAMED-ITEM MENU-SET-NAMED-ITEM) (ADD-MENU MENU-SET-ADD-MENU)
         (ADD-PICMENU MENU-SET-ADD-PICMENU)
         (ADD-COMPONENT MENU-SET-ADD-COMPONENT)
         (ADD-BARMENU MENU-SET-ADD-BARMENU)
         (ADD-ITEM MENU-SET-ADD-ITEM) (FIND-ITEM MENU-SET-FIND-ITEM)
         (DELETE-ITEM MENU-SET-DELETE-ITEM)
         (REMOVE-ITEMS MENU-SET-REMOVE-ITEMS)
         (ITEM-POSITION MENU-SET-ITEM-POSITION) (ITEMP MENU-SET-ITEMP)
         (ADJUST MENU-SET-ADJUST) (MOVE MENU-SET-MOVE)
         (DRAW-CONN MENU-SET-DRAW-CONN))))
(SETF (GET 'MENU-SET-ITEM 'GLSTRUCTURE)
      '((LIST (MENU-NAME SYMBOL) (SYM ANYTHING) (MENU MENU-SET-MENU))
        PROP
        ((LEFT ((PARENT-OFFSET-X MENU)))
         (BOTTOM ((PARENT-OFFSET-Y MENU)))
         (WIDTH ((PICTURE-WIDTH MENU)))
         (HEIGHT ((PICTURE-HEIGHT MENU))))
        SUPERS (REGION)))
(SETF (GET 'MENU-SET-MENU 'GLSTRUCTURE)
      '((TRANSPARENT MENU) MSG ((DRAW MENU-MDRAW))))
(SETF (GET 'MENU-PORT 'GLSTRUCTURE)
      '((LIST (PORT SYMBOL) (MENU-NAME SYMBOL))))
(SETF (GET 'MENU-SELECTION 'GLSTRUCTURE)
      '((LIST (PORT SYMBOL) (MENU-NAME SYMBOL) (BUTTON INTEGER))))
(SETF (GET 'MENU-SET-CONN 'GLSTRUCTURE)
      '((LIST (FROM MENU-PORT) (TO MENU-PORT))))
(SETF (GET 'MENU-CONNS 'GLSTRUCTURE)
      '((LISTOBJECT (MENU-SET MENU-SET)
            (CONNECTIONS (LISTOF MENU-SET-CONN)))
        PROP ((WINDOW ((WINDOW (MENU-SET SELF))))) MSG
        ((DRAW MENU-CONNS-DRAW) (REDRAW MENU-CONNS-REDRAW)
         (MOVE MENU-CONNS-MOVE) (ADD-CONN MENU-CONNS-ADD-CONN)
         (ADD-ITEM MENU-CONNS-ADD-ITEM OPEN T)
         (FIND-CONN MENU-CONNS-FIND-CONN)
         (FIND-ITEM MENU-CONNS-FIND-ITEM)
         (DELETE-ITEM MENU-CONNS-DELETE-ITEM)
         (DELETE-CONN MENU-CONNS-DELETE-CONN)
         (REMOVE-ITEMS MENU-CONNS-REMOVE-ITEMS)
         (FIND-CONNS MENU-CONNS-FIND-CONNS)
         (CONNECTED-PORTS MENU-CONNS-CONNECTED-PORTS)
         (NEW-CONN MENU-CONNS-NEW-CONN)
         (NAMED-MENU MENU-CONNS-NAMED-MENU)
         (NAMED-ITEM MENU-CONNS-NAMED-ITEM))))


(DEFUN MENU-SET-CREATE (W &OPTIONAL FN) (LIST 'MENU-SET W NIL FN))
(SETF (GET 'MENU-SET-CREATE 'GLARGUMENTS)
      '((W WINDOW) (&OPTIONAL NIL)))
(SETF (GET 'MENU-SET-CREATE 'GLFNRESULTTYPE) 'MENU-SET)


(DEFUN MENU-SET-SELECT (MS &OPTIONAL REDRAW ENABLED)
  (LET (RES RESB ITM SEL LASTX LASTY)
    (IF REDRAW (MENU-SET-DRAW MS))
    (WHILE (NOT (OR RES RESB))
           (SETQ ITM
                 (WINDOW-TRACK-MOUSE (CADR MS)
                     #'(LAMBDA (X Y CODE)
                         (OR (AND (PLUSP CODE) (SETQ LASTX X)
                                  (SETQ LASTY Y) CODE)
                             (SOME #'(LAMBDA (GLVAR237)
                                       (IF
                                        (AND
                                         (BETWEEN X
                                          (FIFTH (CADDR GLVAR237))
                                          (+ (FIFTH (CADDR GLVAR237))
                                           (SEVENTH (CADDR GLVAR237))))
                                         (BETWEEN Y
                                          (SIXTH (CADDR GLVAR237))
                                          (+ (SIXTH (CADDR GLVAR237))
                                           (EIGHTH (CADDR GLVAR237)))))
                                        GLVAR237))
                                   (CADDR MS))))))
           (IF (NUMBERP ITM)
               (SETQ RESB (LIST (LIST LASTX LASTY) 'BACKGROUND ITM))
               (WHEN (OR (ATOM ENABLED) (MEMBER (CAR ITM) ENABLED))
                 (SETQ SEL (MENU-MSELECT (CADDR ITM) (EQ ENABLED T)))
                 (IF SEL
                     (SETQ RES (LIST SEL (CAR ITM) *WINDOW-MENU-CODE*))
                     (IF (AND *WINDOW-MENU-CODE*
                              (NOT (ZEROP *WINDOW-MENU-CODE*)))
                         (SETQ RES
                               (LIST NIL (CAR ITM) *WINDOW-MENU-CODE*)))))))
    (XFLUSH *WINDOW-DISPLAY*)
    (OR RES RESB)))
(SETF (GET 'MENU-SET-SELECT 'GLARGUMENTS)
      '((MS MENU-SET) (&OPTIONAL BOOLEAN) (REDRAW (LISTOF SYMBOL))))
(SETF (GET 'MENU-SET-SELECT 'GLFNRESULTTYPE) 'MENU-SELECTION)


(DEFUN MENU-SET-ADD-MENU (MS NAME SYM TITLE ITEMS &OPTIONAL OFFSET)
  (LET (MENU)
    (SETQ MENU
          (MENU-CREATE ITEMS TITLE (CADR MS) (CAR OFFSET) (CADR OFFSET)
              T T))
    (MENU-INIT MENU)
    (IF (NOT OFFSET)
        (SETQ OFFSET
              (WINDOW-GET-BOX-POSITION (CADR MS) (SEVENTH MENU)
                  (EIGHTH MENU))))
    (SETF (FIFTH MENU) (CAR OFFSET))
    (SETF (SIXTH MENU) (CADR OFFSET))
    (MENU-SET-ADD-ITEM MS NAME SYM MENU)))
(SETF (GET 'MENU-SET-ADD-MENU 'GLARGUMENTS)
      '((MS MENU-SET) (NAME SYMBOL) (SYM SYMBOL) (TITLE STRING)
        (ITEMS NIL) (&OPTIONAL VECTOR)))
(SETF (GET 'MENU-SET-ADD-MENU 'GLFNRESULTTYPE) '(LISTOF MENU-SET-ITEM))


(DEFUN MENU-SET-ADD-ITEM (MS NAME SYM MENU)
  (SETF (CADDR MS) (NCONC (CADDR MS) (CONS (LIST NAME SYM MENU) NIL))))
(SETF (GET 'MENU-SET-ADD-ITEM 'GLARGUMENTS)
      '((MS MENU-SET) (NAME SYMBOL) (SYM SYMBOL) (MENU MENU)))
(SETF (GET 'MENU-SET-ADD-ITEM 'GLFNRESULTTYPE) '(LISTOF MENU-SET-ITEM))


(DEFUN MENU-SET-REMOVE-ITEMS (MS) (SETF (CADDR MS) NIL))
(SETF (GET 'MENU-SET-REMOVE-ITEMS 'GLARGUMENTS) '((MS MENU-SET)))
(SETF (GET 'MENU-SET-REMOVE-ITEMS 'GLFNRESULTTYPE)
      '(LISTOF MENU-SET-ITEM))


(DEFUN MENU-SET-ADD-PICMENU
       (MS NAME SYM TITLE SPEC &OPTIONAL OFFSET NOBOX)
  (LET (MENU MAXWIDTH MAXHEIGHT)
    (IF (AND SPEC (SYMBOLP SPEC)) (SETQ SPEC (GET SPEC 'PICMENU-SPEC)))
    (SETQ MENU
          (PICMENU-CREATE-FROM-SPEC SPEC TITLE (CADR MS) (CAR OFFSET)
              (CADR OFFSET) T T (NOT NOBOX)))
    (SETQ MAXWIDTH
          (MAX (IF TITLE (+ 6 (* 9 (LENGTH TITLE))) 0) (CADR SPEC)))
    (SETQ MAXHEIGHT (+ (IF TITLE 15 0) (CADDR SPEC)))
    (IF (NOT OFFSET)
        (SETQ OFFSET
              (WINDOW-GET-BOX-POSITION (CADR MS) MAXWIDTH MAXHEIGHT)))
    (SETF (FIFTH MENU) (CAR OFFSET))
    (SETF (SIXTH MENU) (CADR OFFSET))
    (MENU-SET-ADD-ITEM MS NAME SYM MENU)))
(SETF (GET 'MENU-SET-ADD-PICMENU 'GLARGUMENTS)
      '((MS MENU-SET) (NAME SYMBOL) (SYM SYMBOL) (TITLE STRING)
        (SPEC PICMENU-SPEC) (&OPTIONAL VECTOR) (OFFSET BOOLEAN)))
(SETF (GET 'MENU-SET-ADD-PICMENU 'GLFNRESULTTYPE)
      '(LISTOF MENU-SET-ITEM))


(DEFUN MENU-SET-ADD-COMPONENT (MS NAME &OPTIONAL OFFSET)
  (MENU-SET-ADD-PICMENU MS (MENU-SET-NAME NAME) NAME NIL NAME OFFSET T))
(SETF (GET 'MENU-SET-ADD-COMPONENT 'GLARGUMENTS)
      '((MS MENU-SET) (NAME SYMBOL) (&OPTIONAL VECTOR)))
(SETF (GET 'MENU-SET-ADD-COMPONENT 'GLFNRESULTTYPE)
      '(LISTOF MENU-SET-ITEM))


(DEFUN MENU-SET-ADD-BARMENU (MS NAME SYM MENU TITLE &OPTIONAL OFFSET)
  (BARMENU-INIT MENU)
  (IF (NOT OFFSET)
      (SETQ OFFSET
            (WINDOW-GET-BOX-POSITION (CADR MS) (SEVENTH MENU)
                (EIGHTH MENU))))
  (SETF (FIFTH MENU) (CAR OFFSET))
  (SETF (SIXTH MENU) (CADR OFFSET))
  (MENU-SET-ADD-ITEM MS NAME SYM MENU))
(SETF (GET 'MENU-SET-ADD-BARMENU 'GLARGUMENTS)
      '((MS MENU-SET) (NAME SYMBOL) (SYM SYMBOL) (MENU BARMENU)
        (TITLE STRING) (&OPTIONAL VECTOR)))
(SETF (GET 'MENU-SET-ADD-BARMENU 'GLFNRESULTTYPE)
      '(LISTOF MENU-SET-ITEM))


(DEFUN MENU-SET-NAME (NM)
  (INTERN (SYMBOL-NAME (GENSYM (SYMBOL-NAME NM)))))
(SETF (GET 'MENU-SET-NAME 'GLARGUMENTS) '((NM SYMBOL)))
(SETF (GET 'MENU-SET-NAME 'GLFNRESULTTYPE) 'SYMBOL)


(DEFUN MENU-SET-NAMED-ITEM (MS NAME) (ASSOC NAME (CADDR MS)))
(SETF (GET 'MENU-SET-NAMED-ITEM 'GLARGUMENTS)
      '((MS MENU-SET) (NAME SYMBOL)))
(SETF (GET 'MENU-SET-NAMED-ITEM 'GLFNRESULTTYPE) 'MENU-SET-ITEM)


(DEFUN MENU-SET-NAMED-MENU (MS NAME)
  (CADDR (MENU-SET-NAMED-ITEM MS NAME)))
(SETF (GET 'MENU-SET-NAMED-MENU 'GLARGUMENTS)
      '((MS MENU-SET) (NAME SYMBOL)))
(SETF (GET 'MENU-SET-NAMED-MENU 'GLFNRESULTTYPE) 'MENU-SET-MENU)


(DEFUN MENU-SET-ITEMP (MS NAME ITEMNAME)
  (LET ((THISMENU (MENU-SET-NAMED-MENU MS NAME)))
    (IF (EQ (FIRST THISMENU) 'MENU)
        (SOME #'(LAMBDA (X)
                  (OR (EQ X ITEMNAME)
                      (AND (CONSP X) (EQ (CAR X) ITEMNAME))))
              (NTH 13 THISMENU))
        (IF (EQ (FIRST THISMENU) 'PICMENU)
            (ASSOC ITEMNAME (CADDDR (NTH 10 THISMENU)))))))
(SETF (GET 'MENU-SET-ITEMP 'GLARGUMENTS)
      '((MS MENU-SET) (NAME SYMBOL) (ITEMNAME SYMBOL)))
(SETF (GET 'MENU-SET-ITEMP 'GLFNRESULTTYPE) 'BOOLEAN)


(DEFUN MENU-CONNS-NAMED-ITEM (MC NAME)
  (MENU-SET-NAMED-ITEM (CADR MC) NAME))
(SETF (GET 'MENU-CONNS-NAMED-ITEM 'GLARGUMENTS)
      '((MC MENU-CONNS) (NAME SYMBOL)))
(SETF (GET 'MENU-CONNS-NAMED-ITEM 'GLFNRESULTTYPE) 'MENU-SET-ITEM)


(DEFUN MENU-CONNS-NAMED-MENU (MC NAME)
  (MENU-SET-NAMED-MENU (CADR MC) NAME))
(SETF (GET 'MENU-CONNS-NAMED-MENU 'GLARGUMENTS)
      '((MC MENU-CONNS) (NAME SYMBOL)))
(SETF (GET 'MENU-CONNS-NAMED-MENU 'GLFNRESULTTYPE) 'MENU-SET-MENU)


(DEFUN MENU-SET-FIND-ITEM (MS POS)
  (LET (MITEM)
    (DOLIST (MI (CADDR MS))
      (IF (AND (BETWEEN (CAR POS)
                        (LET ((SELF (CADDR MI)))
                          (IF (CADDR SELF) (FIFTH SELF) 0))
                        (+ (LET ((SELF (CADDR MI)))
                             (IF (CADDR SELF) (FIFTH SELF) 0))
                           (SEVENTH (CADDR MI))))
               (BETWEEN (CADR POS)
                        (LET ((SELF (CADDR MI)))
                          (IF (CADDR SELF) (SIXTH SELF) 0))
                        (+ (LET ((SELF (CADDR MI)))
                             (IF (CADDR SELF) (SIXTH SELF) 0))
                           (EIGHTH (CADDR MI)))))
          (SETQ MITEM MI)))
    MITEM))
(SETF (GET 'MENU-SET-FIND-ITEM 'GLARGUMENTS)
      '((MS MENU-SET) (POS VECTOR)))
(SETF (GET 'MENU-SET-FIND-ITEM 'GLFNRESULTTYPE) 'MENU-SET-ITEM)


(DEFUN MENU-SET-DELETE-ITEM (MS MI)
  (SETF (CADDR MS) (REMOVE MI (CADDR MS))))
(SETF (GET 'MENU-SET-DELETE-ITEM 'GLARGUMENTS)
      '((MS MENU-SET) (MI MENU-SET-ITEM)))
(SETF (GET 'MENU-SET-DELETE-ITEM 'GLFNRESULTTYPE)
      '(LISTOF MENU-SET-ITEM))


(DEFUN MENU-SET-MOVE (MS)
  (LET (SEL M)
    (SETQ SEL (MENU-SET-SELECT MS NIL T))
    (SETQ M (MENU-SET-NAMED-MENU MS (CADR SEL)))
    (MENU-REPOSITION M)))

(DEFUN MENU-MDRAW (M)
  (CASE (FIRST M)
    (MENU (MENU-DRAW M))
    (PICMENU (PICMENU-DRAW M))
    (BARMENU (BARMENU-DRAW M))
    (TEXTMENU (TEXTMENU-DRAW M))
    (EDITMENU (EDITMENU-DRAW M))
    (T (GLSEND M DRAW))))

(DEFUN MENU-MSELECT (M &OPTIONAL ANYCLICK)
  (CASE (FIRST M)
    (MENU (MENU-SELECT M T))
    (PICMENU (PICMENU-SELECT M T ANYCLICK))
    (BARMENU (BARMENU-SELECT M))
    (TEXTMENU (TEXTMENU-SELECT M T))
    (EDITMENU (EDITMENU-SELECT M T))
    (T (GLSEND M SELECT))))

(DEFUN MENU-MITEM-POSITION (M NAME LOC)
  (CASE (FIRST M)
    (MENU (MENU-ITEM-POSITION M NAME LOC))
    (PICMENU (PICMENU-ITEM-POSITION M NAME LOC))
    (T (GLSEND M ITEM-POSITION NAME LOC))))

(DEFUN MENU-SET-DRAW (MS)
  (XMAPWINDOW *WINDOW-DISPLAY* (CADADR MS))
  (XFLUSH *WINDOW-DISPLAY*)
  (WINDOW-WAIT-EXPOSURE (CADR MS))
  (DOLIST (ITEM (CADDR MS)) (MENU-MDRAW (CADDR ITEM))))

(DEFUN MENU-SET-ITEM-POSITION (MS DESC &OPTIONAL LOC)
  (LET (M)
    (SETQ M (MENU-SET-NAMED-MENU MS (CADR DESC)))
    (OR (MENU-MITEM-POSITION M (CAR DESC) LOC)
        (MENU-MITEM-POSITION M NIL LOC))))
(SETF (GET 'MENU-SET-ITEM-POSITION 'GLARGUMENTS)
      '((MS MENU-SET) (DESC MENU-PORT) (&OPTIONAL SYMBOL)))
(SETF (GET 'MENU-SET-ITEM-POSITION 'GLFNRESULTTYPE) 'VECTOR)


(DEFUN MENU-SET-DRAW-CONN (MS CONN)
  (LET (PA PB TMP (DESCA (CAR CONN)) (DESCB (CADR CONN)))
    (SETQ PA (MENU-SET-ITEM-POSITION MS DESCA 'CENTER))
    (SETQ PB (MENU-SET-ITEM-POSITION MS DESCB 'CENTER))
    (WHEN (> (CAR PA) (CAR PB))
      (SETQ TMP DESCA)
      (SETQ DESCA DESCB)
      (SETQ DESCB TMP))
    (SETQ PA (MENU-SET-ITEM-POSITION MS DESCA 'RIGHT))
    (SETQ PB (MENU-SET-ITEM-POSITION MS DESCB 'LEFT))
    (WINDOW-DRAW-CIRCLE-XY (CADR MS) (CAR PA) (CADR PA) 3 NIL)
    (WINDOW-DRAW-LINE-XY (CADR MS) (CAR PA) (CADR PA) (CAR PB)
        (CADR PB) NIL)
    (WINDOW-DRAW-CIRCLE-XY (CADR MS) (CAR PB) (CADR PB) 3 NIL)
    (XFLUSH *WINDOW-DISPLAY*)))

(DEFUN MENU-SET-ADJUST (MS NAME EDGE FROM OFFSET)
  (LET (M FROMM PLACE)
    (WHEN (SETQ M (MENU-SET-NAMED-ITEM MS NAME))
      (IF FROM
          (PROGN
            (SETQ FROMM (MENU-SET-NAMED-ITEM MS FROM))
            (SETQ PLACE
                  (CASE EDGE
                    (TOP (SIXTH (CADDR FROMM)))
                    (BOTTOM (+ (SIXTH (CADDR FROMM))
                               (EIGHTH (CADDR FROMM))))
                    (LEFT (+ (FIFTH (CADDR FROMM))
                             (SEVENTH (CADDR FROMM))))
                    (RIGHT (FIFTH (CADDR FROMM))))))
          (SETQ PLACE
                (CASE EDGE
                  (TOP (CADDDR (CADR MS)))
                  ((BOTTOM LEFT) 0)
                  (RIGHT (FIFTH (CADR MS))))))
      (CASE EDGE
        (TOP (SETF (SIXTH (CADDR M))
                   (- (- PLACE (EIGHTH (CADDR M))) OFFSET)))
        (BOTTOM (SETF (SIXTH (CADDR M)) (+ PLACE OFFSET)))
        (LEFT (SETF (FIFTH (CADDR M)) (+ PLACE OFFSET)))
        (RIGHT (SETF (FIFTH (CADDR M))
                     (- (- PLACE (SEVENTH (CADDR M))) OFFSET)))))))
(SETF (GET 'MENU-SET-ADJUST 'GLARGUMENTS)
      '((MS MENU-SET) (NAME SYMBOL) (EDGE SYMBOL) (FROM SYMBOL)
        (OFFSET INTEGER)))
(SETF (GET 'MENU-SET-ADJUST 'GLFNRESULTTYPE) 'INTEGER)


(DEFUN VECTOR-SNAP (FIXED APPROX &OPTIONAL TOLERANCE)
  (OR TOLERANCE (SETQ TOLERANCE 10))
  (IF (< (ABS (- (CAR FIXED) (CAR APPROX))) TOLERANCE)
      (LIST (CAR FIXED) (CADR APPROX))
      (IF (< (ABS (- (CADR FIXED) (CADR APPROX))) TOLERANCE)
          (LIST (CAR APPROX) (CADR FIXED)) APPROX)))
(SETF (GET 'VECTOR-SNAP 'GLARGUMENTS)
      '((FIXED VECTOR) (APPROX VECTOR) (&OPTIONAL NIL)))
(SETF (GET 'VECTOR-SNAP 'GLFNRESULTTYPE) 'VECTOR)


(DEFUN MENU-CONNS-CREATE (MS) (LIST 'MENU-CONNS MS NIL))
(SETF (GET 'MENU-CONNS-CREATE 'GLARGUMENTS) '((MS MENU-SET)))
(SETF (GET 'MENU-CONNS-CREATE 'GLFNRESULTTYPE) 'MENU-CONNS)


(DEFUN MENU-CONNS-DRAW (MC)
  (MENU-SET-DRAW (CADR MC))
  (DOLIST (C (CADDR MC)) (MENU-SET-DRAW-CONN (CADR MC) C)))

(DEFUN MENU-CONNS-MOVE (MC)
  (MENU-SET-MOVE (CADR MC))
  (XCLEARWINDOW *WINDOW-DISPLAY* (CADR (CADADR MC)))
  (XFLUSH *WINDOW-DISPLAY*)
  (MENU-CONNS-DRAW MC))

(DEFUN MENU-CONNS-REDRAW (MC)
  (XCLEARWINDOW *WINDOW-DISPLAY* (CADR (CADADR MC)))
  (XFLUSH *WINDOW-DISPLAY*)
  (MENU-CONNS-DRAW MC))

(DEFUN MENU-CONNS-ADD-CONN (MC)
  (LET (SEL SELB CONN)
    (SETQ SEL (MENU-SET-SELECT (CADR MC)))
    (IF (EQ (CADR SEL) 'BACKGROUND) SEL
        (PROGN
          (SETQ SELB (MENU-SET-SELECT (CADR MC)))
          (WHEN (NOT (EQ (CADR SELB) 'BACKGROUND))
            (SETQ CONN (LIST SEL SELB))
            (MENU-SET-DRAW-CONN (CADR MC) CONN)
            (SETF (CADDR MC) (NCONC (CADDR MC) (CONS CONN NIL))))
          NIL))))
(SETF (GET 'MENU-CONNS-ADD-CONN 'GLARGUMENTS) '((MC MENU-CONNS)))
(SETF (GET 'MENU-CONNS-ADD-CONN 'GLFNRESULTTYPE) 'MENU-SELECTION)


(DEFUN MENU-CONNS-NEW-CONN (MC FROMNAME FROMPORT TONAME TOPORT)
  (LET (CONN)
    (SETQ CONN (LIST (LIST FROMPORT FROMNAME) (LIST TOPORT TONAME)))
    (SETF (CADDR MC) (NCONC (CADDR MC) (CONS CONN NIL)))))
(SETF (GET 'MENU-CONNS-NEW-CONN 'GLARGUMENTS)
      '((MC MENU-CONNS) (FROMNAME SYMBOL) (FROMPORT SYMBOL)
        (TONAME SYMBOL) (TOPORT SYMBOL)))
(SETF (GET 'MENU-CONNS-NEW-CONN 'GLFNRESULTTYPE)
      '(LISTOF MENU-SET-CONN))


(DEFUN MENU-CONNS-ADD-ITEM (MC NAME SYM MENU)
  (MENU-SET-ADD-ITEM (CADR MC) NAME SYM MENU))
(SETF (GET 'MENU-CONNS-ADD-ITEM 'GLARGUMENTS)
      '((MC MENU-CONNS) (NAME SYMBOL) (SYM SYMBOL) (MENU MENU)))
(SETF (GET 'MENU-CONNS-ADD-ITEM 'GLFNRESULTTYPE)
      '(LISTOF MENU-SET-ITEM))


(DEFUN MENU-CONNS-FIND-CONN (MC PT)
  (LET (MS LS FOUND RES PA PB TMP DESCA DESCB)
    (SETQ LS (LIST (COPY-LIST '(0 0)) (COPY-LIST '(0 0))))
    (SETQ MS (CADR MC))
    (DOLIST (CONN (CADDR MC))
      (UNLESS FOUND
        (SETQ DESCA (CAR CONN))
        (SETQ DESCB (CADR CONN))
        (SETQ PA (MENU-SET-ITEM-POSITION MS DESCA 'CENTER))
        (SETQ PB (MENU-SET-ITEM-POSITION MS DESCB 'CENTER))
        (WHEN (> (CAR PA) (CAR PB))
          (SETQ TMP DESCA)
          (SETQ DESCA DESCB)
          (SETQ DESCB TMP))
        (SETF (CAR LS) (MENU-SET-ITEM-POSITION MS DESCA 'RIGHT))
        (SETF (CADR LS) (MENU-SET-ITEM-POSITION MS DESCB 'LEFT))
        (WHEN (< (ABS (/ (- (* (- (CAADR LS) (CAAR LS))
                               (- (CADR PT) (CADAR LS)))
                            (* (- (CADADR LS) (CADAR LS))
                               (- (CAR PT) (CAAR LS))))
                         (SQRT (+ (EXPT (- (CAADR LS) (CAAR LS)) 2)
                                  (EXPT (- (CADADR LS) (CADAR LS)) 2)))))
                 5)
          (SETQ FOUND T)
          (SETQ RES CONN))))
    RES))
(SETF (GET 'MENU-CONNS-FIND-CONN 'GLARGUMENTS)
      '((MC MENU-CONNS) (PT VECTOR)))
(SETF (GET 'MENU-CONNS-FIND-CONN 'GLFNRESULTTYPE) 'MENU-SET-CONN)


(DEFUN MENU-CONNS-FIND-ITEM (MC PT) (MENU-SET-FIND-ITEM (CADR MC) PT))
(SETF (GET 'MENU-CONNS-FIND-ITEM 'GLARGUMENTS)
      '((MC MENU-CONNS) (PT VECTOR)))
(SETF (GET 'MENU-CONNS-FIND-ITEM 'GLFNRESULTTYPE) 'MENU-SET-ITEM)


(DEFUN MENU-CONNS-DELETE-CONN (MC CONN)
  (SETF (CADDR MC) (REMOVE CONN (CADDR MC))))
(SETF (GET 'MENU-CONNS-DELETE-CONN 'GLARGUMENTS)
      '((MC MENU-CONNS) (CONN MENU-SET-CONN)))
(SETF (GET 'MENU-CONNS-DELETE-CONN 'GLFNRESULTTYPE)
      '(LISTOF MENU-SET-CONN))


(DEFUN MENU-CONNS-DELETE-ITEM (MC MI)
  (LET (MS)
    (SETQ MS (CADR MC))
    (MENU-SET-DELETE-ITEM MS MI)
    (DOLIST (CONN (CADDR MC))
      (IF (OR (EQ (CADAR CONN) (CAR MI)) (EQ (CADADR CONN) (CAR MI)))
          (MENU-CONNS-DELETE-CONN MC CONN)))))

(DEFUN MENU-CONNS-REMOVE-ITEMS (MC)
  (MENU-SET-REMOVE-ITEMS (CADR MC))
  (SETF (CADDR MC) NIL))
(SETF (GET 'MENU-CONNS-REMOVE-ITEMS 'GLARGUMENTS) '((MC MENU-CONNS)))
(SETF (GET 'MENU-CONNS-REMOVE-ITEMS 'GLFNRESULTTYPE)
      '(LISTOF MENU-SET-CONN))


(DEFUN MENU-CONNS-CONNECTED-PORTS (MC BOXNAME)
  (LET (PORTS)
    (DOLIST (CONN (CADDR MC))
      (IF (EQ BOXNAME (CADADR CONN)) (PUSHNEW (CAADR CONN) PORTS)
          (IF (EQ BOXNAME (CADAR CONN)) (PUSHNEW (CAAR CONN) PORTS))))
    PORTS))

(DEFUN MENU-CONNS-FIND-CONNS (MC BOXNAME PORT)
  (LET (RES)
    (DOLIST (CONN (CADDR MC))
      (IF (AND (EQ BOXNAME (CADADR CONN)) (EQ PORT (CAADR CONN)))
          (SETQ RES (NCONC RES (CONS (CAR CONN) NIL))))
      (IF (AND (EQ BOXNAME (CADAR CONN)) (EQ PORT (CAAR CONN)))
          (SETQ RES (NCONC RES (CONS (CADR CONN) NIL)))))
    RES))
(SETF (GET 'MENU-CONNS-FIND-CONNS 'GLARGUMENTS)
      '((MC MENU-CONNS) (BOXNAME SYMBOL) (PORT SYMBOL)))
(SETF (GET 'MENU-CONNS-FIND-CONNS 'GLFNRESULTTYPE) '(LISTOF MENU-PORT))


(DEFUN COMPILE-MENU-SET ()
  (GLCOMPFILES *DIRECTORY* '("glisp/vector.lsp" "X/dwindow.lsp")
      '("glisp/menu-set.lsp") "glisp/menu-settrans.lsp"
      "glisp/menu-set-header.lsp")
  (COMPILE-FILE "glisp/menu-settrans.lsp"))

(DEFUN COMPILE-MENU-SETB ()
  (GLCOMPFILES *DIRECTORY*
      '("glisp/vector.lsp" "X/dwindow.lsp" "X/dwnoopen.lsp")
      '("glisp/menu-set.lsp") "glisp/menu-settrans.lsp"
      "glisp/menu-set-header.lsp"))
