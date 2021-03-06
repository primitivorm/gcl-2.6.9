; ice-cream.lsp   14 Nov 1994 16:16:15


(SETF (GET 'ICE-CREAM 'DRAW-DESCR)
      '(DRAW-DESC ICE-CREAM
           ((DRAW-DOT (79 294) (4 4) NIL 0)
            (DRAW-CIRCLE (7 222) (148 148) NIL 0)
            (DRAW-ELLIPSE (7 274) (148 44) NIL 0)
            (DRAW-LINE (81 296) (0 -278) NIL 0)
            (DRAW-LINE (81 18) (74 278) NIL 0)
            (DRAW-LINE (81 18) (-74 278) NIL 0)
            (DRAW-ELLIPSE (0 269) (162 54) NIL 0)
            (DRAW-ARROW (154 391) (-27 -35) NIL 0)
            (DRAW-TEXT (140 395) (63 14) "Ice Cream" 0)
            (DRAW-ARROW (81 296) (-74 0) NIL 0)
            (DRAW-TEXT (47 299) (7 14) "r" 0)
            (DRAW-TEXT (86 186) (7 14) "h" 0)
            (DRAW-LINE (81 0) (81 296) NIL 0)
            (DRAW-LINE (81 0) (-81 296) NIL 0))
           (0 0) (203 409))) 

(DEFUN DRAW-ICE-CREAM (W X Y)
  (WINDOW-DRAW-DOT-XY W (+ 81 X) (+ 296 Y))
  (WINDOW-DRAW-CIRCLE-XY W (+ 81 X) (+ 296 Y) 74)
  (WINDOW-DRAW-ELLIPSE-XY W (+ 81 X) (+ 296 Y) 74 22)
  (WINDOW-DRAW-LINE-XY W (+ 81 X) (+ 296 Y) (+ 81 X) (+ 18 Y))
  (WINDOW-DRAW-LINE-XY W (+ 81 X) (+ 18 Y) (+ 155 X) (+ 296 Y))
  (WINDOW-DRAW-LINE-XY W (+ 81 X) (+ 18 Y) (+ 7 X) (+ 296 Y))
  (WINDOW-DRAW-ELLIPSE-XY W (+ 81 X) (+ 296 Y) 81 27)
  (WINDOW-DRAW-ARROW-XY W (+ 154 X) (+ 391 Y) (+ 127 X) (+ 356 Y))
  (WINDOW-PRINTAT-XY W "Ice Cream" (+ 140 X) (+ 395 Y))
  (WINDOW-DRAW-ARROW-XY W (+ 81 X) (+ 296 Y) (+ 7 X) (+ 296 Y))
  (WINDOW-PRINTAT-XY W "r" (+ 47 X) (+ 299 Y))
  (WINDOW-PRINTAT-XY W "h" (+ 86 X) (+ 186 Y))
  (WINDOW-DRAW-LINE-XY W (+ 81 X) Y (+ 162 X) (+ 296 Y))
  (WINDOW-DRAW-LINE-XY W (+ 81 X) Y X (+ 296 Y))
  (WINDOW-FORCE-OUTPUT W)) 
