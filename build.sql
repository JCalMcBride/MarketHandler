create database if not exists market;
use market;

drop table if exists item_statistics;
drop table if exists item_subtypes;
drop table if exists item_mod_ranks;
drop table if exists items_in_set;
drop table if exists item_tags;
drop table if exists item_aliases;
drop table if exists word_aliases;
drop table if exists username_history;
drop table if exists market_users;
drop table if exists items;


CREATE TABLE items
(
    id        VARCHAR(255) PRIMARY KEY,
    item_name VARCHAR(255),
    item_type VARCHAR(255),
    url_name  VARCHAR(255),
    thumb     VARCHAR(255),
    max_rank  INT DEFAULT NULL
);

CREATE TABLE items_in_set
(
    item_id VARCHAR(255),
    set_id  VARCHAR(255),
    PRIMARY KEY (item_id, set_id),
    FOREIGN KEY (item_id) REFERENCES items (id),
    FOREIGN KEY (set_id) REFERENCES items (id)
);

CREATE TABLE item_tags
(
    item_id VARCHAR(255),
    tag     VARCHAR(255),
    PRIMARY KEY (item_id, tag),
    FOREIGN KEY (item_id) REFERENCES items (id)
);

CREATE TABLE item_subtypes
(
    item_id  VARCHAR(255),
    sub_type VARCHAR(255),
    PRIMARY KEY (item_id, sub_type),
    FOREIGN KEY (item_id) REFERENCES items (id)
);

CREATE TABLE item_statistics
(
    id           VARCHAR(255),
    datetime     TIMESTAMP,
    item_id      VARCHAR(255),
    volume       INT,
    min_price    DECIMAL(10, 2),
    max_price    DECIMAL(10, 2),
    avg_price    DECIMAL(10, 2),
    wa_price     DECIMAL(10, 2),
    median       DECIMAL(10, 2),
    order_type   ENUM ('Buy', 'Sell', 'Closed') DEFAULT NULL,
    subtype      VARCHAR(255)                   DEFAULT NULL,
    moving_avg   DECIMAL(10, 2)                 DEFAULT NULL,
    open_price   DECIMAL(10, 2)                 DEFAULT NULL,
    closed_price DECIMAL(10, 2)                 DEFAULT NULL,
    mod_rank     INT                            DEFAULT NULL,
    donch_bot    DECIMAL(10, 2)                 DEFAULT NULL,
    donch_top    DECIMAL(10, 2)                 DEFAULT NULL,
    PRIMARY KEY (item_id, datetime),
    FOREIGN KEY (item_id) REFERENCES items (id)
);

CREATE TABLE item_aliases (
    item_id VARCHAR(255),
    alias VARCHAR(255),
    PRIMARY KEY (item_id, alias),
    FOREIGN KEY (item_id) REFERENCES items (id)
);

CREATE TABLE word_aliases (
    word VARCHAR(255),
    alias VARCHAR(255),
    PRIMARY KEY (word, alias)
);

CREATE TABLE market_users (
    user_id VARCHAR(255),
    ingame_name VARCHAR(255),
    PRIMARY KEY (user_id)
);

CREATE TABLE username_history (
    user_id VARCHAR(255),
    ingame_name VARCHAR(255),
    datetime TIMESTAMP,
    PRIMARY KEY (user_id, ingame_name),
    FOREIGN KEY (user_id) REFERENCES market_users (user_id)
);

CREATE INDEX idx_item_statistics_optimized
ON item_statistics (item_id, datetime, order_type);

CREATE INDEX idx_item_statistics_2
ON item_statistics (datetime, item_id);

CREATE INDEX idx_item_order
ON item_statistics (item_id, order_type);


INSERT INTO `word_aliases` VALUES ('blueprint','bp'),('blueprint','nude'),('blueprint','nudes'),('chassis','boob'),('chassis','boobies'),('chassis','boobs'),('chassis','booby'),('chassis','honkers'),('chassis','tit'),('chassis','titties'),('chassis','titty'),('handle','cock'),('neuroptics','brain'),('neuroptics','head'),('systems','milk');

INSERT INTO `item_aliases` VALUES ('54a74455e779892d5e5156f3','morbid'),('55a469a4e7798902410538b1','stuff'),('566751295dcbc186f0536bd1','energize'),('566751295dcbc186f0536bd1','gize'),('56783f24cbfa8f0432dd898f','ninja'),('56783f24cbfa8f0432dd898f','ninja boi'),('56783f24cbfa8f0432dd898f','ninja boy'),('56783f24cbfa8f0432dd8995','banana'),('56783f24cbfa8f0432dd8999','kamas'),('56783f24cbfa8f0432dd899a','fire'),('56783f24cbfa8f0432dd899a','fire chicken'),('56783f24cbfa8f0432dd899a','fire girl'),('56783f24cbfa8f0432dd899a','fire lady'),('56783f24cbfa8f0432dd899a','hot'),('56783f24cbfa8f0432dd899a','hot girl'),('56783f24cbfa8f0432dd899a','hot lady'),('56783f24cbfa8f0432dd899a','lele'),('56783f24cbfa8f0432dd899a','spike head'),('56783f24cbfa8f0432dd899c','cold'),('56783f24cbfa8f0432dd899c','cold boy'),('56783f24cbfa8f0432dd899c','cold dude'),('56783f24cbfa8f0432dd899c','cold guy'),('56783f24cbfa8f0432dd899c','cold man'),('56783f24cbfa8f0432dd899c','cool'),('56783f24cbfa8f0432dd899c','cool boy'),('56783f24cbfa8f0432dd899c','cool dude'),('56783f24cbfa8f0432dd899c','cool guy'),('56783f24cbfa8f0432dd899c','ice'),('56783f24cbfa8f0432dd899c','ice boy'),('56783f24cbfa8f0432dd899c','ice dude'),('56783f24cbfa8f0432dd899c','ice guy'),('56783f24cbfa8f0432dd899c','icy'),('56783f24cbfa8f0432dd899c','icy boy'),('56783f24cbfa8f0432dd899c','icy dude'),('56783f24cbfa8f0432dd899c','icy guy'),('56783f24cbfa8f0432dd899d','frisbee'),('56783f24cbfa8f0432dd89a1','latrine'),('56783f24cbfa8f0432dd89a3','dogshit trash'),('56783f24cbfa8f0432dd89a3','invisible boi'),('56783f24cbfa8f0432dd89a3','invisible boy'),('56783f24cbfa8f0432dd89a3','invisible dude'),('56783f24cbfa8f0432dd89a3','invisible guy'),('56783f24cbfa8f0432dd89a3','invisible man'),('56783f24cbfa8f0432dd89a3','noki'),('56783f24cbfa8f0432dd89a3','trashki'),('56783f24cbfa8f0432dd89a4','attractive girl'),('56783f24cbfa8f0432dd89a4','attractive lady'),('56783f24cbfa8f0432dd89a4','hathena'),('56783f24cbfa8f0432dd89a4','magnetic girl'),('56783f24cbfa8f0432dd89a4','magnetic lady'),('56783f24cbfa8f0432dd89a5','bofa'),('56783f24cbfa8f0432dd89a5','portal girl'),('56783f24cbfa8f0432dd89a5','portal lady'),('56783f24cbfa8f0432dd89a5','voltage'),('56783f24cbfa8f0432dd89a6','brain girl'),('56783f24cbfa8f0432dd89a6','brain lady'),('56783f24cbfa8f0432dd89a6','mind control girl'),('56783f24cbfa8f0432dd89a6','mind control lady'),('56783f24cbfa8f0432dd89a7','awful'),('56783f24cbfa8f0432dd89a7','disgusting'),('56783f24cbfa8f0432dd89a7','eww'),('56783f24cbfa8f0432dd89a7','itsjustapieceofjunk'),('56783f24cbfa8f0432dd89a7','worst'),('56783f24cbfa8f0432dd89aa','grim'),('56783f24cbfa8f0432dd89ab','big dick'),('56783f24cbfa8f0432dd89ab','strong guy'),('56783f24cbfa8f0432dd89ab','strong man'),('56783f24cbfa8f0432dd89ab','stronk guy'),('56783f24cbfa8f0432dd89ab','stronk man'),('56783f24cbfa8f0432dd89ab','tank guy'),('56783f24cbfa8f0432dd89ab','tank man'),('56783f24cbfa8f0432dd89af','healing girl'),('56783f24cbfa8f0432dd89af','healing lady'),('56783f24cbfa8f0432dd89af','lobster'),('56783f24cbfa8f0432dd89af','lobster girl'),('56783f24cbfa8f0432dd89af','lobster lady'),('56783f24cbfa8f0432dd89b1','kektis'),('56783f24cbfa8f0432dd89b2','copium'),('56783f24cbfa8f0432dd89b2','electric'),('56783f24cbfa8f0432dd89b2','electric male'),('56783f24cbfa8f0432dd89b2','pogolt'),('56783f24cbfa8f0432dd89b2','taser'),('56783f24cbfa8f0432dd89b2','taser man'),('56783f24cbfa8f0432dd89b2','taserman'),('56783f24cbfa8f0432dd89b2','trasholt'),('56783f24cbfa8f0432dd89b2','zappy'),('567af35fcbfa8f05d076a51e','meme mod'),('56c3bbe45d2f0202da32e93e','mommy milkers'),('56c3bbea5d2f0202da32e93f','poison girl'),('56c3bbea5d2f0202da32e93f','poison lady'),('56c3bbea5d2f0202da32e93f','toxic girl'),('56c3bbea5d2f0202da32e93f','toxic lady'),('56c3bbea5d2f0202da32e93f','toxin girl'),('56c3bbea5d2f0202da32e93f','toxin lady'),('56c3bbea5d2f0202da32e93f','wholesuhm'),('56c3bbfc5d2f0202da32e943','legaliize'),('573b7fcc0ec44a47787a6910','booben'),('573b7fcc0ec44a47787a6910','buben'),('573b7fcc0ec44a47787a6910','golden boy'),('573b7fcc0ec44a47787a6910','train'),('573b7fcc0ec44a47787a6910','train dude'),('573b7fcc0ec44a47787a6910','train guy'),('573b7fcc0ec44a47787a6910','train man'),('573b7fcc0ec44a47787a6910','trainman'),('57bc9a40e506eb45ea251451','bone'),('57bc9a40e506eb45ea251451','bone daddy'),('57bc9a40e506eb45ea251451','spooky guy'),('58358a0e2c2ada0047b386fa','angry girl'),('58358a0e2c2ada0047b386fa','angry lady'),('58358a0e2c2ada0047b386fa','cat'),('58358a0e2c2ada0047b386fa','cat girl'),('58358a0e2c2ada0047b386fa','cat lady'),('58358a0e2c2ada0047b386fa','catgirl'),('58358a0e2c2ada0047b386fa','catlady'),('58358a0e2c2ada0047b386fa','sui'),('58358a0e2c2ada0047b386fa','valkitty'),('58b57068eb26db5c3119210e','ishtar'),('58b57068eb26db5c3119210e','loud girl'),('58b57068eb26db5c3119210e','loud lady'),('58b57068eb26db5c3119210e','screamer'),('592dd262011e88f094afec81','broberon'),('592dd262011e88f094afec81','goat'),('592dd262011e88f094afec81','goat guy'),('592dd262011e88f094afec81','goat man'),('592dd262011e88f094afec81','goatman'),('592dd262011e88f094afec8b','silva'),('59a48b625cd9938cfede703c','best'),('59a48b625cd9938cfede703c','davy jones'),('59a48b625cd9938cfede703c','god'),('59a48b625cd9938cfede703c','guthix'),('59a48b625cd9938cfede703c','hentoid'),('59a48b625cd9938cfede703c','illern'),('59a48b625cd9938cfede703c','jake'),('59a48b625cd9938cfede703c','pirate dude'),('59a48b625cd9938cfede703c','pirate guy'),('59a48b625cd9938cfede703c','pirate man'),('59a48b625cd9938cfede703c','tentacle'),('59a48b625cd9938cfede703c','tentacle dude'),('59a48b625cd9938cfede703c','tentacle guy'),('59a48b625cd9938cfede703c','tentacle man'),('59a5c2565cd9938cfede7040','nami'),('5a26c31dc2c9e903a8381330','lead'),('5a2feeb2c2c9e90cbdaa23d3','disco'),('5a2feeb2c2c9e90cbdaa23d3','disco girl'),('5a2feeb2c2c9e90cbdaa23d3','disco lady'),('5a2feeb2c2c9e90cbdaa23d3','discogirl'),('5a2feeb2c2c9e90cbdaa23d3','discolady'),('5a2feeb2c2c9e90cbdaa23d3','verka'),('5ab1570db2b6a8044d5137c5','birb'),('5ab1570db2b6a8044d5137c5','bird'),('5ab1570db2b6a8044d5137c5','bird girl'),('5ab1570db2b6a8044d5137c5','bird lady'),('5b2985e3eb069f04ea65b0fa','pograna'),('5b2987abeb069f0536234278','limbno'),('5b2987abeb069f0536234278','top hat dude'),('5b2987abeb069f0536234278','top hat guy'),('5ba9f2034567de01415f638b','dragon'),('5ba9f2034567de01415f638b','dragon boy'),('5ba9f2034567de01415f638b','dragon guy'),('5ba9f2034567de01415f638b','stinky'),('5c182b739603780081b09a53','cow girl'),('5c182b739603780081b09a53','cowgirl'),('5c182b739603780081b09a53','gun girl'),('5c182b739603780081b09a53','gun lady'),('5c182b739603780081b09a53','mccree'),('5c182b739603780081b09a53','shooty girl'),('5c182b739603780081b09a53','shooty lady'),('5ca28670fc2db2035eae059e','ying yang'),('5ca28670fc2db2035eae059e','ying yang girl'),('5d21ce48f4604c012d1e0c18','monke'),('5d21ce48f4604c012d1e0c18','monkey'),('5d21ce48f4604c012d1e0c18','wudong'),('5d9385b17ea27b0a28fd75b9','aloo'),('5d9385b17ea27b0a28fd75b9','fist guy'),('5d9385b17ea27b0a28fd75b9','one punch man'),('5d9385b17ea27b0a28fd75b9','rock stone'),('5d93ca117ea27b0a87566f6b','deth'),('5d93ca117ea27b0a87566f6b','ducatcube'),('5dbe9b0b7ea27b0ffe3ca26e','faras'),('5df8b0ab1456970087cd9b00','ahsoka'),('5df8b0ab1456970087cd9b00','guify'),('5df8b0ab1456970087cd9b00','invisible girl'),('5df8b0ab1456970087cd9b00','invisible lady'),('5df8b0ab1456970087cd9b00','jellyfish'),('5df8b0ab1456970087cd9b00','squid'),('5e839496267539077b0dd6d3','bug lady'),('5e839496267539077b0dd6d3','butterfly'),('5e839496267539077b0dd6d3','fairy'),('5e839496267539077b0dd6d3','fairy girl'),('5e839496267539077b0dd6d3','fairy lady'),('5e839496267539077b0dd6d3','pixie'),('5e839496267539077b0dd6d3','pixie girl'),('5e839496267539077b0dd6d3','pixie lady'),('5e839496267539077b0dd6d3','robo'),('5e839496267539077b0dd6d3','robost3alth'),('5e839496267539077b0dd6d3','robostealth'),('5e839496267539077b0dd6d3','tit ass'),('5e839496267539077b0dd6d3','titass'),('5f0deab69f527b024d48f055','brozime'),('5f0deab69f527b024d48f055','s-tier tank'),('5f0deab69f527b024d48f055','sand'),('5f0deab69f527b024d48f055','sand boy'),('5f0deab69f527b024d48f055','sand dude'),('5f0deab69f527b024d48f055','sand guy'),('5f0deab69f527b024d48f055','sandy'),('5f986cfc9dbdce024971b0c2','chakram guy'),('5f986cfc9dbdce024971b0c2','sarv'),('603621500a372600fd5614dc','music'),('603621500a372600fd5614dc','music girl'),('603621500a372600fd5614dc','music lady'),('6054dd125221e30057500f1c','eli'),('6054dd475221e30057500f48','literal dogshit'),('6054de1e5221e30057501022','alex'),('60ad4a1bf1904300d012c701','glass'),('60ad4a1bf1904300d012c701','glass girl'),('60ad4a1bf1904300d012c701','glass lady'),('60f3feb1b64404003f0bf5fb','god gamer from chair clan'),('6139101930dd5b004b7f909e','infested'),('6139101930dd5b004b7f909e','infested dude'),('6139101930dd5b004b7f909e','infested guy');

