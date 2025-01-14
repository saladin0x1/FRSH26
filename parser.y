%{
#include <stdio.h>      // Inclut la bibliothèque standard pour les entrées/sorties
#include <ctype.h>      // Inclut la bibliothèque pour les fonctions de traitement de caractères
#include <stdlib.h>     // Inclut la bibliothèque pour srand et rand
#include <time.h>       // Inclut la bibliothèque pour time

// Déclarations en avant pour les fonctions
void frsh26(char *ch, int shift);  // Déclare la fonction frsh26 avec un paramètre de décalage
int generate_shift(int base_shift, int index);  // Déclare la fonction generate_shift

extern char *yytext;      // Déclare yytext (généré par Flex, contient le texte actuel analysé)
extern int yylex();       // Déclare yylex (généré par Flex, utilisé pour analyser les tokens)
extern int yyerror(char *s); // Déclare yyerror pour la gestion des erreurs
%}

%token LETTER      // Déclare le token LETTER pour les lettres
%token WHITESPACE  // Déclare le token WHITESPACE pour les espaces blancs
%token OTHER       // Déclare le token OTHER pour tout autre caractère
%token ERROR       // Déclare le token ERROR pour les caractères invalides

%%

program:
    /* Vide */        // La règle pour le programme, peut être vide
  | program statement  // Un programme est composé d'une ou plusieurs instructions
;

statement:
    LETTER            { 
        int shift = generate_shift(5, yylen);  // Calcule le décalage en fonction de la longueur du token
        frsh26(&yytext[0], shift); 
        printf("%c", yytext[0]); 
    }  // Si le token est une lettre, applique frsh26 et affiche la lettre chiffrée
  | WHITESPACE        { printf(" "); }  // Si le token est un espace blanc, affiche un espace
  | OTHER             { printf("%c", yytext[0]); }  // Si le token est un autre caractère, l'affiche
  | ERROR             { yyerror("Caractère invalide rencontré"); }  // Si le token est une erreur, appelle yyerror
;

%%

// Fonction de génération de décalage aléatoire
int generate_shift(int base_shift, int index) {
    srand(time(NULL) + index);  // Initialise le générateur de nombres aléatoires basé sur l'index
    return (base_shift + rand() % 26);  // Génère un décalage aléatoire entre 0 et 25
}

// Fonction de chiffrement FRSH26 (décale les lettres par un certain nombre)
void frsh26(char *ch, int shift) {
    if (isupper(*ch)) {
        *ch = (*ch - 'A' + shift) % 26 + 'A';  // Décale les lettres majuscules
    } else if (islower(*ch)) {
        *ch = (*ch - 'a' + shift) % 26 + 'a';  // Décale les lettres minuscules
    }
}

// Fonction principale pour invoquer le processus d'analyse
int main() {
    printf("Entrez le texte à chiffrer avec FRSH26 :\n");
    yyparse();  // Lance l'analyse du texte d'entrée
    return 0;
}

// Fonction de gestion des erreurs
int yyerror(char *s) {
    fprintf(stderr, "Erreur : %s\n", s);  // Affiche le message d'erreur
    return 0;
}
