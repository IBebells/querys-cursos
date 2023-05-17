CREATE OR REPLACE FUNCTION instrutores_internos (id_instrutor INTEGER) RETURNS refcursor AS $$
	DECLARE
		cursor_salarios refcursor;
	BEGIN
		OPEN cursor_salarios FOR SELECT instrutor.salario 
								  FROM instrutor
							     WHERE id <> id_instrutor AND salario > 0;
		RETURN cursor_salarios;
	END;
$$ LANGUAGE plpgsql;

---------------------------------------------------------

DO $$ 
	DECLARE
		cursor_salarios refcursor;
		salario DECIMAL;
		total_instrutores INTEGER DEFAULT 0;
		instrutores_recebem_menos INTEGER DEFAULT 0;
		percentual DECIMAL (5,2);
	BEGIN
		SELECT instrutores_internos(12) INTO cursor_salarios;
		LOOP
			FETCH cursor_salarios INTO salario;
			EXIT WHEN NOT FOUND;
			total_instrutores := total_instrutores + 1;

			IF 600::DECIMAL > salario THEN
				instrutores_recebem_menos := instrutores_recebem_menos + 1;
			END IF;
		END LOOP;
		percentual =  (instrutores_recebem_menos ::DECIMAL / total_instrutores::DECIMAL) * 100;
		
		RAISE NOTICE 'Percentual : % %%', percentual;
	END;
$$;