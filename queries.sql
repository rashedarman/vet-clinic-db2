/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name = 'Agumon' OR name = 'Pikachu';
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

-- Inside a transaction update the animals table by setting the species column to unspecified. Verify that change was made. Then roll back the change and verify that the species columns went back to the state before the transaction.
BEGIN;
UPDATE animals SET species = 'unspecified';
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;

-- Inside a transaction:
--    Update the animals table by setting the species column to digimon for all animals that have a name ending in mon. 
--    Update the animals table by setting the species column to pokemon for all animals that don't have species already set.
--    Commit the transaction.
BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
COMMIT;

-- Verify that change was made and persists after commit.
SELECT * FROM animals;

-- Inside a transaction delete all records in the animals table, then roll back the transaction.
BEGIN;
DELETE FROM animals;
ROLLBACK;

-- After the rollback verify if all records in the animals table still exists.
SELECT * FROM animals;

-- Inside a transaction:
--    Delete all animals born after Jan 1st, 2022.
--    Create a savepoint for the transaction.
--    Update all animals' weight to be their weight multiplied by -1.
--    Rollback to the savepoint
--    Update all animals' weights that are negative to be their weight multiplied by -1.
--    Commit transaction
BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT ReZeroReference; -- xD
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO ReZeroReference;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
COMMIT;

-- Verify that change was made and persists after commit.
SELECT * FROM animals;

-- Create queries to answer the questions:
--    How many animals are there?
--    How many animals have never tried to escape?
--    What is the average weight of animals?
--    Who escapes the most, neutered or not neutered animals?
--    What is the minimum and maximum weight of each type of animal?
--    What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT COUNT(*) FROM animals;
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
SELECT ROUND(AVG(weight_kg)) FROM animals;
SELECT neutered, SUM(escape_attempts) as escape_attempts FROM animals GROUP BY neutered ORDER BY escape_attempts DESC LIMIT 1;
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;
SELECT species, AVG(escape_attempts) FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;

-- Write queries (using JOIN) to answer the following questions:
--    What animals belong to Melody Pond?
--    List of all animals that are pokemon (their type is Pokemon).
--    List all owners and their animals, remember to include those that don't own any animal.
--    How many animals are there per species?
--    List all Digimon owned by Jennifer Orwell.
--    List all animals owned by Dean Winchester that haven't tried to escape.
--    Who owns the most animals?
SELECT animals.name AS animal_name, owners.full_name AS owner_name 
FROM animals JOIN owners ON animals.owner_id = owners.id 
WHERE full_name = 'Melody Pond';

SELECT * FROM animals
JOIN species ON animals.species_id = species.id
WHERE species.name = 'Pokemon';

SELECT animals.name AS animal_name, owners.fulL_name AS owner_name 
FROM owners LEFT JOIN animals ON owners.id = animals.owner_id;

SELECT species.name, COUNT(*) AS count FROM animals
JOIN species ON animals.species_id = species.id
GROUP BY species.name;

SELECT animals.name AS animal_name, owners.full_name AS owner_name FROM animals
JOIN owners ON animals.owner_id = owners.id
JOIN species ON animals.species_id = species.id
WHERE species.name = 'Digimon' AND owners.full_name = 'Jennifer Orwell';

SELECT animals.name AS animal_name, owners.full_name AS owner_name FROM animals
JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attempts = 0;

SELECT owners.full_name AS owner_name, COUNT(*) AS count FROM animals
JOIN owners ON animals.owner_id = owners.id
GROUP BY owner_name ORDER BY count DESC LIMIT 1;
