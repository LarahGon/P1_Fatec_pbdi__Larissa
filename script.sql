--Enunciado 1
CREATE TABLE Titanic_Dataset(  
    PassengerId SERIAL PRIMARY KEY,
    Survived INT,
    Pclass INT,
    Sex TEXT,
    Fare NUMERIC(10, 4),
    Embarked TEXT);
DROP TABLE Titanic_Dataset;

--Enunciado 2
DO $$
DECLARE
    cur_sobreviventes REFCURSOR;
    v_total INT;
BEGIN
    OPEN cur_sobreviventes FOR
    SELECT COUNT(*)
    FROM titanic_dataset
    WHERE survived = 1 AND pclass = 1;

    LOOP
        FETCH cur_sobreviventes INTO v_total;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE 'Sobreviventes na 1 classe: %', v_total;
    END LOOP;
    CLOSE cur_sobreviventes;
END;
$$

--Enunciado 3
DO $$
DECLARE
    cur_sobreviventes REFCURSOR;
    v_total INT;

    v_sexo VARCHAR(10) := 'female';
    v_nome_tabela VARCHAR(200) := 'titanic_dataset';
BEGIN
    OPEN cur_sobreviventes FOR EXECUTE
    format(
        '
        SELECT COUNT(*)
        FROM %s
        WHERE survived = 1 AND sex = $1
        ',
        v_nome_tabela
    ) USING v_sexo;

    LOOP
        FETCH cur_sobreviventes INTO v_total;
        EXIT WHEN NOT FOUND;
        IF v_total = 0 THEN
            RAISE NOTICE '-1';
        ELSE
            RAISE NOTICE 'Sobreviventes mulheres: %', v_total;
        END IF;

    END LOOP;

    CLOSE cur_sobreviventes;
END;
$$

--Enunciado 4
DO $$
DECLARE
    cur_passageiros CURSOR FOR 
    SELECT fare, embarked
    FROM titanic_dataset;
    tupla RECORD;
    total INT DEFAULT 0;
BEGIN
    OPEN cur_passageiros;
    FETCH cur_passageiros INTO tupla;
    WHILE FOUND LOOP
        IF tupla.fare > 50 AND tupla.embarked = 'C' THEN
            total := total + 1;
        END IF;
        FETCH cur_passageiros INTO tupla;
    END LOOP;
    CLOSE cur_passageiros;
    RAISE NOTICE 'Passageiros que pagaram tarifa > 50 e que embarcaram em Cherbourg: %', total;
END;
$$
