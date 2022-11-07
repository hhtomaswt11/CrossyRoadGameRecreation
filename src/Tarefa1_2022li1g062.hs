{- |
Module      : Tarefa1_2022li1g062
Description : Validação de um mapa
Copyright   : Tomas Henrique Alves Melo <a104529@alunos.uminho.pt>
              José Diogo Azevedo Martins <a104443@alunos.uminho.pt>

Módulo para a realização da Tarefa 1 do projeto de LI1 em 2022/23.
-}
module Tarefa1_2022li1g062 where

import LI12223
 
--Tarefa 1

mapaValido :: Mapa -> Bool
mapaValido m = if mapaValido1 m == True && mapaValido2 m == True && mapaValido3 m == True 
               then True
               else False

--Exercício 1 (Concluído) 
mapaValido1 :: Mapa -> Bool
mapaValido1 (Mapa l []) = True
mapaValido1 (Mapa l ((Relva,(h1:t1)):t2)) 
  |(elem Tronco (h1:t1) || elem Carro (h1:t1)) = False
  |otherwise = mapaValido1 (Mapa l t2)
mapaValido1 (Mapa l (((Rio v),(h1:t1)):t2))
  |(elem Carro (h1:t1) || elem Arvore (h1:t1)) = False
  |otherwise = mapaValido1 (Mapa l t2)
mapaValido1 (Mapa l (((Estrada v),(h1:t1)):t2))
  |(elem Arvore (h1:t1) || elem Tronco (h1:t1)) = False
  |otherwise = mapaValido1 (Mapa l t2)

--Exercício 2(Concluído)
mapaValido2 :: Mapa -> Bool
mapaValido2 (Mapa l (((Rio v),o):[])) = True
mapaValido2 (Mapa l (((Rio v),o):((Rio v'),o'):t2))
   | v > 0 && v' > 0 = False
   | v < 0 && v' < 0 = False
   |otherwise = mapaValido2 (Mapa l (((Rio v'),o'):t2))
mapaValido2 (Mapa l (((Estrada v),o):((Rio v'),o'):t2)) = True
mapaValido2 (Mapa l (((Relva),o):((Rio v'),o'):t2)) = True
mapaValido2 (Mapa l (((Rio v),o):((Estrada v'),o'):t2)) = True
mapaValido2 (Mapa l (((Rio v),o):((Relva),o'):t2)) = True































--Exercício 3 (Imcompleto)
mapaValido3 :: Mapa -> Bool
mapaValido3 m = aux m 0

aux :: Ord a => Mapa -> a -> Bool
aux (Mapa l (((Rio v),[]):t2)) x = True 
aux (Mapa l (((Rio v),(h1:t1)):t2)) x
   | x > 5 = False
   | h1 == Tronco = aux (Mapa l (((Rio v),(t1)):t2)) (x+1)
