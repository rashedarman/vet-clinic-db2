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

-- How many animals are there?
SELECT COUNT(*) FROM animals;

-- How many animals have never tried to escape?
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;

-- What is the average weight of animals?
SELECT ROUND(AVG(weight_kg)) FROM animals;

-- Who escapes the most, neutered or not neutered animals?
SELECT neutered, SUM(escape_attempts) as escape_attempts 
    FROM animals GROUP BY neutered 
    ORDER BY escape_attempts DESC LIMIT 1;

-- What is the minimum and maximum weight of each type of animal?
SELECT species, MIN(weight_kg), MAX(weight_kg) 
    FROM animals GROUP BY species;

-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species, AVG(escape_attempts)
    FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
    GROUP BY species;

-- Write queries (using JOIN) to answer the following questions:

-- What animals belong to Melody Pond?
SELECT animals.name AS animal_name, owners.full_name AS owner_name 
    FROM animals JOIN owners ON animals.owner_id = owners.id 
    WHERE full_name = 'Melody Pond';

-- List of all animals that are pokemon (their type is Pokemon).
SELECT * FROM animals
    JOIN species ON animals.species_id = species.id
    WHERE species.name = 'Pokemon';

-- List all owners and their animals, remember to include those that don't own any animal.
SELECT animals.name AS animal_name, owners.fulL_name AS owner_name 
    FROM owners LEFT JOIN animals ON owners.id = animals.owner_id;

-- How many animals are there per species?
SELECT species.name, COUNT(*) AS count FROM animals
    JOIN species ON animals.species_id = species.id
    GROUP BY species.name;

-- List all Digimon owned by Jennifer Orwell.
SELECT animals.name AS animal_name, owners.full_name AS owner_name FROM animals
    JOIN owners ON animals.owner_id = owners.id
    JOIN species ON animals.species_id = species.id
    WHERE species.name = 'Digimon' AND owners.full_name = 'Jennifer Orwell';

-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT animals.name AS animal_name, owners.full_name AS owner_name FROM animals
    JOIN owners ON animals.owner_id = owners.id
    WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attempts = 0;

-- Who owns the most animals?
SELECT owners.full_name AS owner_name, COUNT(*) AS count FROM animals
    JOIN owners ON animals.owner_id = owners.id
    GROUP BY owner_name ORDER BY count DESC LIMIT 1;

-- Write queries to answer the following:

-- Who was the last animal seen by William Tatcher?
SELECT animals.name AS animals_name FROM animals
    JOIN visits ON animals.id = visits.animals_id 
    JOIN vets ON visits.vets_id = vets.id 
    WHERE vets.name = 'William Tatcher'
    ORDER BY visits.date_of_visit DESC LIMIT 1;

-- How many different animals did Stephanie Mendez see?
SELECT COUNT(DISTINCT animals.id) FROM animals
    JOIN visits ON animals.id = visits.animals_id
    JOIN vets ON visits.vets_id = vets.id
    WHERE vets.name = 'Stephanie Mendez';

-- List all vets and their specialties, including vets with no specialties.
SELECT vets.name, species.name FROM vets
    LEFT JOIN specializations ON specializations.vet_id = vets.id
    LEFT JOIN  species ON specializations.species_id = species.id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT animals.name AS animals_name FROM animals
    JOIN visits ON animals.id = visits.animals_id
    JOIN vets ON visits.vets_id = vets.id
    WHERE vets.name = 'Stephanie Mendez' AND visits.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';

-- What animal has the most visits to vets?
SELECT animals.name AS animals_name, COUNT(*) AS count FROM animals
    JOIN visits ON animals.id = visits.animals_id
    GROUP BY animals_name ORDER BY count DESC LIMIT 1;

-- Who was Maisy Smith's first visit?
SELECT vets.name AS vet_name, 
    visits.date_of_visit AS visit_date,
    animals.name AS animal_name 
    FROM visits 
    JOIN vets ON vets.id = visits.vets_id
    JOIN animals ON animals.id = visits.animals_id
    WHERE vets.name = 'Maisy Smith'
    ORDER BY visit_date LIMIT 1;

-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT animals.name AS animal_name, 
    vets.name AS vet_name, 
    visits.date_of_visit 
    FROM animals 
    JOIN visits ON animals.id = visits.animals_id 
    JOIN vets ON visits.vets_id = vets.id 
ORDER BY visits.date_of_visit DESC LIMIT 1;

-- How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(*)
    FROM visits 
    JOIN animals ON animals.id = visits.animals_id
    JOIN vets ON vets.id = visits.vets_id
    JOIN specializations ON specializations.vet_id = visits.vets_id
    WHERE animals.species_id != specializations.species_id;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most
SELECT species.name as species, COUNT(*) AS count FROM visits
    JOIN vets ON vets.id = visits.vets_id
    JOIN animals ON animals.id = visits.animals_id
    JOIN species ON species.id = animals.species_id
    WHERE vets.name = 'Maisy Smith'
    GROUP BY species.name ORDER BY count DESC LIMIT 1;

-- Explain analyze performance queries for the database
EXPLAIN ANALYZE SELECT COUNT(*) FROM visits where animals_id = 4;
EXPLAIN ANALYZE SELECT * FROM visits where vets_id = 2;
EXPLAIN ANALYZE SELECT * FROM owners where email = 'owner_18327@mail.com';
