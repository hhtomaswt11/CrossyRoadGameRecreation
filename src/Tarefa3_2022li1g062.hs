{- |
Module      : Tarefa3_2022li1g062
Description : Movimentação do personagem e obstáculos
Copyright   : Tomas Henrique Alves Melo <a104529@alunos.uminho.pt>
              José Diogo Azevedo Martins <a104443@alunos.uminho.pt>

Módulo para a realização da Tarefa 3 do projeto de LI1 em 2022/23.
-}

module Tarefa3_2022li1g062 where
import LI12223

{-|




-}

animaJogo :: Jogo -> Jogada -> Jogo 
animaJogo (Jogo (Jogador (x,y)) ((Mapa l linhas))) jogada = (validoMovimento (Jogo ((Jogador (x,y)) ) (Mapa l linhas) ) jogada)
    where linhas = moveObs l linhas_atrop   
          linhas_atrop = (atropelamento (Jogo (Jogador (x,y)) ((Mapa l linhas))) )





{- | A função "moveJogador" pretende animar o jogador, mediante a jogada escolhida ser fazer o jogador andar para cima, para baixo, para esquerda ou para a direita.
Clicando em /Direcao/ e /Jogador/ é possivel obter mais informações relativamente a estas funções.

== Exemplos de utilização:

@
>>> moveJogador Move Cima ( Jogador (0,0) )
Jogador (0,1)
@

@
>>> moveJogador Move Esquerda ( Jogador (2,1) )
Jogador (1,1)
@

-}


moveJogador :: Jogada -> Jogador-> Jogador 
moveJogador (Move Cima) (Jogador (x,y)) = (Jogador (x,y+1))
moveJogador (Move Baixo) (Jogador (x,y)) = (Jogador (x,y-1))
moveJogador (Move Esquerda) (Jogador (x,y)) = (Jogador (x-1,y))
moveJogador (Move Direita) (Jogador (x,y)) = (Jogador (x+1,y))
moveJogador Parado (Jogador (x,y)) = (Jogador (x,y)) 


movitron :: Jogo -> Jogada -> Jogo 
movitron (Jogo (Jogador (x , y) ) (Mapa l ((Rio v ,o ):t) ) ) jog 
 | ((!!) o x == Tronco) && (jog == Move Cima) = (Jogo (Jogador (x , y+1) ) (Mapa l ((Rio v ,o ):t) ) ) 
 | ((!!) o x == Tronco) && (jog == Move Baixo) = (Jogo (Jogador (x , y-1) ) (Mapa l ((Rio v ,o ):t) ) ) 
 | ((!!) o x == Tronco) && (jog == Move Esquerda) && v < 0 = (Jogo (Jogador (x -1 + v  , y) ) (Mapa l ((Rio v ,o ):t) ) ) 
 | ((!!) o x == Tronco) && (jog == Move Direita) && v> 0 = (Jogo (Jogador (x+1+ v , y) ) (Mapa l ((Rio v ,o ):t) ) ) 
 | otherwise = (Jogo (Jogador (x , y) ) (Mapa l ((Rio v ,o ):t)))


movernotronco :: Jogo -> Jogada -> Jogo 
movernotronco (Jogo (Jogador (x , y) ) (Mapa l ((Rio v ,o ):t) ) ) jogada
  | v == 0 && jogada == Parado && x `elem` posicao_tronco o = (Jogo (Jogador (x , y) ) (Mapa l ((Rio v ,o ):t) ) )
  | v > 0 && jogada == (Move Direita) &&  ( (x+1) `elem` posicao_tronco o) = (Jogo (Jogador (x+2 , y) ) (Mapa l ((Rio v ,o ):t) ) )
  | v > 0 && jogada == (Move Esquerda) &&  ( (x-1) `elem` posicao_tronco o) = (Jogo (Jogador (x-2 , y) ) (Mapa l ((Rio v ,o ):t) ) )
  | v < 0 && jogada == (Move Direita) &&  ( (x+1) `elem` posicao_tronco o) = (Jogo (Jogador (x+2 , y) ) (Mapa l ((Rio v ,o ):t) ) )
  | v < 0 && jogada == (Move Esquerda ) && ( (x-1) `elem` posicao_tronco o) = (Jogo (Jogador (x-2 , y) ) (Mapa l ((Rio v ,o ):t) ) )
  | otherwise = (Jogo (Jogador (x , y) ) (Mapa l t ) ) 



{- | A função 'validoMovimento' pretende limitar os coordenadas possíveis do jogador, ao limite do mapa, não permitindo que ele saia para fora deste. A funçao sera deslocada para as respetivas funçoes auxiliares de acordo com a jogada que o jogador recebe.
As funçoes auxiliares 'validoMovimento1', 'validoMovimento2', 'validoMovimento3' e 'validoMovimento4' estarao explicadas mais a frente.
Clicando em /Jogo/ e /Jogada/ é possivel obter mais informações relativamente a estas funções.

== Exemplos de utilização:

@
>>> validoMovimento ( Jogo ( Jogador (2,0)) (Mapa 5 [(Relva,[Arvore, Nenhum, Arvore, Nenhum, Arvore]),(Estrada (-1), [Carro, Nenhum, Nenhum, Nenhum, Carro]),(Rio (1),[Tronco, Nenhum, Nenhum, Tronco, Tronco]),(Rio (-2), [Tronco, Tronco, Nenhum, Tronco, Tronco]), (Rio (1), [Nenhum, Nenhum, Tronco, Tronco, Tronco]),(Relva,[Arvore, Nenhum, Nenhum, Arvore, Arvore])]) ) (Move Cima) 
Jogo (Jogador (2,1)) (Mapa 5 [(Relva,[Arvore,Nenhum,Arvore,Nenhum,Arvore]),(Estrada (-1),[Carro,Nenhum,Nenhum,Nenhum,Carro]),(Rio 1,[Tronco,Nenhum,Nenhum,Tronco,Tronco]),(Rio (-2),[Tronco,Tronco,Nenhum,Tronco,Tronco]),(Rio 1,[Nenhum,Nenhum,Tronco,Tronco,Tronco]),(Relva,[Arvore,Nenhum,Nenhum,Arvore,Arvore])])
@

@
>>> validoMovimento ( Jogo ( Jogador (2,3)) (Mapa 5 [(Relva,[Arvore, Nenhum, Arvore, Nenhum, Arvore]),(Estrada (-1), [Carro, Nenhum, Nenhum, Nenhum, Carro]),(Rio (1),[Tronco, Nenhum, Nenhum, Tronco, Tronco]),(Rio (-2), [Tronco, Tronco, Nenhum, Tronco, Tronco]), (Rio (1), [Nenhum, Nenhum, Tronco, Tronco, Tronco]),(Relva,[Arvore, Nenhum, Nenhum, Arvore, Arvore])]) ) (Move Esquerda)
Jogo (Jogador (1,3)) (Mapa 5 [(Relva,[Arvore,Nenhum,Arvore,Nenhum,Arvore]),(Estrada (-1),[Carro,Nenhum,Nenhum,Nenhum,Carro]),(Rio 1,[Tronco,Nenhum,Nenhum,Tronco,Tronco]),(Rio (-2),[Tronco,Tronco,Nenhum,Tronco,Tronco]),(Rio 1,[Nenhum,Nenhum,Tronco,Tronco,Tronco]),(Relva,[Arvore,Nenhum,Nenhum,Arvore,Arvore])])
@

-} 


validoMovimento :: Jogo -> Jogada -> Jogo
validoMovimento jogo jogada
  | jogada == Move Esquerda = validoMovimento1 jogo
  | jogada == Move Direita = validoMovimento2 jogo 
  | jogada == Move Baixo = validoMovimento3 jogo 
  | jogada == Move Cima = validoMovimento4 jogo 
  | otherwise = validoMovimentoP jogo



{- | Funçao auxiliar 'validoMovimento1'. O primeiro elemento do par de coordenadas do jogador diminui (-1) a nao ser quando ha uma arvore ao lado esquerdo do jogador ou quando a posiçao do jogador e (0,_) em que _ esta dentro dos respetivos limites do mapa ou ainda quando ha movimentos num tronco tendo em conta a velocidade do tronco e a jogada que o jogador faz que neste casos sera sempre Move Esquerda (definido em validoMovimento).

== Exemplos de utilizaçao:

@
>>> validoMovimento1 ( Jogo ( Jogador (2,0)) (Mapa 5 [(Rio (1),[Tronco, Nenhum, Nenhum, Tronco, Tronco]),(Rio (-2), [Tronco, Tronco, Nenhum, Tronco, Tronco]), (Rio (2), [Nenhum, Nenhum, Tronco, Tronco, Tronco]) ]) ) 
Jogo (Jogador (3,0)) (Mapa 5 [(Rio 1,[Tronco,Nenhum,Nenhum,Tronco,Tronco]),(Rio (-2),[Tronco,Tronco,Nenhum,Tronco,Tronco]),(Rio 2,[Nenhum,Nenhum,Tronco,Tronco,Tronco])])
@

@
>>> validoMovimento1 ( Jogo ( Jogador (2,0)) (Mapa 5 [(Rio (1),[Tronco, Nenhum, Nenhum, Tronco, Tronco]),(Rio (-2), [Tronco, Tronco, Nenhum, Tronco, Tronco]), (Rio (3), [Nenhum, Nenhum, Tronco, Tronco, Tronco]) ]) ) 
Jogo (Jogador (4,0)) (Mapa 5 [(Rio 1,[Tronco,Nenhum,Nenhum,Tronco,Tronco]),(Rio (-2),[Tronco,Tronco,Nenhum,Tronco,Tronco]),(Rio 3,[Nenhum,Nenhum,Tronco,Tronco,Tronco])])
@

-}


validoMovimento1 :: Jogo -> Jogo  -- esquerda 
validoMovimento1 (Jogo (Jogador (x,y)) (Mapa l (h:t)))
   | (x == 0 && (y < length (h:t)) && y>= 0 ) = (Jogo (Jogador (x,y)) (Mapa l (h:t)))
   | (x-1) `elem` (posicao_arvore (snd linha_actual)) = (Jogo (Jogador (x,y)) (Mapa l (h:t)))
   | (!!) (snd linha_actual) x == Tronco = Jogo (move_tronco_e linha_actual (Jogador (x,y))) (Mapa l (h:t))
   | otherwise = (Jogo (Jogador (x-1,y)) (Mapa l (h:t)))
      where linha_actual = linha_jogador (h:t) y 


{-|
'move_tronco_e' e a funçao auxiliar aplicada em validoMovimento1 que garante que o jogador, quando num Rio, no primeiro elemento do par de coordenadas do jogador, este diminua (-1) devido a jogada Move Esquerda vista em 'validoMovimento' ao mesmo tempo que seja adicionada a velocidade do tronco que garante assim os movimentos em cima do tronco tendo a jogada em conta em 'validoMovimento1'.

-}

move_tronco_e :: (Terreno, [Obstaculo]) -> Jogador -> Jogador 
move_tronco_e (Rio v, obs) (Jogador (x,y)) = Jogador ((x-1) + v ,y)


{- | Funçao auxiliar 'validoMovimento2'. O primeiro elemento do par de coordenadas do jogador aumenta (+1) a nao ser quando ha uma arvore ao lado direito do jogador ou quando a posiçao do jogador e (l-1,_) em que l representa a largura do mapa, dentro dos respetivos limites do mapa ou ainda quando ha movimentos num tronco tendo em conta a velocidade do tronco e a jogada que o jogador faz que neste casos sera sempre Move Direita (definido em validoMovimento).

== Exemplos de utilizaçao:

@
>>> validoMovimento2 ( Jogo ( Jogador (0,2)) (Mapa 5 [(Rio (1),[Tronco, Nenhum, Nenhum, Tronco, Tronco]),(Rio (-2), [Tronco, Tronco, Nenhum, Tronco, Tronco]), (Rio (2), [Nenhum, Nenhum, Tronco, Tronco, Tronco]) ]) ) 
Jogo (Jogador (2,2)) (Mapa 5 [(Rio 1,[Tronco,Nenhum,Nenhum,Tronco,Tronco]),(Rio (-2),[Tronco,Tronco,Nenhum,Tronco,Tronco]),(Rio 2,[Nenhum,Nenhum,Tronco,Tronco,Tronco])])

@

@
>>> validoMovimento2 ( Jogo ( Jogador (3,2)) (Mapa 5 [(Rio (3),[Tronco, Nenhum, Nenhum, Tronco, Tronco]),(Rio (-3), [Tronco, Tronco, Nenhum, Tronco, Tronco]), (Rio (-2), [Nenhum, Nenhum, Tronco, Tronco, Tronco]) ]) ) 
Jogo (Jogador (1,2)) (Mapa 5 [(Rio 3,[Tronco,Nenhum,Nenhum,Tronco,Tronco]),(Rio (-3),[Tronco,Tronco,Nenhum,Tronco,Tronco]),(Rio (-2),[Nenhum,Nenhum,Tronco,Tronco,Tronco])])
@
-}


validoMovimento2 :: Jogo ->  Jogo  -- direita 
validoMovimento2 (Jogo (Jogador (x,y)) (Mapa l (h:t))) 
   | (x == (l -1) && y < length (h:t)) &&y >= 0 =  (Jogo (Jogador (x,y)) (Mapa l (h:t)))
   | (x+1) `elem` (posicao_arvore (snd linha_actual)) = (Jogo (Jogador (x,y)) (Mapa l (h:t)))
   | (!!) (snd linha_actual) x == Tronco = Jogo (move_tronco_d linha_actual (Jogador (x,y))) (Mapa l (h:t))
   | otherwise = (Jogo (Jogador (x+1,y)) (Mapa l (h:t)))
      where linha_actual = linha_jogador (h:t) y

{-|
'move_tronco_d' e a funçao auxiliar aplicada em validoMovimento2 que garante que o jogador, quando num Rio, no primeiro elemento do par de coordenadas do jogador, este aumente (+1) devido a jogada Move Direita vista em 'validoMovimento' ao mesmo tempo que seja reduzida a velocidade do tronco que garante assim os movimentos em cima do tronco tendo a jogada em conta em 'validoMovimento2'.

-}

move_tronco_d :: (Terreno, [Obstaculo]) -> Jogador -> Jogador 
move_tronco_d (Rio v, obs) (Jogador (x,y)) = Jogador ((x+1) - v, y)


{- | Funçao auxiliar 'validoMovimento3'. O segundo elemento do par de coordenadas do jogador diminui (-1) a nao ser quando ha uma arvore na linha abaixo do jogador para o mesmo x ou quando a posiçao do jogador e (_,0), dentro dos respetivos limites do mapa.

== Exemplos de utilizaçao: 1ªcaso -> respeitar os limites do mapa. 2ªcaso -> arvore na linha abaixo. 

@
>>> validoMovimento3 (Jogo (Jogador (1,0)) (Mapa 5 [(Relva,[Arvore, Nenhum, Arvore, Nenhum, Arvore]),(Estrada (-1), [Carro, Nenhum, Nenhum, Nenhum, Carro]),(Rio (1),[Tronco, Nenhum, Nenhum, Tronco, Tronco]),(Rio (-2), [Tronco, Tronco, Nenhum, Tronco, Tronco]), (Rio (1), [Nenhum, Nenhum, Tronco, Tronco, Tronco]),(Relva,[Arvore, Nenhum, Nenhum, Arvore, Arvore])]) ) 
Jogo (Jogador (1,0)) (Mapa 5 [(Relva,[Arvore,Nenhum,Arvore,Nenhum,Arvore]),(Estrada (-1),[Carro,Nenhum,Nenhum,Nenhum,Carro]),(Rio 1,[Tronco,Nenhum,Nenhum,Tronco,Tronco]),(Rio (-2),[Tronco,Tronco,Nenhum,Tronco,Tronco]),(Rio 1,[Nenhum,Nenhum,Tronco,Tronco,Tronco]),(Relva,[Arvore,Nenhum,Nenhum,Arvore,Arvore])])
@

@
>>> validoMovimento3 (Jogo (Jogador (3,1)) (Mapa 5 [(Relva,[Arvore, Nenhum, Arvore, Nenhum, Arvore]),(Estrada (-1), [Carro, Nenhum, Nenhum, Nenhum, Carro]),(Rio (1),[Tronco, Nenhum, Nenhum, Tronco, Tronco]),(Rio (-2), [Tronco, Tronco, Nenhum, Tronco, Tronco]), (Relva, [Arvore,Arvore,Nenhum,Nenhum,Nenhum]),(Relva,[Arvore, Nenhum, Nenhum, Arvore, Arvore])]) ) 
Jogo (Jogador (3,1)) (Mapa 5 [(Relva,[Arvore,Nenhum,Arvore,Nenhum,Arvore]),(Estrada (-1),[Carro,Nenhum,Nenhum,Nenhum,Carro]),(Rio 1,[Tronco,Nenhum,Nenhum,Tronco,Tronco]),(Rio (-2),[Tronco,Tronco,Nenhum,Tronco,Tronco]),(Relva,[Arvore,Arvore,Nenhum,Nenhum,Nenhum]),(Relva,[Arvore,Nenhum,Nenhum,Arvore,Arvore])])
@
-}

validoMovimento3 :: Jogo -> Jogo  -- baixo
validoMovimento3 (Jogo (Jogador (x,y)) (Mapa l (h:t))) 
  | (y == 0)  && (x <= l-1) && x >= 0  = (Jogo (Jogador (x,y)) (Mapa l (h:t)))
  | ( linha_abaixo == (Relva, obstaculos) ) && (x `elem` (posicao_arvore (snd (linha_abaixo)) ) ) = (Jogo (Jogador (x,y)) (Mapa l (h:t)))
  | otherwise= (Jogo (Jogador (x,y-1)) (Mapa l (h:t))) 
        where linha_abaixo = linha_jogador (h:t) (y-1)
              obstaculos = obstaculos_da_linha linha_abaixo 

{- | Funçao auxiliar 'validoMovimento4'. O segundo elemento do par de coordenadas do jogador aumenta (+1) a nao ser quando ha uma arvore na linha acima do jogador para o mesmo x ou quando a posiçao do jogador e (_, length (h:t)-1 ) em que length (h:t) representa o comprimento da lista de terrenos com os respetivos obstaculos, em que _ esta dentro dos respetivos limites do mapa. 

== Exemplos de utilizaçao: 1ªcaso -> respeitar os limites do mapa. 2ªcaso -> arvore na linha acima.

@
>>> validoMovimento4 (Jogo (Jogador (3,5)) (Mapa 5 [(Relva,[Arvore, Nenhum, Arvore, Nenhum, Arvore]),(Estrada (-1), [Carro, Nenhum, Nenhum, Nenhum, Carro]),(Rio (1),[Tronco, Nenhum, Nenhum, Tronco, Tronco]),(Rio (-2), [Tronco, Tronco, Nenhum, Tronco, Tronco]), (Relva, [Arvore,Arvore,Nenhum,Nenhum,Nenhum]),(Relva,[Arvore, Nenhum, Nenhum, Arvore, Arvore])]) ) 
Jogo (Jogador (3,5)) (Mapa 5 [(Relva,[Arvore,Nenhum,Arvore,Nenhum,Arvore]),(Estrada (-1),[Carro,Nenhum,Nenhum,Nenhum,Carro]),(Rio 1,[Tronco,Nenhum,Nenhum,Tronco,Tronco]),(Rio (-2),[Tronco,Tronco,Nenhum,Tronco,Tronco]),(Relva,[Arvore,Arvore,Nenhum,Nenhum,Nenhum]),(Relva,[Arvore,Nenhum,Nenhum,Arvore,Arvore])])
@

@
>>> validoMovimento4 (Jogo (Jogador (1,0)) (Mapa 5 [(Relva,[Arvore, Nenhum, Arvore, Nenhum, Arvore]),(Estrada (-1), [Carro, Nenhum, Nenhum, Nenhum, Carro]),(Rio (1),[Tronco, Nenhum, Nenhum, Tronco, Tronco]),(Rio (-2), [Tronco, Tronco, Nenhum, Tronco, Tronco]), (Relva, [Arvore,Arvore,Nenhum,Nenhum,Nenhum]),(Relva,[Arvore, Nenhum, Nenhum, Arvore, Arvore])]) ) 
Jogo (Jogador (1,0)) (Mapa 5 [(Relva,[Arvore,Nenhum,Arvore,Nenhum,Arvore]),(Estrada (-1),[Carro,Nenhum,Nenhum,Nenhum,Carro]),(Rio 1,[Tronco,Nenhum,Nenhum,Tronco,Tronco]),(Rio (-2),[Tronco,Tronco,Nenhum,Tronco,Tronco]),(Relva,[Arvore,Arvore,Nenhum,Nenhum,Nenhum]),(Relva,[Arvore,Nenhum,Nenhum,Arvore,Arvore])])
@
-}

validoMovimento4 :: Jogo -> Jogo  -- cima
validoMovimento4 (Jogo (Jogador (x,y)) (Mapa l (h:t))) 
  | ((y == (length (h:t) ) -1 ) && (x <= l - 1) && (x>=0) ) = (Jogo (Jogador (x,y)) (Mapa l (h:t)))
  | (linha_acima == (Relva , obstaculos) )&& (x `elem` (posicao_arvore (snd (linha_acima)) ) ) = (Jogo (Jogador (x,y)) (Mapa l (h:t)))
  | otherwise = (Jogo (Jogador (x,y+1)) (Mapa l (h:t)))
                              where linha_acima = linha_jogador (h:t) (y+1)
                                    obstaculos = obstaculos_da_linha linha_acima 

{- | 
Funçao auxiliar 'validoMovimentoP' faz com que o jogador, quando parado em cima do tronco, acompanhe o movimento do tronco.

== Exemplos de utilizaçao:

@
>>> validoMovimentoP (Jogo (Jogador (0,2)) (Mapa 5 [(Relva,[Arvore, Nenhum, Arvore, Nenhum, Arvore]),(Estrada (-1), [Carro, Nenhum, Nenhum, Nenhum, Carro]),(Rio (1),[Tronco, Nenhum, Nenhum, Tronco, Tronco]),(Rio (2), [Tronco, Tronco, Nenhum, Tronco, Tronco]), (Relva, [Arvore,Arvore,Nenhum,Nenhum,Nenhum]),(Relva,[Arvore, Nenhum, Nenhum, Arvore, Arvore])]) )
Jogo (Jogador (2,2)) (Mapa 5 [(Relva,[Arvore,Nenhum,Arvore,Nenhum,Arvore]),(Estrada (-1),[Carro,Nenhum,Nenhum,Nenhum,Carro]),(Rio 1,[Tronco,Nenhum,Nenhum,Tronco,Tronco]),(Rio 2,[Tronco,Tronco,Nenhum,Tronco,Tronco]),(Relva,[Arvore,Arvore,Nenhum,Nenhum,Nenhum]),(Relva,[Arvore,Nenhum,Nenhum,Arvore,Arvore])])
@

@
>>> validoMovimentoP (Jogo (Jogador (3,2)) (Mapa 5 [(Relva,[Arvore, Nenhum, Arvore, Nenhum, Arvore]),(Estrada (-1), [Carro, Nenhum, Nenhum, Nenhum, Carro]),(Rio (1),[Tronco, Nenhum, Nenhum, Tronco, Tronco]),(Rio (1), [Tronco, Tronco, Nenhum, Tronco, Tronco]), (Relva, [Arvore,Arvore,Nenhum,Nenhum,Nenhum]),(Relva,[Arvore, Nenhum, Nenhum, Arvore, Arvore])]) )
Jogo (Jogador (4,2)) (Mapa 5 [(Relva,[Arvore,Nenhum,Arvore,Nenhum,Arvore]),(Estrada (-1),[Carro,Nenhum,Nenhum,Nenhum,Carro]),(Rio 1,[Tronco,Nenhum,Nenhum,Tronco,Tronco]),(Rio 1,[Tronco,Tronco,Nenhum,Tronco,Tronco]),(Relva,[Arvore,Arvore,Nenhum,Nenhum,Nenhum]),(Relva,[Arvore,Nenhum,Nenhum,Arvore,Arvore])])
@

-}


validoMovimentoP :: Jogo -> Jogo
validoMovimentoP (Jogo (Jogador (x,y)) (Mapa l (h:t)))
   | (!!) (snd linha_atual) x == Tronco = Jogo (move_tronco_p linha_atual (Jogador (x,y))) (Mapa l (h:t))
   | otherwise = (Jogo (Jogador (x,y)) (Mapa l (h:t)))
        where linha_atual = linha_jogador (h:t) y





move_tronco_p :: (Terreno, [Obstaculo]) -> Jogador -> Jogador 
move_tronco_p (Rio v, obs) (Jogador (x,y)) = Jogador (x+ v, y)

{-|
Funçao auxiliar que indica o terreno e a respetiva lista de obstaculos tendo em conta o segundo elemento do par de coordenadas do jogador em que o jogador se encontra.

== Exemplos de utilizaçao: 

@
>>> linha_jogador [(Relva, [Nenhum,Arvore]), (Rio 2 , [Tronco , Nenhum]) ] 0 
(Rio 2,[Tronco,Nenhum])
@

@
>>> linha_jogador [(Relva, [Nenhum,Arvore]), (Rio 2 , [Tronco , Nenhum]) ] 1
(Relva, [Nenhum,Arvore])
@

-}


linha_jogador :: [(Terreno, [Obstaculo])] -> Int -> (Terreno, [Obstaculo])
linha_jogador linhas y = (!!) (reverse linhas) y

    -- M O V E   O B S T A C U L O S -- 



{-|

A funçao 'moveObs' vai alternar a lista de obstaculos que constituem as linhas do mapa. Esta alteraçao varia mediante o valor da velocidade e o sinal desta. Caso a velocidade seja positiva, quanto maior for a velocidade mais obstaculos serao retirados do fim da lista e adicionados ao inicio, simulando a movimentaçao dos obstaculos esquerda->direita e o efeito WormHole. Caso a velocidade seja negativa, quanto maior for o valor da velocidade maior sera o numero de obstaculos retirados do inicio da lista e adicionados ao fim, simulando o movimento direita->esquerda e o efeito WormHole.        


== Exemplos de utilizaçao: 

@
>>> moveObs 2 [(Relva,[Arvore, Nenhum, Arvore, Nenhum, Arvore]),(Estrada (-1), [Carro, Nenhum, Nenhum, Nenhum, Carro]),(Rio (1),[Tronco, Nenhum, Nenhum, Tronco, Tronco]),(Rio (-2), [Tronco, Tronco, Nenhum, Tronco, Tronco]), (Rio (1), [Nenhum, Nenhum, Tronco, Tronco, Tronco])]
[(Relva,[Arvore,Nenhum,Arvore,Nenhum,Arvore]),(Estrada (-1),[Nenhum,Nenhum,Nenhum,Carro,Carro]),(Rio 1,[Nenhum,Nenhum,Tronco,Tronco,Tronco]),(Rio (-2),[Nenhum,Tronco,Tronco,Tronco,Tronco]),(Rio 1,[Nenhum,Tronco,Tronco,Tronco,Nenhum])] 
@

@
>>> moveObs 3 [(Estrada (-1), [Carro, Nenhum, Nenhum, Nenhum, Carro]),(Rio (1),[Tronco, Nenhum, Nenhum, Tronco, Tronco]),(Rio (2), [Tronco, Tronco, Nenhum, Tronco, Tronco]), (Rio (3), [Nenhum, Nenhum, Tronco, Tronco, Tronco])]
[(Estrada (-1),[Nenhum,Nenhum,Nenhum,Carro,Carro]),(Rio 1,[Nenhum,Tronco,Tronco,Tronco,Nenhum]),(Rio 2,[Tronco,Nenhum,Tronco,Tronco,Tronco]),(Rio 3,[Nenhum,Nenhum,Tronco,Tronco,Tronco])]
@
-}

moveObs :: Int -> [(Terreno,[Obstaculo])] -> [(Terreno,[Obstaculo])]
moveObs _ [] =  [] 
moveObs l ((Relva, obstaculos):t)=(Relva, obstaculos):(moveObs l t)
moveObs l ((Rio v, obstaculos):t)
  | v > 0 = (Rio v, ((drop (l-v) obstaculos) ++ (take (l-v) obstaculos))):(moveObs l t)
  | v < 0 = (Rio v, ((drop (-v) obstaculos) ++ (take (-v) obstaculos))):(moveObs l t)
  | v == 0 = (Rio v, obstaculos):(moveObs l t)
moveObs l ((Estrada v, obstaculos):t)
  | v > 0 = (Estrada v, ((drop (l-v) obstaculos) ++ (take (l-v) obstaculos))):(moveObs l t)
  | v < 0 = (Estrada v, ((drop (-v) obstaculos) ++ (take (-v) obstaculos))):(moveObs l t)
  | v == 0 = (Estrada v, obstaculos):(moveObs l t)


-- FUNÇÃO ATROPELAMENTO --

{-|
Funçao 'atropelamento' 

== Exemplos de utilizaçao: 

@
>>> atropelamento

@

@
>>> atropelamento

@
-}

atropelamento :: Jogo ->  [(Terreno, [Obstaculo])] 
atropelamento (Jogo (Jogador (x,y)) (Mapa l (h:t)))  = if linha_jogador (h:t) y == (Estrada v, obstaculos)
                                                           then ((mapa_atualizado))
                                                           else ((h:t))
    where linha_atual = linha_jogador (h:t) y 
          linha_atualizada = atropelamento_aux linha_atual l x 
          mapa_atualizado = (take (y-1) (h:t)) ++ [linha_atualizada] ++ (drop y (h:t))
          v = velocidade_da_linha linha_atual
          obstaculos = obstaculos_da_linha linha_atual

{-|
Funçao 'atropelamento_aux' -> Funçao auxiliar utilizada em 'atropelamento'. Caso a velocidade atribuida aos carros for positiva a funçao 'atropelamento_aux_e' sera chamada, pois os carros estarao a vir da esquerda para a direita sendo o atropelamento pela esquerda o unico possivel. Caso esta seja negativa, a funçao 'atropelamento_aux_d' sera chamada, dado que para velocidades neagtivas o atropelamento pela direita e o unico possivel. 


== Exemplos de utilizaçao: 

@
>>> atropelamento_aux (Estrada 2, [Carro, Carro, Nenhum , Nenhum,Nenhum]) 5 2 (Move Esquerda)
(Estrada 2,[Nenhum,Carro,Carro,Nenhum,Nenhum])
@

@
>>> atropelamento_aux (Estrada (-1), [Carro, Carro, Nenhum , Carro, Nenhum]) 5 2 (Move Direita)
(Estrada (-1),[Carro,Carro,Nenhum,Carro,Nenhum])
@
-}


atropelamento_aux :: (Terreno, [Obstaculo]) -> Int -> Int -> (Terreno, [Obstaculo])
atropelamento_aux (Estrada v, (h:t)) l x 
  | v > 0 = atropelamento_aux_e (Estrada v, (h:t)) l x 
  | v < 0 = atropelamento_aux_d (Estrada v, (h:t)) l x 
  |otherwise = (Estrada v, (h:t))



{-|
Funçao 'atropelamento_aux_e'. De acordo com a jogada feita pelo jogador (Move Esquerda ou Paraod) e tendo em conta a posiçao dos carros e a velocidade que estes possuem, ira determinar se o jogador sera ou nao atropelado (se a posiçao do carro coincide com a posiçao do jogador).

== Exemplos de utilizaçao: 

@
>>> atropelamento_aux_e (Estrada 2, [Carro, Carro, Nenhum , Nenhum,Nenhum]) 5 2 (Move Direita)
(Estrada 2,[Nenhum,Carro,Carro,Nenhum,Nenhum])
@

@
>>> atropelamento_aux_e (Estrada 1, [Carro, Carro, Nenhum , Nenhum,Nenhum]) 5 2 (Move Direita)
(Estrada 1,[Nenhum,Carro,Carro,Nenhum,Nenhum])
@
-}


atropelamento_aux_e :: (Terreno, [Obstaculo]) -> Int -> Int -> (Terreno, [Obstaculo])
atropelamento_aux_e (Estrada v, (h:t)) l x
  | ( v >= distancia_e ) = (Estrada v, (drop ( l - distancia_e ) (h:t)) ++ (take (l - distancia_e) (h:t)) )
  | otherwise = (Estrada v, (h:t))
         where lista_pos = posicao_carro (h:t)
               poscarro = posicao_carro_prox_e lista_pos x 
               distancia_e = (x- poscarro)

{-|

Funçao 'atropelamento_aux_d'. De acordo com a jogada feita pelo jogador (Move Direita ou Parado) e tendo em conta a posiçao dos carros e a velocidade que estes possuem, ira determinar se o jogador sera ou nao atropelado (se a posiçao do carro coincide com a posiçao do jogador).

== Exemplos de utilizaçao: 

@
>>> atropelamento_aux_d (Estrada 1, [Carro, Carro, Nenhum , Nenhum,Nenhum]) 5 2 (Move Direita)
(Estrada 1,[Carro,Carro,Nenhum,Nenhum,Nenhum])
@

@
>>> atropelamento_aux_d (Estrada 2, [Carro, Carro, Nenhum , Nenhum,Nenhum]) 5 2 (Move Direita)
(Estrada 2,[Carro,Carro,Nenhum,Nenhum,Nenhum])
@
-}



atropelamento_aux_d :: (Terreno, [Obstaculo]) -> Int -> Int -> (Terreno, [Obstaculo])
atropelamento_aux_d (Estrada v, (h:t)) l x 
  | ( (-v) >= distancia_d ) = (Estrada v, (drop distancia_d (h:t)) ++ (take distancia_d (h:t)))
  | otherwise = (Estrada v, (h:t))
         where lista_pos = posicao_carro (h:t) 
               poscarro = posicao_carro_prox_d lista_pos x
               distancia_d = -(x- poscarro)



    -- E S T R A D A   E   O B S T A C U L O S --

posicao_carro_prox_e :: [Int] -> Int -> Int
posicao_carro_prox_e [] _ = 0
posicao_carro_prox_e l x 
  | last l > x = posicao_carro_prox_e (init l) x
  | otherwise = last l 


posicao_carro_prox_d :: [Int] -> Int -> Int
posicao_carro_prox_d [] _ = 0
posicao_carro_prox_d l x 
  | head l < x = (posicao_carro_prox_d (tail l) x ) 
  | otherwise = ( head l )


   -- E S T R A D A  E   O B S T A C U L O S -- 


{-|

A funçao 'posicao_carro' indica as posiçoes em que Carro se encontra num dada lista.

== Exemplos de utilizaçao: 

@
>>> posicao_carro [Nenhum]
[]
@

@
>>> posicao_carro [Carro, Carro, Nenhum , Tronco]
[0,1]
@
-}


posicao_carro :: [Obstaculo] -> [Int]
posicao_carro (h:t) = lista_posicoescarro (h:t) Carro 0


    -- R E L V A   E   O B S T A C U L O S -- 

{-|

A funçao 'posicao_arvore' indica as posiçoes em que Arvore se encontra num dada lista.

== Exemplos de utilizaçao: 

@
>>> posicao_arvore [Nenhum,Arvore]
[1]
@

@
>>> posicao_arvore [Carro, Carro, Nenhum , Arvore, Arvore]
[3,4]
@
-}


posicao_arvore :: [Obstaculo] -> [Int]
posicao_arvore (h:t) = lista_posicoesarvore (h:t) Arvore 0

    -- R I O   E   O B S T A C U L O S -- 


{-|

A funçao 'posicao_tronco' indica as posiçoes em que Tronco se encontra num dada lista.

== Exemplos de utilizaçao: 

@
>>> posicao_tronco [Nenhum, Tronco , Arvore , Carro , Arvore , Carro, Tronco,Tronco, Tronco]
[1,6,7,8]
@

@
>>> posicao_tronco [Carro, Carro, Nenhum , Tronco]
[3]
@

-}

posicao_tronco :: [Obstaculo] -> [Int]
posicao_tronco (h:t) = lista_posicoestronco (h:t) Tronco 0 


    --  C O N T A D O R   D E   O B S T A C U L O S INDIVIDUAL --


{-|

Funçao auxiliar utilizada em 'posicao_carro'. Listar as posiçoes do carro Funçao que entrega as posiçoes em que o carro se encontra.

== Exemplos de utilizaçao: 

@
>>> lista_posicoescarro [Carro, Tronco, Arvore, Arvore, Tronco] Carro 0
[0]
@

-}


lista_posicoescarro :: [Obstaculo] -> Obstaculo -> Int -> [Int] 
lista_posicoescarro [] n y = [] 
lista_posicoescarro (h:t) n y 
  | h == Carro = y:(lista_posicoescarro t n (y+1)) 
  | otherwise = lista_posicoescarro t n (y+1)

{-|

Funçao auxiliar utilizada em 'posicao_arvore'. Listar as posiçoes da arvore. Funçao que entrega as posiçoes em que a arvore se encontra.

== Exemplos de utilizaçao: 

@
>>> lista_posicoesarvore [Tronco, Tronco, Arvore, Arvore, Tronco] Arvore 0
[2,3]
@

-}



lista_posicoesarvore :: [Obstaculo] -> Obstaculo -> Int -> [Int] 
lista_posicoesarvore [] n y = [] 
lista_posicoesarvore (h:t) n y 
  | h == Arvore = y:(lista_posicoesarvore t n (y+1)) 
  | otherwise = lista_posicoesarvore t n (y+1)

{-|

Funçao auxiliar utilizada em 'posicao_tronco. Listar as posiçoes do tronco. Funçao que entrega as posiçoes em que o tronco se encontra.

== Exemplos de utilizaçao: 

@
>>> lista_posicoestronco [Tronco, Tronco, Arvore, Arvore, Tronco] Tronco 0
[0,1,4]
@

-}

lista_posicoestronco :: [Obstaculo] -> Obstaculo -> Int -> [Int] 
lista_posicoestronco [] n y = [] 
lista_posicoestronco (h:t) n y 
  | h == Tronco = y:(lista_posicoestronco t n (y+1)) 
  | otherwise = (lista_posicoestronco t n (y+1)) 

{-|

Funçao que entrega os obstaculos de um terreno (Rio e Estrada).

-}

velocidade_da_linha :: (Terreno, [Obstaculo]) -> Velocidade
velocidade_da_linha (Estrada v, o) = v
velocidade_da_linha (Rio v, o) = v

{-|

Funçao que entrega os obstaculos de um terreno (Rio, Estrada e Relva).

-}

obstaculos_da_linha :: (Terreno, [Obstaculo]) -> [Obstaculo]
obstaculos_da_linha (Relva , o ) =  o 
obstaculos_da_linha (Estrada v, o) = o
obstaculos_da_linha (Rio v, o) = o
