      ******************************************************************
      * Author:Thiago Souza
      * Date:09/06/2025
      * Purpose:Projeto - Sistema de gestao de clientes(CRUD)
      *  -  MODULO DE ALTERACAO
      * Tectonics: cobc
      ******************************************************************
       IDENTIFICATION          DIVISION.
       PROGRAM-ID. ALTERAR.
      ******************************************************************
       ENVIRONMENT             DIVISION.
      *
       CONFIGURATION           SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.
      *
       INPUT-OUTPUT            SECTION.
       FILE-CONTROL.
           SELECT CLIENTES ASSIGN TO "C:/projeto-bootcamp/clientes.dat"
               ORGANIZATION    IS INDEXED
               ACCESS MODE     IS DYNAMIC
               RECORD KEY      IS CHAVE-CLIENTES
               FILE STATUS     IS FS-CLIENTES.
      ******************************************************************
       DATA                    DIVISION.
      *
       FILE                    SECTION.
       FD  CLIENTES.
       01  REG-CLIENTES.
           05 CHAVE-CLIENTES.
               10 REG-TELEFONE     PIC 9(09).
           05 REG-NOME             PIC A(30).
           05 REG-EMAIL            PIC X(40).
      ******************************************************************
       WORKING-STORAGE         SECTION.
      *---> STATUS ARQUIVO
       01  FS-CLIENTES             PIC X(02) VALUE SPACES.

      *---> ABENDS
       77  WK-ABEND-MESSAGE        PIC X(40) VALUE SPACES.

      *---> TELA
       77  WK-OPCAO                PIC X     VALUE SPACES.
       77  WK-TECLA                PIC X     VALUE SPACES.
       77  WK-MODULO               PIC X(25) VALUE SPACES.
      ******************************************************************
       SCREEN                  SECTION.
       01  TELA-ALTERA.
           05 BLANK SCREEN.
           05 LINE 02 COLUMN 01 PIC X(25) ERASE EOL
               BACKGROUND-COLOR 5 FROM WK-MODULO.
           05 LINE 08 COLUMN 10 VALUE "INSIRA CHAVE PARA A ALTERAR".
      *
           05 CHAVE FOREGROUND-COLOR 3.
               10 LINE 10 COLUMN 10 VALUE "TELEFONE ".
               10 COLUMN PLUS 2 PIC 9(09) USING REG-TELEFONE
                   BLANK WHEN ZEROS.
           05 SS-DADOS.
               10 LINE 11 COLUMN 10 VALUE "NOME.... ".
               10 COLUMN PLUS 2 PIC X(30) USING REG-NOME.
               10 LINE 12 COLUMN 10 VALUE "EMAIL... ".
               10 COLUMN PLUS 2 PIC X(40) USING REG-EMAIL.
      *
           COPY "ERROR.cpy".
      ******************************************************************
       PROCEDURE               DIVISION.
       0000-PRINCIPAL          SECTION.
             PERFORM 0100-INICIALIZAR.
             PERFORM 0200-ALTERAR.
             PERFORM 1000-FINALIZAR.

             GOBACK.
       0000-PRINCIPAL-FIM.     EXIT.
      ******************************************************************
       0100-INICIALIZAR        SECTION.
           OPEN I-O CLIENTES.
           IF FS-CLIENTES EQUAL "35"
               OPEN OUTPUT CLIENTES
               CLOSE CLIENTES
               OPEN I-O CLIENTES
           END-IF.
       0100-INICIALIZAR-FIM.   EXIT.
      ******************************************************************
       0200-ALTERAR            SECTION.
           MOVE "MODULO - ALTERACAO" TO WK-MODULO
           PERFORM UNTIL WK-OPCAO = "N"
               DISPLAY TELA-ALTERA
               ACCEPT CHAVE
               IF REG-TELEFONE = ZEROS
                   EXIT PERFORM
               END-IF
      *---> LE REGISTRO
               READ CLIENTES
               EVALUATE TRUE
                   WHEN FS-CLIENTES = "00"
                       ACCEPT SS-DADOS
                       DISPLAY "PARA ALTERAR APERTE 'ENTER': "
                        FOREGROUND-COLOR 2 AT 1415
                       ACCEPT WK-TECLA AT 1462

                       IF WK-TECLA = SPACE
                           PERFORM 0300-CONFIRMA-ALTERACAO
                       END-IF

                   WHEN FS-CLIENTES = "23"
                       MOVE "REGISTRO NAO ENCONTRADO"
                                               TO WK-ABEND-MESSAGE
                       DISPLAY MOSTRA-ERRO
                       ACCEPT WK-TECLA

                   WHEN OTHER
                       MOVE "ERRO AO LER ARQUIVO" TO WK-ABEND-MESSAGE
                       DISPLAY MOSTRA-ERRO
                       ACCEPT WK-TECLA
               END-EVALUATE
      *--> LIMPA CAMPO
               MOVE ZEROS TO CHAVE-CLIENTES
               MOVE SPACES TO REG-NOME, REG-EMAIL
           END-PERFORM.
       0200-ALTERAR-FIM. EXIT.

       0300-CONFIRMA-ALTERACAO SECTION.
           DISPLAY "TEM CERTEZA? (S/N): " FOREGROUND-COLOR 2 AT 1515
           ACCEPT WK-OPCAO AT 1538

           IF FUNCTION UPPER-CASE(WK-OPCAO) = "S"
               REWRITE REG-CLIENTES
               EVALUATE TRUE
                   WHEN FS-CLIENTES = "00"
                       DISPLAY "REGISTRO ALTERADO!"
                        FOREGROUND-COLOR 2 AT 1032
                   WHEN OTHER
                       MOVE "ERRO AO ALTERAR REGISTRO"
                                           TO WK-ABEND-MESSAGE
               END-EVALUATE
               ACCEPT WK-TECLA AT 1051
           ELSE
               MOVE "ALTERACAO CANCELADA" TO WK-ABEND-MESSAGE
           END-IF
           DISPLAY MOSTRA-ERRO
           ACCEPT WK-TECLA.
           0300-CONFIRMA-ALTERACAO-FIM. EXIT.
      ******************************************************************
       1000-FINALIZAR          SECTION.
           CLOSE CLIENTES.
       1000-FINALIZAR-FIM.     EXIT.
