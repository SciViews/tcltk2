# fr.msg --
#
#	French-language messages for KHIM
#
# Copyright (c) 2015 by Philippe Grosjean.
#
# Refer to the file "license.terms" for the terms and conditions of
# use and redistribution of this file, and a DISCLAIMER OF ALL WARRANTEES.
#
# $Id: fr.msg,v 103 2015/12/27 02:00:19 kennykb Exp $
# $Source: /cvsroot/tcllib/tklib/modules/khim/es.msg,v $
#
#----------------------------------------------------------------------

namespace eval ::khim {

    ::msgcat::mcset fr HELPTEXT {

	Kevin's Hacky Input Method (KHIM)

	KHIM permet de taper des caractères internationaux depuis un
	clavier qui ne les supporte pas. Il fonctionne de manière
	indépendante de toute méthode d'entrée que l'OS propose; Il est
	prévu pour les cas où vous n'avez pas de contrôle sur le clavier
	et devez toutefois taper du texte dans un autre langage.

	Pour utiliser KHIM, sélectionnez la boite de dialogue KHIM (la
	façon d'y arriver dépend de l'application) et activez KHIM en
	sélectionnant "Utiliser KHIM". Vous devez également choisir une
	touche rarement utilisée, et qui sera votre touche de "Composition"
	en appuyant sur "Touche de composition:", et en appuyant ensuite
	sur la touche que vous souhaitez utiliser. De manière générale,
	cette touche ne doit pas être celle de composition du clavier;
	cette dernière doit en effet encore servir à ce rôle par rapport
	au fonctionnement classique de votre clavier.
	
	Une fois KHIM activé, vous pouvez entrer des caractères
	internationaux dans n'importe quel widget configuré pour utiliser
	KHIM en tapant la touche de composition suivie des deux touches
	formant une séquence KHIM. La liste indique l'ensemble des
	séquences connues par KHIM. De plus, si vous tapez la touche de
	composition deux fois de suite, vous obtenez une boite de dialogue
	qui vous permet d'entrer n'importe quel symbole d'une table de
	caractères Unicode. Vous pouvez naviguer dans cette table à l'aide
	des touches curseurs ou de la souris, et vous pouvez sélectionner
	un caractère pour son insertion par double-clic, en appuyant sur
	la barre espace, ou en appuyant sur la touche entrée.
	
	Pour définir une nouvelle séquence à utiliser avec la touche de
	composition, activez le configurateur KHIM, entrez les deux
	caractères dans la "Séquence d'entrée" et le caractère désiré dans
	"Caractère", et appuyez sur "Changer". (Vous pouvez copier-coller
	le caractère depuis une autre application, ou utiliser le bouton
	"Unicode..." (ou appuyer sur la touche de composition deux fois)
	pour sélectionner le caractère depuis la table unicode.) Pour
	éliminer une séquence, sélectionnez-là dans la liste et appuyez
	"Effacer".

    }

    ::msgcat::mcset fr {SELECT COMPOSE KEY} [string map [list \n\t \n] {
	Veuillez appuyer
	sur la touche
	à utiliser pour
	la "Composition".
    }]

    ::msgcat::mcset fr {Apply} {Appliquer}

    ::msgcat::mcset fr {Cancel} {Annuler}

    ::msgcat::mcset fr {Change} {Changer}

    ::msgcat::mcset fr {Character} {Charactère}

    ::msgcat::mcset fr {Compose Key} {Touche de composition}

    ::msgcat::mcset fr {Compose key:} {Touche de composition:}

    ::msgcat::mcset fr {Composed sequence must be two characters long} \
	{La séquence de composition doit comporter deux caractères}

    ::msgcat::mcset fr {Delete} {Effacer}

    ::msgcat::mcset fr {KHIM Help} {Aide de KHIM}

    ::msgcat::mcset fr {Help...} {Aide...}

    ::msgcat::mcset fr {Input key sequence} {Séquence d'entrée}

    ::msgcat::mcset fr {Insert Character} {Insérer le charactère}

    ::msgcat::mcset fr {Invalid sequence} {Séquence invalide}

    ::msgcat::mcset fr {Key sequences} {Séquences de touches}

    ::msgcat::mcset fr {KHIM Controls} {Contrôles de KHIM}

    ::msgcat::mcset fr {OK} {OK}

    ::msgcat::mcset fr {Select code page:} {Sélectionner la page de code:}

    ::msgcat::mcset fr {Unicode...} {Unicode...}

    ::msgcat::mcset fr {Use KHIM} {Utiliser KHIM}
	
	::msgcat::mcset fr {Do you want to save this configuration on disk?} \
    {Voulez-vous sauvegarder cette configuration sur disque?}

}