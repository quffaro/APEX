create sequence mtg_seq_decks ;

create table mtg_decks (
	deck_id number(10) not null 
	,user_id number(10) not null 
	,deck_name varchar2(255) not null 
	,format_id number(10) not null 
	,card_count number(10) not null 
	,constraint mtg_deck_pk primary key (deck_id)
) ;

create or replace trigger mtg_trg_decks 
	before insert on mtg_decks 
	for each row 
	when (new.deck_id is null)
	begin 
		select mtg_seq_decks.nextval 
		into   :new.deck_id
		from   dual;
	end ;
/

---
create table mtg_jn_deck_card (
	deck_id number(10) not null 
	,card_id number(10) not null 
	,qty number(10) default 1
) ;


