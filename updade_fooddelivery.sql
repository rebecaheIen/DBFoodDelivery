
UPDATE tb_item_cardapio SET preco_unitario = 39.90 WHERE item_id = 9;

UPDATE tb_cardapio SET nome = 'Aperitivos' WHERE categoria_cardapio_id = 13;

UPDATE tb_endereco_cliente SET cep = '44052004', numero = '999', ponto_referencia = 'Próximo a academia', complemento = 'Apto 505' WHERE cliente_id = 8;

UPDATE tb_pedido SET status_id = 10 WHERE cliente_id = 8;

UPDATE tb_pedido SET data_hora_entrega = NULL WHERE cliente_id = 8;