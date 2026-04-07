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

