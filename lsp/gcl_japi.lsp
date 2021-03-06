;;; Binding to the cross platform Japi GUI library from http://www.japi.de/

(eval-when (load eval)
	   (make-package :japi-primitives :nicknames '(jpr) :use '(lisp)))
(in-package :japi-primitives)


(clines "#include <japi.h>")

;; BOOLEAN   
(defconstant J_TRUE  1)
(defconstant J_FALSE 0)

;;  ALIGNMENT   
(defconstant J_LEFT  0)
(defconstant J_CENTER   1)
(defconstant J_RIGHT 2)
(defconstant J_TOP   3)
(defconstant J_BOTTOM   4)
(defconstant J_TOPLEFT  5)
(defconstant J_TOPRIGHT 6)
(defconstant J_BOTTOMLEFT  7)
(defconstant J_BOTTOMRIGHT 8)

;;  CURSOR   
(defconstant J_DEFAULT_CURSOR 0)
(defconstant J_CROSSHAIR_CURSOR  1)
(defconstant J_TEXT_CURSOR 2)
(defconstant J_WAIT_CURSOR 3)
(defconstant J_SW_RESIZE_CURSOR  4)
(defconstant J_SE_RESIZE_CURSOR  5)
(defconstant J_NW_RESIZE_CURSOR  6)
(defconstant J_NE_RESIZE_CURSOR  7)
(defconstant J_N_RESIZE_CURSOR   8)
(defconstant J_S_RESIZE_CURSOR   9)
(defconstant J_W_RESIZE_CURSOR   10)
(defconstant J_E_RESIZE_CURSOR   11)
(defconstant J_HAND_CURSOR 12)
(defconstant J_MOVE_CURSOR 13)

;;  ORIENTATION   
(defconstant J_HORIZONTAL  0)
(defconstant J_VERTICAL 1)

;;  FONTS   
(defconstant J_PLAIN 0)
(defconstant J_BOLD  1)
(defconstant J_ITALIC   2)
(defconstant J_COURIER  1)
(defconstant J_HELVETIA 2)
(defconstant J_TIMES 3)
(defconstant J_DIALOGIN 4)
(defconstant J_DIALOGOUT   5)

;;  COLORS   
(defconstant J_BLACK 0)
(defconstant J_WHITE 1)
(defconstant J_RED   2)
(defconstant J_GREEN 3)
(defconstant J_BLUE  4)
(defconstant J_CYAN  5)
(defconstant J_MAGENTA  6)
(defconstant J_YELLOW   7)
(defconstant J_ORANGE   8)
(defconstant J_GREEN_YELLOW   9)
(defconstant J_GREEN_CYAN  10)
(defconstant J_BLUE_CYAN   11)
(defconstant J_BLUE_MAGENTA   12)
(defconstant J_RED_MAGENTA 13)
(defconstant J_DARK_GRAY   14)
(defconstant J_LIGHT_GRAY  15)
(defconstant J_GRAY  16)

;;  BORDERSTYLE   
(defconstant J_NONE  0)
(defconstant J_LINEDOWN 1)
(defconstant J_LINEUP   2)
(defconstant J_AREADOWN 3)
(defconstant J_AREAUP   4)

;;  MOUSELISTENER   
(defconstant J_MOVED 0)
(defconstant J_DRAGGED  1)
(defconstant J_PRESSED  2)
(defconstant J_RELEASED 3)
(defconstant J_ENTERERD 4)
(defconstant J_EXITED   5)
(defconstant J_DOUBLECLICK 6)

;;  J_MOVED   
(defconstant J_RESIZED  1)
(defconstant J_HIDDEN   2)
(defconstant J_SHOWN 3)

;;  WINDOWLISTENER   
(defconstant J_ACTIVATED   0)
(defconstant J_DEACTIVATED 1)
(defconstant J_OPENED   2)
(defconstant J_CLOSED   3)
(defconstant J_ICONIFIED   4)
(defconstant J_DEICONIFIED 5)
(defconstant J_CLOSING  6)

;;  IMAGEFILEFORMAT   
(defconstant J_GIF   0)
(defconstant J_JPG   1)
(defconstant J_PPM   2)
(defconstant J_BMP   3)

(defentry j_start () ( int "j_start" ))
(defentry j_connect ( string ) ( int "j_connect" ))
(defentry j_setdebug ( int ) ( void "j_setdebug" ))
(defentry j_frame ( string ) ( int "j_frame" ))
(defentry j_button ( int string ) ( int "j_button" ))
(defentry j_graphicbutton ( int string ) ( int "j_graphicbutton" ))
(defentry j_checkbox ( int string ) ( int "j_checkbox" ))
(defentry j_label ( int string ) ( int "j_label" ))
(defentry j_graphiclabel ( int string ) ( int "j_graphiclabel" ))
(defentry j_canvas ( int int int ) ( int "j_canvas" ))
(defentry j_panel ( int ) ( int "j_panel" ))
(defentry j_borderpanel ( int int ) ( int "j_borderpanel" ))
(defentry j_radiogroup ( int ) ( int "j_radiogroup" ))
(defentry j_radiobutton ( int string ) ( int "j_radiobutton" ))
(defentry j_list ( int int ) ( int "j_list" ))
(defentry j_choice ( int ) ( int "j_choice" ))
(defentry j_dialog ( int string ) ( int "j_dialog" ))
(defentry j_window ( int ) ( int "j_window" ))
(defentry j_popupmenu ( int string ) ( int "j_popupmenu" ))
(defentry j_scrollpane ( int ) ( int "j_scrollpane" ))
(defentry j_hscrollbar ( int ) ( int "j_hscrollbar" ))
(defentry j_vscrollbar ( int ) ( int "j_vscrollbar" ))
(defentry j_line ( int int int int ) ( int "j_line" ))
(defentry j_printer ( int ) ( int "j_printer" ))
(defentry j_image ( int int ) ( int "j_image" ))
(defentry j_filedialog ( int string string string ) ( string "j_filedialog" ))
(defentry j_fileselect ( int string string string ) ( string "j_fileselect" ))
(defentry j_messagebox ( int string string ) ( int "j_messagebox" ))
(defentry j_alertbox ( int string string string ) ( int "j_alertbox" ))
(defentry j_choicebox2 ( int string string string string ) ( int "j_choicebox2" ))
(defentry j_choicebox3 ( int string string string string string ) ( int "j_choicebox3" ))
(defentry j_additem ( int string ) ( void "j_additem" ))
(defentry j_textfield ( int int ) ( int "j_textfield" ))
(defentry j_textarea ( int int int ) ( int "j_textarea" ))
(defentry j_menubar ( int ) ( int "j_menubar" ))
(defentry j_menu ( int string ) ( int "j_menu" ))
(defentry j_helpmenu ( int string ) ( int "j_helpmenu" ))
(defentry j_menuitem ( int string ) ( int "j_menuitem" ))
(defentry j_checkmenuitem ( int string ) ( int "j_checkmenuitem" ))
(defentry j_pack ( int ) ( void "j_pack" ))
(defentry j_print ( int ) ( void "j_print" ))
(defentry j_playsoundfile ( string ) ( void "j_playsoundfile" ))
(defentry j_play ( int ) ( void "j_play" ))
(defentry j_sound ( string ) ( int "j_sound" ))
(defentry j_setfont ( int int int int ) ( void "j_setfont" ))
(defentry j_setfontname ( int int ) ( void "j_setfontname" ))
(defentry j_setfontsize ( int int ) ( void "j_setfontsize" ))
(defentry j_setfontstyle ( int int ) ( void "j_setfontstyle" ))
(defentry j_seperator ( int ) ( void "j_seperator" ))
(defentry j_disable ( int ) ( void "j_disable" ))
(defentry j_enable ( int ) ( void "j_enable" ))
(defentry j_getstate ( int ) ( int "j_getstate" ))
(defentry j_getrows ( int ) ( int "j_getrows" ))
(defentry j_getcolumns ( int ) ( int "j_getcolumns" ))
(defentry j_getselect ( int ) ( int "j_getselect" ))
(defentry j_isselect ( int int ) ( int "j_isselect" ))
(defentry j_isvisible ( int ) ( int "j_isvisible" ))
(defentry j_isparent ( int int ) ( int "j_isparent" ))
(defentry j_isresizable ( int ) ( int "j_isresizable" ))
(defentry j_select ( int int ) ( void "j_select" ))
(defentry j_deselect ( int int ) ( void "j_deselect" ))
(defentry j_multiplemode ( int int ) ( void "j_multiplemode" ))
(defentry j_insert ( int int string ) ( void "j_insert" ))
(defentry j_remove ( int int ) ( void "j_remove" ))
(defentry j_removeitem ( int string ) ( void "j_removeitem" ))
(defentry j_removeall ( int ) ( void "j_removeall" ))
(defentry j_setstate ( int int ) ( void "j_setstate" ))
(defentry j_setrows ( int int ) ( void "j_setrows" ))
(defentry j_setcolumns ( int int ) ( void "j_setcolumns" ))
(defentry j_seticon ( int int ) ( void "j_seticon" ))
(defentry j_setimage ( int int ) ( void "j_setimage" ))
(defentry j_setvalue ( int int ) ( void "j_setvalue" ))
(defentry j_setradiogroup ( int int ) ( void "j_setradiogroup" ))
(defentry j_setunitinc ( int int ) ( void "j_setunitinc" ))
(defentry j_setblockinc ( int int ) ( void "j_setblockinc" ))
(defentry j_setmin ( int int ) ( void "j_setmin" ))
(defentry j_setmax ( int int ) ( void "j_setmax" ))
(defentry j_setslidesize ( int int ) ( void "j_setslidesize" ))
(defentry j_setcursor ( int int ) ( void "j_setcursor" ))
(defentry j_setresizable ( int int ) ( void "j_setresizable" ))
(defentry j_getlength ( int ) ( int "j_getlength" ))
(defentry j_getvalue ( int ) ( int "j_getvalue" ))
(defentry j_getscreenheight () ( int "j_getscreenheight" ))
(defentry j_getscreenwidth () ( int "j_getscreenwidth" ))
(defentry j_getheight ( int ) ( int "j_getheight" ))
(defentry j_getwidth ( int ) ( int "j_getwidth" ))
(defentry j_getinsets ( int int ) ( int "j_getinsets" ))
(defentry j_getlayoutid ( int ) ( int "j_getlayoutid" ))
(defentry j_getinheight ( int ) ( int "j_getinheight" ))
(defentry j_getinwidth ( int ) ( int "j_getinwidth" ))
(defentry j_gettext ( int string ) ( string "j_gettext" ))
(defentry j_getitem ( int int string ) ( string "j_getitem" ))
(defentry j_getitemcount ( int ) ( int "j_getitemcount" ))
(defentry j_delete ( int int int ) ( void "j_delete" ))
(defentry j_replacetext ( int int int int ) ( void "j_replacetext" ))
(defentry j_appendtext ( int int ) ( void "j_appendtext" ))
(defentry j_inserttext ( int int int ) ( void "j_inserttext" ))
(defentry j_settext ( int string ) ( void "j_settext" ))
(defentry j_selectall ( int ) ( void "j_selectall" ))
(defentry j_selecttext ( int int int ) ( void "j_selecttext" ))
(defentry j_getselstart ( int ) ( int "j_getselstart" ))
(defentry j_getselend ( int ) ( int "j_getselend" ))
;(defentry j_getseltext ( int string ) ( string "j_getseltext" ))
(defentry j_getseltext ( int int ) ( int "j_getseltext" ))
(defentry j_getcurpos ( int ) ( int "j_getcurpos" ))
(defentry j_setcurpos ( int int ) ( void "j_setcurpos" ))
(defentry j_setechochar ( int char ) ( void "j_setechochar" ))
(defentry j_seteditable ( int int ) ( void "j_seteditable" ))
(defentry j_setshortcut ( int char ) ( void "j_setshortcut" ))
(defentry j_quit () ( void "j_quit" ))
(defentry j_kill () ( void "j_kill" ))
(defentry j_setsize ( int int int ) ( void "j_setsize" ))
(defentry j_getaction () ( int "j_getaction" ))
(defentry j_nextaction () ( int "j_nextaction" ))
(defentry j_show ( int ) ( void "j_show" ))
(defentry j_showpopup ( int int int ) ( void "j_showpopup" ))
(defentry j_add ( int int ) ( void "j_add" ))
(defentry j_release ( int ) ( void "j_release" ))
(defentry j_releaseall ( int ) ( void "j_releaseall" ))
(defentry j_hide ( int ) ( void "j_hide" ))
(defentry j_dispose ( int ) ( void "j_dispose" ))
(defentry j_setpos ( int int int ) ( void "j_setpos" ))
(defentry j_getviewportheight ( int ) ( int "j_getviewportheight" ))
(defentry j_getviewportwidth ( int ) ( int "j_getviewportwidth" ))
(defentry j_getxpos ( int ) ( int "j_getxpos" ))
(defentry j_getypos ( int ) ( int "j_getypos" ))
;(defentry j_getpos ( int int* int* ) ( void "j_getpos" ))
(defentry j_getpos ( int int int ) ( void "j_getpos" ))
(defentry j_getparentid ( int ) ( int "j_getparentid" ))
(defentry j_setfocus ( int ) ( void "j_setfocus" ))
(defentry j_hasfocus ( int ) ( int "j_hasfocus" ))
(defentry j_getstringwidth ( int string ) ( int "j_getstringwidth" ))
(defentry j_getfontheight ( int ) ( int "j_getfontheight" ))
(defentry j_getfontascent ( int ) ( int "j_getfontascent" ))
(defentry j_keylistener ( int ) ( int "j_keylistener" ))
(defentry j_getkeycode ( int ) ( int "j_getkeycode" ))
(defentry j_getkeychar ( int ) ( int "j_getkeychar" ))
(defentry j_mouselistener ( int int ) ( int "j_mouselistener" ))
(defentry j_getmousex ( int ) ( int "j_getmousex" ))
(defentry j_getmousey ( int ) ( int "j_getmousey" ))
;(defentry j_getmousepos ( int int* int* ) ( void "j_getmousepos" ))
(defentry j_getmousepos ( int int int ) ( void "j_getmousepos" ))
(defentry j_getmousebutton ( int ) ( int "j_getmousebutton" ))
(defentry j_focuslistener ( int ) ( int "j_focuslistener" ))
(defentry j_componentlistener ( int int ) ( int "j_componentlistener" ))
(defentry j_windowlistener ( int int ) ( int "j_windowlistener" ))
(defentry j_setflowlayout ( int int ) ( void "j_setflowlayout" ))
(defentry j_setborderlayout ( int ) ( void "j_setborderlayout" ))
(defentry j_setgridlayout ( int int int ) ( void "j_setgridlayout" ))
(defentry j_setfixlayout ( int ) ( void "j_setfixlayout" ))
(defentry j_setnolayout ( int ) ( void "j_setnolayout" ))
(defentry j_setborderpos ( int int ) ( void "j_setborderpos" ))
(defentry j_sethgap ( int int ) ( void "j_sethgap" ))
(defentry j_setvgap ( int int ) ( void "j_setvgap" ))
(defentry j_setinsets ( int int int int int ) ( void "j_setinsets" ))
(defentry j_setalign ( int int ) ( void "j_setalign" ))
(defentry j_setflowfill ( int int ) ( void "j_setflowfill" ))
(defentry j_translate ( int int int ) ( void "j_translate" ))
(defentry j_cliprect ( int int int int int ) ( void "j_cliprect" ))
(defentry j_drawrect ( int int int int int ) ( void "j_drawrect" ))
(defentry j_fillrect ( int int int int int ) ( void "j_fillrect" ))
(defentry j_drawroundrect ( int int int int int int int ) ( void "j_drawroundrect" ))
(defentry j_fillroundrect ( int int int int int int int ) ( void "j_fillroundrect" ))
(defentry j_drawoval ( int int int int int ) ( void "j_drawoval" ))
(defentry j_filloval ( int int int int int ) ( void "j_filloval" ))
(defentry j_drawcircle ( int int int int ) ( void "j_drawcircle" ))
(defentry j_fillcircle ( int int int int ) ( void "j_fillcircle" ))
(defentry j_drawarc ( int int int int int int int ) ( void "j_drawarc" ))
(defentry j_fillarc ( int int int int int int int ) ( void "j_fillarc" ))
(defentry j_drawline ( int int int int int ) ( void "j_drawline" ))
;(defentry j_drawpolyline ( int int int* int* ) ( void "j_drawpolyline" ))
;(defentry j_drawpolygon ( int int int* int* ) ( void "j_drawpolygon" ))
;(defentry j_fillpolygon ( int int int* int* ) ( void "j_fillpolygon" ))
(defentry j_drawpolyline ( int int int int ) ( void "j_drawpolyline" ))
(defentry j_drawpolygon ( int int int int ) ( void "j_drawpolygon" ))
(defentry j_fillpolygon ( int int int int ) ( void "j_fillpolygon" ))
(defentry j_drawpixel ( int int int ) ( void "j_drawpixel" ))
(defentry j_drawstring ( int int int string ) ( void "j_drawstring" ))
(defentry j_setxor ( int int ) ( void "j_setxor" ))
(defentry j_getimage ( int ) ( int "j_getimage" ))
;(defentry j_getimagesource ( int int int int int int* int* int* ) ( void "j_getimagesource" ))
;(defentry j_drawimagesource ( int int int int int int* int* int* ) ( void "j_drawimagesource" ))
(defentry j_getimagesource ( int int int int int int int int ) ( void "j_getimagesource" ))
(defentry j_drawimagesource ( int int int int int int int int ) ( void "j_drawimagesource" ))
(defentry j_getscaledimage ( int int int int int int int ) ( int "j_getscaledimage" ))
(defentry j_drawimage ( int int int int ) ( void "j_drawimage" ))
(defentry j_drawscaledimage ( int int int int int int int int int int ) ( void "j_drawscaledimage" ))
(defentry j_setcolor ( int int int int ) ( void "j_setcolor" ))
(defentry j_setcolorbg ( int int int int ) ( void "j_setcolorbg" ))
(defentry j_setnamedcolor ( int int ) ( void "j_setnamedcolor" ))
(defentry j_setnamedcolorbg ( int int ) ( void "j_setnamedcolorbg" ))
(defentry j_loadimage ( string ) ( int "j_loadimage" ))
(defentry j_saveimage ( int string int ) ( int "j_saveimage" ))
(defentry j_sync () ( void "j_sync" ))
(defentry j_beep () ( void "j_beep" ))
(defentry j_random () ( int "j_random" ))
(defentry j_sleep ( int ) ( void "j_sleep" ))


