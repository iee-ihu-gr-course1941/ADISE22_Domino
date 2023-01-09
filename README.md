#LINK
https://users.iee.ihu.gr/~it144347/ADISE22_Domino/www/index.html
# ADISE22_Domino

Η εργασία αυτή γίνεται στα πλαίσια του μαθήματος Ανάπτυξη Διαδικτυακών Συστημάτων & Εφαρμογών που διδάσκεται στο χειμερινό εξάμηνο για το έτος 2022 στο Τμήμα Πληροφορικής και Ηλεκτρονικής Διεθνούς Πανεπιστήμιου Ελλάδος (ΔΙΠΑΕ). Η Εργασία αυτή υλοποιείται στην αρχιτεκτονική WebAPI σε php/mysql/ajax/ (jquery).


## Σκοπός του παιχνιδιού
Σκοπός του παιχνιδιού είναι να τοποθετήσει πρώτος
ο παίκτης όλα τα πλακίδια του στο τραπέζι. Δηλαδή ο παίχτης που
δεν θα έχει άλλα πλακίδια στο χέρι του είναι και ο Νικητής. Τοποθετώντας τα σωστά πλακίδια
στους πίνακες.

ΚΑΝΟΝΕΣ ΠΑΙΧΝΙΔΙΟΎ
ΑΝ είναι κάτω στο board πχ. 2-4, 4-6 ο παίχτης χ θα πρέπει να παίξει ένα πλακίδιο οπού αποτελείτε
με 2 η 6 αλλιώς μπορεί και να τραβήξει αλλιώς θα χάσει την σειρά του
Ο παίχτης που μένει χωρίς πλακίδια κερδίζει.

## Το project
Το project αποτελείτε από την βάση που περιέχει τους πίνακες
board, board_empty, gamestatus, players, sharetile, tile
επισεις υπάρχει ενασ πίνακας clonetile για την βοήθεια
να μοιράσουμε τα tiles έτσι ώστε να μην έχουμε διπλό έγραφες και επισεις η βάση ολοκληρώνεται
με τα procedure check_aboard,check_play,cherck_result,cleanboard,draw_tile,play_tile,
tile_shuffle,update_sharetile,update_turn.

Έπειτα είναι υλοποιημένο σε php για το API κώδικα με με ($. ajax) javascript κώδικα για την μεριά του client Και τα κατάλληλα css
για τα html αρχεία και to bootstrap

Ενώ από την μεριά του server είναι υλοποιημένο σε php χρησιμοποιώντας σε php/mysql/ (jquery).
όπου έχουμε τα 4 αρχεία board. php, game. php, players. php για την εφαρμογή και για τη σύνδεση της βάσης
το dbconnnection. php
## API Reference

#### Get all items

```http
  GET /API/domino.php/players
   {
        "name": "aggelos",
        "id": 1
         
        "name": "aggelos2",
        "id": 2
    
    }
   Η μέθοδος αυτή επιστρέφει τα ονόματα και και τα id από τον πινάκα players
έτσι ξέρουμε αν υπάρχουν αρκετοί παίχτες έτσι ώστε
το παιχνίδι να ξεκινήσει που θα το δούμε στην συνεχεία

    GET /API/domino.php/players/1
     {
        "name": "aggelos"
    }
    επιστρεφει τον 1ο παιχτη
    
```
```http
  PUT /API/domino.php/players
   {
        "name":"aggelos"
    }
Η μέθοδος αυτή καταχωρεί έναν παίχτη στον πινάκα της βάσης μας με το όνομα aggelos
μόνο αυτό χρειαζόμαστε να βάλουμε τα υπόλοιπα καταχωρούνται αυτόματα εκτός του result
που παίρνει την τιμή =' win' μόνο αν ο παίχτης δεν έχει αλλά Ντόμινο στο χέρι του
'' '
Ο Πινάκας players αποθηκεύει τους υπάρχων παίχτες στον πινάκα.
ENTITIES

PLAYERS 
| Parameter   |   Type      |    |Description                |
| :--------   |   :-------  |    |:------------------------- |
|   `id`      |   `int`     |    | NOT NULL AUTO_INCREMENT   |
|   `name`    |   `varchar` |    |the name of the player     |
|  `token`    |   `varchar` |    |an MD5 Token of the player |
|`last_action`| `timestamp` |    |update current_timestamp() |
|   `result`  |   `varchar` |    | DEFAULT NULL(only ="win") |


#### Get item

```http
  GET /API/domino.php/board

   {
        "bid": "1",
        "btile": null,
        "last_change": "2023-01-08 01:03:09"
    },
    {
        "bid": "2",
        "btile": null,
        "last_change": "2023-01-08 01:03:09"
    }
```
```http
  POST /API/domino.php/board
    Ο πινάκας board δεν έχει έγραφες
```
BOARD
| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `bid`      |  `enum('1','2')`   | primary key NOT NULL AUTO_INCREMENT |
| `btile`      |  `varchar`   | DEFAULT NULL (takes the value with playing) |
| `firstvalue`      |  `secondvalue`   | DEFAULT NULL (takes the value with playing) |
| `last_change`      |  `timestamp`   | DEFAULT current_timestamp() |

```http
  GET /API/domino.php/tiles

   {
        "id": 0,
        "tile_name": "0-6",
        "player_name": "aggelos"
    },
    {
        "id": 1,
        "tile_name": "3-4",
        "player_name": "aggelos2"
    }
επιστρέφει τον πινάκα με τα tiles μοιρασμένα όλα ισάξια

```

```http
  GET /API/domino.php/tiles/aggelos
   {
        "id": 0,
        "tile_name": "0-6",
        "player_name": "aggelos"
    },
    {
        "id": 12,
        "tile_name": "3-5",
        "player_name": "aggelos"
    }
Επιστρεφει τα tiles οπου ονομα aggelos 
```
```http
  PUT /API/domino.php/tiles

Αυτη η μεθοδο μοιραζει 7 tiles στον καθε παιχτι
```
tile
| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `tilename`      |  `varchar`   | primary key NOT NULL |
| `firstvalue`      |  `int`   | NOT NULL|
| `secondvalue`      |  `int`   | NOT NULL |

sharetile
| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `id`      |  `int`   | primary key NOT NULL |
| `tile_name`      |  `varchar`   | DEFAULT NULL|
| `player_name`      |  `varchar`   | DEFAULT NULL |

```http
  GET /API/domino.php/status
    
    {
        "id": 1,
        "status": "started",
        "p_turn": "1",
        "last_change": "2023-01-08 21:08:18"
    }
Αυτη η μεθοδος μας εμφανιζει την κατασταση δηλαδη ολα τα στοιχεια του πινακα gamestatus
```

gamestatus
| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `id`      |  `int`   | primary key NOT NULL AUTO_INCREMENT |
| `status`      |  `varchar`   |initialized,started,ended,aborted NOT NULL DEFAULT initialized|
| `p_turn`      |  `int`   | enum('1','2') DEFAULT NULL |
| `last_change`      |  `timestamp`   |NULL DEFAULT current_timestamp |


```http
  GET /API/domino.php/play
Αυτή η μέθοδος μας εμφανίζει την κατάσταση δηλαδή όλα τα στοιχειά
του πινάκα board για να δούμε αν έπαιξαν οι παίχτες
```
```http
  PUT /API/domino.php/play
    
 Aυτη η μέθοδος μας καλεί την συνάρτηση call play_tile (tile_name, player_name)
από την βάση μας μεσώ sql query πραγματοποιώντας τους καταλλήλους έλεγχους και
κατάλληλες αλλαγές ενημερώνοντας τον πινάκα board και αλλάζοντας σειρά παιχνιδιού
    
```

```http
  GET /API/domino.php/abort
  
Αυτή η μέθοδος μας ενημερώνει τον πινάκα gamestatus
κάνοντας call check_aboart που είναι συνάρτηση στην βάση μας
κάνοντας του καταλλήλους έλεγχους και έπειτα ενημερώνει την
κατάσταση abort στον πινάκα gamestatus και το παιχνίδι τερματίζει
```



```http
  PUT /API/domino.php/draw

    Η μέθοδος αυτή μας επιτρέπει πχ να τραβήξουμε ένα tile δηλαδή ο χρήστης πχ aggelos
έχει 5 tiles Και θέλει να τραβήξει θα ορίσει στον πινάκα
sharetile ακόμα ένα όνομα aggelos τυχαί
```







## Authors

    ΛΟΥΣΙ ΑΝΤΖΕΛΟ 144347
    ADISE22_DOMINO

