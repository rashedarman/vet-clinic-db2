/* Database schema to keep the structure of entire database. */

CREATE TABLE IF NOT EXISTS animals (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(100),
    date_of_birth DATE,
    escape_attempts INT,
    neutered BOOLEAN,
    weight_kg FLOAT
);

-- Add a new column species to the animals table
ALTER TABLE animals ADD COLUMN species VARCHAR(100);

-- Create table owners
CREATE TABLE IF NOT EXISTS owners (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(100),
    age INT
);

-- Create table species
CREATE TABLE IF NOT EXISTS species (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100)
);

-- Modify animals table:

-- Make sure that id is set as autoincremented PRIMARY KEY
    -- this now makes animals.id a primary key, which was not the case before.
    -- you can validate thi by running command `\d+ animals` in postgresql.
ALTER TABLE animals ADD PRIMARY KEY (id);

-- Remove column species
-- ALTER TABLE animals DROP COLUMN species;

-- Add column species_id which is a foreign key referencing species table
-- ALTER TABLE animals ADD COLUMN species_id INT REFERENCES species(id);

-- Add column owner_id which is a foreign key referencing the owners table
-- ALTER TABLE animals ADD COLUMN owner_id INT REFERENCES owners(id);

-- Note: I like to combine the above three ALTER statements since they are all modifying the same table.
ALTER TABLE animals DROP COLUMN species, ADD COLUMN species_id INT, ADD COLUMN owner_id INT;
