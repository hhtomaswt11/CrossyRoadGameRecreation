{- |
Module      : Tarefa2_2022li1g062
Description : Geração contínua de um mapa
Copyright   : Tomas Henrique Alves Melo <a104529@alunos.uminho.pt>
              José Diogo Azevedo Martins <a104443@alunos.uminho.pt>

Módulo para a realização da Tarefa 2 do projeto de LI1 em 2022/2023.
-}

module Tarefa2_2022li1g062 where

import LI12223
import Test.HUnit 
import System.Random

{- | A funcao ’estendeMapa’ tem como finalidade gerar e adicionar uma nova linha valida ao topo de um dado mapa. O valor inteiro deve estar entre [0,100] usado para acrescentar alguma pseudo-aleatoriedade a geracao a proxima nova linha.
Acima encontram-se mais informaçoes sobre as funçoes /Mapa/. 

== Exemplos de utilização:

@
>>>  estendeMapa (Mapa 3 [(Relva , [])]) 3
Mapa 3 [(Relva,[]),(Relva,[Arvore,Arvore,Nenhum])]
@

== Sobre...

Na funçao 'estendeMapa', usamos random com recurso a funçao mod de modo a gerar novas linhas de terreno no mapa. 

-}

{- Funçao estendeMapa -}


estendeMapa :: Mapa -> Int -> Mapa 
estendeMapa (Mapa l m) n = ( Mapa l ((terreno_selecionado, (listaObstaculos l n (terreno_selecionado, [])) ):m ))
    where terreno_selecionado = terrenos_validos !! mod n (length terrenos_validos)
          terrenos_validos = (proximosTerrenosValidos (Mapa l m))


listaObstaculos :: Int -> Int -> (Terreno, [Obstaculo]) -> [Obstaculo]
listaObstaculos l n (ter,o)
 |length o ==(l-1) && elem Nenhum o == False = o ++ [Nenhum]
 |length o == l = o
 |otherwise = listaObstaculos l (div ((n+1)^4) 3) (ter,[(obstaculos_validos !! mod n (length obstaculos_validos))] ++ o)
      where obstaculos_validos = proximosObstaculosValidos l (ter, o) 

{- |A função ’proximosTerrenosValidos’ calcula a lista de terrenos que poderao surgir na nova linha do mapa. Para esta funçao iremos ignorar os parametros relacionados com a velocidade do /terreno Estrada/ e /terreno Rio/.
Clicando em __Mapa__ e em __Terreno__ acima e possivel obter mais informaçoes relativamente a estas 2 funcoes.

== Exemplos de utilização:

@
>>> proximosTerrenosValidos (Mapa 3 [(Estrada 3,[])])
[Relva,Rio 0,Estrada 0]
@

@
>>>  proximosTerrenosValidos (Mapa 3 [(Estrada 3,[Carro,Carro,Nenhum]), (Relva , [Arvore,Arvore,Nenhum])])
[Relva,Rio 0,Estrada 0]
@

@
>>> proximosTerrenosValidos (Mapa 2 [(Rio 7, [Tronco,Nenhum]), (Rio 1, [Tronco,Nenhum]),(Rio 2, [Tronco,Nenhum]),(Rio 3, [Tronco,Nenhum])])
[Estrada 0,Relva]
@

-}


{- Funçao proximosTerrenosValidos -}

proximosTerrenosValidos :: Mapa -> [Terreno]  -- ^  
proximosTerrenosValidos (Mapa l []) = [Relva,Rio 0,Estrada 0] 
proximosTerrenosValidos (Mapa l [(Estrada v ,a),(Estrada vv ,aa),(Estrada vvv ,aaa),(Estrada vvvv ,aaaa),(Estrada vvvvv ,aaaaa)])=[Rio 0,Relva]
proximosTerrenosValidos (Mapa l (x:[(Estrada  v, a),(Estrada  vv, aa),(Estrada vvv, aaa),(Estrada vvvv, aaaa),(Estrada aaaaa, vvvvv)]))=[Rio 0, Relva]
proximosTerrenosValidos (Mapa l [(Rio v, a),(Rio vv, aa),(Rio vvv, aaa),(Rio vvvv, aaaa)]) = [Estrada 0, Relva]
proximosTerrenosValidos (Mapa l (x:[(Rio v, a),(Rio vv, aa),(Rio vvv, aaa),(Rio vvvv, aaaa)])) = [Estrada 0, Relva]
proximosTerrenosValidos (Mapa l [(Relva ,a),(Relva, aa),(Relva , aaa),(Relva , aaaa),(Relva , aaaaa)])=[Estrada 0 , Rio 0]
proximosTerrenosValidos (Mapa l (x:[(Relva ,a),(Relva, aa),(Relva , aaa),(Relva , aaaa),(Relva , aaaaa)]))=[Estrada 0 , Rio 0]
proximosTerrenosValidos (Mapa l t) = [Relva,Rio 0 ,Estrada 0]


{- | A função ’proximosObauxiliar’ calcula os obstaculos que podem ser gerados para continuar uma dada linha do mapa. O valor inteiro corresponde a largura do mapa. Se o comprimento da lista de obstaculos atinge a largura do mapa entao mais nenhum obstaculo e possivel adicionar. Os obstaculos escolhidos devem ainda estar de acordo com o seu respetivo terreno.
Clicando em /Terreno/ e /Obstaculo/ é possivel obter mais informaçoes relativamente a estas funcoes. 

== Exemplos de utilização:

@
>>> proximosObauxiliar 10 (Estrada 3 , [Carro,Carro,Carro,Carro])
[Nenhum]
@

@
>>>  proximosObauxiliar 3 (Estrada 3 , [Carro,Carro,Carro,Nenhum])
[Nenhum] 
@

@
>>>  proximosObauxiliar 6 (Estrada 3 , [Carro,Carro,Carro,Carro])
[Nenhum]
@

@
>>>  proximosObauxiliar 6 (Estrada 3 , [])
[Nenhum,Carro]
@

@
>>>  proximosObauxiliar 2 (Estrada 3 , [Carro,Carro,Carro,Carro])
[Nenhum]
@

-}

{- Funçao proximosObstaculosValidos -}


proximosObstaculosValidos  :: Int -> (Terreno,[Obstaculo]) -> [Obstaculo]
proximosObstaculosValidos n (Relva, [])=[Nenhum,Arvore]
proximosObstaculosValidos n (Estrada f,[])=[Nenhum,Carro]
proximosObstaculosValidos n (Rio f, [])=[Nenhum, Tronco]
proximosObstaculosValidos n (Rio f,(Tronco:Tronco:Tronco:Tronco:Tronco:t))=[Nenhum]
proximosObstaculosValidos n (Rio f,lar)=[Nenhum,Tronco]
proximosObstaculosValidos n (Relva,lar)=[Nenhum,Arvore]
proximosObstaculosValidos n (Estrada f,(Carro:Carro:Carro:t))=[Nenhum]
proximosObstaculosValidos n (Estrada f,lar)=[Nenhum,Carro]


