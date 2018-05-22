# Progetto Programmazione Web - Idee

### Per il database

Entità da creare:
* Utente (con un _boolean_ per definire un admin)
* Shopping List
* Prodotto
* Categoria prodotto (**ID**, Nome)
* Categoria Shopping List (**ID**, Nome)

### Idee sparse

Una lista della spesa può contenere solo elementi di un particolare prodotto.

La **Landing Page** deve permettere ad un utente di registrarsi/eseguire il login, con form per ciascuno

Deve esserci la possibilità di creare una lista per l'utente anonimo.

Un utente anonimo deve poter mantenere salvate le proprie liste tramite cookie/**sessione**.

Il login deve portare l'utente alla Landing Page.

Un utente anonimo può essere owner delle proprie liste, tramite l'uso delle sessioni. **NON PUO' condividere**.

Un utente anonimo che fa a disposizione delle liste e fa il login **deve avere le liste che ha creato da anonimo anche sul proprio account**. Si può fare tramite un controllo della sessione attuale con quanto salvato nelle tabelle.
