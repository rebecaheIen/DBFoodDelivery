create schema if not exists db_fooddelivery; 

use db_fooddelivery; 

    create table if not exists tb_usuario(

    usuario varchar(20) not null, 
    senha char(8) not null, 
    data_criacao datetime not null, 
    data_ultima_atualizacao datetime, 
    ativo bit not null, 

    primary key(usuario) 
  
  );
  
    create table if not exists tb_endereco(
 
    cep char(8) not null,
    tipo_logradouro varchar(12),
    logradouro varchar(40),
    bairro varchar (40),
    cidade varchar(30) not null,
    uf char(2) not null,
   
    primary key(cep)
   
   ); 
   
    create table if not exists tb_categoria_estabelecimento(
   
    categoria_estabelecimento_id integer not null auto_increment,
    nome varchar(40) not null unique,
   
    primary key(categoria_estabelecimento_id)
   
  );
  
    create table if not exists tb_dias_semana(
   
    dia_id integer not null auto_increment,
    nome varchar(15) not null unique,
   
    primary key(dia_id)
   
   );
   
    create table if not exists tb_categoria_cardapio( 
    
    categoria_cardapio_id integer not null auto_increment,
    nome varchar (20) not null unique,
    
    primary key(categoria_cardapio_id)
   
   );
  
    create table if not exists tb_categoria_item(
  
    categoria_item_id integer not null auto_increment,
    nome varchar(20) not null unique,
  
    primary key(categoria_item_id)
 
  );
 
    create table if not exists tb_voucher( 
   
    codigo_promo varchar (15) not null,
    valor decimal (7,2),
    porcentagem decimal (3,2),
    tipo_voucher bit not null,
    data_inicio datetime not null,
    data_fim datetime not null,
    descricao varchar(144) not null,
    quantidade integer not null,
    
    primary key(codigo_promo)
    
    );
   
    create table if not exists tb_status(
    
    status_id integer not null auto_increment,
    nome varchar(20) not null unique,
    status_anterior integer,
    status_proximo integer,
    
    primary key(status_id),
    foreign key(status_anterior) references tb_status(status_id),
    foreign key(status_proximo) references tb_status(status_id)
   
    );
   
   
    create table if not exists tb_cliente( 
    
    cliente_id integer not null auto_increment,
    usuario varchar(20) not null unique,
    cpf char(11) not null unique,
    rg varchar(11) not null,
    pre_nome varchar(15) not null,
    sobrenome varchar(80) not null,
    sexo char(1),
    data_nascimento date not null,
    
    primary key(cliente_id),
    foreign key(usuario) references tb_usuario(usuario)
    
    );
   
    create table if not exists tb_cartao( 
    
    cartao_id integer not null auto_increment,
    cliente_id integer not null,
    numero char(16) not null,
    nome varchar(20) not null,
    validade char(5) not null,
    cvv char(3) not null,
    
    primary key(cartao_id),
    foreign key(cliente_id) references tb_cliente(cliente_id)
   
    );
   
    create table if not exists tb_endereco_cliente( 
   
    endereco_cliente_id integer not null auto_increment,
    cliente_id integer not null,
    cep char(8) not null,
    numero varchar(8),
    ponto_referencia varchar(40),
    complemento varchar(40),
    
    primary key(endereco_cliente_id),
    foreign key(cliente_id) references tb_cliente(cliente_id),
    foreign key(cep) references tb_endereco(cep)
    
    );
   
    
    create table if not exists tb_estabelecimento( 
    
    estabelecimento_id integer not null auto_increment,
    categoria_estabelecimento_id integer not null,
    cnpj char(14) not null unique,
    razao_social varchar(60) not null unique,
    nome_fantasia varchar(60) not null,
    descricao varchar(144),
    email varchar(30) not null,
    nota decimal(3,2) not null,
    
    primary key(estabelecimento_id),
    foreign key(categoria_estabelecimento_id) references tb_categoria_estabelecimento(categoria_estabelecimento_id)
    
    );
   
    
    create table if not exists tb_estabelecimento_endereco(
    
    estabelecimento_id integer not null,
    cep char(8) not null,
    numero varchar(8),
    ponto_referencia varchar(40),
    complemento varchar(40),
    
    primary key(estabelecimento_id, cep),
    foreign key(estabelecimento_id) references tb_estabelecimento(estabelecimento_id),
    foreign key(cep) references tb_endereco(cep)
   
    );
   
    create table if not exists tb_contato_estabelecimento(
    
    estabelecimento_id integer not null,
    contato char(11) not null,
    
    foreign key(estabelecimento_id) references tb_estabelecimento(estabelecimento_id)
   
    );
   
    create table if not exists tb_horario_funcionamento(
    
    estabelecimento_id integer not null,
    dia_id integer not null,
    horario_inicio time not null,
    horario_fim time not null,
    almoco bit not null,
    
    foreign key(estabelecimento_id) references tb_estabelecimento(estabelecimento_id),
    foreign key(dia_id) references tb_dias_semana(dia_id)
   
    );
   
    create table if not exists tb_pedido( 
    
    pedido_id integer not null auto_increment,
    endereco_cliente_id integer not null,
    estabelecimento_id integer not null,
    cliente_id integer not null,
    status_id integer not null,
    data_hora_solicitacao datetime not null,
    data_hora_entrega datetime,
    total decimal(7,2),
    desconto decimal(7,2),
    
    primary key(pedido_id),
    foreign key(endereco_cliente_id) references tb_endereco_cliente(endereco_cliente_id),
    foreign key(estabelecimento_id) references tb_estabelecimento(estabelecimento_id),
    foreign key(cliente_id) references tb_cliente(cliente_id),
    foreign key(status_id) references tb_status(status_id)
    
    );
   
    create table if not exists tb_pedido_historico(
    
    pedido_id integer not null,
    status_id integer not null,
    data_hora datetime not null,
    
    foreign key(pedido_id) references tb_pedido(pedido_id),
    foreign key(status_id) references tb_status(status_id)
   
    );
   
    create table if not exists tb_pagamento(
    
    pedido_id integer not null,
    cartao_id integer,
    codigo_promo varchar(15),
    valor decimal(7,2) not null,
    data_hora datetime not null,
    
    foreign key(pedido_id) references tb_pedido(pedido_id),
    foreign key(cartao_id) references tb_cartao(cartao_id),
    foreign key(codigo_promo) references tb_voucher(codigo_promo)
   
    );
   
   
    create table if not exists tb_cardapio(
    
    cardapio_id integer not null auto_increment,
    categoria_cardapio_id integer not null,
    estabelecimento_id integer not null,
    nome varchar(20) not null,
    
    primary key(cardapio_id),
    foreign key(categoria_cardapio_id) references tb_categoria_cardapio(categoria_cardapio_id),
    foreign key(estabelecimento_id) references tb_estabelecimento(estabelecimento_id)
   
    );
   
    create table if not exists tb_item_cardapio(
    
    item_id integer not null auto_increment,
    cardapio_id integer not null,
    categoria_item_id integer not null,
    nome varchar(30) not null,
    preco_unitario decimal(6,2) not null,
    descricao varchar(30) not null,
    observacoes varchar(144),
    
    primary key(item_id),
    foreign key(cardapio_id) references tb_cardapio(cardapio_id),
    foreign key(categoria_item_id) references tb_categoria_item(categoria_item_id)
   
    );
   
   
    create table if not exists tb_item_pedido(
    
    pedido_id integer not null,
    item_cardapio_id integer not null,
    quantidade integer not null,
    observacao varchar(144),
   
    primary key(pedido_id, item_cardapio_id),
    foreign key(pedido_id) references tb_pedido(pedido_id),
    foreign key(item_cardapio_id) references tb_item_cardapio(item_id)
    
    );
    
   
   DROP DATABASE db_fooddelivery;
  
   