CREATE TABLE patients (
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name VARCHAR(100),
  date_of_birth DATE
);

CREATE TABLE medical_histories (
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  admitted_at TIMESTAMP,
  patient_id INT REFERENCES patients(id),
  status VARCHAR(40)
);

CREATE TABLE treatments (
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  type VARCHAR(40),
  name VARCHAR(100)
);

CREATE TABLE invoice_items (
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  unit_price NUMERIC(10, 2), -- DECIMAL is also valid
  quantity INT,
  total_price NUMERIC(10, 2),
  invoice_id INT REFERENCES invoices(id),
  treatment_id INT REFERENCES treatments(id)
);

-- Many-to-many relationship between medical_histories and treatments
CREATE TABLE medical_history_treatments (
  medical_history_id INT REFERENCES medical_histories(id),
  treatment_id INT REFERENCES treatments(id),
  PRIMARY KEY (medical_history_id, treatment_id)
);

CREATE TABLE invoices (
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  total_amount NUMERIC(10, 2),
  generated_at TIMESTAMP,
  payed_at TIMESTAMP,
  medical_history_id INT REFERENCES medical_histories(id)
);

-- Create FK indexes
CREATE INDEX idx_medical_histories_patient_id ON medical_histories(patient_id);
CREATE INDEX idx_invoice_items_invoice_id ON invoice_items(invoice_id);
CREATE INDEX idx_invoice_items_treatment_id ON invoice_items(treatment_id);
CREATE INDEX idx_medical_history_treatments_medical_history_id ON medical_history_treatments(medical_history_id);
CREATE INDEX idx_medical_history_treatments_treatment_id ON medical_history_treatments(treatment_id);
CREATE INDEX idx_invoices_medical_history_id ON invoices(medical_history_id);
