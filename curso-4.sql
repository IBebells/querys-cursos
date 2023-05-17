CREATE FUNCTION primeira_funcao () RETURNS INTEGER AS'
	SELECT (5 - 1) * 3
'LANGUAGE SQL;

SELECT * FROM primeira_funcao() AS resultado;

CREATE FUNCTION multiplica_dois_numeros (numero_1 INTEGER, numero_2 INTEGER) RETURNS INTEGER AS '
	SELECT numero_1 * numero_2
'LANGUAGE SQL;

SELECT * FROM multiplica_dois_numeros (3, 8);

CREATE TABLE a (nomes VARCHAR(255) NOT NULL);
DROP FUNCTION cria_a;
CREATE OR REPLACE FUNCTION cria_a (nome VARCHAR) RETURNS VARCHAR AS $$ 
	INSERT INTO a (nomes) VALUES (cria_a.nome);
	
	SELECT nome;
$$ LANGUAGE SQL;

SELECT cria_a ('Bells');

--------------------------------------------------

CREATE TYPE dois_valores AS (soma INTEGER, produto INTEGER);

DROP FUNCTION soma_e_produto;

-- SETOF record
--CREATE FUNCTION soma_e_produto (numero_1 INTEGER, numero_2 INTEGER, OUT soma INTEGER, OUT produto INTEGER) AS $$ 
	--SELECT numero_1 + numero_2 AS soma, numero_1 * numero_2 AS produto;
--$$ LANGUAGE SQL;

CREATE FUNCTION soma_e_produto (numero_1 INTEGER, numero_2 INTEGER) RETURNS dois_valores AS $$ 
	SELECT numero_1 + numero_2 AS soma, numero_1 * numero_2 AS produto;
$$ LANGUAGE SQL;

SELECT * FROM soma_e_produto (4,4);

---------------------------------------------------------

CREATE OR REPLACE FUNCTION primeira_pl() RETURNS INTEGER AS $$
	DECLARE 
		variavel_1 INTEGER DEFAULT 3;
	BEGIN
		variavel_1 := variavel_1 * 2;
		--
		RETURN variavel_1;
	END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION cria_instrutor_falso() RETURNS instrutor AS $$
	DECLARE
		retorno instrutor;
	BEGIN
		SELECT '22','Falsao', 250::DECIMAL INTO retorno;
		
		RETURN retorno;
	END
$$ LANGUAGE plpgsql;

SELECT * FROM cria_instrutor_falso();

SELECT primeira_pl();

---------------------------------------------------------------
CREATE TABLE instrutor(
	id SERIAL PRIMARY KEY,
	nome VARCHAR(255),
	salario DECIMAL (10,2)
);


CREATE OR REPLACE FUNCTION salario_ok (instrutor instrutor) RETURNS VARCHAR AS $$ 
	BEGIN 
		/*IF instrutor.salario > 300 THEN
			RETURN 'O Salário está ok';
		ELSEIF instrutor.salario = 300 THEN
			RETURN 'O Salário pode aumentar';
		ELSE
			RETURN 'O Salário está defasado';
		END IF;*/
	CASE instrutor.salario
		WHEN 100 THEN
			RETURN 'O salário está muito baixo';
		WHEN 200 THEN
			RETURN 'O salário está baixo';
		WHEN 300 THEN
			RETURN 'O salário está ok';
		ELSE 
			RETURN 'O salário está ótimo';
	END CASE;
	END
$$ LANGUAGE plpgsql;

SELECT nome, salario_ok(instrutor) FROM instrutor;

CREATE FUNCTION salario_ok_2 (id_instrutor INTEGER) RETURNS VARCHAR AS $$
	DECLARE 
		instrutor instrutor;
	BEGIN
		SELECT * FROM instrutor WHERE id = id_instrutor INTO instrutor;
		
		IF instrutor.salario > 200 THEN
			RETURN 'Salário está ok';
		ELSE 
			RETURN 'O Salário pode aumentar';
		END IF;
	END
$$ LANGUAGE plpgsql;

--------------------------------------------------

CREATE FUNCTION tabuada_1 (numero INTEGER) RETURNS SETOF INTEGER AS $$ 
	BEGIN
		RETURN NEXT numero * 1;
		RETURN NEXT numero * 2;
		RETURN NEXT numero * 3;
		RETURN NEXT numero * 4;
		RETURN NEXT numero * 5;
		RETURN NEXT numero * 6;
		RETURN NEXT numero * 7;
		RETURN NEXT numero * 8;
		RETURN NEXT numero * 9;

	END
$$ LANGUAGE plpgsql;

DROP FUNCTION tabuada;
CREATE OR REPLACE FUNCTION tabuada (numero INTEGER) RETURNS SETOF VARCHAR AS $$
	DECLARE
		multiplicador INTEGER DEFAULT 1;
	BEGIN
		WHILE multiplicador < 10 LOOP
		RETURN NEXT numero || ' x ' || multiplicador || ' = ' ||numero * multiplicador;
		
		multiplicador := multiplicador + 1;
		
		--EXIT WHEN multiplicador = 10;
		END LOOP;
	END
$$ LANGUAGE plpgsql;

SELECT * FROM tabuada_1 (2);
SELECT * FROM tabuada (9);
SELECT * FROM tabuada_2 (9);

CREATE OR REPLACE FUNCTION tabuada_2 (numero INTEGER) RETURNS SETOF VARCHAR AS $$
	BEGIN
		FOR multiplicador IN 1..9 LOOP
			RETURN NEXT numero || ' x ' || multiplicador || ' = ' ||numero * multiplicador;
		END LOOP;
	END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION instrutor_com_salario(OUT nome VARCHAR, OUT salario_ok VARCHAR) RETURNS SETOF record AS $$
	DECLARE 
		instrutor instrutor;
	BEGIN
		FOR instrutor IN SELECT * FROM instrutor LOOP
			nome := instrutor.nome;
			salario_ok := salario_ok_2(instrutor.id);
			
			RETURN NEXT;
		END LOOP;
	END
$$ LANGUAGE plpgsql;

SELECT * FROM instrutor_com_salario();