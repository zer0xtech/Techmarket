CREATE TABLE users (
    id int PRIMARY KEY NOT NULL AUTO_INCREMENT,
    password varchar(255) NOT NULL,
    email varchar(255) NOT NULL,
    nom varchar(255) NOT NULL,
    prenom varchar(255) NOT NULL,
    phone varchar(20) NOT NULL,
    ville varchar(255) NOT NULL,
    blocked boolean NOT NULL DEFAULT false,
    role enum(
        'utilisateur',
        'moderateur',
        'administrateur'
    ) NOT NULL DEFAULT 'utilisateur',
    date_inscription datetime NOT NULL
);

CREATE TABLE annonces (
    id int PRIMARY KEY NOT NULL AUTO_INCREMENT,
    categorie varchar(255) NOT NULL,
    sous_categorie varchar(255) NOT NULL,
    user_id int NOT NULL,
    statut enum(
        'brouillon',
        'en_attente', 
        'validee',
        'refusee',
        'vendue',
        'expiree'
    ) NOT NULL DEFAULT 'en_attente',
    titre varchar(255) NOT NULL,
    description TEXT NOT NULL,
    creation_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    ville varchar(255) NOT NULL,
    prix DECIMAL(9, 2) NOT NULL,
    etat varchar(50) NOT NULL,
    url_photo TEXT NOT NULL,
    motif_modification varchar(255) DEFAULT NULL,
    motif_refus varchar(255) DEFAULT NULL
);

CREATE TABLE categories (
    id int PRIMARY KEY AUTO_INCREMENT,
    nom varchar(255) NOT NULL,
    parent_id int NOT NULL
);

CREATE TABLE favoris (
    id int PRIMARY KEY AUTO_INCREMENT,
    id_annonce int NOT NULL,
    id_user int NOT NULL
);

ALTER TABLE annonces
ADD FOREIGN KEY (categorie_id) REFERENCES categories (id);

ALTER TABLE categories
ADD FOREIGN KEY (parent_id) REFERENCES categories (id);

ALTER TABLE annonces ADD FOREIGN KEY (user_id) REFERENCES users (id);

ALTER TABLE favoris ADD FOREIGN KEY (id_user) REFERENCES users (id);

ALTER TABLE favoris
ADD FOREIGN KEY (id_annonce) REFERENCES annonces (id); 