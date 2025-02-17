; Générateur de Diagramme de Voronoi
; Utilise le mode VGA 13h (320x200 pixels, 256 couleurs)
; Crée un diagramme à partir de 50 points aléatoires

bits 16                     ; Code 16-bit
org 100h                    ; Format de fichier COM, le code commence à l'offset 100h

; Constantes
POINTS_COUNT equ 50         ; Nombre de points aléatoires à générer

;-------------------------------------------------------------------------------
; Section des Données
;-------------------------------------------------------------------------------
section .data
start:                      ; Point d'entrée du programme
        finit
        call demarrer_mode_graphique
        call generer_points_aleatoires
        call dessiner_voronoi
        call dessiner_points

attendre_touche:
        mov ah, 0
        int 16h

quitter_programme:
        mov ah, 4ch
        int 21h

;-------------------------------------------------------------------------------
; Fonctions de Dessin
;-------------------------------------------------------------------------------
dessiner_voronoi:
        ; Dessine le diagramme de Voronoi en coloriant chaque pixel en fonction du point le plus proche
        ; Pour chaque pixel à l'écran :
        ; 1. Trouver le point le plus proche
        ; 2. Colorier le pixel en fonction de l'indice de ce point
        ; Paramètres :
        ;   al = indice de couleur
        ;   bx = coordonnée y (0-199)
        ;   cx = coordonnée x (0-319)
        mov al, 1              ; Commencer avec l'indice de couleur 1
        mov cx, 0              ; Commencer à x = 0
        mov bx, 0              ; Commencer à y = 0
.pixel_suivant:
        call calculer_point_plus_proche
        
        pusha
        add al, 30
        shl al, 1
        call definir_pixel
        popa
        
        inc cx
        cmp cx, 320
        jne .pixel_suivant
        mov cx, 0
        inc bx
        cmp bx, 200
        jne .pixel_suivant
        ret

;-------------------------------------------------------------------------------
; Calcul des Points
;-------------------------------------------------------------------------------
calculer_point_plus_proche:
        ; Trouve le point le plus proche du pixel actuel en utilisant la distance euclidienne
        ; Utilise l'unité de calcul en virgule flottante (FPU) pour les calculs de distance
        ; Entrée :
        ;   bx = coordonnée y du pixel actuel
        ;   cx = coordonnée x du pixel actuel
        ; Sortie :
        ;   al = indice du point le plus proche (basé sur 1)
        mov al, 0                          ; Initialiser l'indice du point
        push bx
        push cx
        mov word [.cx], cx                 ; Stocker la coordonnée x actuelle
        mov word [.cy], bx                 ; Stocker la coordonnée y actuelle
        mov byte [.indice_plus_proche], 0  ; Initialiser l'indice du point le plus proche
        mov word [.distance_actuelle], 0ffffh; Initialiser la distance actuelle au maximum
        mov word [.distance_plus_proche], 0ffffh; Initialiser la distance la plus proche au maximum
        mov cx, POINTS_COUNT               ; Définir le compteur de boucle au nombre de points
        mov di, 0                          ; Initialiser l'indice du tableau de points
.suivant:
        push cx
        
        fild word [ds:points + di + 2]     ; Charger la coordonnée y
        fild word [.cy]                    ; Charger la coordonnée y actuelle
        fsub st0, st1
        fmul st0, st0
        
        fild word [ds:points + di]         ; Charger la coordonnée x
        fild word [.cx]                    ; Charger la coordonnée x actuelle
        fsub st0, st1
        fmul st0, st0
        
        fadd st0, st2
        fsqrt
        
        fild word [.v100]                  ; Facteur d'échelle
        fmul st0, st1
        
        fistp word [.distance_actuelle]
        ffree st0
        ffree st1
        ffree st2
        ffree st3
        
        mov cx, [.distance_actuelle]
        mov bx, [.distance_plus_proche]
        cmp cx, bx
        jnb .continuer

.definir_nouveau_point_plus_proche:
        mov [.distance_plus_proche], cx
        mov [.indice_plus_proche], al

.continuer:
        add di, 4
        pop cx
        inc al
        loop .suivant
        
        pop cx
        pop bx
        inc byte [.indice_plus_proche]
        mov al, [.indice_plus_proche]
        ret
.cx dw 0
.cy dw 0
.v100 dw 100
.indice_plus_proche db 0
.distance_plus_proche dw 0
.distance_actuelle dw 0

;-------------------------------------------------------------------------------
; Dessin des Points
;-------------------------------------------------------------------------------
dessiner_points:
        ; Dessine tous les points sous forme de carrés noirs de 2x2 pixels
        ; Chaque point est dessiné en noir (couleur 0) pour la visibilité
        mov cx, POINTS_COUNT               ; Définir le compteur de boucle
        mov di, 0                          ; Initialiser l'indice du tableau de points
.suivant:
        push cx
        mov al, 0
        mov cx, word [points + di]
        mov bx, word [points + di + 2]
        add di, 4
        
        pusha
        call definir_pixel
        popa
        
        pusha
        inc cx
        call definir_pixel
        popa
        
        pusha
        inc bx
        call definir_pixel
        popa
        
        pusha
        inc bx
        inc cx
        call definir_pixel
        popa
        
        pop cx
        loop .suivant
        ret

;-------------------------------------------------------------------------------
; Génération des Points
;-------------------------------------------------------------------------------
generer_points_aleatoires:
        ; Génère des points aléatoires dans les limites de l'écran
        ; Les points sont stockés comme des paires (x,y) dans le tableau de points
        ; Les coordonnées x vont de 0 à 319
        ; Les coordonnées y vont de 0 à 199
        mov cx, POINTS_COUNT               ; Définir le compteur de boucle
        mov di, 0                          ; Initialiser l'indice du tableau de points
.suivant:
        push cx
        
        mov bx, 320
        call generer_nombre_aleatoire
        mov word [points + di], dx
        add di, 2
        
        mov bx, 200
        call generer_nombre_aleatoire
        mov word [points + di], dx
        add di, 2
        
        pop cx
        loop .suivant
        ret

;-------------------------------------------------------------------------------
; Fonctions Utilitaires
;-------------------------------------------------------------------------------
generer_nombre_aleatoire:
        ; Génère un nombre pseudo-aléatoire en utilisant l'heure système
        ; Entrée :
        ;   bx = valeur maximale (exclusive)
        ; Sortie :
        ;   dx = nombre aléatoire dans l'intervalle [0, bx-1]
        mov ah, 0
        int 1ah                           ; Obtenir l'heure système (cx:dx = ticks d'horloge)
        push cx
        push dx
        
        mov ax, dx
        mul cx
        xor ax, [.graine]
        xor dx, dx
        div bx                            ; dx = reste de la division
        
        pop bx
        pop cx
        add [.graine], bx
        add [.graine], cx
        ret
.graine dw 0

demarrer_mode_graphique:
        ; Initialise le mode VGA 13h (320x200, 256 couleurs)
        ; Configure le segment ES pour pointer vers la mémoire vidéo à A000:0000
        mov ax, 0a000h                     ; Segment de mémoire vidéo
        mov es, ax                         ; Définir ES au segment vidéo
        mov ah, 0                          ; Fonction 0 - définir le mode vidéo
        mov al, 13h                        ; Mode 13h - 320x200, 256 couleurs
        int 10h                           ; Appeler l'interruption vidéo BIOS
        ret

definir_pixel:
        ; Définit un pixel à l'écran
        ; Entrée :
        ;   al = couleur (0-255)
        ;   bx = coordonnée y (0-199)
        ;   cx = coordonnée x (0-319)
        pusha                             ; Sauvegarder tous les registres
        xor dx, dx                        ; Effacer DX pour la multiplication
        push ax                           ; Sauvegarder la couleur
        mov ax, 320                       ; Largeur de l'écran
        mul bx                            ; Calculer y * 320
        add ax, cx                        ; Ajouter l'offset x
        mov bx, ax                        ; Déplacer l'offset vers BX
        pop ax                            ; Restaurer la couleur
        mov byte [es:bx], al              ; Écrire le pixel dans la mémoire vidéo
        popa                              ; Restaurer tous les registres
        ret

;-------------------------------------------------------------------------------
; Section BSS
;-------------------------------------------------------------------------------
section .bss
points resw POINTS_COUNT * 2               ; Tableau pour stocker les coordonnées des points