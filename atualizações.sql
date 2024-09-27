ALTER TABLE tb_status add column nome_es varchar(20) not null after nome;

ALTER TABLE tb_status 
change column nome nome_pt varchar(20);


UPDATE tb_status SET nome_es = 'Pending' WHERE status_id = 1;

UPDATE tb_status SET nome_es = 'Confirmed' WHERE status_id = 2;

UPDATE tb_status SET nome_es = 'Preparing' WHERE status_id = 3;

UPDATE tb_status SET nome_es = 'Ready' WHERE status_id = 4;

UPDATE tb_status SET nome_es = 'On the Way' WHERE status_id = 5;

UPDATE tb_status SET nome_es = 'Delivered' WHERE status_id = 6;

UPDATE tb_status SET nome_es = 'Rejected' WHERE status_id = 7;

UPDATE tb_status SET nome_es = 'Returned' WHERE status_id = 8;

UPDATE tb_status SET nome_es = 'Completed' WHERE status_id = 9;

UPDATE tb_status SET nome_es = 'Canceled' WHERE status_id = 10;

-- ////////////////////////////////////

ALTER TABLE tb_cartao 
add column cpf char(11) after cliente_id;

ALTER TABLE tb_cartao 
add column cnpj char(14) after cpf;

ALTER TABLE tb_cartao 
add column tipo_cartao enum('CREDITO', 'DEBITO', 'REFEICAO', 'OUTROS') default 'OUTROS' not null after cnpj;

UPDATE tb_cartao SET cpf = '19845632701' WHERE cliente_id = 1;

UPDATE tb_cartao SET cpf =  '98723056401' WHERE cliente_id = 2;

UPDATE tb_cartao SET cpf = '45689012401' WHERE cliente_id = 3;

UPDATE tb_cartao SET cpf = '78950213401' WHERE cliente_id = 4;

UPDATE tb_cartao SET cpf =  '23456790821' WHERE cliente_id = 5;

UPDATE tb_cartao SET cpf = '87654320112' WHERE cliente_id = 6;

UPDATE tb_cartao SET cpf = '56032198704' WHERE cliente_id = 7;

UPDATE tb_cartao SET cpf = '89123045601' WHERE cliente_id = 8;

UPDATE tb_cartao SET cpf = '34567890421' WHERE cliente_id = 9;

UPDATE tb_cartao SET cpf = '65430921823' WHERE cliente_id = 10;



-- ALTER HORARIO FUNC E DROP DIAS DA SEMANA

ALTER TABLE tb_horario_funcionamento DROP CONSTRAINT tb_horario_funcionamento_ibfk_2;

DROP TABLE IF EXISTS tb_dias_semana;

ALTER TABLE tb_horario_funcionamento
change column almoco intervalo bit,
add column dia_semana enum ('SEG', 'TER', 'QUA', 'QUI', 'SEX', 'SAB', 'DOM', 'FERIADO') not null;

UPDATE tb_horario_funcionamento
SET dia_semana =
case 
when dia_id = 1 then 'SEG'
when dia_id = 2 then 'TER'
when dia_id = 3 then 'QUA'
when dia_id = 4 then 'QUI'
when dia_id = 5 then 'SEX'
when dia_id = 6 then 'SAB'
when dia_id = 7 then 'DOM'
when dia_id = 8 then 'FERIADO'
end;

-- ////////////// CREATES E INSERTS //////////////// --

CREATE TABLE IF NOT EXISTS tb_categoria( 
categoria_id integer not null auto_increment, 
nome varchar(20) not null,
tipo enum('ESTABELECIMENTO', 'CARDAPIO', 'ITEM'),
supercategoria_id integer,

primary key(categoria_id),
foreign key (supercategoria_id) references tb_categoria(categoria_id)

);


INSERT INTO tb_categoria(nome, tipo) SELECT nome, 'ESTABELECIMENTO' AS tipo FROM tb_categoria_estabelecimento 
UNION ALL SELECT nome, 'CARDAPIO' AS tipo FROM tb_categoria_cardapio UNION ALL SELECT nome, 'ITEM' AS tipo FROM tb_categoria_item;

-- ALTER TABLE & UPDATE TB_CATEGORIA --

UPDATE tb_categoria SET supercategoria_id = 1 WHERE tipo = 'CARDAPIO';

UPDATE tb_categoria SET supercategoria_id = 2 WHERE tipo = 'ITEM';


ALTER TABLE tb_categoria add column subcategoria_id integer;
ALTER TABLE tb_categoria add constraint fk_subcategoria foreign key(subcategoria_id) references tb_categoria(categoria_id);

UPDATE tb_categoria SET subcategoria_id = 2 WHERE tipo = 'ESTABELECIMENTO';

UPDATE tb_categoria SET subcategoria_id = 3 WHERE tipo = 'CARDAPIO';


-- DROP CATEGORIAS --

ALTER TABLE tb_estabelecimento DROP CONSTRAINT tb_estabelecimento_ibfk_1;

DROP TABLE IF EXISTS tb_categoria_estabelecimento;


ALTER TABLE tb_item_cardapio DROP CONSTRAINT tb_item_cardapio_ibfk_2;

DROP TABLE IF EXISTS tb_categoria_item;


ALTER TABLE tb_cardapio DROP CONSTRAINT tb_cardapio_ibfk_1;

DROP TABLE IF EXISTS tb_categoria_cardapio;

-- /////////////////////////////////////////////////

CREATE TABLE IF NOT EXISTS tb_motoboy(

motoboy_id integer not null auto_increment,
cnh char(9) not null,
data_validade_cnh date not null,
placa_moto char(7) not null unique,
prenome varchar(20) not null,
sobrenome varchar(30) not null,
sexo char(1) not null,
nota decimal(3,2) not null,

primary key(motoboy_id)

);

INSERT INTO tb_motoboy (cnh, data_validade_cnh, placa_moto, prenome, sobrenome, sexo, nota) 
VALUES 
('654287910', '2024-12-31', 'PLT1343', 'João', 'Silva', 'M', 4.75),
('876542199', '2025-06-30', 'JJK1997', 'Maria', 'Oliveira', 'F', 4.90),
('345891095', '2024-10-15', 'PJM1995', 'Carlos', 'Santos', 'M', 4.60),
('987645432', '2026-04-01', 'BTS1306', 'Ana', 'Costa', 'F', 4.80);

-- ////////////////////////////////////////////////////

CREATE TABLE IF NOT EXISTS tb_avaliacao_pedido(

pedido_id  integer not null,
nota integer not null,
descricao varchar(144),

foreign key(pedido_id) references tb_pedido(pedido_id)

);

INSERT INTO tb_avaliacao_pedido (pedido_id, nota, descricao) 
VALUES 
(1, 4, 'Entrega no prazo, porém a embalagem estava danificada.'),
(3, 5, 'Serviço excelente, comida deliciosa.'),
(4, 3, 'Pedimos sobremesa, mas não estava tão boa quanto esperávamos.'),
(2, 2, 'Comida fria e demorou muito para chegar.'),
(6, 4, 'Boa experiência no geral, entrega rápida.'),
(9, 3, 'Atrasou um pouco, mas a comida estava saborosa.'),
(5, 5, 'Melhor restaurante, sempre entregam no horário e a comida é ótima.'),
(10, 1, 'Desastre total, comida errada e entregue com muito atraso.'),
(8, 4, 'Pedimos um prato especial e ficamos muito satisfeitos.'),
(7, 3, 'Entrega rápida, mas a embalagem estava um pouco danificada.');


-- ////////////////////////////////////////////////////

CREATE TABLE IF NOT EXISTS tb_entrega (

pedido_id integer not null,
valor decimal(7,2) not null,
motoboy_id integer not null,
entrega_paga bit not null,

primary key(pedido_id, motoboy_id),
foreign key(pedido_id) references tb_pedido(pedido_id),
foreign key(motoboy_id) references tb_motoboy(motoboy_id)

);

INSERT INTO tb_entrega (pedido_id, valor, motoboy_id, entrega_paga) 
VALUES (1, 65.00, 1, 1),
(2, 57.00, 2, 0),
(3, 36.00, 3, 1),
(4, 60.00, 4, 0),
(5, 30.00, 1, 1),
(6, 28.00, 2, 0),
(7, 50.00, 3, 1),
(8, 55.00, 4, 0),
(9, 50.50, 1, 1),
(10, 48.50, 2, 0);


-- ////////////////////////////////////////////////////


CREATE TABLE IF NOT EXISTS tb_avaliacao_entrega (

avaliacao_entrega_id integer not null auto_increment,
pedido_id integer not null,
motoboy_id integer not null,
gorjeta decimal(4,2), 
nota integer not null,
descricao varchar(144),

primary key(avaliacao_entrega_id),
foreign key(pedido_id) references tb_pedido(pedido_id),
foreign key(motoboy_id) references tb_motoboy(motoboy_id),
CHECK (gorjeta IN (2.00, 5.00, 10.00))

);

INSERT INTO tb_avaliacao_entrega (pedido_id, motoboy_id, gorjeta, nota, descricao)
VALUES (1, 1, 2.00, 3, 'Entrega rápida, mas a comida estava fria.'),
(2, 2, 5.00, 4, 'Ótimo serviço, entrega no prazo.'),
(3, 3, NULL, 2, 'Atrasou um pouco, comida insatisfatória.'),
(4, 4, 10.00, 5, 'Entrega perfeita, comida deliciosa.'),
(5, 1, NULL, 3, 'Demorou um pouco, mas a comida estava boa.'),
(6, 2, 2.00, 4, 'Entrega rápida, comida saborosa.'),
(7, 3, NULL, 2, 'Comida fria e atrasada.'),
(8, 4, 5.00, 4, 'Excelente atendimento e entrega.'),
(9, 1, 10.00, 5, 'Entrega perfeita, comida quente.'),
(10, 2, NULL, 3, 'Demorou mais do que o esperado.');


-- ////////////////////////////////////////////////////
