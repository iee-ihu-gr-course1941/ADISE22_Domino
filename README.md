
# ADISE22_Domino

Η εργασια αυτη γινεται στα πλαισια του μαθήματος Ανάπτυξη
 Διαδικτυακών Συστημάτων & Εφαρμογών 
 που διδασκεται στο χειμερινο εξαμηνο για το ετος 2022 στο 
 Τμημα Πληροφορικης και Ηλεκτρονικης Διεθνους Πανεπηστημιου Ελλαδος (ΔΙΠΑΕ).
 Η Εργασια αυτη  υλοποιείται στην αρχιτεκτονικη  WebAPI σε php/mysql/ajax/(jquery).


## Σκοπος του παιχνιδιου
Σκοπός του παιχνιδιού είναι να τοποθετήσει πρώτος 
ο παίκτης όλα τα πλακίδιά του στο τραπέζι.Δηλαδη ο παιχτης που 
δεν θα εχει αλλα πλακίδιά στο χερι του ειναι και ο Νικητης.Τοποθετοντας τα σωστα πλακιδια 
στους πινακες.

ΚΑΝΟΝΕΣ ΠΑΙΧΝΙΔΙΟΥ
ΑΝ ειναι κατω στο board πχ. 2-4,4-6 ο παιχτης χ θα πρεπει να παιξει ενα πλακιδιιο οπου αποτελειτε 
με 2 η 6 αλλιως μπορει και να τραβηξει αλλιως θα χασει την σειρα του 
Ο παιχτης που μενει χωρις πλακιδια κερδιζει.

## Το project
Το project αποτελειτε απο την  βαση που περιεχει τους πινακες
board,board_empty,gamestatus,players,sharetile,tile
επισεις υπαρχει ενασ πινακας clonetile για την βοηθεια 
να μοιρασουμε τα tiles ετσι ωστε να μην εχουμε διπλο εγραφες και επισεις η βαση ολοκληρωνεται
με τα procedure check_aboard,check_play,cherck_result,cleanboard,draw_tile,play_tile,
tile_shuffle,update_sharetile,update_turn.

Επειτα ειναι υλοποιημενο σε php για το API  κωδικα με με ($.ajax)javascript  κωδικα για την μερια του client Και τα καταληλα css
για τα html αρχεια και  to bootstrap

Ενω απο την μερια του σερβερ ειναι υλοποιημενο σε php χρησημοποιηοντας  σε php/mysql/(jquery).
οπου εχουμε τα 4 αρχεια board.php,game.php,players.php για την εφαρμογη και για τη συνδεση της βασης 
το dbconnnection.php
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
    Η μεθοδος αυτη επιστρεφει τα ονοματα και και τα id απο τον πινακα players 
    ετσι ξερουμε αν υπαρχουν αρκετοι παιχτες ετσι ωστε
    το παιχνιδι να ξεκινησει που θα το δουμε στην συνεχεια

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
Η μεθοδος αυτη καταχωρη εναν παιχτη στον πινακα τησ βασης μας με το ονομα aggelos
    μονο αυτο χρειαζομαστε να βαλουμε τα υπολοιπα καταχωρουντε αυτοματα εκτος του result 
    που παιρνει την τιμη='win' μονο αν ο παιχτης δεν εχει αλλα Ντομινο στο χερι του 
```
Ο Πινακας players αποθηκευη τους υπαρχων παιχτες στον πινακα.
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
    Καθαριζει τον πινακα της βασης μασ 
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
επιστρεφει τον πινακα με τα tiles μοιρασμενα ολα ισαξια

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
Αυτη η μεθοδος μας εμφανιζει την κατασταση δηλαδη ολα τα στοιχεια 
του πινακα board για να δουμε αν επαιξαν οι παιχτες
```
```http
  PUT /API/domino.php/play
    
 Aυτη η μεθοδος μας καλει την συναρτηση call play_tile(tile_name,player_name) 
 απο την βαση μας μεσω sql query πραγματοποιοντας τους καταληλους ελεγχους και  
 καταληλες αλλαγες ενημερωνντας τον πινακα board και αλλαζοντας σειρα παιχνιδιου
    
```

```http
  GET /API/domino.php/abort
Αυτη η μεθοδος μας ενημερωνει τον πινακα gamestatus
 κανοντας call check_aboart που ειναι συναρτηση στην βαση μας
κανοντας του καταληλους ελεγχους και επειτα ενημερωνει την 
κατασταση abort στον πινακα gamestatus και το παιχνιδι τερματιζει 
```



```http
  PUT /API/domino.php/draw

    Η μεθοδος αυτη μας επιτρεπει πχ να τραβηξουμε ενα tile δηλαδη ο χρηστης πχ aggelos
        εχει 5 tiles Και θελει να τραβειξει θα ορισει στον πινακα 
        sharetile ακομα ενα ονομα aggelos τυχαια 
    
```







## Authors

    ΛΟΥΣΙ ΑΝΤΖΕΛΟ 144347
    ADISE22_DOMINO

